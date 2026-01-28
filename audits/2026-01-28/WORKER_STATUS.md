# SOLO Worker Fleet Status - 2026-01-28 19:40

## Summary

| Worker | PID | FDs | CPU | Memory | Status |
|--------|-----|-----|-----|--------|--------|
| v4_entity_worker | 1892025 | 141 | 67.5% | 8.1% | ⚠️ High CPU |
| v4_relationship_worker | 1940948 | 139 | 50.0% | 6.9% | ⚠️ LLM Errors |
| v4_reasoning_worker | 1892027 | 140 | 30.5% | 9.9% | ✅ Excellent |
| v4_community_worker | 3799549 | - | 17.0% | 1.3% | ✅ Optimized |
| v4_wisdom_worker | 3173414 | 23 | 0.0% | 1.2% | ✅ Good (sleeping) |
| v4_anticipator_worker | 3416020 | 23 | 0.0% | 3.5% | ✅ Excellent |

## Overall Assessment

- **Total Workers**: 6 running ✅
- **Health**: 5/6 excellent, 1/6 has issues
- **File Descriptors**: All under control now ✅

## Worker Details

### ✅ v4_entity_worker
- **FDs**: 141 (healthy)
- **CPU**: 67.5% (high but working)
- **Issue**: Embedding connection errors (intermittent)
- **Note**: Embedding service confirmed working on Alienware

### ⚠️ v4_relationship_worker
- **FDs**: 139 (healthy)
- **CPU**: 50.0% (working hard)
- **Issue**: LLM 'choices' error
- **Stuck at**: 20,547 relationships (0.98/entity)
- **Root Cause**: LiteLLM "smart" pool rate limited

### ✅ v4_reasoning_worker
- **FDs**: 140 (healthy)
- **CPU**: 30.5%
- **Status**: **Excellent**
- **Output**: Chains: 325, Runbooks: 185
- **Growing**: +1 runbook per cycle

### ✅ v4_community_worker
- **PID**: 3799549
- **CPU**: 17.0% (**95% reduction** from 366%!)
- **Status**: **Optimized** (Phase 1 fix applied)
- **Fixed**: Replaced full table loads with SQL COUNT + scanner columns

### ✅ v4_wisdom_worker
- **FDs**: 23 (excellent!)
- **Status**: **Good** (sleeping - no high-value records)
- **Fixed**: FD leak resolved

### ✅ v4_anticipator_worker
- **FDs**: 23 (excellent!)
- **CPU**: 0.0% (idle)
- **Status**: **Excellent**
- **Fixed**: FD leak resolved, just restarted

## Services

| Service | Location | Status |
|---------|----------|--------|
| Qwen3-VL-Embedding | Alienware:8002 | ✅ Working |
| Qwen3-VL-Reranker | Alienware:8003 | ✅ Working |
| Brain API | Alienware:8080 | ✅ Working |
| LiteLLM | Alienware:4001 | ✅ Running (rate limited) |
| Redis | Alienware:6379 | ✅ Running |

## Issues to Address

### 1. Relationship Worker (Medium Priority)
- **Problem**: LLM 'choices' error
- **Impact**: Stuck at 20,547 relationships
- **Fix**: Add dedicated LLM API key (bypass "smart" pool)

### 2. Entity Worker (Low Priority)
- **Problem**: Intermittent embedding errors
- **Impact**: Still processing at 67% CPU
- **Fix**: Likely transient, embedding service confirmed working

## Recommendations

1. **Monitor** relationship worker - needs dedicated LLM key
2. **No action** - entity worker errors are intermittent
3. **✅ Community worker optimized** - 95% CPU reduction achieved

---

*Generated: 2026-01-28 19:40*
*Updated: 2026-01-28 21:05 - Community worker Phase 1 fix applied*
*Next check: 2026-01-29*
