# SOLO Business Vision - Strategic Brief
**Date:** 2026-01-29
**Founder:** Petr
**Strategic Coordinator:** Claude (glm3)
**Status:** ACTIVE VISION - Aligned with Founder's Intent

---

## THE FOUNDER'S VISION (As Evolved)

> "Fully AI-powered and automated solo business running hundreds of MVPs and automatically improving and learning from every single interaction."
>
> **Key Requirements:**
> - **Business Dashboard:** See progress, signals, funnel operations
> - **24/7 Scanning:** AI scans for opportunities continuously
> - **Funnel:** Produces 10-30 MVP candidates overnight for morning selection
> - **Automated Ops:** AI solves operational issues, escalates only critical decisions
> - **Founder Role:** Go/No-Go decisions, key business strategy only

---

## THE DREAM: MORNING COFFEE WORKFLOW

```
┌─────────────────────────────────────────────────────────────────┐
│                     7:00 AM - MORNING ROUTINE                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Open Business Dashboard                                    │
│     → See 10-30 MVP candidates generated overnight             │
│     → Revenue metrics from live apps                           │
│     → Operational health (all green)                           │
│                                                                  │
│  2. Review Candidates (AI Pre-Scored)                          │
│     → Market size, competition analysis                        │
│     → Emotional value potential score                          │
│     → Estimated build time & resources                         │
│                                                                  │
│  3. Make 3-5 Go/No-Go Decisions (5 minutes)                     │
│     → Selected: "Build this" → Factory starts immediately      │
│     → Rejected: "Pass" → Archived with reasoning               │
│     → Maybe: "Research more" → Added to investigation queue    │
│                                                                  │
│  4. Go About Your Day                                            │
│     → Factory builds automatically                             │
│     → Ops AI handles all issues                                 │
│     → Only critical interruptions for emergencies              │
│                                                                  │
│  5. Evening Review (Optional)                                   │
│     → See what shipped                                         │
│     → Check revenue                                            │
│     → Review AI-solved operational issues                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## CURRENT STATE: WHAT'S BUILT (9/10 INFRASTRUCTURE!)

### ✅ ALREADY OPERATIONAL

| Component | Status | Location | Notes |
|-----------|--------|----------|-------|
| **Brain API** | 🟢 UP | Alienware :8080 | 485K+ records, Qwen3-VL embeddings |
| **Workers** | 🟢 ACTIVE | PC (192.168.68.50) | All v4 workers running |
| **LiteLLM** | 🟢 UP | Alienware :4001 | GLM routing, cost control |
| **Grafana** | 🟢 UP | Alienware :3000 | Exists, needs business panels |
| **Prometheus** | 🟢 UP | Alienware :9090 | Metrics collection ready |
| **Redis** | 🟢 UP | Alienware :6379 | Caching layer available |
| **opus-router** | 🟢 UP | Mac :8788 | GLM proxy (87% cost savings) |
| **Factory ORDERS** | 🟢 READY | /Users/p/dev/mvps/ | 3 orders pending |
| **Factory STATUS** | 🟢 READY | /Users/p/dev/mvps/ | Auto-updating |
| **Dashboard UI** | 🟢 EXISTS | /Users/p/dev/mvps/dashboard/ | Basic HTML, needs enhancement |

### Infrastructure Score: 9/10

**The Ferrari is built. Now we need to drive it.**

---

## THE GAPS: WHAT'S MISSING

### 🔴 MISSING: Business Intelligence Layer

| Gap | Impact | Effort |
|-----|--------|--------|
| **Business Dashboard** | No visibility into revenue, users, funnel | 3 days |
| **24/7 Signal Scanner** | No automatic opportunity discovery | 5 days |
| **Candidate Funnel** | No overnight MVP generation pipeline | 4 days |
| **Ops AI Agent** | No automatic issue resolution | 3 days |
| **Morning Brief Generator** | No curated morning report | 2 days |

**Total: ~17 days of focused work**

---

## THE ARCHITECTURE: HOW IT CONNECTS

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SOLO BUSINESS ENGINE                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    24/7 SIGNAL SCANNING                         │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │ Web Scanner  │  │ Trend Spotter│  │ Gap Analyzer │          │   │
│  │  │ (Reddit, X)  │  │ (GPT, Google)│  │ (Brain data) │          │   │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │   │
│  │         │                  │                  │                  │   │
│  │         └──────────────────┴──────────────────┘                  │   │
│  │                            ▼                                     │   │
│  │                   ┌─────────────────┐                            │   │
│  │                   │ Candidate Queue │  (10-30/day)               │   │
│  │                   └────────┬────────┘                            │   │
│  └────────────────────────────┼────────────────────────────────────┘   │
│                                 ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      AI SCORING ENGINE                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │ Market Size  │  │ Competition  │  │ Emotional    │          │   │
│  │  │ Analysis     │  │ Check        │  │ Potential    │          │   │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │   │
│  │         │                  │                  │                  │   │
│  │         └──────────────────┴──────────────────┘                  │   │
│  │                            ▼                                     │   │
│  │                   ┌─────────────────┐                            │   │
│  │                   │ Scored List     │  (Ready for review)        │   │
│  │                   └────────┬────────┘                            │   │
│  └────────────────────────────┼────────────────────────────────────┘   │
│                                 ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                   FOUNDER MORNING REVIEW                        │   │
│  │  ┌─────────────────────────────────────────────────────────┐   │   │
│  │  │              Business Dashboard (7:00 AM)                │   │   │
│  │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │   │   │
│  │  │  │ Revenue  │ │  Users   │ │ Alerts   │ │ Candidates│     │   │   │
│  │  │  │   $X     │ │   +Y     │ │   0      │ │    15    │     │   │   │
│  │  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘     │   │   │
│  │  │                                                             │   │   │
│  │  │  Candidates List (Pre-Scored):                              │   │   │
│  │  │  ┌──────────────────────────────────────────────────────┐ │   │   │
│  │  │  │ [GO] AI-Powered Habit Tracker (Score: 92)            │ │   │   │
│  │  │  │ [GO] Mood-Based Music Player (Score: 88)             │ │   │   │
│  │  │  │ [PASS] Generic To-Do App (Score: 45 - crowded)      │ │   │   │
│  │  │  │ [RESEARCH] AI Writing Assistant (Score: 76)          │ │   │   │
│  │  │  └──────────────────────────────────────────────────────┘ │   │   │
│  │  └────────────────────────────────────────────────────────────┘   │   │
│  └────────────────────────────────────┬────────────────────────────────┘   │
│                                       ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      AI FACTORY                                 │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │   │
│  │  │ Spec Writer  │  │ MVP Builder  │  │ Quality Gate │          │   │
│  │  │ (Auto-gen)   │  │ (Parallel)   │  │ (Automated)  │          │   │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │   │
│  │         │                  │                  │                  │   │
│  │         └──────────────────┴──────────────────┘                  │   │
│  │                            ▼                                     │   │
│  │                   ┌─────────────────┐                            │   │
│  │                   │ Live MVP        │                            │   │
│  │                   └─────────────────┘                            │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## IMPLEMENTATION PLAN

### PHASE 1: Business Dashboard (3 days)

**Deliverable:** Grafana dashboard showing:
- Revenue from all live MVPs (aggregate + per-app)
- User growth (D1/D7 retention, DAU/MAU)
- Funnel metrics (candidates → specs → builds → live)
- Operational health (worker status, errors, alerts)

**Data Sources:**
```python
# Dashboard queries
sources = {
    "revenue": "RevenueCat API + Stripe API",
    "users": "PostHog + Mixpanel analytics",
    "factory": "STATUS.json + features.json",
    "ops": "Prometheus metrics + worker logs"
}
```

### PHASE 2: Signal Scanner (5 days)

**Deliverable:** 24/7 scanning service that:
- Monitors Reddit (r/SideProject, r/SaaS, r/Entrepreneur)
- Monitors X/Twitter (indie hacker accounts)
- Scans Product Hunt launches
- Analyzes App Store charts
- Cross-references Brain for gaps

**Output:** Candidate queue with raw signals

### PHASE 3: AI Scoring Engine (4 days)

**Deliverable:** Automated scoring for each candidate:
- **Market Score:** TAM, growth rate, monetization potential
- **Competition Score:** How crowded, differentiation opportunity
- **Emotional Score:** Can we make users feel something? (>96 threshold)
- **Build Feasibility:** Tech stack complexity, time estimate
- **Overall Score:** Weighted average (0-100)

### PHASE 4: Ops AI Agent (3 days)

**Deliverable:** Automated operational issue handling:
- Monitor all services (Brain, workers, apps)
- Auto-restart failed services
- Auto-resolve common issues
- Escalate ONLY to founder for:
  - Revenue drops >20%
  - App rejections
  - Security incidents
  - Go/No-Go decisions

### PHASE 5: Morning Brief Generator (2 days)

**Deliverable:** Curated morning report:
```
=== SOLO MORNING BRIEF ===
Date: 2026-01-29

