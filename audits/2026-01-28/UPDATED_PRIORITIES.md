# SOLO Fleet - UPDATED Priorities (Reality-Corrected)

**Date**: 2026-01-28
**Based on**: Actual PC/Alienware status check

---

## 🔴 CRITICAL CORRECTIONS

### What's ACTUALLY Running (Not Stale!)

#### PC Workers - ALL ACTIVE
```bash
Worker                    Status      CPU    Memory    Started
─────────────────────────────────────────────────────────────
v4_entity_worker          🟢 ACTIVE   67%    2.3GB     13:56
v4_relationship_worker    🟢 ACTIVE   49%    1.3GB     14:06
v4_reasoning_worker       🟢 ACTIVE   27%    2.4GB     13:56
v4_anticipator_worker     🟢 ACTIVE   21%    0.4GB     13:56
v4_community_worker       🟢 ACTIVE   33%    2.6GB     10:21
v4_wisdom_worker          🟢 ACTIVE    9%    0.05GB    14:07
v4_research_orchestrator  🟢 IDLE     0.2%   0.03GB    10:30
v3_session_worker         🟢 IDLE     0.1%   0.006GB   Jan27
v3_founder_worker         🟢 IDLE     0.0%   0.01GB    Jan27
v3_ingestion_worker       🟢 IDLE     0.0%   0.007GB   Jan27
```

#### Alienware Services
```bash
Service               Status    Uptime
───────────────────────────────────────
Brain API (8080)      🟢 UP     19h
Qwen3-VL-Embedding    🟢 UP     41h
Qwen3-VL-Reranker     🟢 UP     41h
LiteLLM (4001)        🟢 UP     4h
Redis (6379)          🟢 UP     41h  ← ALREADY EXISTS!
Grafana (3000)        🟢 UP     29h  ← ALREADY EXISTS!
Prometheus            🟢 UP     7h   ← ALREADY EXISTS!
```

---

## ❌ REMOVED FROM LIST

| # | Item | Reason |
|---|------|--------|
| ~~#1~~ | Entity deduplication | Catastrophic loss history, too risky |
| ~~#2~~ | Wake community worker | Already running and active |
| ~~#15~~ | Worktree auto-setup | Needs verification |
| ~~#16~~ | Backup orchestrator | Needs more research |

---

## ✅ REVISED TOP 12-25

### 🔴 P0 - Immediate High Value

#### #3 Wisdom Extraction Pipeline
**Status**: Worker running, but is it extracting?

**Reality Check**:
```bash
# Check if wisdom is actually being generated
ssh pc 'tail -50 /tmp/v4_wisdom_worker.log'

# Check wisdom growth rate
ssh pc 'sqlite3 ~/.brain/lancedb "SELECT COUNT(*) FROM wisdom WHERE created_at > datetime(\"now\", \"-1 hour\")"'
```

**If NOT extracting**:
```python
# Add to v4_wisdom_worker.py
def extract_from_synthesized_insights():
    """Automatically extract wisdom from high-value insights"""
    insights = brain.query("""
        SELECT * FROM synthesized_insights
        WHERE value_score > 0.8
        AND NOT EXISTS (SELECT 1 FROM wisdom WHERE source_id = insights.id)
        LIMIT 100
    """)
    for insight in insights:
        wisdom = consolidate_wisdom(insight)
        brain.store(wisdom)
```

**Expected Outcome**: 7,588 new wisdom records from existing insights

---

#### #4 Brain Query Caching (Redis exists, just add layer)
**Status**: Redis running, unused for query caching

**Implementation**:
```python
# Add to Brain API (alienware:/root/brain-api/cache_middleware.py)
import redis
import json
import hashlib

r = redis.Redis(host='localhost', port=6379, db=0)

def cache_key(query, params):
    return hashlib.md5(f"{query}:{json.dumps(params)}".encode()).hexdigest()

def get_cached(query, params):
    key = cache_key(query, params)
    cached = r.get(key)
    if cached:
        return json.loads(cached)
    return None

def set_cache(query, params, result, ttl=3600):
    key = cache_key(query, params)
    r.setex(key, ttl, json.dumps(result))

# In query endpoint:
@app.post("/query")
def query(request):
    # Check cache first
    cached = get_cached(request.query, request.params)
    if cached:
        return {"source": "cache", "result": cached}

    # Normal query
    result = brain.query(request.query)

    # Cache result
    set_cache(request.query, request.params, result)

    return {"source": "brain", "result": result}
```

