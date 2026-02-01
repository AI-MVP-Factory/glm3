# SOLO BUSINESS VISION - EXECUTION PLAN
**Date:** 2026-01-29
**Mode:** Parallel Build (Option B)
**Coordinator:** Claude (glm3)

---

## 📋 OVERVIEW

Building 5 components in parallel to achieve the SOLO business vision:

| # | Component | Spec | Worker | Est. Days |
|---|-----------|------|--------|-----------|
| 1 | Business Dashboard | `SPEC_01_Business_Dashboard.md` | glm2 | 3 |
| 2 | Signal Scanner | `SPEC_02_Signal_Scanner.md` | glm4 | 5 |
| 3 | AI Scoring Engine | `SPEC_03_AI_Scoring_Engine.md` | glm | 4 |
| 4 | Ops AI Agent | `SPEC_04_Ops_AI_Agent.md` | glm6 | 3 |
| 5 | Morning Brief | `SPEC_05_Morning_Brief.md` | glm5 | 2 |

**Parallel Timeline:** ~5 days (longest component)

---

## 🚀 SPAWN INSTRUCTIONS

### Option A: Spawn All Now (Recommended)
```bash
# Terminal 1 - glm2 (Dashboard)
cd ~/dev/glm2 && claude
> Read /Users/p/dev/glm3/artifacts/strategy/SPEC_01_Business_Dashboard.md
> Execute the spec

# Terminal 2 - glm4 (Signal Scanner)
cd ~/dev/glm4 && claude
> Read /Users/p/dev/glm3/artifacts/strategy/SPEC_02_Signal_Scanner.md
> Execute the spec

# Terminal 3 - glm (Scoring Engine)
cd ~/dev/glm && claude
> Read /Users/p/dev/glm3/artifacts/strategy/SPEC_03_AI_Scoring_Engine.md
> Execute the spec

# Terminal 4 - glm6 (Ops Agent)
cd ~/dev/glm6 && claude
> Read /Users/p/dev/glm3/artifacts/strategy/SPEC_04_Ops_AI_Agent.md
> Execute the spec

# Terminal 5 - glm5 (Morning Brief)
cd ~/dev/glm5 && claude
> Read /Users/p/dev/glm3/artifacts/strategy/SPEC_05_Morning_Brief.md
> Execute the spec
```

### Option B: Spawn Gradually
Start with highest priority first (Dashboard, Signal Scanner), then add others.

---

## 📊 PROGRESS TRACKING

Each worker should update status daily:

```bash
# Check all worker status
cat ~/dev/glm*/STATUS.md 2>/dev/null | grep -E "Worker:|Progress:"
```

Coordinator (glm3) will:
- Review progress daily
- Resolve dependencies
- Handle blockers
- Merge completed work

---

## 🗂️ OUTPUT LOCATIONS

```
/Users/p/dev/mvps/
├── dashboards/           # Grafana dashboard JSONs
├── services/
│   ├── signal-scanner/   # 24/7 signal scanning
│   ├── scoring-engine/   # AI candidate scoring
│   ├── ops-agent/        # Automated operations
│   └── morning-brief/    # Daily report generator
└── signals/
    ├── queue.jsonl       # Raw signals from scanner
    └── scored.jsonl      # Scored candidates
```

---

## ✅ ACCEPTANCE CHECKLIST

Before marking vision complete:

- [ ] Dashboard shows real revenue/user data
- [ ] Scanner produces 10-30 signals/day
- [ ] Scoring engine scores all queued signals
- [ ] Ops agent resolves >80% of issues automatically
- [ ] Morning brief arrives by 6:00 AM
- [ ] Founder can review 10-30 candidates in <5 minutes
- [ ] Go/No-Go decisions trigger factory builds
- [ ] Critical alerts reach founder immediately

---

## 🎯 SUCCESS METRICS

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Daily Candidates | 10-30 | `cat scored.jsonl \| wc -l` |
| Founder Review Time | <5 min | Morning brief completion rate |
| Auto-Resolved Ops | >80% | Ops agent success rate |
| Time to Decision | <1 day | Signal → Score → Decision |
| Revenue Visibility | Real-time | Dashboard refresh rate |

---

## 📞 COORDINATOR ACCESS

Coordinator (glm3) available at:
- Location: `/Users/p/dev/glm3`
- Brain: Query for context
- Specs: `/Users/p/dev/glm3/artifacts/strategy/`

**When to escalate:**
- Blocked on dependencies
- Ambiguous requirements
- Technical dead ends
- Completed work for integration

---

**Ready to spawn workers? Execute the spawn instructions above.**

The specs are detailed. The architecture is defined. The path is clear.

Let's build.
