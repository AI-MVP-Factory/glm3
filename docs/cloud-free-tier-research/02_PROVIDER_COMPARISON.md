# Cloud Provider Free Tier Comparison

> **Research Date:** February 3, 2026
> **Providers Analyzed:** 20+
> **Focus:** Always-free tiers (not trial credits)

---

## Complete Provider Rankings

### Tier 1: Most Generous (Always Free)

| Rank | Provider | Compute Free | Storage Free | DB Free | Network Free | Est. Value |
|------|----------|--------------|--------------|---------|--------------|------------|
| **1** | **Oracle Cloud** | 4 OCPU Arm + 24GB RAM | 200GB Block + 30GB Object | 2×20GB Autonomous DB | 10TB egress/mo | **~$50/mo** |
| **2** | **Google Cloud** | e2-micro (0.25 vCPU, 1GB) | 5GB Cloud Storage | Cloud SQL (limited) | 1GB egress | **~$20/mo** |
| **3** | **Cloudflare** | Workers (100K req/day) | 10GB R2 + 5M Vectorize dims | D1 SQL (5GB) | Unlimited egress | **~$5/mo** |

### Tier 2: Serverless/Function Focus

| Provider | Free Compute | Free Requests | Duration | Value |
|----------|--------------|---------------|----------|-------|
| **AWS Lambda** | 400K GB-sec/mo | 1M requests/mo | Up to 15min | ~$10/mo |
| **Azure Functions** | 1M requests/mo | 400K GB-sec/mo | Up to 10min | ~$10/mo |
| **GCP Cloud Run** | 2M requests/mo | 200K vCPU-sec | Up to 60min | ~$15/mo |

### Tier 3: Limited Compute (12 Months Only)

| Provider | Free Compute | Duration | After Period |
|----------|--------------|----------|--------------|
| **AWS EC2** | t2.micro (1 vCPU, 1GB) | 12 months | Paid only |
| **Azure B1S** | 1 vCPU, 1GB | 750 hrs/mo × 12mo | Paid only |
| **GCP e2-micro** | 0.25 vCPU, 1GB | Always free | Always free |

### Tier 4: Developer Platforms (Changed in 2025-2026)

| Provider | Status | Notes |
|----------|--------|-------|
| **Railway** | ❌ No longer always free | Trial credits only, then usage-based |
| **Fly.io** | ❌ No longer always free | Trial credits only, then usage-based |
| **Render** | ⚠️ Limited | 750 hrs/mo (0.1 vCPU, 512MB) |
| **Northflank** | ✅ 2 free services | 2 services + 2 DBs |

### Tier 5: Frontend/Static Focus

| Provider | Free Tier | Best For |
|----------|-----------|----------|
| **Vercel** | Edge functions, 35+ frameworks | Next.js deployments |
| **Netlify** | Static sites, Functions | JAMstack |
| **Cloudflare Pages** | Static sites, Functions | Frontend hosting |

---

## Detailed Breakdown: Top 5 Providers

### 1. Oracle Cloud Always Free (Winner)

