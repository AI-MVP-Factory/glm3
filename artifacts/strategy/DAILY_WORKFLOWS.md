# DAILY WORKFLOWS - SOLO Business System

**Version:** 1.0  
**Date:** 2026-01-29  
**Status:** Active

---

## 📋 OVERVIEW

This document outlines the complete daily workflow system for the SOLO business, designed to maximize founder efficiency while maintaining high-velocity product development. The system runs 24/7 with minimal human intervention, requiring only 5-10 minutes of founder attention daily.

---

## 🌅 1. FOUNDER WORKFLOW

### Morning Routine (7:00 AM)

**1. Review Morning Brief (5 minutes)**
- Location: Terminal (`cat /Users/p/dev/mvps/briefs/today.md`) or Email
- What to look for:
  - Business health metrics
  - GO candidates ready for review
  - Critical alerts (🚨)
  - Previous day's output

**2. Make Go/No-Go Decisions (5 minutes)**
- For each GO candidate in the brief:
  - Review the emotional score (>96% threshold)
  - Consider market size and competition
  - Assess build feasibility
  - Decision: `y` (build), `n` (pass), `r` (research more)

**3. Trigger Builds (immediate)**
- Accepted candidates added to:
  - `/Users/p/dev/mvps/orders.json`
  - Orchestrator automatically picks up orders
  - Factory starts building immediately

### Optional Evening Review (7:00 PM)

**Quick Check (2 minutes)**
- Scan dashboard for progress
- Note any alerts that came in during day
- Review yesterday's shipped items

**Weekly Strategy Review (30 minutes, Friday 5:00 PM)**
- Review week's performance metrics
- Assess signal quality improvements
- Adjust scoring weights if needed
- Plan next week's priorities

**Monthly Business Review (2 hours, last Sunday)**
- Revenue and user growth analysis
- Competitor landscape review
- Product portfolio health
- Strategic pivots or new market entry

---

## 🔄 2. AUTOMATED WORKFLOWS

### 24/7 Signal Scanning

**When & How Often**
- Reddit: Hourly (r/SideProject, r/SaaS, r/Entrepreneur)
- X/Twitter: Hourly (@IndieHackers, @levelsio)
- Product Hunt: Daily (Top 20 launches)
- App Store Charts: Daily (Top 50 per category)
- Hacker News: Hourly (Show HN threads)
- YC Hacker News: Daily ("Who wants to build" posts)

**Process**
1. Scanner runs continuously on Alienware
2. Extracts pain points, opportunities, and gaps
3. Enriches with Brain context (market size, patterns)
4. Writes to queue: `/Users/p/dev/mvps/signals/queue.jsonl`
5. Produces 10-30 quality signals per day

### Scoring Pipeline

**Triggers**
- New signal in queue → Automatic scoring
- Batch processing every 15 minutes

**Process**
1. Scoring engine reads from queue.jsonl
2. Evaluates 5 dimensions:
   - Market Score (25%): TAM, growth, monetization
   - Competition Score (20%): Crowding, differentiation
   - Emotional Score (30%): FEEL factor (>96% threshold)
   - Build Feasibility (15%): Complexity, time estimate
   - Signal Quality (10%): Source credibility, engagement
3. Writes to scored.jsonl with verdicts:
   - GO: >80 score + emotional >96%
   - RESEARCH: 50-80 score
   - PASS: <50 score

### Morning Brief Generation (6:00 AM)

**Automated Process**
1. 6:00 AM cron job triggers
2. Aggregates data from all services:
   - Business health (RevenueCat, PostHog)
   - Top GO candidates from scored.jsonl
   - Yesterday's shipped items (STATUS.json)
   - Active alerts (Ops Agent)
   - Service health (Prometheus)
   - Daily insights (Brain API)
3. Formats into morning brief
4. Delivers via:
   - Terminal (markdown file)
   - Email (HTML format)
   - Slack (if configured)

### Ops Monitoring (Continuous)

