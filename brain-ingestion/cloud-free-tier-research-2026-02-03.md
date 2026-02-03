# Brain Ingestion: Cloud Free Tier Research

> **Session Date:** February 3, 2026
> **Research Type:** Infrastructure Analysis
> **Tags:** cloud, free-tier, oracle, cloudflare, sox-infrastructure

---

## Executive Summary

After researching 20+ cloud providers' free tiers, the key finding is:

**Oracle Cloud's Arm CPU is too weak for AI inference.** SOLO tested this and had to migrate back to Alienware.

**However, free tiers ARE valuable for:**
1. Edge API gateway (Cloudflare Workers) - Cache, rate limiting
2. Data plane (Oracle Cloud) - Databases, storage, monitoring
3. Vector backup (Zilliz Cloud) - 5GB free vector storage
4. Analytics (GCP) - BigQuery 1TB/month

**Total free value: ~$85/month** in services that complement Alienware Brain.

---

## Key Decisions

| Decision | Rationale | Confidence |
|----------|-----------|------------|
| Keep Brain on Alienware | Arm CPU too weak for embedding inference | 100% |
| Use Cloudflare for edge gateway | Reduces load, adds global distribution | 90% |
| Use Oracle for data plane only | Sufficient for non-AI workloads | 85% |
| Zilliz over Pinecone | 5GB vs 2GB free storage | 95% |

---

## Technical Specifications

### Current SOLO Infrastructure

```
Alienware (192.168.68.58):
- Qwen3-VL-Embedding-2B: 2048-dim multimodal
- Qwen3-VL-Reranker-2B: Cross-encoder scoring
- LanceDB: 166K+ records, ~340M dimensions
- Brain API: FastAPI on port 8080
- LiteLLM: Multi-model router on port 4001
```

### Why Not Migrate Brain to Cloud?

| Issue | Details |
|-------|---------|
| Storage | 340M dims > all free tiers (max 5-5M) |
| Compute | Arm CPUs too weak for embedding inference |
| Cost | Paid tiers $50-200+/month |
| Privacy | Brain data on external servers |
| Latency | Cloud ~50-200ms vs LAN ~6ms |

---

## Provider Rankings

### Most Generous Always Free

1. **Oracle Cloud** - 4 OCPU Arm + 24GB RAM, 200GB storage, 2x 20GB DB
2. **Google Cloud** - e2-micro (0.25 vCPU), BigQuery 1TB/month
3. **Cloudflare** - Workers 100K/day, R2 10GB, Vectorize 5M dims
4. **AWS Lambda** - 1M requests/month
5. **Azure** - B1S VM (12 months only)

### Best for SOLO Use Cases

| Use Case | Best Provider | Alternative |
|----------|---------------|-------------|
| Edge Gateway | Cloudflare Workers | - |
| Data Plane | Oracle Cloud | - |
| Vector Backup | Zilliz Cloud | Pinecone |
| Analytics | GCP BigQuery | - |
| Webhooks | AWS Lambda | GCP Cloud Run |

---

## Vector Database Comparison

| Provider | Free Storage | Vector Capacity | Score |
|----------|--------------|-----------------|-------|
| Zilliz Cloud | 5 GB | ~1M @ 768-dim | ⭐⭐⭐⭐⭐ |
| Pinecone | 2 GB | ~100K @ 1536-dim | ⭐⭐⭐ |
| Qdrant | 1 GB | ~200K @ 768-dim | ⭐⭐⭐ |
| Cloudflare Vectorize | 5M dims | ~6.5K @ 768-dim | ⭐⭐ |

---