```
┌─────────────────────────────────────────────────────────────────┐
│                   ORACLE CLOUD ALWAYS FREE                      │
├─────────────────────────────────────────────────────────────────┤
│  COMPUTE:                                                        │
│  ├─ 2x AMD VMs: 1/8 OCPU (0.25 vCPU) + 1GB RAM each            │
│  └─ 4x Arm VMs: 24GB RAM total, 3,000 OCPU-hours/mo            │
│                                                                  │
│  STORAGE:                                                         │
│  ├─ 2x Block Volumes: 200GB total                               │
│  ├─ 10GB Object Storage (Standard)                              │
│  ├─ 10GB Object Storage (Infrequent Access)                     │
│  └─ 10GB Archive Storage                                        │
│                                                                  │
│  DATABASES:                                                       │
│  ├─ 2x Autonomous Database (20GB each)                          │
│  └─ NoSQL Database: 25GB × 3 tables                             │
│                                                                  │
│  NETWORK:                                                         │
│  ├─ 10TB egress/month per region                               │
│  ├─ 4x Load Balancers (1 flexible + 3 network)                 │
│  └─ 5x Bastions                                                 │
│                                                                  │
│  OTHER:                                                           │
│  ├─ Resource Manager (Terraform)                               │
│  ├─ Monitoring & Notifications                                  │
│  └─ 30-day free trial: $300 credit + 5TB storage               │
│                                                                  │
│  ESTIMATED VALUE: ~$50/month                                     │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Only provider with substantial always-free compute
- Generous storage (200GB + 30GB object)
- 10TB egress is huge
- Two full databases included

**Cons:**
- Arm CPU (Neoverse-N1) too weak for AI inference
- Documentation can be confusing
- Console is enterprise-complex

**Best For SOLO:** Data plane, backups, monitoring dashboards

---

### 2. Google Cloud Always Free

```
┌─────────────────────────────────────────────────────────────────┐
│                    GOOGLE CLOUD ALWAYS FREE                      │
├─────────────────────────────────────────────────────────────────┤
│  COMPUTE:                                                        │
│  └─ e2-micro: 0.25 vCPU + 1GB RAM (us-west1/central1/east1)   │
│                                                                  │
│  STORAGE:                                                         │
│  └─ 5GB-months Regional Cloud Storage (US regions)             │
│                                                                  │
│  DATABASES:                                                       │
│  ├─ BigQuery: 1TB querying/month + 10GB storage               │
│  └─ Cloud Firestore: 1GB                                      │
│                                                                  │
│  NETWORK:                                                         │
│  ├─ 1GB egress/month (premium tier)                            │
│  └─ 200GB egress/month (standard tier, +20% latency)           │
│                                                                  │
│  OTHER:                                                           │
│  ├─ Cloud Run: 2M requests/month                               │
│  ├─ Cloud Functions: 2M invocations/month                     │
│  └─ Pub/Sub: 10GB of messaging data                           │
│                                                                  │
│  ESTIMATED VALUE: ~$20/month                                     │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- BigQuery 1TB/month is excellent for analytics
- Cloud Run for containerized apps
- Well-documented, great console

**Cons:**
- e2-micro is very small (0.25 vCPU)
- Only 1GB network egress on premium tier
- Not suitable for compute-heavy workloads

**Best For SOLO:** Analytics (BigQuery), small services

---

### 3. Cloudflare Free Plan

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLOUDFLARE FREE PLAN                          │
├─────────────────────────────────────────────────────────────────┤
│  COMPUTE:                                                        │
│  ├─ Workers: 100,000 requests/day                              │
│  ├─ Pages Functions: Serverless functions                      │
│  └─ CPU time: 10ms per request (free)                          │
│                                                                  │
│  STORAGE:                                                         │
│  ├─ R2 Object Storage: 10GB                                    │
│  ├─ D1 SQL Database: 5GB                                       │
│  └─ KV Storage: 1GB (100k reads/day)                           │
│                                                                  │
│  NETWORK:                                                         │
│  ├─ Unlimited egress (no bandwidth charges)                    │
│  ├─ 330+ global edge locations                                 │
│  └─ CDN with automatic HTTPS                                   │
│                                                                  │
│  AI (WORKERS AI):                                                 │
│  ├─ 10,000 neurons/day                                         │
│  └─ Vectorize: 5M queried vector dimensions/mo                 │
│                                                                  │
│  OTHER:                                                           │
│  ├─ DDoS protection                                            │
│  ├─ Web Application Firewall (WAF)                             │
│  └─ DNS hosting                                                 │
│                                                                  │
│  ESTIMATED VALUE: ~$5/month                                      │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- True global edge (330+ PoPs)
- Unlimited egress is unique
- Workers are fast for edge logic
- 100K requests/day is decent

**Cons:**
- 10ms CPU limit per request
- Workers AI limited (10K neurons/day)
- Vectorize too small for Brain (5M dims)

**Best For SOLO:** Edge API gateway, caching, rate limiting

---

### 4. AWS Free Tier

