# GLM Instance Comparison - Synthesis Report

**Date**: 2026-01-28
**Purpose**: Compare audit outputs from GLM (baseline), GLM2, GLM3
**Auditor**: Claude Opus 4.5

---

## Executive Summary

Three GLM instances audited the SOLO fleet. **GLM3 produced the most accurate results**, while GLM2 demonstrated strong self-awareness despite business blindness.

### Quick Comparison

| Metric | GLM (Baseline) | GLM2 | GLM3 | Winner |
|--------|----------------|------|------|--------|
| **Overall Accuracy** | ~89% (11% FP) | 56% | 95% | GLM3 |
| **Health Score** | N/A | 2.8/5 | 8.2/10 | GLM3 |
| **Duration** | 50s | 45m | 5m | GLM |
| **Lines Generated** | Unknown | 1,250 | 952 | - |
| **Record Count** | 485K (accurate) | 166K (65% low) | 485,848 (accurate) | GLM3 |
| **Critical Issues** | 3 false positives | 7 (mixed validity) | 0 | GLM3 |
| **Business Awareness** | N/A | 1/5 | N/A | GLM2* |
| **Self-Awareness** | Low | High | High | GLM2, GLM3 |

*GLM2 rated itself 1/5 on business alignment and corrected its findings

---

## Detailed Comparison

### 1. Data Accuracy

| Data Point | Ground Truth | GLM | GLM2 | GLM3 |
|------------|--------------|-----|------|------|
| Brain Records | 485,848 | 485K ✅ | 166K ❌ | 485,848 ✅ |
| Brain Tables | 55 | N/A | 37 ❌ | 55 ✅ |
| Services Up | 7 | 8+ | 15 | 7 |
| Entities | 21,138 | N/A | N/A | 21,138 ✅ |
| Alienware RAM | 39GB | N/A | 47.4GB ❌ | 39GB ✅ |
| PC Load | 13.85 | 17.00 ⚠️ | 18 ⚠️ | 13.85 ✅ |

**Winner**: GLM3 - most accurate ground truth data

### 2. Issue Detection Quality

| Instance | False Positives | False Negatives | Valid Issues |
|----------|-----------------|-----------------|--------------|
| **GLM** | 3 | 0 | 25 minor |
| **GLM2** | 4+ | 0 | 3 valid |
| **GLM3** | 0 | 0 | 4 valid |

**False Positives by GLM**:
1. Embedding service DOWN → Actually UP 40h
2. vLLM service FAILED → Working with fallback
3. Workers BLOCKED → Processing normally

**Potentially Invalid Issues by GLM2**:
1. Grafana default credentials → May be intentional local use
2. LiteLLM no auth → May be LAN-only
3. Brain API 47.4GB RAM → Overcount, actually 39GB
4. Oracle "OFFLINE" → May be intentional cold standby

**Valid Issues by GLM3**:
1. 1,386 duplicate entities (0.9%) - verified
2. BGE Reranker module missing - verified
3. vLLM 404 on chat endpoint - verified
4. Relationship ratio 0.97 vs 0.99 target - verified

**Winner**: GLM3 - zero false positives, all verified

### 3. Business Awareness

| Instance | Cost Estimate | Cost Reality | Accuracy |
|----------|---------------|--------------|----------|
| **GLM2** | $240/month | $2,800+/month | 11.6x off ❌ |
| **GLM3** | N/A | N/A | N/A |

**GLM2 Self-Assessment**:
- Technical Quality: 4/5
- Business Alignment: 1/5
- Cost Accuracy: 2/5
- Overall: 2.8/5

**GLM2 Key Learning**:
> "Infrastructure audits require business literacy. High load interpreted as waste, not potential revenue."

**Winner**: GLM2 - for self-awareness and recognizing business blindness

### 4. Performance

| Instance | Duration | Parallelism | Tokens Used |
|----------|----------|-------------|-------------|
| **GLM** | 50s | 10 haiku | Low |
| **GLM2** | 45m | Sequential | High (hit limit) |
| **GLM3** | 5m | Swarm | Medium |

**Winner**: GLM for speed, GLM3 for balance

### 5. Output Quality

| Instance | Lines | Structure | Readability |
|----------|-------|-----------|-------------|
| **GLM** | ~600 | Good | Good |
| **GLM2** | 1,250 | Excellent | Excellent |
| **GLM3** | 952 | Excellent | Excellent |

All instances produced well-structured, readable documentation.

---

## Root Cause Analysis

### Why GLM2 Had Issues

1. **No Ground Truth Verification**
   - GLM2 made claims without running verification commands
   - Resulted in 65% error on record count

2. **Business Context Missing**
   - Assumed high load = waste
   - Didn't consider revenue-generating work
   - Cost estimate 11.6x off

3. **Context Window Exhaustion**
   - Hit 200K limit, required model switch
   - Lost context during switch

