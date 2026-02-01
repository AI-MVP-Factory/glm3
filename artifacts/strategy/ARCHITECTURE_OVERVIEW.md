# SOLO Business Vision - Architecture Overview
**Date:** 2026-01-29
**Version:** 1.0
**Status:** COMPLETE - All 5 components built

---

## THE BIG PICTURE

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                          SOLO AI-POWERED BUSINESS ENGINE                            │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌──────────────┐         ┌──────────────┐         ┌──────────────┐             │
│  │     MAC      │         │  ALIENWARE    │         │     PC       │             │
│  │  (Orchestrator)│        │ (Production)  │         │ (Research)   │             │
│  └──────┬───────┘         └──────┬───────┘         └──────┬───────┘             │
│         │                        │                        │                      │
│  ┌──────▼───────┐         ┌──────▼───────┐         ┌──────▼───────┐             │
│  │ opus-router  │         │  Brain API   │         │   Workers    │             │
│  │   :8788      │         │    :8080     │         │  (7 workers)  │             │
│  │  GLM proxy   │         │ 485K+ records│         │  Factory     │             │
│  └──────────────┘         └──────┬───────┘         └──────────────┘             │
│                                  │                                                │
│                         ┌────────▼──────────┐                                 │
│                         │  Signal Scanner   │ 24/7 scanning                  │
│                         │  Scoring Engine   │ AI evaluation                  │
│                         │  Ops Agent        │ Auto-recovery                  │
│                         │  Morning Brief    │ 6:00 AM daily                 │
│                         │  Grafana          │ :3000                          │
│                         │  Prometheus       │ :9090                          │
│                         └───────────────────┘                                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## SERVICE INVENTORY

### Mac (192.168.68.55) - Orchestrator

| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| opus-router | 8788 | GLM proxy, 87% cost savings | 🟢 UP |
| Claude Desktop | - | Development environment | 🟢 ACTIVE |
| Coordinator (glm3) | - | Strategic oversight | 🟢 ACTIVE |

### Alienware (192.168.68.58) - Production Brain

| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Brain API | 8080 | Knowledge base, embeddings | 🟢 UP |
| LiteLLM | 4001 | LLM routing | 🟢 UP |
| Grafana | 3000 | Business dashboard | 🟢 UP |
| Prometheus | 9090 | Metrics collection | 🟢 UP |
| Signal Scanner | - | 24/7 opportunity discovery | 🟡 READY |
| Scoring Engine | 8100 | AI candidate evaluation | 🟡 READY |
| Ops Agent | - | Auto-operations | 🟡 READY |
| Morning Brief | - | Daily report generator | 🟡 READY |
| Redis | 6379 | Caching | 🟢 UP |

### PC (192.168.68.50) - Research Lab

| Service | Purpose | Status |
|---------|---------|--------|
| Worker 1 (research) | Deep research | 🟢 ACTIVE |
| Worker 2 (writer) | Content generation | 🟢 ACTIVE |
| Worker 3 (coder) | Code implementation | 🟢 ACTIVE |
| Worker 4 (tester) | Testing & QA | 🟢 ACTIVE |
| Worker 5 (reviewer) | Code review | 🟢 ACTIVE |
| Worker 6 (scorer) | Quality scoring | 🟢 ACTIVE |
| Worker 7 (builder) | MVP builder | 🟢 ACTIVE |
| Factory Orchestrator | Coordinates workers | 🟢 ACTIVE |

---

## TECHNOLOGY STACK

### Languages & Runtimes
- **Python 3.11+** - All services
- **Bash** - Deployment scripts
- **JavaScript** - Grafana dashboards

### Frameworks & Libraries
| Component | Technology |
|-----------|------------|
| Signal Scanner | asyncio, aiohttp, asyncpraw, structlog |
| Scoring Engine | FastAPI, httpx, pydantic |
| Ops Agent | asyncio, structlog, psutil |
| Morning Brief | jinja2, croniter |
| Dashboard | Grafana, Prometheus |
| Brain API | FastAPI, LanceDB, Qwen3-VL |

### Databases & Storage
| Database | Purpose | Location |
|----------|---------|----------|
| LanceDB | Vector embeddings, knowledge | Alienware |
| Redis | Caching layer | Alienware |
| JSON files | Signals, scored candidates | Alienware |
| JSONL files | Factory state | Mac/PC |

### Monitoring Stack
- **Prometheus** - Metrics collection (:9090)
- **Grafana** - Visualization (:3000)
- **structlog** - Structured logging
- **journalctl** - Systemd logs

---

