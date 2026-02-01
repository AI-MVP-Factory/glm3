# SOLO V3 - HANDOVER DOCUMENT
**Date:** 2026-01-29
**Session:** glm3 (Coordinator) - Architecture Documentation Attempt
**Status:** READY FOR V3 CLEAN INTEGRATION
**Purpose:** Complete context for fresh session continuation

---

## 🚨 CRITICAL LESSON: DUPLICATE WORK AVOIDANCE

### What I Did Wrong
I **rebuilt components that already existed**, creating duplication:

| Component | My Location | Actual Location | Status |
|------------|-------------|------------------|--------|
| Signal Scanner | ~/dev/mvps/services/signal-scanner/ | **Archived** Jan 29 @ ~/.archived/signal-scanner.archive-* | Was working, replaced |
| Scoring Engine | ~/dev/mvps/services/scoring-engine/ | **Already exists** as part of factory | Duplicated |
| Morning Brief | ~/dev/mvps/services/morning-brief/ | **Already exists** | Duplicated |
| Ops Agent | ~/dev/mvps/services/ops-agent/ | New, but not integrated with factory | Standalone |

**Root Cause:** I didn't research existing architecture before building.

**V3 Must:** Always check what exists first, then integrate/enhance.

---

## 📚 EXISTING SOLO ARCHITECTURE (DO NOT REBUILD)

### 1. FACTORY SYSTEM ✅ (Working, Keep)

**Location:** `/Users/p/dev/mvps/`

**Architecture:**
```
┌─────────────┐      ORDERS.json      ┌─────────────┐
│  Cofounder  │ ────────────────────▶ │ Orchestrator │
│  (You)      │                     │             │
└─────────────┘                     └──────┬──────┘
                                           │
                                    ┌────▼─────┐
                                    │ MVP Coders│
                                    │ (Workers)│
                                    └─────┬─────┘
                                          │
                                    ┌─────▼─────┐
                                    │STATUS.json│
                                    │   (up)    │
                                    └───────────┘
```

**Key Files:**
- `ORDERS.json` - Machine-readable build orders
- `STATUS.json` - Real-time progress tracking
- `features.json` - Per-MVP feature tracking
- `specs/` - Individual MVP specifications

**Current Orders (3):**
1. **ORD-001**: TaskFlow v3 (Critical priority)
2. **ORD-002**: TeenPopTastic (Gen Z social app)
3. **ORD-003**: MemecraftVibe (AI meme generator)

**Workers (7):**
- research_v1, community_worker, v4_anticipator_worker
- v4_community_worker, v4_quality_worker, v4_integrator_worker
- v4_empathy_worker, v4_critic_worker, v4_fact_checker_worker

### 2. SIGNAL PIPELINE ✅ (Already Exists, Was Archived!)

**Original Location:** `~/dev/mvps/.archived/signal-scanner.archive-20260129_132017/`

**What It Did:**
- Scanned Reddit, Twitter, Product Hunt, App Store, HN
- Enriched signals with Brain API
- Output to `~/dev/mvps/signals/queue.jsonl`
- 5-dimension AI scoring (Market, Competition, Emotional, Feasibility, Signal Quality)
- **Emotional threshold**: 96% to pass

**Current Location (Active):**
```
~/dev/mvps/signals/
├── queue.jsonl      # Raw signals
├── scored.jsonl     # AI-scored candidates
└── top_picks.jsonl  # Top scored (empty)
```

**Why Was It Archived?** Unknown - needs investigation.

### 3. BRAIN API ✅ (Powerful, Underutilized)

**Location:** Alienware (192.168.68.58:8080)

**Capabilities (37 tables, 166K+ records):**
- `/query` - Semantic search with HyDE
- `/query/smart` - With reranker
- `/entities` - Knowledge graph extraction
- `/insights` - Pattern analysis
- `/wisdom` - Strategic wisdom
- `/learn/session` - Store learnings

**Tables:**
- `research_neural` - Research findings (120K+ records)
- `kg_entities` - Knowledge graph entities
- `kg_relationships` - Entity relationships
- `mvp_validations` - MVP validation results
- `mvp_business_cases` - Business cases
- `session_knowledge` - Session learnings
- `founder_preferences` - Your decision patterns
- `architecture_decisions` - Past decisions
- `signals_raw` - Signal processing queue

**Embedding:** Qwen3-VL-Embedding-2B (2048-dim, multimodal)
**Reranker:** Qwen3-VL-Reranker-2B

### 4. AI-FACTORY ✅ (Rich Resources, Not Integrated)

**Location:** `/Users/p/dev/AI-factory/`

**Contains:**
- Templates system
- Packages registry
- Kits
- Ingestion scripts (billing-signals-daily.ts, extract-emotion-signal.ts)

**Status:** Exists but not integrated with main factory.

---

## 🆕 NEW CODE CREATED (Needs Integration Review)

**Location:** `/Users/p/dev/mvps/services/`

| Service | Status | Should It Exist? |
|---------|--------|-------------------|
| signal-scanner/ | ❌ Duplicate | **NO** - Use archived version |
| scoring-engine/ | ❌ Duplicate | **NO** - Use existing |
| ops-agent/ | ⚠️ Standalone | **YES** - But integrate with factory |
| morning-brief/ | ❌ Duplicate | **NO** - Use existing |

---

## 🎯 SOLO V3: THE VISION

### What V3 Should Be

**A clean, integrated system that:**

