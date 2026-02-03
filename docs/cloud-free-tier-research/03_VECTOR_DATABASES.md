# Vector Database Free Tier Comparison

> **Research Date:** February 3, 2026
> **Purpose:** Compare vector database free tiers for Brain backup/redundancy

---

## Quick Summary

| Provider | Free Storage | Dimensions | Vector Capacity | Best For |
|----------|--------------|------------|-----------------|----------|
| **Zilliz Cloud** | **5 GB** | Any | ~1M @ 768-dim | **Winner** |
| Pinecone | 2 GB | 1536 max | ~100K @ 1536-dim | Production |
| Qdrant | 1 GB | Any | ~200K @ 768-dim | Testing |
| Cloudflare Vectorize | 5M dims | Any | ~6.5K @ 768-dim | Edge only |
| Weaviate | 14-day trial | Any | N/A | Testing only |

---

## Why Vector DB Free Tiers Matter for SOLO

### Current Brain Storage Requirements

| Metric | Value |
|--------|-------|
| Records | 166,000+ |
| Embedding Model | Qwen3-VL-Embedding-2B |
| Dimensions | 2,048 |
| Total Dimensions | ~340 million |
| Estimated Storage | ~5-10 GB |

### The Problem

Even the **most generous free tier (Zilliz 5GB)** cannot store the full Brain:
- 340M dimensions ÷ 768-dim equivalent = ~443K "standard" vectors
- But Qwen3-VL uses 2,048 dimensions = ~2.7× storage

**Conclusion:** Free tiers are suitable for:
1. **Hot backup** of critical Brain subset
2. **Geographic redundancy** for read replicas
3. **Testing** and development

---

## Detailed Provider Analysis

### 1. Zilliz Cloud (Milvus) - ⭐⭐⭐⭐⭐ WINNER

```
┌─────────────────────────────────────────────────────────────────┐
│                      ZILLIZ CLOUD FREE TIER                      │
├─────────────────────────────────────────────────────────────────┤
│  STORAGE: 5 GB                                                  │
│  VECTORS: ~1,000,000 @ 768-dim / ~650,000 @ 1024-dim           │
│  DURATION: Forever (no credit card required)                    │
│                                                                  │
│  FEATURES:                                                       │
│  ├─ Full Milvus 2.6.x compatibility                            │
│  ├─ Scalar filtering (metadata queries)                        │
│  ├─ Hybrid search (vector + scalar)                            │
│  ├─ Multi-tenancy support                                      │
│  └─ RESTful API + SDKs (Python, JS, Go)                        │
│                                                                  │
│  LIMITS:                                                         │
│  ├─ 1 free cluster per account                                │
│  ├─ No SLA on free tier                                       │
│  └─ Best-effort performance                                   │
│                                                                  │
│  PAID: $0.023/hour (~$17/month) for serverless                 │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- **Most generous free tier** (5GB)
- Built on Milvus (battle-tested)
- Full feature set on free tier
- No credit card required

**Cons:**
- Still too small for full Brain
- No SLA on free tier
- Cold starts on free tier

**Best For SOLO:** Critical Brain subset backup, geographic read replica

---

### 2. Pinecone - ⭐⭐⭐

```
┌─────────────────────────────────────────────────────────────────┐
│                       PINECONE STARTER (FREE)                    │
├─────────────────────────────────────────────────────────────────┤
│  STORAGE: 2 GB                                                  │
│  VECTORS: ~100,000 @ 1536-dim                                  │
│  DURATION: Forever                                              │
│                                                                  │
│  FEATURES:                                                       │
│  ├─ 1 index per project                                        │
│  ├─ 5 namespaces per index                                     │
│  ├─ 2M write units/month                                       │
│  ├─ 1M read units/month                                        │
│  └─ Metadata filtering                                         │
│                                                                  │
│  LIMITS:                                                         │
│  ├─ 2GB storage limit                                          │
│  ├─ 20,000 max dimensions                                     │
│  ├─ Pod-based only (no serverless on free)                    │
│  └─ Community support only                                     │
│                                                                  │
│  PAID: Starts at $0.096/hour (~$70/month)                      │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Managed service (no ops)
- Good documentation
- Production-ready features

