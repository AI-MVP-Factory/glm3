# Decisions: Cloud Free Tier Strategy

> **Date:** February 3, 2026
> **Context:** SOLO infrastructure augmentation using free cloud tiers

---

## Decision 1: Keep Brain on Alienware

**Status:** ✅ CONFIRMED

**Rationale:**
- Oracle Arm CPU (Ampere A1) too weak for embedding inference
- Tested in production, had to migrate back
- 340M vector dimensions exceeds all free tier storage limits
- LAN latency (~6ms) unbeatable by cloud (~50-200ms)
- Data privacy concerns with external hosting

**Alternatives Considered:**
- Migrate to Oracle Cloud: Rejected due to weak CPU
- Migrate to paid GPU cloud: Rejected due to cost ($50-200/mo)
- Hybrid approach: Selected (see below)

---

## Decision 2: Use Cloudflare Workers for Edge Gateway

**Status:** ✅ APPROVED

**Rationale:**
- 100,000 requests/day free tier
- Edge caching reduces Brain load by 30-50%
- Global distribution (330+ PoPs)
- Rate limiting and auth validation
- Unlimited egress (unique to Cloudflare)

**Implementation:**
- Week 1 priority
- Cache-first architecture
- API key validation
- Circuit breaker for Brain failures

---

## Decision 3: Use Oracle Cloud for Data Plane Only

**Status:** ✅ APPROVED

**Rationale:**
- 4 OCPU + 24GB RAM sufficient for non-AI workloads
- 2x 20GB Autonomous Database for user/metadata
- 200GB Block Volume for backups
- 10TB egress/month (very generous)

**NOT Suitable For:**
- AI inference (embedding models)
- Vector search (LanceDB replacement)
- Real-time request serving

**Suitable For:**
- PostgreSQL database
- Grafana dashboards
- Backup storage
- Cron jobs

---

## Decision 4: Zilliz Cloud for Vector Backup

**Status:** ✅ APPROVED

**Rationale:**
- 5GB free storage (vs 2GB Pinecone, 1GB Qdrant)
- Built on Milvus (production-proven)
- Full feature set on free tier
- No credit card required

**Use Case:**
- Hot backup of ~50K critical vectors
- Geographic read replica
- Disaster recovery

**NOT Suitable For:**
- Full Brain backup (340M dims too large)

---

## Decision 5: Defer AWS Lambda Until Needed

**Status:** ⏸️ DEFERRED

**Rationale:**
- Not immediately necessary
- Can use Oracle cron jobs for scheduled tasks
- Add when webhook requirements emerge

**Future Use Cases:**
- GitHub webhooks
- Slack integration
- Batch processing

---

## Decision 6: Use GCP BigQuery for Analytics

**Status:** ✅ APPROVED

**Rationale:**
- 1TB/month query capacity
- Excellent for usage analytics
- Looker Studio integration
- Can ingest from Oracle PostgreSQL

**Implementation:**
- Week 4 priority
- Pipeline: Oracle → Lambda → BigQuery
- Dashboards for:
  - Query patterns
  - Performance metrics
  - User behavior

---

## Decision Record Summary

| ID | Decision | Date | Status |
|----|----------|------|--------|
| 2026-02-03-01 | Keep Brain on Alienware | 2026-02-03 | ✅ Confirmed |
| 2026-02-03-02 | Cloudflare Workers for edge | 2026-02-03 | ✅ Approved |
| 2026-02-03-03 | Oracle for data plane | 2026-02-03 | ✅ Approved |
| 2026-02-03-04 | Zilliz for vector backup | 2026-02-03 | ✅ Approved |
| 2026-02-03-05 | Defer AWS Lambda | 2026-02-03 | ⏸️ Deferred |
| 2026-02-03-06 | GCP BigQuery for analytics | 2026-02-03 | ✅ Approved |

---

*Decision Record: 2026-02-03*
