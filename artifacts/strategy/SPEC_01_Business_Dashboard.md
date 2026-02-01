# SPEC 01: Business Dashboard
**Priority:** CRITICAL
**Estimated Effort:** 3 days
**Worker:** glm2 (formerly Oracle - ready to pivot)

---

## OBJECTIVE
Build a Grafana dashboard showing the SOLO business at a glance - revenue, users, funnel, operations.

## DELIVERABLES

### 1. Grafana Dashboard JSON
- File: `/Users/p/dev/mvps/dashboards/business-overview.json`
- Import into Grafana (Alienware :3000)

### 2. Data Source Setup
- Prometheus queries for operational metrics
- Custom API connectors for:
  - RevenueCat (revenue data)
  - PostHog (analytics)
  - Factory STATUS.json (build pipeline)

## PANELS REQUIRED

### Row 1: Business Health (Top KPIs)
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  MRR Revenue│  Total Users│  Live Apps  │  Alerts     │
│    $2,450   │    4,280    │      3      │      0      │
│   +12% WoW  │    +89      │      +1     │      0      │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

### Row 2: Revenue Trend
- Line chart: Daily revenue (last 30 days)
- Breakdown by app (stacked)
- Target: $1,000 MRR per app

### Row 3: Funnel Metrics
```
Candidates Scanned → Scored → Selected → Building → Live
     150              87        5           3          3
```

### Row 4: Operational Health
- Worker status (7 workers, show online/offline)
- Brain API response time
- Error rate (last 24h)
- Service uptime %

### Row 5: Recent Activity
- Last 5 builds shipped
- Last 5 ops issues (resolved)
- Last 5 user feedback items

## DATA SOURCES

| Metric | Source | Query/API |
|--------|--------|-----------|
| Revenue | RevenueCat | `GET /v1/1/subscriptions` |
| Users | PostHog | `GET /api/projects/@current/insights/trend` |
| Funnel | Factory | `cat /Users/p/dev/mvps/STATUS.json` |
| Worker Health | Prometheus | `up{job="workers"}` |
| Brain Health | Prometheus | `up{job="brain-api"}` |

## ACCEPTANCE CRITERIA
- [ ] Dashboard loads in <2 seconds
- [ ] All panels show real data (no mock data)
- [ ] Auto-refresh every 30 seconds
- [ ] Mobile-responsive
- [ ] Alert thresholds configured (email on revenue drop >20%)

## OUTPUT
Commit dashboard JSON to: `/Users/p/dev/mvps/dashboards/`
Import Grafana dashboard on Alienware
Test with real data
