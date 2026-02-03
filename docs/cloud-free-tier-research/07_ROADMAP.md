# Implementation Roadmap

> **Purpose:** Step-by-step plan to implement SOLO Free Fleet
> **Timeline:** 4 weeks
> **Total Time Estimate:** 8-12 hours

---

## Overview

| Phase | Focus | Duration | Priority |
|-------|-------|----------|----------|
| **Week 1** | Edge API Gateway | 2-3 hours | HIGH |
| **Week 2** | Data Plane Setup | 3-4 hours | HIGH |
| **Week 3** | Monitoring & Backups | 2-3 hours | MEDIUM |
| **Week 4** | Analytics & Polish | 1-2 hours | LOW |

---

## Week 1: Edge API Gateway (Cloudflare Workers)

**Goal:** Reduce load on Brain by 30-50% through caching and rate limiting

### Day 1: Account & Worker Setup (30 min)

- [ ] Create Cloudflare account
- [ ] Install Wrangler CLI
- [ ] Create brain-gateway worker
- [ ] Test hello world

### Day 2: Core Implementation (1 hour)

- [ ] Implement proxyToBrain function
- [ ] Add API key validation
- [ ] Add rate limiting (per IP)
- [ ] Test basic proxy functionality

### Day 3: Caching Layer (1 hour)

- [ ] Create KV namespace
- [ ] Implement cache-first logic
- [ ] Add cache key generation
- [ ] Test cache hit/miss scenarios

### Day 4: Deployment (30 min)

- [ ] Set environment variables
- [ ] Set API key secret
- [ ] Deploy to production
- [ ] Configure custom domain (optional)

### Day 5: Testing & Verification (30 min)

- [ ] Test all Brain endpoints through gateway
- [ ] Verify caching works
- [ ] Verify rate limiting works
- [ ] Check logs and metrics

**Success Criteria:**
- Gateway responds to requests
- Cached responses return in <50ms
- Rate limiting blocks abusive requests
- Brain API logs show reduced traffic

---

## Week 2: Data Plane Setup (Oracle Cloud)

**Goal:** Offload user data, metrics, and backups from Brain

### Day 1: Oracle Account & VCN (30 min)

- [ ] Create Oracle Cloud account
- [ ] Verify Always Free resources
- [ ] Create VCN (solo-vcn)
- [ ] Configure security lists

### Day 2: Compute Instance (1 hour)

- [ ] Create Ampere A1 instance (4 OCPU, 24GB RAM)
- [ ] Generate SSH key
- [ ] Connect via SSH
- [ ] Update system packages

### Day 3: Storage Setup (1 hour)

- [ ] Create 2x 100GB Block Volumes
- [ ] Attach to instance
- [ ] Format and mount volumes
- [ ] Configure auto-mount on boot

### Day 4: PostgreSQL Install (1 hour)

- [ ] Install PostgreSQL
- [ ] Create solo_brain database
- [ ] Create schema (users, api_keys, usage_logs)
- [ ] Test remote connections

### Day 5: Object Storage (30 min)

- [ ] Create solo-brain-backups bucket
- [ ] Install OCI CLI
- [ ] Test upload/download
- [ ] Configure lifecycle rules

**Success Criteria:**
- PostgreSQL accessible and working
- Block volumes mounted and persistent
- Can upload files to Object Storage
- Can connect to instance remotely

---

## Week 3: Monitoring & Backups

**Goal:** Full observability and automated backups

### Day 1: Grafana Setup (30 min)

- [ ] Install Docker
- [ ] Create docker-compose.yml
- [ ] Deploy Grafana + Prometheus
- [ ] Access dashboards on port 3000

### Day 2: Metrics Collection (1 hour)

- [ ] Create Brain API /metrics endpoint
- [ ] Add Prometheus scrape config
- [ ] Create dashboards:
  - Request rate
  - Response time percentiles
  - Error rate
  - Cache hit rate

### Day 3: Backup Script (1 hour)

- [ ] Create backup-brain.sh script
- [ ] Add snapshot trigger from Brain
- [ ] Add upload to Oracle Object Storage
- [ ] Add checksum verification

### Day 4: Scheduled Tasks (30 min)

- [ ] Configure cron jobs:
  - Daily 2AM: Backup
  - Daily 3AM: Metrics aggregation
  - Weekly: Cleanup