**24/7 Service Health**
- Monitored services: Brain API, 7 Workers, LiteLLM, Grafana, Prometheus
- Health checks every 60 seconds
- Auto-resolution for common issues:
  - Service restarts
  - Cache clearing
  - Log rotation
  - Resource management

**Alert Levels**
- 🚨 CRITICAL: Immediate founder attention (revenue >20% drop, security incidents)
- ⚠️ WARNING: Monitor but no action needed (disk space, worker restarts)
- 📥 INFO: Logged for review (unknown errors, patterns)

---

## 🎯 3. INTERVENTION POINTS

### Go/No-Go Decisions

**When Founder Acts**
- Daily review of GO candidates in morning brief
- For each candidate, decide: `y`, `n`, or `r`
- Decision triggers immediate factory build or pass

**Decision Framework**
```markdown
[y] Build if:
- Emotional score >96%
- Overall score >80
- Build time <4 days
- Clear market opportunity

[n] Pass if:
- Emotional score <96 (fails core thesis)
- Oversaturated market
- Build time too long
- No differentiation

[r] Research more if:
- 50-80 score with potential
- Need competitive analysis
- Market size unclear
```

### Critical Alerts Only

**Immediate Attention (🚨)**
- Revenue drop >20% (hourly comparison)
- App Store rejection
- Security breach detected
- Service down >10 minutes

**No Action Required**
- Worker auto-resolved issues
- Warnings with auto-actions taken
- Information-only updates

### Strategy Pivots

**Monthly Review Points**
- Revenue trends and retention
- Market opportunity shifts
- Competitor moves
- Technology stack evolution

**Quarterly Strategic Reviews**
- New market entry decisions
- Portfolio optimization
- Platform vs. app strategy
- M&A opportunities

---

## ⏱️ 4. TIME BUDGET

### Daily Founder Time
- **Morning Brief Review:** 5 minutes
- **Go/No-Go Decisions:** 5 minutes
- **Total Daily:** 10 minutes maximum

### Weekly Commitment
- **Friday Strategy Review:** 30 minutes
- **Weekly Total:** <1 hour

### Monthly Commitment
- **Sunday Business Review:** 2 hours
- **Monthly Total:** ~3 hours

### Efficiency Metrics
- **Time per Decision:** <30 seconds per candidate
- **Review Speed:** 10-30 candidates in 5 minutes
- **Auto-Resolution Rate:** >80% of issues
- **Alert Signal Ratio:** <5 true alerts/week

---

## 📝 5. EXAMPLE WORKFLOWS

### Example Morning Brief

```
╔════════════════════════════════════════════════════════════════╗
║                    SOLO MORNING BRIEF                          ║
║                     2026-01-29 Thursday                        ║
╚════════════════════════════════════════════════════════════════╝

┌────────────────────────────────────────────────────────────────┐
│ 📊 BUSINESS HEALTH                                             │
├────────────────────────────────────────────────────────────────┤
│  Revenue:    $2,450 MRR         (+12% WoW)                     │
│  Users:      4,280 total        (+89 yesterday)                │
│  Live Apps:  3                  (+1 this week)                  │
│  Conversion: 2.3%               (target: 3%)                    │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ 🎯 MVP CANDIDATES (Ready for Your Review)                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. [GO] AI-Powered Habit Tracker              Score: 92       │
│     Market: $2.4B growing 18% YoY                              │
│     Competition: Moderate (5 major, all guilt-focused)         │
│     Emotional Hook: "Celebrate your streaks"                   │
│     Build Time: 2-3 days                                       │
│     → Select to build? [y/n/r]                                 │
│                                                                │
│  2. [GO] Mood-Based Music Player                 Score: 88     │
│     Market: $12B (Spotify API opportunity)                    │
│     Competition: High but undifferentiated                     │
│     Emotional Hook: "Music that matches your vibe"             │
│     Build Time: 3-4 days                                       │
│     → Select to build? [y/n/r]                                 │
│                                                                │
│  3. [PASS] Generic To-Do App                      Score: 45    │
│     Reason: Oversaturated market, no differentiation           │
│                                                                │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ 🚨 ALERTS (Needs Your Attention)                              │
├────────────────────────────────────────────────────────────────┤
│  🚨 CRITICAL: Revenue dropped 15% (2am-4am spike?)             │
│     → Investigate: PostHog session replay link                │
│                                                                │
│  ⚠️  WARNING: Worker glm4 restarted 3 times                    │
│     → Ops Agent monitoring, may need investigation             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

╔════════════════════════════════════════════════════════════════╗
║  SUMMARY: 15 candidates | 2 GO recommendations | 1 alert      ║
║  Estimated review time: 5 minutes                              ║
╚════════════════════════════════════════════════════════════════╝
```