**Expected**: 30-50% cache hit rate, 10x faster cached queries

---

#### #5 Health Dashboard (Grafana exists, needs panels)
**Status**: Grafana running, likely empty/default

**Implementation**:
```bash
# 1. Login to Grafana
# Default admin/soloadmin - change if not done

# 2. Add Prometheus data source (if not exists)
# URL: http://192.168.68.58:9090

# 3. Create dashboard JSON
```

**Dashboard Panels**:
```json
{
  "dashboard": {
    "title": "SOLO Brain Fleet",
    "panels": [
      {
        "title": "Brain API Response Time",
        "targets": [{
          "expr": "rate(brain_api_duration_seconds_sum[5m]) / rate(brain_api_duration_seconds_count[5m])"
        }]
      },
      {
        "title": "Worker CPU Usage",
        "targets": [
          {"expr": "rate(process_cpu_seconds_total{job=\"brain_workers\"}[5m])"}
        ]
      },
      {
        "title": "LanceDB Record Growth",
        "targets": [{"expr": "lancedb_record_count"}]
      },
      {
        "title": "Query Success Rate",
        "targets": [{
          "expr": "rate(brain_query_success[5m]) / (rate(brain_query_success[5m]) + rate(brain_query_error[5m]))"
        }]
      },
      {
        "title": "Entity Duplicate Rate",
        "targets": [{"expr": "brain_entity_duplicates / brain_entity_total"}]
      },
      {
        "title": "Worker Queue Depths",
        "targets": [{"expr": "worker_queue_depth"}]
      }
    ]
  }
}
```

**Or use Grafana web UI** to import the dashboard JSON.

---

### 🟠 P1 - High Value (6-12)

#### #6 Relationship Worker Optimization
**Current**: 0.97 relationships/entity (target: 0.99)

**Action**: Monitor progress, it's already running at 49% CPU
```bash
# Check if it's making progress
ssh pc 'tail -20 /home/p/logs/v4-workers/v4_relationship_worker.log'

# Check relationship growth
ssh pc 'sqlite3 ~/.brain/lancedb "SELECT COUNT(*) FROM kg_relationships WHERE created_at > datetime(\"now\", \"-1 hour\")"'
```

**If stuck**: Increase worker priority or add second instance

---

#### #7 Reasoning Chain Processing
**Current**: Worker running at 27% CPU

**Check if actually processing**:
```bash
ssh pc 'tail -30 /home/p/logs/v4-workers/v4_reasoning_worker.log'

# Check runbook generation rate
ssh pc 'sqlite3 ~/.brain/lancedb "SELECT COUNT(*) FROM runbooks WHERE created_at > datetime(\"now\", \"-1 hour\")"'
```

**If not generating runbooks**:
```python
# Add to v4_reasoning_worker.py
def process_chains_to_runbooks():
    chains = brain.query("""
        SELECT * FROM reasoning_chains
        WHERE status = 'pending'
        AND confidence > 0.7
        LIMIT 50
    """)
    for chain in chains:
        runbook = generate_runbook(chain)
        if validate_runbook(runbook):
            brain.store(runbook)
            mark_chain_processed(chain.id)
```

---

#### #8 Cross-Reference KG ↔ Research
**New**: Bidirectional validation

**Implementation**:
```python
# cross_reference.py
def find_orphaned_entities():
    """Entities with no research backing"""
    entities = brain.query("SELECT id, name FROM kg_entities")
    orphaned = []
    for entity in entities:
        research_count = brain.query(f"""
            SELECT COUNT(*) FROM research_neural
            WHERE content LIKE '%{entity.name}%'
        """)
        if research_count == 0:
            orphaned.append(entity)
    return orphaned

def find_unlinked_research():
    """Research that should link to entities"""
    research = brain.query("SELECT id, content FROM research_neural LIMIT 1000")
    unlinked = []
    for r in research:
        entities = extract_entities(r.content)
        if not entities:
            unlinked.append(r)
    return unlinked

# Run weekly
def weekly_cross_reference():
    print(f"Orphaned entities: {len(find_orphaned_entities())}")
    print(f"Unlinked research: {len(find_unlinked_research())}")
```

---

#### #9 vLLM/LiteLLM Integration Fix
**Issue**: /v1/chat/completions returns 404

**Debug**:
```bash
ssh alien 'docker logs litellm 2>&1 | grep -i vllm | tail -20'

# Check LiteLLM config
ssh alien 'docker exec litellm cat /app/config.yaml'
```

