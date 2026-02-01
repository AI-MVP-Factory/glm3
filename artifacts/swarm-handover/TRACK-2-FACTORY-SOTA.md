# TRACK 2: Factory SOTA - Detailed Brief

**Mission:** Build the AI Factory to State-of-the-Art automation levels
**Model:** GLM-4.7 (Sonnet) via opus-router
**Timeline:** Week 1-4
**Success:** Factory at 70%+ automation, quality gates operational, dashboards live

---

## 🎯 Your Mission in One Sentence

**Build the factory automation so when MVPs are ready, they build themselves.**

Current automation: ~30%. Target: 70%+. This makes iOS development 10x faster.

---

## 📋 Current State Assessment

### What Works
- ORDERS.json structure defined
- STATUS.json exists but manual updates
- Some scripts in `/Users/p/dev/mvps/scripts/`
- Prometheus + Grafana running (underutilized)
- Quality gates defined but not executed

### What's Broken/Missing
- [ ] STATUS.json doesn't auto-update
- [ ] No quality gate execution engine
- [ ] No CI/CD pipeline for MVPs
- [ ] No factory dashboard in Grafana
- [ ] Emotional scoring not automated
- [ ] Templates not audited against SOTA

---

## 🚀 Priority Order (Do This Sequence)

### Priority 1: Fix STATUS.json Auto-Updates (Week 1, 4 hours)

**Location:** `/Users/p/dev/mvps/STATUS.json`

**Problem:** Status is stale, no visibility into progress

**Solution:**
```bash
# 1. Read current STATUS.json structure
cat /Users/p/dev/mvps/STATUS.json

# 2. Create update script at /Users/p/dev/mvps/scripts/update-status.sh
#!/bin/bash
# Updates STATUS.json when features complete

# 3. Hook into feature completion events
# 4. Test: Manually trigger updates
# 5. Verify: STATUS.json reflects reality
```

**Deliverable:** STATUS.json updates automatically on feature completion

---

### Priority 2: Build Quality Gate System (Week 1-2, 16 hours)

**Location:** New file `/Users/p/dev/mvps/scripts/quality-gate.sh`

**5 Quality Gates to Implement:**

| Gate | Check | Command | Threshold |
|------|-------|---------|-----------|
| 1. Console Clean | No console errors | Lighthouse CI | 0 errors |
| 2. Performance | Lighthouse scores | lhci autorun | 90+ all |
| 3. Security | Gitleaks | gitleaks detect | 0 leaks |
| 4. Accessibility | WCAG AA | axe-core | 0 violations |
| 5. Emotional Score | AI assessment | brain query | >96% |

**Implementation:**
```bash
# Create quality gate runner
#!/bin/bash
# Run all 5 gates, fail if any fail

GATE_CONSOLE=0
GATE_PERF=0
GATE_SECURITY=0
GATE_A11Y=0
GATE_EMOTION=0

# Run checks...
# If all pass: exit 0
# If any fail: exit 1 with details
```

**Deliverable:** Working quality gate execution engine

---

### Priority 3: CI/CD Pipeline (Week 2, 12 hours)

**Location:** `.github/workflows/mvp-build.yml` in each MVP repo

**Pipeline Stages:**
```yaml
on: [pull_request, push]

jobs:
  quality-gates:
    - Run lint
    - Run typecheck
    - Run quality gates
    - Fail if any gate fails

  build:
    - Build for target platform
    - Run tests
    - Create artifact

  deploy-staging:
    - Deploy to staging environment
    - Run smoke tests

  deploy-production:
    - Only on merge to main
    - Deploy to production
    - Run health checks
```

**Deliverable:** CI/CD that builds, tests, deploys automatically

---

### Priority 4: Grafana Factory Dashboard (Week 2, 8 hours)

**Location:** Grafana at `http://192.168.68.58:3000`

**Metrics to Display:**

| Panel | Metric | Query |
|-------|--------|-------|
| MVP Progress | Features complete/total | features.json |
| Build Success Rate | Pass/Fail last 10 builds | CI/CD logs |
| Quality Gate Pass Rate | % gates passing | Gate runner logs |
| Brain Growth | Records added over time | Brain API |
| Build Duration | Time per build | CI/CD timing |
| Error Rate | Sentry errors per hour | Sentry API |

**Implementation:**
```bash
# 1. Create Prometheus exporters for factory metrics
# 2. Configure Prometheus to scrape
# 3. Build Grafana dashboard
# 4. Add alerts for critical failures
```

**Deliverable:** Live factory dashboard at http://192.168.68.58:3000/d/factory

---

### Priority 5: Emotional Scoring Automation (Week 3, 16 hours)

**Location:** New skill or script at `/Users/p/dev/mvps/scripts/emotional-score.sh`

**5 Dimensions to Score:**

| Dimension | Weight | Question |
|-----------|--------|----------|
| Warmth | 20% | Does it feel like a caring friend? |
| Empathy | 20% | Does it understand user struggles? |
| Celebration | 20% | Does it celebrate wins? |
| Validation | 20% | Does it validate feelings? |
| Encouragement | 20% | Does it encourage progress? |

**Implementation:**
```bash
# Use Brain API with emotional analysis prompt
# Score each dimension 0-100
# Weighted average = final score
# Threshold: >96 required to ship

SOLO_API_KEY=$(grep SOLO_API_KEY ~/.config/solo/api_key.env | cut -d= -f2)
curl -X POST http://192.168.68.58:8080/query \
  -H "X-API-Key: $SOLO_API_KEY" \
  -d '{"query": "Analyze [MVP] for emotional value across 5 dimensions..."}'
```

**Deliverable:** Automated emotional scorer that outputs 0-100 score

---

### Priority 6: Template Quality Pass (Week 3-4, 12 hours)

**Location:** `/Users/p/dev/AI-factory/templates/`

**Templates to Audit:**

| Template | Check | Fix If Needed |
|----------|-------|---------------|
| MVP scaffold (Next.js) | Modern, type-safe | Update dependencies |
| MVP scaffold (Expo) | Latest Expo SDK | Update to 52+ |
| Auth flow | Supabase best practices | Add error handling |
| Payment | Paddle/Stripe current | Verify integration |
| Error handling | Consistent patterns | Standardize |
| Loading states | Good UX | Add skeletons |
| Dark mode | True black OLED | Implement |
| Emotional design | Celebrations built-in | Add micro-animations |

**Deliverable:** All templates at SOTA quality level

---

## 📊 Success Metrics

| Metric | Current | Target | Timeline |
|--------|---------|--------|----------|
| Automation Level | 30% | 70% | Week 4 |
| Quality Gates | 0/5 | 5/5 | Week 2 |
| CI/CD Coverage | 0% | 100% | Week 2 |
| STATUS.json Accuracy | Manual | Real-time | Week 1 |
| Dashboard Live | No | Yes | Week 2 |

---

## 📚 Reference Documentation

| Document | Location | Purpose |
|----------|----------|---------|
| Factory Architecture | `/Users/p/dev/mvps/docs/FACTORY_ARCHITECTURE.md` | System design |
| Automation Audit | Research output from deep dive | Gap analysis |
| Grafana Docs | http://192.168.68.58:3000 | Dashboard building |
| GitHub Actions | https://docs.github.com/actions | CI/CD reference |

---

## 🔄 Daily Workflow

1. Work on priorities in order
2. Test each automation before moving on
3. Document what you build
4. Update STATUS.json with progress
5. Escalate blockers immediately

---

## 🎯 The North Star

> **"When the factory is done, MVPs build themselves."**

You're not just writing scripts. You're building the machine that builds the products.

**Go build.**
