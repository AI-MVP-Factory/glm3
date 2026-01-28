# SOLO Fleet - Top 25 Next Steps

**Generated**: 2026-01-28
**Based on**: GLM3 Audit + Fleet Analysis
**Priority Formula**: (Impact × Urgency) / Effort

---

## 🔴 P0 - Critical Wins (1-5)

### 1. Entity Deduplication Pass
**Effort**: 2h | **Impact**: High | **ROI**: 🌟🌟🌟

```
Current: 1,386 duplicates (0.9%)
Target: <0.1%
Action: Run entity matching with lower threshold
```

```bash
# Trigger entity worker with dedupe focus
ssh pc 'cd ~/dev && python3 -c "
from workers.entity_worker import EntityDeduplicator
deduper = EntityDeduper(threshold=0.95)
deduper.run_deduplication_pass()
"'
```

**Why**: Dirty data propagates through entire knowledge graph.

---

### 2. Wake Community Detection Worker
**Effort**: 1h | **Impact**: High | **ROI**: 🌟🌟🌟

```
Last run: Jan 27
New entities since: ~1,000+
Stale clusters: Losing value daily
```

```bash
# Trigger community worker
ssh pc 'cd ~/dev && python3 workers/v3_community_worker.py --force'
```

**Why**: Communities = entity clusters = higher-level insights. Stale data = missed opportunities.

---

### 3. Wisdom Extraction Pipeline
**Effort**: 4h | **Impact**: High | **ROI**: 🌟🌟🌟

```
Gap: 12,372 insights → 4,784 wisdom (39% coverage)
Action: Automated insight → wisdom conversion
```

**Implementation**:
```python
# wisdom_pipeline.py
def extract_wisdom_from_insights():
    insights = brain.query("SELECT * FROM synthesized_insights WHERE NOT converted")
    for insight in insights:
        if insight.value_score > 0.8:
            wisdom = synthesize_wisdom(insight)
            brain.store(wisdom)
```

**Why**: Wisdom is the highest-value knowledge. 7,588 insights waiting to be converted.

---

### 4. Brain Query Caching Layer
**Effort**: 3h | **Impact**: High | **ROI**: 🌟🌟🌟

```
Current: 8,012 queries tracked, no caching
Opportunity: 30-50% cache hit rate
Implementation: Redis on Alienware
```

```bash
# Add Redis to Alienware
ssh alien 'docker run -d --name brain-cache \
  -p 6379:6379 redis:alpine'

# Add caching middleware to Brain API
# Cache common queries for 1 hour
```

**Why**: Same queries repeated. Cache = 10x faster, less GPU usage.

---

### 5. Real Health Monitoring Dashboard
**Effort**: 4h | **Impact**: High | **ROI**: 🌟🌟

```
Current: Manual SSH checks
Target: Web dashboard with alerts
Tech: Grafana + Prometheus (already running)
```

**Metrics to Track**:
- Brain API response time
- Worker queue depths
- Entity duplicate rate
- Query success rate
- Service uptime

**Why**: Visibility = faster response to issues.

---

## 🟠 P1 - High Value (6-12)

### 6. Relationship Worker Optimization
**Effort**: 2h | **Impact**: Medium | **ROI**: 🌟🌟

```
Current: 0.97 relationships/entity
Target: 0.99
Gap: ~420 relationships missing
```

**Action**: Wake relationship worker until target hit.

**Why**: Relationships = knowledge graph connectivity. Missing = weaker intelligence.

---

### 7. Reasoning Chain Processing
**Effort**: 6h | **Impact**: High | **ROI**: 🌟🌟

```
Total chains: 12,350
Processed: 1,010 (8%)
Untapped: 11,340 chains
```

**Action**: Batch process remaining chains into runbooks.

**Why**: Each chain = reasoning pattern. Runbooks = automation potential.

---

### 8. Cross-Reference KG ↔ Research
**Effort**: 3h | **Impact**: Medium | **ROI**: 🌟🌟

```
Entities: 21,138
Research records: 316,771
Opportunity: Find gaps both ways
```

**Questions**:
1. Which research topics lack entities?
2. Which entities lack research backing?
3. What relationships are missing?

**Why**: Bidirectional validation = stronger knowledge base.

---

### 9. vLLM/LiteLLM Integration Fix
**Effort**: 1h | **Impact**: Low | **ROI**: 🌟

```
Issue: /v1/chat/completions returns 404
Impact: Fallback to Groq works, but slower
```

```bash
# Debug routing
ssh alien 'docker logs litellm | grep -i vllm'

# Fix LiteLLM config to point to correct vLLM endpoint
```

**Why**: Currently working, but optimization potential.

---

### 10. Auto-Wake Sleeping Workers
**Effort**: 3h | **Impact**: Medium | **ROI**: 🌟🌟

```
Sleeping: Wisdom, Community, Anticipator
Trigger: When new data available
Implementation: Watcher daemon
```

**Logic**:
```python
if new_entities > 100:
    wake_worker('community')
if new_insights > 50:
    wake_worker('wisdom')
if query_volume > threshold:
    wake_worker('anticipator')
```

**Why**: Manual wake = stale insights. Auto = continuous intelligence.