**Fix**: Update LiteLLM config to correct vLLM endpoint
```yaml
model_list:
  - model_name: vllm
    litellm_params:
      api_base: http://localhost:8000/v1  # Verify this port
      rpm: 100
```

---

#### #10 Auto-Wake Workers (They're all awake!)
**Status**: ALL v4 workers are running

**Better idea**: Worker health monitoring & auto-restart
```bash
#!/bin/bash
# worker_health_check.sh - Run from cron

WORKERS=(
    "v4_entity_worker"
    "v4_relationship_worker"
    "v4_reasoning_worker"
    "v4_community_worker"
    "v4_wisdom_worker"
    "v4_anticipator_worker"
)

for worker in "${WORKERS[@]}"; do
    if ! ssh pc "pgrep -f $worker" > /dev/null; then
        echo "$worker not running, restarting..."
        ssh pc "cd /home/p/solo-cloud/brain && python3 ${worker}.py &"
    fi
done
```

**Add to crontab**:
```
*/5 * * * * /home/p/scripts/worker_health_check.sh
```

---

#### #11 Audit Framework Standardization
**Create template based on GLM3 methodology**:

```bash
mkdir -p ~/.claude/templates/audit
```

**Template**: `~/.claude/templates/audit/fleet_audit.md`
```markdown
# SOLO Fleet Audit Template

## Required Sections

### 1. Ground Truth Verification
```bash
# Must run these commands first
curl -s http://192.168.68.58:8080/health
ssh pc 'ps aux | grep worker'
ssh alien 'docker ps'
```

### 2. Data Verification
```bash
# Get actual counts before reporting
brain_records=$(curl -s http://192.168.68.58:8080/stats | jq '.records')
```

### 3. Issue Reporting Format
```json
{
  "issue": "description",
  "severity": "critical|high|medium|low",
  "verified": true,
  "verification_command": "command that proves it",
  "impact": "what it affects"
}
```

## Rules
1. NEVER claim service status without verification
2. If unsure, say "believe" not "is"
3. Include verification commands for all findings
4. Separate observed data from inferences
```

---

#### #12 Brain API /entities Endpoint
**Add to Brain API**:

```python
# In brain-api/main.py
@app.get("/entities")
async def list_entities(
    limit: int = 100,
    offset: int = 0,
    search: str = None
):
    """List entities with pagination and search"""
    query = "SELECT * FROM kg_entities"
    params = {}

    if search:
        query += " WHERE name LIKE :search"
        params["search"] = f"%{search}%"

    query += " ORDER BY created_at DESC LIMIT :limit OFFSET :offset"
    params["limit"] = limit
    params["offset"] = offset

    entities = db.execute(query, params)
    return {
        "entities": entities,
        "count": len(entities),
        "limit": limit,
        "offset": offset
    }

@app.get("/entities/{entity_id}")
async def get_entity(entity_id: str):
    """Get single entity with relationships"""
    entity = db.execute(
        "SELECT * FROM kg_entities WHERE id = :id",
        {"id": entity_id}
    )
    relationships = db.execute(
        "SELECT * FROM kg_relationships WHERE source_id = :id OR target_id = :id",
        {"id": entity_id}
    )
    return {"entity": entity, "relationships": relationships}
```

---

## Summary

| Priority | Action | Effort | Status |
|----------|--------|--------|--------|
| ~~#1~~ | Entity deduplication | - | ❌ SKIP - Too risky |
| ~~#2~~ | Wake community worker | - | ❌ SKIP - Already running |
| #3 | Wisdom extraction | 4h | ✅ DO - Verify & enhance |
| #4 | Query caching | 3h | ✅ DO - Redis exists |
| #5 | Health dashboard | 2h | ✅ DO - Create Grafana panels |
| #6 | Relationship optimization | 1h | ✅ DO - Monitor & tune |
| #7 | Reasoning processing | 2h | ✅ DO - Verify runbook gen |
| #8 | KG ↔ Research x-ref | 3h | ✅ DO - New analysis |
| #9 | vLLM fix | 1h | ✅ DO - Debug & fix |
| #10 | Worker health check | 2h | ✅ DO - Auto-restart script |
| #11 | Audit framework | 2h | ✅ DO - Create template |
| #12 | /entities endpoint | 2h | ✅ DO - Add API routes |

**Total**: 22 hours of high-impact, low-risk work
