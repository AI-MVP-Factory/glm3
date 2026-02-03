# Cloudflare Workers Setup Guide

> **Purpose:** Configure Cloudflare Workers as edge API gateway for Brain
> **Difficulty:** Easy
> **Time:** 30 minutes

---

## Prerequisites

- Cloudflare account (free)
- Domain pointed to Cloudflare DNS
- Brain API endpoint accessible from internet (or tunnel)

---

## Quick Start

### 1. Create Cloudflare Account

```
1. Go to https://dash.cloudflare.com/sign-up
2. Sign up (free, no credit card required)
3. Add your domain (or use workers.dev subdomain)
4. Update nameservers if using custom domain
```

### 2. Install Wrangler CLI

```bash
# Via npm
npm install -g wrangler

# Authenticate
wrangler login

# Verify
wrangler whoami
```

### 3. Create Brain Gateway Worker

```bash
# Create new worker
wrangler init brain-gateway

# Select:
# - What would you like to start with? "Hello World" Worker
# - TypeScript? Yes
# - Deploy now? No (we'll configure first)
```

---

## Worker Configuration

### wrangler.toml

```toml
name = "brain-gateway"
main = "src/index.ts"
compatibility_date = "2024-01-01"

# KV Namespace for caching
[[kv_namespaces]]
binding = "CACHE"
id = "your-kv-namespace-id"

# Environment variables
[vars]
BRAIN_API_URL = "http://192.168.68.58:8080"
API_KEY_HEADER = "X-API-Key"
RATE_LIMIT_PER_MINUTE = "60"
CACHE_TTL_SECONDS = "3600"

# Secrets (use: wrangler secret put API_KEY)
# API_KEY = "your-secret-api-key"
```

---

## Worker Implementation

### src/index.ts

```typescript
// Brain Gateway Worker for SOLO
// Caches responses, rate limits, validates requests

interface Env {
  CACHE: KVNamespace;
  BRAIN_API_URL: string;
  API_KEY: string;
  API_KEY_HEADER: string;
  RATE_LIMIT_PER_MINUTE: string;
  CACHE_TTL_SECONDS: string;
}

interface CacheEntry {
  data: any;
  timestamp: number;
  ttl: number;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    try {
      const url = new URL(request.url);
      const path = url.pathname;

      // Health check (bypass cache, auth)
      if (path === '/health' || path === '/favicon.ico') {
        return jsonResponse({ status: 'healthy', edge: true }, 200);
      }

      // Metrics endpoint (public)
      if (path === '/metrics') {
        return jsonResponse({
          gateway: 'cloudflare-workers',
          version: '1.0.0',
          timestamp: Date.now(),
        }, 200);
      }

      // Validate API key for protected routes
      if (path.startsWith('/query') || path.startsWith('/search')) {
        const apiKey = request.headers.get(env.API_KEY_HEADER);
        if (!apiKey || apiKey !== env.API_KEY) {
          return jsonResponse({ error: 'Unauthorized' }, 401);
        }

        // Check rate limit
        const clientId = request.headers.get('CF-Connecting-IP') || 'unknown';
        const rateLimitOk = await checkRateLimit(clientId, env);
        if (!rateLimitOk) {
          return jsonResponse({
            error: 'Rate limit exceeded',
            limit: env.RATE_LIMIT_PER_MINUTE
          }, 429);
        }
      }

      // Generate cache key
      const cacheKey = generateCacheKey(request);

      // Try cache first (GET requests only)
      if (request.method === 'GET') {
        const cached = await env.CACHE.get(cacheKey, 'json');
        if (cached) {
          ctx.waitUntil(logMetric('cache_hit', path, env));
          return jsonResponse({
            ...cached.data,
            _cached: true,
            _age: Math.floor((Date.now() - cached.timestamp) / 1000)
          }, 200);
        }
      }

      // Proxy to Brain API
      const brainResponse = await proxyToBrain(request, env);

      // Cache successful GET responses
      if (request.method === 'GET' && brainResponse.ok) {
        const data = await brainResponse.clone().json();
        const ttl = parseInt(env.CACHE_TTL_SECONDS || '3600');
        ctx.waitUntil(
          env.CACHE.put(cacheKey, JSON.stringify({
            data,
            timestamp: Date.now(),
            ttl
          }), { expirationTtl: ttl })
        );
        ctx.waitUntil(logMetric('cache_miss', path, env));
      }

      return brainResponse;

    } catch (error) {
      console.error('Worker error:', error);
      return jsonResponse({
        error: 'Internal gateway error',
        message: error.message
      }, 500);
    }
  }
};

// Helper Functions

async function proxyToBrain(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const brainUrl = new URL(url.pathname + url.search, env.BRAIN_API_URL);

  const proxyRequest = new Request(brainUrl, {
    method: request.method,
    headers: {
      ...Object.fromEntries(request.headers),
      'Host': new URL(env.BRAIN_API_URL).host,
      'X-Forwarded-For': request.headers.get('CF-Connecting-IP'),
    },
    body: request.body,
  });

  const response = await fetch(proxyRequest);

  // Return response with CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, X-API-Key',
  };

  const headers = new Headers(response.headers);
  Object.entries(corsHeaders).forEach(([k, v]) => headers.set(k, v));

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}

function generateCacheKey(request: Request): string {
  const url = new URL(request.url);
  const method = request.method;
  const search = url.search;

  // For POST requests with body, hash the body
  let bodyHash = '';
  if (request.method === 'POST') {
    // Simple hash of query string for cache key
    bodyHash = ':' + btoa(url.search);
  }

  return `brain:${method}:${url.pathname}${search}${bodyHash}`;
}

async function checkRateLimit(clientId: string, env: Env): Promise<boolean> {
  const key = `ratelimit:${clientId}:${getCurrentMinute()}`;
  const current = await env.CACHE.get(key);

  if (!current) {
    await env.CACHE.put(key, '1', { expirationTtl: 60 });
    return true;
  }

  const count = parseInt(current);
  const limit = parseInt(env.RATE_LIMIT_PER_MINUTE || '60');

  if (count >= limit) {
    return false;
  }

  await env.CACHE.put(key, String(count + 1), { expirationTtl: 60 });
  return true;
}

function getCurrentMinute(): number {
  return Math.floor(Date.now() / 60000);
}

async function logMetric(type: string, path: string, env: Env): Promise<void> {
  const key = `metrics:${getCurrentHour()}`;
  const current = await env.CACHE.get(key, 'json') as Record<string, number> || {};

  current[`${type}:${path}`] = (current[`${type}:${path}`] || 0) + 1;

  await env.CACHE.put(key, JSON.stringify(current), { expirationTtl: 3600 });
}

function getCurrentHour(): number {
  return Math.floor(Date.now() / 3600000);
}

function jsonResponse(data: any, status: number = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
```