**Cons:**
- **Only 2GB** (smallest free tier)
- Expensive paid tier ($70/mo)
- Namespace limits on free tier

**Best For SOLO:** Testing, small MVP vectors

---

### 3. Qdrant Cloud - ⭐⭐⭐

```
┌─────────────────────────────────────────────────────────────────┐
│                       QDRANT CLOUD FREE                          │
├─────────────────────────────────────────────────────────────────┤
│  STORAGE: 1 GB                                                  │
│  VECTORS: ~200,000 @ 768-dim (with compression)                │
│  DURATION: Forever (no credit card required)                    │
│                                                                  │
│  FEATURES:                                                       │
│  ├─ 1GB cluster (free forever)                                 │
│  ├─ Full API compatibility with open-source                    │
│  ├─ Payload indexing (metadata)                                │
│  ├─ Quantization support (reduces storage)                     │
│  └─ Multi-cloud (AWS, GCP, Azure)                              │
│                                                                  │
│  LIMITS:                                                         │
│  ├─ 1GB storage                                                │
│  ├─ No SLA                                                     │
│  └─ Single region per cluster                                  │
│                                                                  │
│  PAID: Starts at $0.014/hour (~$10/month) for 1GB cluster      │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- Rust-based (fast)
- No credit card required
- Quantization reduces storage
- Multi-cloud deployment

**Cons:**
- **Only 1GB** (second smallest)
- Paid tier adds up quickly

**Best For SOLO:** Development, testing

---

### 4. Cloudflare Vectorize - ⭐⭐

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLOUDFLARE VECTORIZE FREE                     │
├─────────────────────────────────────────────────────────────────┤
│  QUERIED: 30 million vector dimensions/month                   │
│  STORED: 5 million vector dimensions                           │
│  DURATION: Forever (part of Workers Free)                      │
│                                                                  │
│  FEATURES:                                                       │
│  ├─ Edge-native (330+ locations)                               │
│  ├─ Integrated with Workers AI                                 │
│  ├─ Metadata filtering (10KB per vector)                       │
│  └─ Instant global replication                                 │
│                                                                  │
│  LIMITS:                                                         │
│  ├─ 5M stored dimensions = ~6,500 vectors @ 768-dim            │
│  ├─ 30M queried dimensions/month                               │
│  ├─ No standalone vector generation (need Workers AI)          │
│  └─ Best for edge workloads, not primary storage              │
│                                                                  │
│  PAID: $0.01 per million queried dimensions                    │
└─────────────────────────────────────────────────────────────────┘
```

**Pros:**
- True edge distribution
- Integrated with Workers
- No egress fees

**Cons:**
- **Very limited storage** (5M dims)
- Must use Workers AI for embeddings
- Not suitable as primary vector store

**Best For SOLO:** Edge caching of hot vectors

---

### 5. Weaviate - ⭐

```
┌─────────────────────────────────────────────────────────────────┐
│                       WEAVIATE CLOUD                             │
├─────────────────────────────────────────────────────────────────┤
│  STORAGE: 14-day free trial only                                │
│  VECTORS: N/A (trial only)                                      │
│  DURATION: 14 days                                              │
│                                                                  │
│  FEATURES:                                                       │
│  ├─ GraphQL + REST API                                         │
│  ├─ Multi-modal support                                         │
│  ├─ Module system (NER, Q&A, etc.)                             │
│  └─ Open-source (self-hostable)                                │
│                                                                  │
│  PAID: Starts at $25/month for serverless                       │
│                                                                  │
│  ALTERNATIVE: Self-host Weaviate on Oracle Cloud Free           │
└─────────────────────────────────────────────────────────────────┘
```

**Verdict:** Not recommended for free tier usage.

**Alternative:** Self-host Weaviate on Oracle Cloud's free tier (4 OCPU + 24GB RAM + 200GB storage)

