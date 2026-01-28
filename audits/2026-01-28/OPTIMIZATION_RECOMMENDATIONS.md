# SOLO Fleet Optimization Recommendations
**Generated:** 2026-01-28 21:20
**Scope:** Alienware + PC complete audit

## Current State Summary

### Alienware (BRAIN Host) - 192.168.68.58
| Metric | Value | Status |
|--------|-------|--------|
| CPU | 10.7% user, 74.4% idle | ✅ Healthy |
| Memory | 34GB/62GB used (27GB avail) | ✅ OK |
| Disk | 40% used (1.1T free) | ✅ Plenty |
| Docker Uptime | 44 hours | ✅ Stable |
| Brain API | Healthy | ✅ Up |
| Redis | 2.3M commands processed | ✅ Working |
| Network | 40ms latency to Mac | ✅ OK |

### PC (Worker Host) - 192.168.68.50
| Metric | Value | Status |
|--------|-------|--------|
| CPU | 16.2% user, **30.8% I/O wait** | ⚠️ Network bottleneck |
| Load Avg | 18.89, 21.51, 20.86 | ⚠️ High |
| Memory | 10GB/23GB used (12GB avail) | ✅ OK |
| Workers | 6 running (1.6-1.9GB each) | ✅ OK |
| Disk Speed | 2.7 GB/s | ✅ Excellent |
| Network | LAN to Alienware | ✅ OK |

### Worker Status (All Healthy)
| Worker | CPU | RAM | FDs | Status |
|--------|-----|-----|-----|--------|
| v4_entity_worker | 77% | 1.9GB | 37 | ✅ Processing |
| v4_relationship_worker | 41% | 1.4GB | 27 | ✅ Working |
| v4_reasoning_worker | 25% | 1.9GB | 21 | ✅ Excellent |
| v4_community_worker | 0.6% | 350MB | 18 | ✅ Optimized |
| v4_anticipator_worker | 34% | 1.6GB | 163 | ✅ Working |
| v4_wisdom_worker | 28% | 2.1GB | 403 | ✅ OK |

---

## Optimization Recommendations (Ranked by ROI)

### 1. [HIGH ROI] Reduce Network I/O Wait on PC
**Problem:** 30.8% I/O wait - workers blocked on network calls to Alienware
**Root Cause:** Each worker makes individual API calls to Brain/LiteLLM

| Solution | Difficulty | Risk | Benefit | Effort |
|----------|------------|------|---------|--------|
| **A. Batch API calls** | Medium | Low | 40-60% I/O reduction | 2-3 hours |
| **B. Local request queue** | Medium | Low | 30% I/O reduction | 3-4 hours |
| **C. Move 1-2 workers to Alienware** | Low | Low | 20% load reduction | 1 hour |

**Recommendation:** Start with C (easiest), then A

**Implementation C - Move Workers to Alienware:**
```bash
# Workers that could run on Alienware:
# - v4_reasoning_worker (low CPU, high value)
# - v4_community_worker (already optimized, very low CPU)

# Just copy worker files and start on Alienware
# Workers on PC will still access Brain API over LAN
```

---

### 2. [MEDIUM ROI] Install Leiden Algorithm on PC
**Problem:** Using Louvain fallback (suboptimal clustering)
**Impact:** Communities may be less well-connected

| Metric | Leiden | Louvain |
|--------|--------|---------|
| Quality | Guaranteed connected | Can be disconnected |
| Speed | Faster | Slower |
| Adoption | SOTA (2024) | Older |

**Solution:**
```bash
pip3 install leidenalg python-igraph
```

| Difficulty | Risk | Benefit | Effort |
|------------|------|---------|--------|
| **Very Low** | None | Better communities | 5 minutes |

---

### 3. [MEDIUM ROI] Worker Memory Limits with Auto-Restart
**Problem:** Workers grow to 2GB+ RAM over time, no restart policy
**Risk:** Memory exhaustion

| Solution | Difficulty | Risk | Benefit | Effort |
|----------|------------|------|---------|--------|
| **systemd service with MemoryMax** | Low | Low | Auto-restart on leak | 1-2 hours |
| **Periodic restart (cron)** | Low | Low | Controlled restart | 30 minutes |