```
┌─────────────────────────────────────────────────────────────────┐
│                       AWS FREE TIER                              │
├─────────────────────────────────────────────────────────────────┤
│  ALWAYS FREE:                                                     │
│  ├─ Lambda: 1M requests/month + 400K GB-seconds                │
│  ├─ API Gateway: 1M API calls/month                            │
│  ├─ DynamoDB: 25GB storage + 25 R/W units                      │
│  └─ SNS: 1M publishes/month                                    │
│                                                                  │
│  12 MONTHS FREE:                                                  │
│  ├─ EC2: t2.micro (1 vCPU, 1GB) × 750 hrs/mo                   │
│  ├─ RDS: 750 hrs/month of db.t2.micro                         │
│  └─ S3: 5GB storage                                             │
│                                                                  │
│  FREE TRIAL:                                                      │
│  └─ $200 credit for first month                                 │
│                                                                  │
│  ESTIMATED VALUE: ~$15/month (always free), ~$50/month (year 1) │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Lambda 1M requests/month is generous
- DynamoDB 25GB always free
- API Gateway included

**Cons:**
- EC2 expires after 12 months
- Complex pricing structure
- Data transfer costs add up

**Best For SOLO:** Lambda functions, webhooks, event handlers

---

### 5. Azure Free Tier

```
┌─────────────────────────────────────────────────────────────────┐
│                       AZURE FREE TIER                            │
├─────────────────────────────────────────────────────────────────┤
│  12 MONTHS FREE:                                                  │
│  ├─ B1S VM: 1 vCPU + 1GB RAM × 750 hrs/mo                      │
│  ├─ B2pts v2 (Arm) and B2ats v2 (AMD) burstable VMs            │
│  ├─ 750 hrs/month managed disks                               │
│  └─ App Service: 1 Free tier                                   │
│                                                                  │
│  ALWAYS FREE (65+ services):                                     │
│  ├─ App Service: 4 Free tiers                                  │
│  ├─ Cosmos DB: Limited                                         │
│  ├─ Functions: 1M requests/month                               │
│  └─ Blob Storage: 5GB LRS                                      │
│                                                                  │
│  FREE TRIAL:                                                      │
│  ├─ $200 credit for first 30 days                              │
│  └─ 30 days of free services                                   │
│                                                                  │
│  ESTIMATED VALUE: ~$15/month (year 1), ~$5/month (after)       │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Good Windows VM options
- App Service free tier
- 65+ always-free services

**Cons:**
- VMs expire after 12 months
- Console can be overwhelming
- Data transfer costs

**Best For SOLO:** Windows workloads, App Service deployments

---

## Comparison Matrix

| Feature | Oracle | GCP | AWS | Azure | Cloudflare |
|---------|--------|-----|-----|-------|------------|
| **Always-Free Compute** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐ | ⭐⭐⭐⭐ |
| **Always-Free Storage** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Always-Free DB** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **Network Egress** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Edge/CDN** | ❌ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Serverless Functions** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **AI/ML** | ❌ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Vector DB** | ❌ | ⭐⭐ | ❌ | ⭐⭐ | ⭐⭐ |
| **Monitoring** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Ease of Use** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## Providers NOT Recommended for SOLO

| Provider | Reason | Verdict |
|----------|--------|---------|
| **Railway** | No longer always free (trial only) | ❌ Skip |
| **Fly.io** | No longer always free (trial only) | ❌ Skip |
| **Heroku** | No free tier since 2022 | ❌ Skip |
| **DigitalOcean** | $100 credit 60-day trial only | ❌ Skip |
| **Linode/Akamai** | $100 credit 60-day trial only | ❌ Skip |
| **Hetzner** | No always-free tier (cheap but paid) | ❌ Skip |
| **OVHcloud** | 200€ 30-day trial only | ❌ Skip |

---

## Summary

| Use Case | Best Provider | Alternative |
|----------|---------------|-------------|
| **Heavy Compute** | Oracle (4 OCPU) | - |
| **Edge Gateway** | Cloudflare Workers | - |
| **Analytics** | GCP BigQuery | - |
| **Serverless** | AWS Lambda | GCP Cloud Run |
| **Vector DB** | Zilliz Cloud | Pinecone |
| **Object Storage** | Oracle R2 | Cloudflare R2 |
| **SQL Database** | Oracle Autonomous DB | Cloudflare D1 |
| **Monitoring** | Oracle + Grafana | GCP Cloud Monitoring |

---

*Document: 02_PROVIDER_COMPARISON.md*
*Research Date: February 3, 2026*