---

## Comparison Matrix

| Feature | Zilliz | Pinecone | Qdrant | Vectorize |
|---------|--------|----------|--------|-----------|
| **Free Storage** | 5 GB ⭐⭐⭐⭐⭐ | 2 GB ⭐⭐⭐ | 1 GB ⭐⭐ | 5M dims ⭐ |
| **Vector Capacity** | ~1M @ 768-dim | ~100K @ 1536-dim | ~200K @ 768-dim | ~6.5K @ 768-dim |
| **Duration** | Forever ⭐⭐⭐⭐⭐ | Forever ⭐⭐⭐⭐⭐ | Forever ⭐⭐⭐⭐⭐ | Forever ⭐⭐⭐⭐⭐ |
| **Credit Card Required** | No ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐ | No ⭐⭐⭐⭐⭐ | No ⭐⭐⭐⭐⭐ |
| **Metadata Filtering** | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ |
| **Hybrid Search** | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ | Yes ⭐⭐⭐⭐⭐ |
| **Edge Distribution** | No ❌ | No ❌ | No ❌ | Yes ⭐⭐⭐⭐⭐ |
| **Self-Host Option** | Milvus ⭐⭐⭐⭐ | No ❌ | Yes ⭐⭐⭐⭐⭐ | No ❌ |
| **Overall Score** | **18/20** | **15/20** | **14/20** | **12/20** |

---

## Strategic Recommendation

### For SOLO Brain

| Use Case | Recommended | Backup |
|----------|-------------|--------|
| **Critical vectors backup** | Zilliz Cloud (5GB) | Self-host on Oracle |
| **Edge caching** | Cloudflare Vectorize | - |
| **Development** | Qdrant Cloud | - |
| **Production** | Keep LanceDB on Alienware | - |

### Hybrid Approach

```
┌─────────────────────────────────────────────────────────────────┐
│                   HYBRID VECTOR STRATEGY                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PRIMARY: LanceDB on Alienware (192.168.68.58)                  │
│  ├─ All 166K+ records                                          │
│  ├─ Qwen3-VL 2048-dim embeddings                               │
│  ├─ Sub-millisecond latency                                    │
│  └─ 100% private                                               │
│                                                                  │
│  BACKUP: Zilliz Cloud Free (5GB)                                │
│  ├─ ~50K most-critical vectors                                 │
│  ├─ Geographic redundancy                                      │
│  ├─ Read replica for global users                              │
│  └─ Disaster recovery                                          │
│                                                                  │
│  EDGE: Cloudflare Vectorize (5M dims)                          │
│  ├─ ~1K hot vectors                                            │
│  ├─ Cache at 330+ edge locations                               │
│  └─ Sub-50ms global latency                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Self-Hosting Alternative

**Best option:** Self-host Milvus/Qdrant on Oracle Cloud Always Free

| Resource | Oracle Free Tier |
|----------|------------------|
| Compute | 4 OCPU Arm + 24GB RAM |
| Storage | 200GB Block Volume |
| Network | 10TB egress/month |

**Setup:**
1. Create Oracle Always Free account
2. Spin up Ampere A1 instance (4 OCPU, 24GB RAM)
3. Install Milvus or Qdrant via Docker
4. Configure 200GB Block Volume for data
5. Set up sync from LanceDB to self-hosted DB

**Benefits:**
- **Full Brain capacity** (200GB > 5-10GB needed)
- **Always free** (no expiration)
- **Full control** over data
- **Can upgrade to paid** if needed

---

## Implementation Checklist

- [ ] Create Zilliz Cloud free account
- [ ] Test vector insert/query performance
- [ ] Identify top 50K critical vectors for backup
- [ ] Set up sync from LanceDB to Zilliz
- [ ] Configure Cloudflare Vectorize for edge cache
- [ ] Evaluate self-hosting on Oracle Cloud

---

*Document: 03_VECTOR_DATABASES.md*
*Research Date: February 3, 2026*