## Recommended Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SOLO DISTRIBUTED FLEET                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  🧠 BRAIN (Alienware) - HEAVY LIFTING ONLY                     │
│  ├─ Qwen3-VL-Embedding-2B (inference)                          │
│  ├─ Qwen3-VL-Reranker-2B (scoring)                             │
│  ├─ LanceDB (166K+ records)                                    │
│  └─ Brain API                                                  │
│                                                                  │
│  🌐 EDGE LAYER (Cloudflare Workers Free)                        │
│  ├─ API Gateway / Rate limiting (100K req/day)                 │
│  ├─ Response caching (reduce Brain load)                        │
│  ├─ Request validation / auth                                  │
│  └─ Geographic edge distribution (330 PoPs)                     │
│                                                                  │
│  💾 DATA LAYER (Oracle Cloud Free)                             │
│  ├─ PostgreSQL (2×20GB)                                        │
│  │   ├─ User accounts, API keys                                │
│  │   ├─ Usage analytics                                        │
│  │   └─ Metadata (not embeddings)                              │
│  ├─ Object Storage (10GB)                                       │
│  │   ├─ Brain backups (LanceDB snapshots)                      │
│  │   └─ Logs / archives                                        │
│  └─ Arm Compute (4 OCPU)                                        │
│       ├─ Grafana / Prometheus (monitoring)                     │
│       ├─ Admin dashboard                                        │
│       └─ Background cron jobs                                   │
│                                                                  │
│  🔔 EVENTS (AWS Lambda Free - 1M req/month)                     │
│  ├─ Webhook handlers (GitHub, Slack, etc.)                      │
│  └─ Scheduled tasks (via EventBridge)                           │
│                                                                  │
│  📊 ANALYTICS (GCP Free)                                        │
│  └─ BigQuery (1TB/month) for usage analytics                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Implementation Priority

1. **Phase 1:** Cloudflare Workers (Week 1)
   - API gateway with caching
   - Rate limiting
   - Request validation

2. **Phase 2:** Oracle Cloud (Week 2)
   - PostgreSQL for user/metadata
   - Object storage for backups
   - Grafana for monitoring

3. **Phase 3:** Backups (Week 3)
   - Automated LanceDB snapshots
   - Upload to Oracle Object Storage
   - Scheduled cleanup

4. **Phase 4:** Analytics (Week 4)
   - Metrics to Oracle PostgreSQL
   - Pipeline to GCP BigQuery
   - Looker Studio dashboards

---

## What This Gets SOLO

| Problem | Free Solution | Benefit |
|---------|---------------|---------|
| Brain API slow | Cloudflare cache at edge | -90% latency for cached |
| No monitoring | Oracle + Grafana | Full observability |
| No backups | Oracle Object Storage | 10GB free backup |
| No admin UI | Oracle Arm compute | Host dashboards |
| No analytics | GCP BigQuery | 1TB/month queries |
| Single point of failure | Distributed services | Better resilience |

---

## Costs

| Service | Monthly Value | Notes |
|---------|---------------|-------|
| Alienware Brain | $0 (sunk) | Hardware already owned |
| Cloudflare Workers | ~$5 | 100K req/day |
| Oracle Cloud | ~$50 | 4 OCPU + 24GB + 200GB |
| AWS Lambda | ~$5 | 1M requests/mo |
| GCP BigQuery | ~$10 | 1TB query/mo |
| **Total Free Value** | **~$70/mo** | **~$840/yr** |

---

## Constraints Discovered

1. **Oracle Arm CPU insufficient for AI** - Tested and confirmed
2. **Vector storage limits** - Even Zilliz's 5GB can't hold full Brain
3. **Free tiers have usage limits** - Designed for testing/learning
4. **No GPU in free tiers** - AI inference requires paid tiers

---

## Related Documents

- Provider Comparison: `~/dev/glm3/docs/cloud-free-tier-research/02_PROVIDER_COMPARISON.md`
- Vector Databases: `~/dev/glm3/docs/cloud-free-tier-research/03_VECTOR_DATABASES.md`
- Architecture: `~/dev/glm3/docs/cloud-free-tier-research/04_ARCHITECTURE.md`
- Cloudflare Setup: `~/dev/glm3/docs/cloud-free-tier-research/05_CLOUDFLARE_SETUP.md`
- Oracle Setup: `~/dev/glm3/docs/cloud-free-tier-research/06_ORACLE_SETUP.md`
- Roadmap: `~/dev/glm3/docs/cloud-free-tier-research/07_ROADMAP.md`

---

## Sources

- Cloudflare Workers: https://developers.cloudflare.com/workers/
- Oracle Cloud Free: https://www.oracle.com/cloud/free/
- Zilliz Cloud: https://zilliz.com/pricing
- GCP Free: https://cloud.google.com/free
- Cloud-Free-Tier-Comparison: https://github.com/cloudcommunity/Cloud-Free-Tier-Comparison

---

*Brain Ingestion: 2026-02-03*
*Research: Cloud Free Tiers for SOLO Infrastructure*