📊 BUSINESS HEALTH
Revenue: $2,450 (+12% WoW)
Users: 4,280 (+89 today)
Live Apps: 3

🎯 MVP CANDIDATES (Ready for Review)
1. AI-Powered Habit Tracker [Score: 92]
   Market: $2.4B growing 18% YoY
   Competition: Moderate (5 major players)
   Emotional Hook: "Celebrate your streaks"

2. Mood-Based Music Player [Score: 88]
   Market: $12B (Spotify APIs)
   Competition: High but undifferentiated
   Emotional Hook: "Music that matches your vibe"

... [13 more candidates]

⚠️ ALERTS: None
✅ OPS: All systems healthy
```

---

## DECISION REQUIRED

This vision aligns with your stated goals. To proceed:

**Option A:** Build phased (Dashboard first, then Scanner, etc.)
- Pros: Immediate value, learning as we go
- Cons: Full vision takes ~17 days

**Option B:** Build in parallel (spawn multiple workers)
- Pros: Faster completion
- Cons: More complex coordination

**Option C:** Refine vision first
- Pros: Ensure alignment before building
- Cons: Delays execution

**Which direction?**

---

## NEXT STEPS (After Decision)

1. Create detailed spec for chosen phase
2. Spawn workers for parallel execution
3. Build iteratively with daily review
4. Integrate with existing infrastructure
5. Handover when complete

---

**The infrastructure is ready. The vision is clear. The path is defined.**

**Ready to build?**