- [ ] Test scheduled runs
- [ ] Verify logs

### Day 5: Testing & Verification (30 min)

- [ ] Trigger manual backup
- [ ] Verify backup appears in Object Storage
- [ ] Test restore from backup
- [ ] Verify metrics in Grafana

**Success Criteria:**
- Grafana accessible and showing metrics
- Backups running automatically
- Can restore from backup
- Logs aggregating correctly

---

## Week 4: Analytics & Polish

**Goal:** Usage analytics and final touches

### Day 1: BigQuery Setup (30 min)

- [ ] Create GCP account
- [ ] Create BigQuery project
- [ ] Create dataset: solo_brain
- [ ] Create tables: usage_daily, queries_top

### Day 2: Data Pipeline (1 hour)

- [ ] Create AWS Lambda function
- [ ] Pull metrics from Oracle PostgreSQL
- [ ] Transform and load to BigQuery
- [ ] Schedule via EventBridge

### Day 3: Dashboards (30 min)

- [ ] Create Looker Studio dashboard
- [ ] Connect to BigQuery data
- [ ] Add charts:
  - Queries over time
  - Top queries
  - User activity
  - Performance trends

### Day 4: Integration Testing (1 hour)

- [ ] End-to-end test: Query → Cache → Brain → Log → Oracle → BigQuery
- [ ] Test failure scenarios:
  - Brain down
  - Oracle full
  - Network issues
- [ ] Verify graceful degradation

### Day 5: Documentation (30 min)

- [ ] Document all endpoints
- [ ] Create runbook for failures
- [ ] Update architecture diagrams
- [ ] Create handoff document

**Success Criteria:**
- Data flowing to BigQuery
- Dashboards showing insights
- All endpoints documented
- Runbook complete

---

## Full Checklist

### Phase 1: Cloudflare Workers
- [ ] Cloudflare account created
- [ ] Wrangler CLI installed
- [ ] KV namespace created
- [ ] Worker code deployed
- [ ] API key validation working
- [ ] Rate limiting working
- [ ] Caching working
- [ ] Custom domain configured
- [ ] Logs and metrics enabled

### Phase 2: Oracle Cloud
- [ ] Oracle account created
- [ ] VCN configured
- [ ] Compute instance running
- [ ] SSH access working
- [ ] Block volumes attached
- [ ] PostgreSQL installed and running
- [ ] Object storage bucket created
- [ ] OCI CLI configured
- [ ] Security lists configured

### Phase 3: Monitoring
- [ ] Grafana deployed
- [ ] Prometheus deployed
- [ ] Brain /metrics endpoint created
- [ ] Dashboards created
- [ ] Backup script written
- [ ] Cron jobs configured
- [ ] Backup tested
- [ ] Restore tested

### Phase 4: Analytics
- [ ] GCP account created
- [ ] BigQuery project created
- [ ] Tables created
- [ ] Lambda function deployed
- [ ] EventBridge rule configured
- [ ] Looker Studio dashboard created
- [ ] Data pipeline tested
- [ ] Documentation complete

---

## Rollback Plan

If something goes wrong:

| Component | Rollback Step |
|-----------|---------------|
| **Cloudflare Workers** | Remove CNAME record, traffic goes directly to Brain |
| **Oracle PostgreSQL** | Brain continues using local DB |
| **Backups** | Local backups still on Brain |
| **Monitoring** | Loss of visibility only, no impact to Brain |

---

## Estimated Costs (All Free)

| Service | Free Tier Used | If Exceeded |
|---------|----------------|-------------|
| Cloudflare Workers | 100K req/day | $5/mo |
| Oracle Cloud | Always Free | Pay-as-you-go |
| AWS Lambda | 1M req/mo | $0.20/million |
| GCP BigQuery | 1TB query/mo | $5/TB |

---

## Support Resources

| Service | Documentation | Community |
|---------|---------------|-----------|
| Cloudflare | developers.cloudflare.com | discord.gg/cloudflaredev |
| Oracle | docs.oracle.com/en-us/iaas | community.oracle.com |
| AWS | docs.aws.amazon.com | stackoverflow.com/tags/aws |
| GCP | cloud.google.com/docs | stackoverflow.com/tags/gcp |

---

*Document: 07_ROADMAP.md*
*Research Date: February 3, 2026*