## DATA FLOW ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SIGNAL DISCOVERY PIPELINE                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  24/7 SOURCES → SIGNAL SCANNER → queue.jsonl → SCORING ENGINE         │
│                                                                          │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐    ┌──────────┐     │
│  │ Reddit   │───▶│              │───▶│          │───▶│          │     │
│  │ Twitter  │    │ Signal       │    │ Brain    │    │ Scored   │     │
│  │ PH/HN    │    │ Scanner      │    │ Enrich   │    │ Candidates│     │
│  │ AppStore │    │ (Alienware)   │    │ (Brain)  │    │ (.jsonl) │     │
│  └──────────┘    └──────────────┘    └──────────┘    └──────────┘     │
│                                                      │                  │
│                                                      ▼                  │
│                                          ┌──────────────────────┐      │
│                                          │ MORNING BRIEF        │      │
│                                          │ aggregates & formats│      │
│                                          └──────────────────────┘      │
│                                                      │                  │
│                                                      ▼                  │
│                                          ┌──────────────────────┐      │
│                                          │ FOUNDER REVIEW       │      │
│                                          │ 7:00 AM daily         │      │
│                                          │ Go/No-Go decisions    │      │
│                                          └──────────────────────┘      │
│                                                      │                  │
│                                                      ▼                  │
│                                          ┌──────────────────────┐      │
│                                          │ AI FACTORY           │      │
│                                          │ Builds MVPs          │      │
│                                          └──────────────────────┘      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## NETWORK TOPOLOGY

```
                    ┌─────────────────────────────────────┐
                    │         ROUTER (192.168.68.1)        │
                    └───────────────┬─────────────────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
      ┌─────▼──────┐         ┌─────▼──────┐         ┌─────▼──────┐
      │   MAC     │         │ ALIENWARE  │         │    PC     │
      │  .68.55   │         │  .68.58    │         │  .68.50   │
      │  WiFi     │         │  Ethernet  │         │  Ethernet │
      └───────────┘         └────────────┘         └───────────┘
            │                       │                       │
            │                       │                       │
      ┌─────▼──────┐         ┌─────▼──────┐         ┌─────▼──────┐
      │ :8788     │         │ :8080     │         │ Workers   │
      │ opus-rt   │         │ Brain API │         │ Factory   │
      └───────────┘         │ :4001     │         └───────────┘
                            │ LiteLLM   │
                            │ :3000     │
                            │ Grafana   │
                            │ :9090     │
                            │ Prom      │
                            └───────────┘
```

---

## SERVICE DEPENDENCIES

```
Signal Scanner ──▶ Brain API (enrichment)
                 ──▶ SOLO_API_KEY

Scoring Engine ───▶ Brain API (market data)
                 ───▶ opus-router (AI scoring)
                 ───▶ queue.jsonl (input)

Ops Agent ────────▶ All services (health checks)
                 ───▶ opus-router (AI diagnosis)
                 ───▶ Brain API (learning)

Morning Brief ────▶ scored.jsonl (candidates)
                 ───▶ STATUS.json (factory state)
                 ───▶ Prometheus (metrics)

Dashboard ───────▶ Prometheus (metrics)
                 ───▶ factory-exporter (custom)
                 ───▶ Grafana (display)
```

---

## DEPLOYMENT SUMMARY

| Component | Location | Method | Auto-restart |
|-----------|----------|--------|--------------|
| Signal Scanner | Alienware | systemd | ✅ |
| Scoring Engine | Alienware | systemd | ✅ |
| Ops Agent | Alienware | systemd | ✅ |
| Morning Brief | Alienware | cron | ✅ |
| Dashboard | Alienware | Grafana import | ✅ |
| Factory Exporter | Mac | systemd | ✅ |

---

## KEY ARCHITECTURAL DECISIONS

1. **Alienware as Brain Host** - Zero network hops for embeddings
2. **opus-router on Mac** - Centralized GLM routing, 87% cost savings
3. **Native Python services** - No Docker overhead, direct systemd
4. **JSONL for signals** - Simple, append-only, resilient
5. **Brain API as central truth** - All services query for enrichment
6. **Ops Agent for self-healing** - 12+ auto-recovery patterns
7. **Morning Brief for founder UX** - Curated daily report, 10 min/day

---

## NEXT STEPS

1. ✅ All components built
2. ✅ All documentation complete
3. 🟡 Deploy to Alienware (run deploy-all-services.sh)
4. 🟡 Configure external API keys (optional)
5. 🟡 Test full pipeline end-to-end

---

**For detailed documentation, see:**
- `DATA_MODELS.md` - All data structures
- `API_ENDPOINTS.md` - All APIs
- `DEPLOYMENT_ARCHITECTURE.md` - Deployment details
- `MONITORING_OBSERVABILITY.md` - Monitoring setup
- `SECURITY_ARCHITECTURE.md` - Security model
- `SCALING_STRATEGIES.md` - Scaling paths
- `FAILURE_RECOVERY.md` - Recovery procedures
- `COST_ANALYSIS.md` - Economics
- `DAILY_WORKFLOWS.md` - Founder experience