**Implementation - systemd service:**
```ini
[Service]
MemoryMax=3G
Restart=on-failure
RestartSec=10
```

---

### 4. [LOW-MEDIUM ROI] Request Batching Library
**Problem:** Workers make many small HTTP requests
**Opportunity:** Batch requests reduce network overhead

| Solution | Difficulty | Risk | Benefit | Effort |
|----------|------------|------|---------|--------|
| **Shared request queue** | High | Medium | 50% reduction | 1 day |
| **Worker-level batching** | Medium | Low | 30% reduction | 4 hours |

**Recommendation:** Worker-level batching (e.g., batch 10 embeddings at once)

---

### 5. [LOW ROI] Worker Health Dashboard
**Problem:** Manual checks required to see worker status
**Solution:** Prometheus metrics + Grafana dashboard

| Component | Difficulty | Risk | Benefit | Effort |
|-----------|------------|------|---------|--------|
| **Prometheus exporter** | Low | None | Visibility | 2 hours |
| **Grafana dashboard** | Low | None | Nice UI | 1 hour |

**Already have:** Prometheus + Grafana on Alienware
**Need:** Worker metrics exporter (already have brain_v3_worker_exporter.py)

---

### 6. [VERY LOW ROI] wisdom_worker FD Investigation
**Problem:** 403 FDs (up from 23 after fix)
**Status:** Still functional, not urgent

| Difficulty | Risk | Benefit | Effort |
|------------|------|---------|--------|
| **Medium** | Low | Peace of mind | 2 hours |

**Likely cause:** LanceDB connection pool or LLM client connections

---

## Priority Matrix

```
HIGH PRIORITY (Do Now):
├── 1C. Move v4_reasoning_worker to Alienware [1 hour]
├── 2. Install Leiden on PC [5 minutes]
└── 3B. Add cron-based worker restart [30 minutes]

MEDIUM PRIORITY (Do Soon):
├── 1A. Implement API call batching [2-3 hours]
├── 3A. systemd services for workers [1-2 hours]
└── 5. Worker health dashboard [3 hours]

LOW PRIORITY (Nice to Have):
├── 1B. Local request queue [3-4 hours]
├── 4. Request batching library [4 hours]
└── 6. Investigate wisdom_worker FDs [2 hours]
```

---

## Risk Assessment

### Highest Risks (Mitigate Now)

1. **Memory exhaustion on PC**
   - Current: 11GB/23GB used by workers
   - Risk: Workers could grow to 3GB each
   - Mitigation: Add MemoryMax to systemd services

2. **Network dependency**
   - PC workers depend on Alienware for Brain/LiteLLM
   - Risk: Alienware down = all workers stop
   - Mitigation: Consider redundant Brain instance on PC

3. **No worker auto-restart**
   - If worker crashes, stays down
   - Mitigation: systemd or cron monitoring

### Low Risks (Monitor Only)

1. **High load average on PC (18-21)**
   - Workers are still functioning fine
   - Load is from CPU, not bottleneck
   - Monitor only

2. **I/O wait (30%)**
   - Network I/O, not disk
   - Acceptable for distributed system
   - Optimize if it grows above 50%

---

## Estimated Total Impact

| Optimization | CPU Reduction | RAM Saved | Risk Reduction |
|--------------|---------------|-----------|----------------|
| Move 1 worker to Alienware | 15% | 1.9GB | 0% |
| API batching | 40% | 0% | 0% |
| Memory limits | 0% | 20% | High |
| Leiden install | 0% | 0% | 0% (quality++) |
| **TOTAL** | **~55%** | **~3GB** | **High** |

---

## Recommended Action Plan

### Week 1 (Quick Wins)
1. Install Leiden on PC (5 min)
2. Move v4_reasoning_worker to Alienware (1 hour)
3. Add cron-based worker restart (30 min)

### Week 2 (Infrastructure)
1. Create systemd services for workers (2 hours)
2. Add MemoryMax limits (30 min)

### Week 3+ (Nice to Have)
1. API call batching (3 hours)
2. Worker dashboard (3 hours)

---

*Generated by Claude Opus 4.5*
*SOLO Fleet Optimization Analysis*