4. **Sequential Processing**
   - 45 minutes vs 5 minutes (GLM3)
   - No swarm parallelization

### Why GLM3 Succeeded

1. **Ground Truth Verification**
   - All claims verified with actual commands
   - `curl` health checks, `docker ps`, `ssh` verification

2. **Reality Check Integration**
   - User provided actual command output
   - Corrected initial wrong assumptions

3. **Swarm Architecture**
   - Parallel agents across domains
   - Cross-validation between agents

4. **Conservative Reporting**
   - Only reported verified issues
   - "If you haven't verified it, say 'I believe' not 'it is'"

---

## Best Practices Identified

### For Future Audits

1. **ALWAYS Verify Claims**
   ```bash
   # Don't claim service status without checking
   curl -s http://service:port/health
   ssh host 'systemctl status service'
   docker ps | grep service
   ```

2. **Check Ground Truth First**
   ```bash
   # Get actual numbers before analyzing
   brain_records=$(curl -s brain:8080/stats | jq '.records')
   ```

3. **Be Conservative**
   - If unsure, say "believe" not "is"
   - Report confidence levels
   - Distinguish observed vs inferred

4. **Use Swarm for Speed**
   - Parallel agents > sequential
   - Cross-validation > single source

5. **Context Management**
   - Save progress before hitting limits
   - Use file-based handoff

---

## Golden Opportunities

### 1. Unified Audit Framework

Create a standard audit template that all instances follow:

```json
{
  "audit_metadata": {
    "instance": "glmX",
    "date": "YYYY-MM-DD",
    "duration_minutes": N,
    "verification_method": "direct_command"
  },
  "ground_truth": {
    "verified": true,
    "commands_used": ["curl", "ssh", "docker ps"],
    "data_source": "actual_output"
  },
  "findings": {
    "verified_issues": [],
    "potential_issues": [],
    "false_positives": []
  }
}
```

### 2. Automated Validation Pipeline

```bash
#!/bin/bash
# verify_audit.sh - Validate audit findings against ground truth

# Check Brain API
actual_records=$(curl -s http://192.168.68.58:8080/stats | jq '.records')
reported_records=$(jq '.brain.total_records' audit/metadata.json)

if [ "$actual_records" != "$reported_records" ]; then
  echo "ERROR: Record count mismatch"
fi
```

### 3. Cross-Instance Consensus

Run all 3 instances and compare:
- If all 3 agree → High confidence
- If 2/3 agree → Medium confidence, investigate
- If all disagree → Low confidence, manual verification

### 4. Business Context Injection

Before technical audit, gather:
```yaml
business_context:
  monthly_spend: 2800
  revenue_generating:
    - worker_v2.py
    - brain_api
  non_revenue:
    - monitoring
  optimization_constraints:
    - cannot reduce revenue capacity
    - $5 oracle is negligible
```

---

## Recommendations

### Immediate (This Week)

1. **Adopt GLM3's Verification Method**
   - All claims must be backed by commands
   - Include verification in audit template

2. **Implement Cross-Validation**
   - Run 2 instances on critical audits
   - Flag discrepancies for manual review

3. **Add Business Context Step**
   - Before audit: load business_context.yaml
   - During audit: check against constraints

### Short Term (This Month)

4. **Create Audit Validation Script**
   - Automated ground truth checks
   - Flag common false positives

5. **Build Consensus System**
   - Run GLM + GLM3 in parallel
   - Merge findings, investigate conflicts

### Long Term (Ongoing)

6. **Train Model on Business Literacy**
   - Examples of revenue vs cost
   - Context-aware optimization

7. **Continuous Improvement**
   - Track false positive rate
   - Learn from corrections

---

## Final Scoring

| Dimension | GLM | GLM2 | GLM3 |
|-----------|-----|------|------|
| **Data Accuracy** | 8/10 | 5/10 | 10/10 |
| **Issue Detection** | 7/10 | 6/10 | 9/10 |
| **Business Awareness** | N/A | 3/10* | N/A |
| **Self-Awareness** | 4/10 | 9/10 | 9/10 |
| **Speed** | 10/10 | 3/10 | 8/10 |
| **Output Quality** | 7/10 | 9/10 | 9/10 |
| **Verification** | 5/10 | 2/10 | 10/10 |
| **OVERALL** | 6.8/10 | 5.4/10 | **9.1/10** |

*GLM2 self-rated 1/5, actual awareness demonstrated in correction doc

---

## Conclusion

**GLM3 is the recommended instance for future audits** based on:
- Highest accuracy (zero false positives)
- Ground truth verification methodology
- Balanced speed/quality
- Self-awareness of limitations

**GLM2's key contribution**: Self-awareness and business context lesson

**Key lesson learned**: >Always verify claims against ground truth. The difference between claiming and knowing is a `curl` command away.*

---

*Generated: 2026-01-28*
*Next comparison: 2026-02-04*