### Example Decision Session

```bash
# Founder opens morning brief
cat /Users/p/dev/mvps/briefs/today.md

# Reviews candidates and makes decisions
# Candidate 1: AI Habit Tracker
echo "y" | /Users/p/dev/mvps/services/orchestrator/order.sh

# Candidate 2: Mood Music Player  
echo "y" | /Users/p/dev/mvps/services/orchestrator/order.sh

# Candidate 3: To-Do App
echo "n" | /Users/p/dev/mvps/services/orchestrator/order.sh

# Check order status
cat /Users/p/dev/mvps/orders.json

# Output: Orders sent to factory
# Factory starts building immediately
```

---

## 🔧 6. SYSTEM ARCHITECTURE

### Data Flow
```
Signal Sources → Scanner → Queue → Scoring Engine → Scored Candidates → Morning Brief → Founder Decision → Factory Orders
                               ↓
                    Ops Agent (24/7 monitoring)
```

### Key Files
- `/Users/p/dev/mvps/signals/queue.jsonl` - Raw signals
- `/Users/p/dev/mvps/signals/scored.jsonl` - Evaluated candidates
- `/Users/p/dev/mvps/briefs/today.md` - Morning brief
- `/Users/p/dev/mvps/orders.json` - Build orders
- `/Users/p/dev/mvps/STATUS.json` - Build progress

### Services
- Signal Scanner (Alienware)
- Scoring Engine (Alienware)
- Morning Brief (Alienware, 6:00 AM)
- Ops Agent (Alienware, 24/7)
- Orchestrator (Mac)

---

## 📊 7. SUCCESS METRICS

| Metric | Current | Target | How Measured |
|--------|---------|--------|--------------|
| Daily Signals | 10-30 | 15-25 | `wc -l queue.jsonl` |
| Founder Review Time | <5 min | <3 min | Morning brief timing |
| Auto-Resolution Rate | >80% | >90% | Ops Agent logs |
| Time to Decision | <1 day | <4 hours | Signal → GO → Build |
| Revenue Visibility | Real-time | Real-time | Dashboard refresh |
| Emotional Score % | >96% | >96% | Scoring engine |

---

## 🚀 8. EVOLUTION PATH

### Phase 1 (Now)
- Core signal scanning and scoring
- Morning brief and simple decisions
- Basic ops monitoring

### Phase 2 (Next Month)
- Predictive scoring based on history
- Advanced competitor analysis
- Multi-market signal processing

### Phase 3 (Quarter 2)
- Automated MVP builder (no-code/low-code)
- Customer feedback integration
- Advanced predictive alerts

---

## 📞 9. SUPPORT

**Emergency Contact Points**
- Critical alerts: Phone/Push notification
- Service outages: Monitor dashboard
- Build failures: Check Orchestrator logs

**System Status**
- Check all services: `curl http://192.168.68.58:8080/health`
- View metrics: `open http://192.168.68.58:3000`
- Recent alerts: `tail -f /var/log/ops-agent.log`

---

*Last Updated: 2026-01-29*  
*Next Review: 2026-02-29*