---

## Deployment

### Create KV Namespace

```bash
# Create KV namespace
wrangler kv:namespace create CACHE

# Copy the ID to wrangler.toml
# Or use preview namespace for development
wrangler kv:namespace create CACHE --preview
```

### Set Secrets

```bash
# Set API key secret
wrangler secret put API_KEY
# Paste your API key when prompted

# Or set programmatically
echo "your-secret-api-key" | wrangler secret put API_KEY
```

### Deploy

```bash
# Deploy to production
wrangler deploy

# Deploy to preview (for testing)
wrangler deploy --env development
```

---

## Testing

### Local Development

```bash
# Run locally with Miniflare
npx miniflare --kv CACHE --local --debug

# Or use Wrangler dev
wrangler dev
```

### Test Endpoints

```bash
# Health check
curl https://brain-gateway.your-subdomain.workers.dev/health

# Query (with API key - replace placeholder)
curl -H "X-API-Key: $YOUR_API_KEY" \
  https://brain-gateway.your-subdomain.workers.dev/query?q=test

# Check cache hit (second request should be faster)
curl -H "X-API-Key: $YOUR_API_KEY" \
  https://brain-gateway.your-subdomain.workers.dev/query?q=test
```

---

## Custom Domain

### 1. Add Custom Domain to Worker

```bash
# Via dashboard
# 1. Go to Workers & Pages
# 2. Select brain-gateway
# 3. Triggers → Custom Domains
# 4. Add: brain.your-domain.com
```

### 2. Configure DNS

```
# In Cloudflare DNS:
brain.your-domain.com  CNAME  brain-gateway.your-subdomain.workers.dev
```

### 3. Enable HTTPS

Automatically handled by Cloudflare (universal SSL).

---

## Monitoring

### View Logs

```bash
# Real-time logs
wrangler tail

# Filter by status
wrangler tail --format=pretty | grep ERROR
```

### View Analytics

```
Dashboard → Workers & Pages → brain-gateway → Metrics
```

Available metrics:
- Requests (total, by status)
- CPU time
- Memory usage
- Errors
- Cache hit rate (custom)

---

## Advanced Configuration

### Cache Partitioning by User

```typescript
// Include user ID in cache key for personalized results
const userId = request.headers.get('X-User-ID');
const cacheKey = `brain:${userId || 'anon'}:${url.pathname}`;
```

### Stale-While-Revalidate

```typescript
// Serve stale cache while revalidating in background
const cached = await env.CACHE.get(cacheKey, 'json');
if (cached && Date.now() - cached.timestamp < cached.ttl * 2) {
  // Stale but acceptable, serve and revalidate
  ctx.waitUntil(revalidateInBackground(cacheKey, env));
  return jsonResponse({ ...cached.data, _stale: true });
}
```

### Circuit Breaker

```typescript
// Track failures and stop forwarding to Brain if failing
const failureKey = `brain:health:recent_failures`;
const failures = await env.CACHE.get(failureKey);

if (failures && parseInt(failures) > 5) {
  // Circuit open - return cached or error
  return jsonResponse({
    error: 'Service temporarily unavailable',
    cached: cached?.data || null
  }, 503);
}
```

---

## Limits (Free Tier)

| Resource | Limit |
|----------|-------|
| Requests | 100,000/day |
| CPU time | 10ms per request |
| KV reads | 100,000/day |
| KV writes | 1,000/day |
| KV storage | 1GB |

---

## Troubleshooting

### Error: "Worker exceeded CPU time limit"

**Cause:** Request taking >10ms

**Solution:**
- Enable cache more aggressively
- Reduce processing in Worker
- Move heavy logic to Brain API

### Error: "KV namespace not found"

**Cause:** KV namespace not created or ID mismatch

**Solution:**
```bash
wrangler kv:namespace list
# Copy ID to wrangler.toml
```

### Cache not working

**Cause:** KV binding not configured

**Solution:**
- Verify KV namespace ID in wrangler.toml
- Check `binding = "CACHE"` matches code

---

*Document: 05_CLOUDFLARE_SETUP.md*
*Research Date: February 3, 2026*
