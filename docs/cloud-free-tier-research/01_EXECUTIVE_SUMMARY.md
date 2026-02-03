# Cloud Free Tier Research - Executive Summary

> **Research Date:** February 3, 2026
> **Objective:** Find free cloud tiers to augment SOLO infrastructure without migrating core Brain AI workloads

---

## TL;DR

**Oracle Cloud's Arm CPU is too weak for AI inference.** We tried it and had to migrate back. However, free tiers ARE valuable for:

1. **Edge API gateway** (Cloudflare Workers) - Cache responses, rate limiting
2. **Data plane** (Oracle Cloud) - Databases, storage, monitoring dashboards
3. **Vector backup** (Zilliz Cloud) - 5GB free vector storage
4. **Analytics** (GCP) - BigQuery 1TB/month for usage analysis

**Total free value: ~$85/month** in services that complement (not replace) Alienware Brain.

---

## Current SOLO Infrastructure

```
┌─────────────────────────────────────────────────────────────────┐
│                      SOLO BRAIN (Alienware)                     │
├─────────────────────────────────────────────────────────────────┤
│  IP: 192.168.68.58 (LAN)                                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ Qwen3-VL-Embedding-2B  (2048-dim multimodal)            │  │
│  │ Qwen3-VL-Reranker-2B    (cross-encoder scoring)          │  │
│  │ LanceDB                  (166K+ records, 340M dims)      │  │
│  │ Brain API                (FastAPI on port 8080)          │  │
│  │ LiteLLM                  (port 4001)                     │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Latency: ~6ms on LAN                                           │
│  Data: 166K+ records, 37 tables, 120K research_neural           │
└─────────────────────────────────────────────────────────────────┘
```

---

## The Problem: Why Not Migrate Brain to Cloud?

| Issue | Details |
|-------|---------|
| **Storage** | 340M vector dimensions > all free tiers (max 5-5M) |
| **Compute** | Arm CPUs too weak for embedding inference |
| **Cost** | Paid tiers would be $50-200+/month |
| **Privacy** | Brain data on external servers |
| **Latency** | Cloud ~50-200ms vs LAN ~6ms |

**Conclusion:** Keep Brain on Alienware. Use free tiers for complementary services.

---

## The Solution: Distributed Free Fleet

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SOLO DISTRIBUTED FLEET                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  🧠 BRAIN (Alienware) - HEAVY LIFTING ONLY                             │
│  ├─ Qwen3-VL-Embedding-2B (inference)                                  │
│  ├─ Qwen3-VL-Reranker-2B (scoring)                                     │
│  ├─ LanceDB (166K+ records)                                            │
│  └─ Brain API                                                          │
│                                                                          │
│  🌐 EDGE LAYER (Cloudflare Workers Free)                                │
│  ├─ API Gateway / Rate limiting (100K req/day)                         │
│  ├─ Response caching (reduce Brain load)                                │
│  ├─ Request validation / auth                                          │
│  └─ Geographic edge distribution (330 PoPs)                             │
│                                                                          │
│  💾 DATA LAYER (Oracle Cloud Free - 24GB RAM, 200GB storage)           │
│  ├─ PostgreSQL (Autonomous DB 2×20GB)                                   │
│  │   ├─ User accounts, API keys                                        │
│  │   ├─ Usage analytics                                                │
│  │   └─ Metadata (not embeddings)                                       │
│  ├─ Object Storage (10GB)                                               │
│  │   ├─ Brain backups (LanceDB snapshots)                               │
│  │   └─ Logs / archives                                                 │
│  └─ Arm Compute (4 OCPU)                                                │
│       ├─ Grafana / Prometheus (monitoring)                              │
│       ├─ Admin dashboard                                                │
│       └─ Background cron jobs                                           │
│                                                                          │
│  🔔 EVENTS (AWS Lambda Free - 1M req/month)                             │
│  ├─ Webhook handlers (GitHub, Slack, etc.)                              │
│  └─ Scheduled tasks (via EventBridge)                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Provider Rankings