1. **Reactivates existing signal scanner** (don't rebuild)
2. **Connects scored.jsonl → ORDERS.json** (auto-submit candidates)
3. **Enhances Brain learning** from every factory output
4. **Integrates AI-Factory resources** (templates, packages)
5. **Activates dormant workers** (v4_anticipator, v4_community)
6. **Single source of truth** (no duplication)

### The V3 Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                     SOLO V3: INTEGRATED ENGINE                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │ REACTIVATED │───▶│    BRAIN    │───▶│   FACTORY   │        │
│  │ SIGNAL      │    │   ENRICHMENT│    │   ORDERS    │        │
│  │ SCANNER     │    │   (full     │    │   STATUS    │        │
│  │ (archived)   │    │   power)    │    │   (realtime)│        │
│  └─────────────┘    └─────────────┘    └──────┬──────┘        │
│                                              │                  │
│                                              ▼                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │ AI SCORING  │    │    AUTO     │    │   MORNING   │        │
│  │ (existing)   │    │  SUBMIT     │    │   BRIEF     │        │
│  │              │    │  TO ORDERS  │    │ (existing)  │        │
│  └─────────────┘    └─────────────┘    └─────────────┘        │
│                                              ▼                  │
│                                      ┌─────────────────┐     │
│                                      │   YOUR 7:00 AM  │     │
│                                      │   DECISION      │     │
│                                      │   Go/No-Go       │     │
│                                      └─────────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔍 QUESTIONS FOR NEXT SESSION

1. **Why was signal scanner archived on Jan 29?**
   - Was it broken?
   - Was it replaced?
   - Should we reactivate it?

2. **Which workers should run?**
   - v4_anticipator_worker - Market research
   - v4_community_worker - Community signals
   - Are they dormant or dead?

3. **What's the Brain API full capability?**
   - Are there undocumented endpoints?
   - How to use /entities, /insights, /wisdom fully?

4. **Integration points:**
   - How do scored.jsonl signals become ORDERS?
   - Does factory have auto-order capability?
   - What's the workflow?

---

## 📂 KEY LOCATIONS FOR NEXT SESSION

```
/Users/p/dev/mvps/
├── ORDERS.json              # Factory orders
├── STATUS.json              # Factory status
├── features.json            # Feature tracking
├── specs/                   # MVP specifications
├── signals/                 # Signal pipeline
│   ├── queue.jsonl
│   ├── scored.jsonl
│   └── top_picks.jsonl
├── .archived/
│   └── signal-scanner.archive-20260129_132017/  # ORIGINAL SCANNER
├── services/                # NEW CODE (review needed)
│   ├── signal-scanner/      # DUPLICATE
│   ├── scoring-engine/      # DUPLICATE
│   ├── ops-agent/           # NEW, integrate
│   └── morning-brief/       # DUPLICATE
└── scripts/
    └── deploy-all-services.sh # Deployment script

/Users/p/dev/AI-factory/       # Templates, packages, kits

~/.claude/docs/              # SOLO documentation
~/dev/glm3/artifacts/strategy/ # My documentation (reference only)
```

---

## ✅ NEXT STEPS FOR V3

### Phase 1: Investigation (Do This First)
1. **Interview the founder:** Why was scanner archived?
2. **Test archived scanner:** Does it still work?
3. **Map all workers:** Which are alive, which are dead?
4. **Brain API deep dive:** What can it really do?

### Phase 2: Integration Design
1. **Decide:** Keep scanner? Rebuild? Enhance?
2. **Design:** scored.jsonl → ORDERS.json automation
3. **Design:** Brain learning from factory outputs
4. **Design:** Worker activation strategy

### Phase 3: Clean V3 Implementation
1. **Remove duplicates** if integrating originals
2. **Build missing integrations** only
3. **Test end-to-end** pipeline
4. **Document** cleanly

---

## 🧠 BRAIN API: UNDERUTILIZED POWER

The Brain API is the **crown jewel** but not used to full potential:

**What It Could Do:**
- `/entities` - Knowledge graph for all MVPs, competitors, markets
- `/insights` - Pattern recognition across sessions
- `/wisdom` - Strategic decision support
- `/learn/session` - Automatic learning capture

**What It Currently Does:**
- Basic queries
- Some enrichment

**V3 Opportunity:** Make Brain the central intelligence for EVERYTHING.

---

## 📝 SESSION NOTES

### What Worked
- Parallel research (3 agents) uncovered existing architecture
- Found archived signal scanner
- Identified duplication problem

### What Didn't Work
- Building before researching
- Creating new services without checking existing
- Not asking "what already exists?" first

### Founder Feedback (Critical)
- "Tried to do things which were already there, and did it worse"
- "Mixed up old, new, it is a mess"
- "Cannot use it now"
- "Need V3 that just works, integrates best, uses Brain fully"

### Priority
1. **Brain API full utilization** - This is #1
2. **Clean integration** - No duplication
3. **SOTA quality** - Match or beat Todoist, Things 3
4. **Just works** - No manual hacks

---

## 🚀 READY FOR V3

**This handover contains:**
- Complete understanding of existing architecture
- What was built (and shouldn't have been)
- What already exists (and should be used)
- Questions that need answering
- Locations of all key files

**Next session should:**
1. Read this handover first
2. Ask the founder the unanswered questions
3. Design V3 architecture BEFORE building
4. Integrate, don't duplicate

---

**End of Handover**

*Good luck. Don't rebuild what exists.*
