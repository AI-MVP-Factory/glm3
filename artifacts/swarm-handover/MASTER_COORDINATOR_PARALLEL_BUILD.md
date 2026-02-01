# SOLO PARALLEL BUILD - Master Coordinator Plan

**Date:** 2026-01-29
**Mission:** Build complete SOLO Business Intelligence system in parallel
**Resources:** 6 Claude Code instances (1 coordinator + 5 workers)
**Timeline:** ~5 days parallel execution

---

## THE VISION (One Paragraph)

Build a fully AI-powered solo business system where:
1. **Signal Scanner** runs 24/7 finding opportunities
2. **AI Scoring Engine** evaluates and scores 10-30 candidates overnight
3. **Business Dashboard** shows revenue, users, funnel metrics
4. **Ops Orchestrator** auto-solves operational issues
5. **Morning Brief Generator** delivers curated report for founder's 7am decisions

Founder wakes up, reviews pre-scored candidates, makes 3-5 Go/No-Go decisions, factory builds automatically. Founder only handles critical business decisions.

---

## THE 6 PARALLEL STREAMS

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        GLM3 (Coordinator - YOU)                        │
│  Role: Strategy, specifications, cross-stream coordination              │
│  Deliverable: This plan + handover docs for each stream                 │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│   GLM         │         │   GLM2        │         │   GLM4        │
│ STREAM 1      │         │ STREAM 2      │         │ STREAM 3      │
│ Business      │         │ Signal        │         │ AI Scoring    │
│ Dashboard     │         │ Scanner 24/7  │         │ Engine        │
│ (Grafana)     │         │              │         │               │
└───────────────┘         └───────────────┘         └───────────────┘
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│   GLM5        │         │   GLM6        │         │   (BONUS)     │
│ STREAM 4      │         │ STREAM 5      │         │ STREAM 6      │
│ Ops           │         │ Morning Brief │         │ Integration   │
│ Orchestrator  │         │ Generator     │         │ & API Layer   │
└───────────────┘         └───────────────┘         └───────────────┘
```

---

## STREAM HANDOFF DOCUMENTS

Each stream gets a dedicated handover document with:
- Objective
- Technical specs
- Data sources
- Deliverables
- Integration points
- Testing checklist

**Documents Location:** `/Users/p/dev/glm3/artifacts/swarm-handover/`

| Stream | File | Owner |
|--------|------|-------|
| Coordinator | `MASTER_COORDINATOR_PARALLEL_BUILD.md` | GLM3 |
| Dashboard | `STREAM_1_DASHBOARD.md` | GLM |
| Scanner | `STREAM_2_SCANNER.md` | GLM2 |
| Scoring | `STREAM_3_SCORING.md` | GLM4 |
| Ops | `STREAM_4_OPS.md` | GLM5 |
| Brief | `STREAM_5_BRIEF.md` | GLM6 |
| Integration | `STREAM_6_INTEGRATION.md` | (optional) |

---

## CROSS-STREAM DEPENDENCIES

```
┌─────────────────────────────────────────────────────────────────┐
│                    DATA FLOW DIAGRAM                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  STREAM 2 (Scanner) ──raw_signals──> STREAM 3 (Scorer)         │
│                                                     │           │
│                                                     ▼           │
│  STREAM 5 (Brief) <──scored_candidates──┐                        │
│         │                               │                       │
│         └───all_metrics──> STREAM 1 (Dashboard)                │
│                                │                                │
│                                ▼                                │
│                        STREAM 4 (Ops)                            │
│                      (monitors everything)                       │
│                                                                 │
│  STREAM 6 (Integration) ──glues──┴─everything together           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Key Principle:** Each stream delivers value independently. Integration is the final polish.

---

## COORDINATOR RESPONSIBILITIES (YOU - GLM3)

1. **Create all handoff documents** (this file + 5 stream docs)
2. **Define data contracts** between streams
3. **Set up integration testing** plan
4. **Monitor progress** across all workers
5. **Resolve cross-stream blockers**
6. **Final integration** and validation

---

## WORKER INSTRUCTIONS (For Each Stream Worker)

```markdown
# When You Receive Your Stream Assignment

1. Read your handoff document completely
2. Ask clarifying questions BEFORE starting
3. Create a task list for your stream
4. Spawn haiku workers for parallel execution within your stream
5. Build incrementally: MVP → Test → Expand
6. Update STATUS.json daily with progress
7. Flag blockers immediately to coordinator
8. Deliver working code, not specs

# Your Output

- Working code in designated folder
- Tests passing
- Documentation updated
- Integration points verified
- STATUS.json updated
```

---

## SHARED RESOURCES

All streams have access to:

| Resource | Location | Access |
|----------|----------|--------|
| Brain API | http://192.168.68.58:8080 | API key |
| Prometheus | http://192.168.68.58:9090 | Direct |
| Grafana | http://192.168.68.58:3000 | admin/soloadmin |
| LiteLLM | http://192.168.68.58:4001 | API key |
| Factory | /Users/p/dev/mvps/ | Direct |
| opus-router | http://127.0.0.1:8788 | Local |

---

## TIMELINE

| Day | Milestone |
|-----|-----------|
| 1 | All streams started, basic MVPs working |
| 2 | Core features complete, integration testing begins |
| 3 | End-to-end flow working (scanner → scorer → dashboard) |
| 4 | Ops orchestrator + morning brief integrated |
| 5 | Polish, testing, documentation |

---

## SUCCESS CRITERIA

**Day 5 Morning:** Founder opens dashboard and sees:
- Revenue from all apps
- 10-30 scored MVP candidates
- Operational health green
- Morning brief ready for review
- Can make Go/No-Go decisions in 5 minutes

---

## NEXT STEP

I will now create handoff documents for each of the 5 streams.

Each document will contain:
1. Objective and success criteria
2. Technical architecture
3. Data sources and APIs
4. Implementation tasks (broken for haiku parallelization)
5. Testing checklist
6. Integration points

After documents are created, workers can begin immediately.

---

**Ready to generate handoff documents?**