### By Generosity (Always Free)

| Rank | Provider | Compute | Storage | Value |
|------|----------|---------|---------|-------|
| 1 | Oracle Cloud | 4 OCPU + 24GB RAM | 200GB + 2 DBs | ~$50/mo |
| 2 | Google Cloud | 0.25 vCPU + 1GB | 5GB + BigQuery 1TB | ~$20/mo |
| 3 | AWS Lambda | 1M req/mo | DynamoDB 25GB | ~$10/mo |
| 4 | Cloudflare | 100K req/day | 10GB R2 + 5M vec dims | ~$5/mo |
| 5 | Azure | 12mo limited | 4 App Services | ~$15/mo (1yr) |

### By Suitability for SOLO

| Rank | Provider | Use Case | Score |
|------|----------|----------|-------|
| 1 | **Cloudflare Workers** | Edge API gateway | ⭐⭐⭐⭐⭐ |
| 2 | **Oracle Cloud** | Data plane, backups | ⭐⭐⭐⭐ |
| 3 | **Zilliz Cloud** | Vector backup | ⭐⭐⭐⭐ |
| 4 | **GCP Free** | Analytics | ⭐⭐⭐ |
| 5 | **AWS Lambda** | Webhooks | ⭐⭐⭐ |

---

## Vector Database Free Tiers

| Provider | Free Storage | Vector Capacity | Score |
|----------|--------------|-----------------|-------|
| **Zilliz Cloud** | 5 GB | ~1M 768-dim vectors | ⭐⭐⭐⭐⭐ |
| Pinecone | 2 GB | ~100K 1536-dim vectors | ⭐⭐⭐ |
| Qdrant | 1 GB | ~200K 768-dim vectors | ⭐⭐⭐ |
| Cloudflare Vectorize | 5M dims | ~6,500 768-dim vectors | ⭐⭐ |

---

## Recommended Implementation Priority

### Phase 1: Edge Layer (Week 1) - Highest ROI
- **Cloudflare Workers** as caching API gateway
- Reduces Brain load by 30-50% for cached queries
- Adds rate limiting and request validation
- Global edge distribution (330 PoPs)

### Phase 2: Data Plane (Week 2)
- **Oracle Cloud** for PostgreSQL, backups
- Autonomous DB for user accounts, API keys, usage metrics
- Object storage for LanceDB snapshots

### Phase 3: Monitoring (Week 3)
- **Oracle Cloud** for Grafana dashboards
- Monitor Brain API performance, usage patterns
- Alert on anomalies

### Phase 4: Analytics (Week 4)
- **GCP BigQuery** for usage analytics
- Query patterns, popular endpoints, performance metrics

---

## What This Actually Gets You

| Problem | Free Solution | Benefit |
|---------|---------------|---------|
| **Brain API slow** | Cloudflare cache at edge | -90% latency for cached queries |
| **No monitoring** | Oracle + Grafana | Full observability |
| **No backups** | Oracle Object Storage | 10GB free backup |
| **No admin UI** | Oracle Arm compute | Host dashboards |
| **No analytics** | GCP BigQuery | 1TB/month queries |
| **Single point of failure** | Distributed services | Better resilience |

---

## Key Constraints Discovered

1. **Oracle Arm CPU insufficient for AI** - Tested and confirmed
2. **Vector storage limits** - Even Zilliz's 5GB can't hold full Brain
3. **Free tiers have usage limits** - Designed for testing/learning
4. **No GPU in free tiers** - AI inference requires paid tiers

---

## Bottom Line

**Keep Brain on Alienware.** Use free tiers for:
- Edge caching and API gateway (Cloudflare)
- Databases and backups (Oracle)
- Monitoring dashboards (Oracle + Grafana)
- Analytics (GCP BigQuery)
- Webhooks (AWS Lambda)

**Total free value: ~$85/month** in services that complement Alienware Brain.

---

*Document: 01_EXECUTIVE_SUMMARY.md*
*Research Date: February 3, 2026*
