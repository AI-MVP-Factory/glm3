# SPEC 05: Morning Brief Generator
**Priority:** LOW (Nice to have)
**Estimated Effort:** 2 days
**Worker:** glm5 (can pivot after other work)

---

## OBJECTIVE
Build a service that generates a curated morning report for founder review - the "daily newspaper" for the SOLO business.

## DELIVERABLES

### 1. Brief Generator Service
- Location: `/Users/p/dev/mvps/services/morning-brief/`
- Python script scheduled via cron
- Runs at 6:00 AM daily

### 2. Output Formats
- Markdown (for Claude Code / terminal)
- HTML email
- JSON (for dashboard display)

### 3. Data Aggregation
- Pulls from all other services
- Formats for human consumption
- Highlights what matters

## BRIEF STRUCTURE

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
│  4. [RESEARCH] AI Writing Assistant                Score: 76   │
│     Reason: Interesting but needs competitive analysis         │
│                                                                │
│  ... 12 more candidates in queue                               │
│                                                                │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ 🚀 WHAT SHIPPED YESTERDAY                                      │
├────────────────────────────────────────────────────────────────┤
│  • TaskFlow v3.2 deployed (performance fixes)                  │
│  • Habit Tracker app submitted to App Store                   │
│  • Ops Agent resolved 3 issues automatically                   │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ ⚠️ ALERTS (Needs Your Attention)                              │
├────────────────────────────────────────────────────────────────┤
│  🚨 CRITICAL: Revenue dropped 15% (2am-4am spike?)             │
│     → Investigate: PostHog session replay link                │
│                                                                │
│  ⚠️  WARNING: Worker glm4 restarted 3 times                    │
│     → Ops Agent monitoring, may need investigation             │
│                                                                │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ ✅ OPS HEALTH                                                  │
├────────────────────────────────────────────────────────────────┤
│  Brain API:      🟢 UP (45ms response)                        │
│  Workers (7):    🟢🟢🟢🟢🟢🟢🟢 All online                      │
│  LiteLLM:        🟢 UP (87% cost savings)                     │
│  Disk Space:     🟡 87% (warning threshold 90%)                │
│  Uptime:         99.7% (30 days)                              │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│ 💡 INSIGHT FROM YESTERDAY                                     │
├────────────────────────────────────────────────────────────────┤
│  Users who complete the onboarding flow convert 4x better.    │
│  → Consider adding progress indicator to onboarding.          │
└────────────────────────────────────────────────────────────────┘

╔════════════════════════════════════════════════════════════════╗
║  SUMMARY: 15 candidates | 2 GO recommendations | 1 alert      ║
║  Estimated review time: 5 minutes                              ║
╚════════════════════════════════════════════════════════════════╝
```

## DATA SOURCES

| Section | Source |
|---------|--------|
| Business Health | RevenueCat API, PostHog |
| MVP Candidates | `/Users/p/dev/mvps/signals/scored.jsonl` |
| What Shipped | `/Users/p/dev/mvps/STATUS.json` |
| Alerts | Ops Agent logs |
| Ops Health | Prometheus metrics |
| Insights | Brain `/insights` endpoint |

## ARCHITECTURE

```python
# morning-brief/generator.py
class MorningBrief:
    def generate_business_health() -> Section
        # Revenue, users, conversion

    def generate_candidates() -> Section
        # Top candidates, sorted by score
        # Filter: score > 80 = GO, 50-80 = RESEARCH, <50 = PASS

    def generate_shipped() -> Section
        # What completed yesterday
        # STATUS.json diff

    def generate_alerts() -> Section
        # Ops Agent escalations
        # Filter: only unresolved

    def generate_ops_health() -> Section
        # Service status from Prometheus

    def generate_insight() -> Section
        # Query Brain for interesting pattern

    def assemble() -> Brief
        # Combine all sections
        # Format: Markdown, HTML, JSON
```

## DELIVERY METHODS

| Method | Implementation |
|--------|----------------|
| **Terminal** | `cat /Users/p/dev/mvps/briefs/today.md` |
| **Email** | Sendgrid/Mailgun at 6:00 AM |
| **Slack** | Slack webhook message |
| **Dashboard** | API endpoint on Grafana |

## SCHEDULING

```cron
# Cron job on Alienware
0 6 * * * cd /Users/p/dev/mvps/services/morning-brief && python3 generate.py
```

## ACCEPTANCE CRITERIA
- [ ] Generates brief by 6:00 AM daily
- [ ] All data sources integrated
- [ ] GO/PASS/RESEARCH verdicts clear
- [ ] Alerts actionable with links
- [ ] Review time <5 minutes
- [ ] Available in 2+ formats

## OUTPUT
Service code in: `/Users/p/dev/mvps/services/morning-brief/`
Sample brief generated
Scheduled cron job
Email/slack integration (optional)

## BONUS
- Add "reply to build" feature (email y/n/r to build)
- Add historical trends (7-day, 30-day)
- Add competitor watch section