---

### 11. Audit Framework Standardization
**Effort**: 4h | **Impact**: Medium | **ROI**: 🌟🌟

```
Template: Based on GLM3 methodology
Verification: Required for all claims
Automation: Validation script
```

**Create**: `~/.claude/templates/audit_template.md`

**Why**: Consistent audits = better comparisons over time.

---

### 12. Brain API - /entities Endpoint
**Effort**: 2h | **Impact**: Medium | **ROI**: 🌟🌟

```
Current: No direct entity listing
Target: GET /entities?limit=100&offset=0
Use: Quick entity browsing, validation
```

**Why**: Faster entity inspection = better debugging.

---

## 🟡 P2 - Medium Value (13-19)

### 13. Query Analytics Pattern Analysis
**Effort**: 2h | **Impact**: Medium | **ROI**: 🌟

```
Queries tracked: 8,012
Opportunity: Find patterns, optimize indexing
```

**Analysis**:
- Top 100 queries → cache permanently
- Failed queries → fix gaps
- Slow queries → optimize

---

### 14. Entity Matching Threshold Tuning
**Effort**: 2h | **Impact**: Medium | **ROI**: 🌟

```
Current: 0.9% duplicate rate
Action: A/B test different thresholds
Target: Find optimal balance
```

---

### 15. Worktree Pool Auto-Setup
**Effort**: 2h | **Impact**: Low | **ROI**: 🌟

```
Current: Manual initialization
Target: Auto-setup for new projects
```

```bash
# Add to project init
~/dev/worktree-manager/worktree.sh init .
```

---

### 16. Backup Orchestrator on PC
**Effort**: 4h | **Impact**: Medium | **ROI**: 🌟

```
Current: Mac is SPOF
Target: Failover to PC if Mac down
Implementation: rsync + heartbeat
```

---

### 17. Session Context Auto-Save
**Effort**: 2h | **Impact**: Medium | **ROI**: 🌟

```
Current: Manual handoff
Target: Auto-save at 70% context
Implementation: PreCompact hook
```

---

### 18. LanceDB Backup Automation
**Effort**: 2h | **Impact**: High | **ROI**: 🌟🌟

```
Current: 485K records, no automated backup
Target: Daily snapshots to PC
```

```bash
# Daily backup
rsync -av alien:/var/oled/brain/lancedb/ pc:/backup/lancedb/
```

---

### 19. Worker Progress Dashboard
**Effort**: 3h | **Impact**: Medium | **ROI**: 🌟

```
Current: No visibility into worker progress
Target: Real-time progress bars
```

---

## 🔵 P3 - Nice to Have (20-25)

### 20. BGE Reranker Module Installation
**Effort**: 5min | **Impact**: Low | **ROI**: 🌟

```bash
ssh alien 'pip install FlagEmbedding'
```

**Why**: Docker fallback works, but native is faster.

---

### 21. Anticipator Query Analysis
**Effort**: 2h | **Impact**: Low | **ROI**: 🌟

```
Anticipated needs: 15,677
Actual queries: 8,012
Accuracy: Measure and improve
```

---

### 22. Community Visualization
**Effort**: 4h | **Impact**: Medium | **ROI**: 🌟

```
Current: 4,231 communities, invisible
Target: Interactive graph view
```

---

### 23. Runbook Executor
**Effort**: 6h | **Impact**: High | **ROI**: 🌟🌟

```
Runbooks: 6,438
Executable: 0
Target: Auto-execute safe runbooks
```

---

### 24. Multi-Model Query Router
**Effort**: 4h | **Impact**: Medium | **ROI**: 🌟

```
Current: Single model per query type
Target: Route based on query complexity
```

---

### 25. Fleet Auto-Scaling
**Effort**: 8h | **Impact**: High | **ROI**: 🌟🌟

```
Current: Fixed worker count
Target: Scale based on queue depth
```

---

## Quick Start Guide

### This Week (Do These First)
```bash
# 1. Entity deduplication (2h)
ssh pc 'cd ~/dev && python3 -c "from workers.entity_worker import EntityDeduplicator; EntityDeduplicator(threshold=0.95).run()"'

# 2. Wake community worker (1h)
ssh pc 'cd ~/dev && python3 workers/v3_community_worker.py --force'

# 3. Fix BGE reranker (5min)
ssh alien 'pip install FlagEmbedding'

# 4. vLLM debug (30min)
ssh alien 'docker logs litellm | grep -i vllm | tail -50'
```

### This Month
- Wisdom extraction pipeline (P0 #3)
- Brain query caching (P0 #4)
- Health dashboard (P0 #5)

---

## ROI Summary

| Priority | Total Items | Total Effort | Total Impact |
|----------|-------------|--------------|--------------|
| P0 | 5 | 14h | Very High |
| P1 | 7 | 23h | High |
| P2 | 7 | 19h | Medium |
| P3 | 6 | 29h | Mixed |

**Quick Wins (< 2h)**: #2, #6, #9, #13, #14, #15, #17, #20
**Highest Impact**: #1, #3, #4, #7, #18, #23, #25

---

*Generated based on GLM3 audit findings*
*Next review: 2026-02-04*
