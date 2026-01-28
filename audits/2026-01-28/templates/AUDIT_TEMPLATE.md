# SOLO Fleet Audit Template

**Version**: 2.0 (GLM3 Methodology)
**Date**: {AUDIT_DATE}
**Auditor**: {AUDITOR_NAME}
**Session ID**: {SESSION_ID}

---

## Phase 1: Ground Truth Verification (MANDATORY)

**Before any analysis, run these commands:**

```bash
# 1. Brain API Health
curl -s http://192.168.68.58:8080/health | jq '.'

# 2. Brain API Stats
curl -s -H "X-API-Key: $SOLO_API_KEY" \
  http://192.168.68.58:8080/stats | jq '.'

# 3. Workers on PC
ssh pc 'ps aux | grep "v4_.*_worker" | grep -v grep'

# 4. Docker Services on Alienware
ssh alien 'docker ps --format "table {{.Names}}\t{{.Status}}"'

# 5. Services Status
ssh alien 'systemctl status brain-api --no-pager | head -15'
```

**Record Actual Values:**
- Brain Records: __________
- Brain Tables: __________
- Workers Running: __________
- Services Up: __________

---

## Phase 2: Infrastructure Audit

### Mac (Orchestrator)
| Service | Port | Expected | Actual | Status |
|---------|------|----------|--------|--------|
| opus-router | 8788 | Running |  |  |
|  |  |  |  |  |

### Alienware (Brain Host)
| Service | Port | Expected | Actual | Status |
|---------|------|----------|--------|--------|
| Brain API | 8080 | Running |  |  |
| Embeddings | 8002 | Running |  |  |
| Reranker | 8003 | Running |  |  |
| LiteLLM | 4001 | Running |  |  |
| Redis | 6379 | Running |  |  |
| Grafana | 3000 | Running |  |  |

### PC (Worker Fleet)
| Worker | Expected | Actual PID | CPU | Status |
|--------|----------|------------|-----|--------|
| v4_entity_worker | Running |  |  |  |
| v4_relationship_worker | Running |  |  |  |
| v4_reasoning_worker | Running |  |  |  |
| v4_community_worker | Running |  |  |  |
| v4_wisdom_worker | Running |  |  |  |

---

## Phase 3: Brain Intelligence Audit

```bash
# Get record counts
SOLO_API_KEY=$(cat ~/.config/solo/api_key.env | cut -d= -f2)
curl -s -X POST http://192.168.68.58:8080/query \
  -H "X-API-Key: $SOLO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT COUNT(*) as count FROM kg_entities"}' | jq '.answer'
```

| Table | Record Count | Growth Rate | Notes |
|-------|--------------|-------------|-------|
| kg_entities |  |  |  |
| kg_relationships |  |  |  |
| research_neural |  |  |  |
| wisdom |  |  |  |
| runbooks |  |  |  |

---

## Phase 4: Issue Reporting Format

**CRITICAL: Only report issues you have VERIFIED with commands.**

```json
{
  "issue": "Brief description",
  "severity": "critical|high|medium|low",
  "verified": true,
  "verification_command": "command that proves it",
  "evidence": "actual output showing the issue",
  "impact": "what it affects",
  "recommendation": "what to do"
}
```

---

## Phase 5: Assessment Scoring

| Dimension | Score (1-10) | Notes |
|-----------|--------------|-------|
| Infrastructure |  |  |
| Brain Intelligence |  |  |
| Worker Fleet |  |  |
| Orchestration |  |  |
| Data Quality |  |  |
| **OVERALL** |  |  |

---

## Rules

1. **NEVER claim service status without verification**
2. **If unsure, say "believe" not "is"**
3. **Include verification commands for all findings**
4. **Separate observed data from inferences**
5. **Document what you checked, not just what you found**

---

*Template Version: 2.0*
*Based on GLM3 verification-first methodology*
