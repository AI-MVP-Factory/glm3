# TRACK 1: Web Ship Now - Detailed Brief

**Mission:** Deploy TaskFlow v3 Web App to production, generate immediate revenue
**Model:** GLM-4.7 (Sonnet) via opus-router
**Timeline:** Week 1-2 (Priority: IMMEDIATE)
**Success:** $500-2,000 MRR from web users while waiting for Apple approval

---

## 🎯 Your Mission in One Sentence

**Deploy the TaskFlow v3 web application to production and start generating revenue THIS WEEK.**

This is the ONLY track that can produce immediate revenue. Web deployment requires NO Apple approval.

---

## 📋 Current State Assessment

### What's Already Built (17/17 Features) ✅

| Feature | Status | Location |
|---------|--------|----------|
| Next.js + Supabase architecture | ✅ Complete | `/Users/p/dev/mvps/taskflow-v3/web/` |
| Task CRUD with all fields | ✅ Complete | `app/tasks/` |
| Natural language input | ✅ Complete | `app/nlp/` |
| Kanban board drag-drop | ✅ Complete | `app/kanban/` |
| AI Daily Focus | ✅ Complete | `app/focus/` |
| Pomodoro timer | ✅ Complete | `app/pomodoro/` |
| Goal tracking | ✅ Complete | `app/goals/` |
| Google OAuth | ✅ Complete | `app/auth/` |
| PWA support | ✅ Complete | `public/sw.js` |
| Dark mode | ✅ Complete | Tailwind config |
| Keyboard shortcuts | ✅ Complete | `app/shortcuts/` |
| Landing pages | ✅ Complete | `app/(landing)/` |
| Payment integration (Paddle) | ✅ Configured | `.env.local` |
| Monitoring (Sentry) | ✅ Configured | `sentry.*.js` |
| Analytics (PostHog) | ✅ Configured | `app/posthog/` |

### What Needs to Be Done

| Task | Status | Priority |
|------|--------|----------|
| Deploy to Vercel production | ❌ TODO | CRITICAL |
| Configure custom domain | ❌ TODO | CRITICAL |
| Enable Paddle live mode | ❌ TODO | CRITICAL |
| Test payment flow end-to-end | ❌ TODO | CRITICAL |
| Create launch waitlist | ❌ TODO | HIGH |
| Set up error monitoring | ❌ TODO | HIGH |
| Configure production analytics | ❌ TODO | HIGH |
| Test all user flows | ❌ TODO | HIGH |

---

## 🚀 Step-by-Step Execution Plan

### Phase 1: Deploy to Vercel (Day 1 - 4 hours)

```
Step 1: Verify Vercel Project Configuration
├── Navigate to: /Users/p/dev/mvps/taskflow-v3/web
├── Check: .vercel/project.json exists and is valid
├── Verify: GitHub repo is linked to Vercel
└── Action: Link if not already connected

Step 2: Configure Production Environment Variables
├── Go to: Vercel Dashboard → Project → Settings → Environment Variables
├── Required variables (check .env.local for reference):
│   ├── NEXT_PUBLIC_SUPABASE_URL
│   ├── NEXT_PUBLIC_SUPABASE_ANON_KEY
│   ├── SUPABASE_SERVICE_ROLE_KEY
│   ├── NEXT_PUBLIC_PADDLE_VENDOR_ID
│   ├── NEXT_PUBLIC_PADDLE_VENDOR_AUTH_CODE
│   ├── NEXT_PUBLIC_APP_URL (will be production URL)
│   ├── SENTRY_DSN
│   └── NEXT_PUBLIC_POSTHOG_KEY
└── Action: Add all variables to Vercel production environment

Step 3: Deploy to Production
├── Command: vercel --prod
├── Or: Push to main branch (if auto-deploy is configured)
├── Verify: Deployment succeeds, no errors
└── Output: Production URL (e.g., taskflow-v3.vercel.app)

Step 4: Test Production Deployment
├── Visit: Production URL
├── Test: All key user flows
│   ├── Landing page loads
│   ├── Sign in with Google works
│   ├── Create task works
│   ├── Kanban board functions
│   └── Settings page accessible
└── Action: Fix any issues found

Step 5: Configure Custom Domain
├── Options:
│   ├── Use existing domain if available
│   └── Register new domain (taskflow.app or similar)
├── Vercel: Settings → Domains → Add Domain
├── DNS: Configure DNS records (A or CNAME)
└── Verify: Domain SSL certificate issues
```

### Phase 2: Enable Payments (Day 1-2 - 4 hours)

```
Step 1: Configure Paddle for Production
├── Navigate to: Paddle Dashboard
├── Verify: Vendor account is active
├── Get: Production API keys
├── Update: Vercel environment variables with production keys
└── Test: Payment flow in production

Step 2: Test Payment Flow End-to-End
├── Create test account
├── Initiate checkout
├── Complete payment (test mode first)
├── Verify: Pro features unlock
├── Verify: Webhook receives payment confirmation
├── Verify: Database updates user subscription
└── Switch: To live mode when confident

Step 3: Configure Pricing Display
├── Verify: Pricing page shows correct amounts
│   ├── Free tier: $0
│   ├── Pro monthly: $4.99/mo
│   └── Pro yearly: $39.99/yr (save ~33%)
├── Check: Currency is correct (USD)
└── Test: Upgrade/downgrade flows
```

### Phase 3: Monitoring & Analytics (Day 2 - 2 hours)

```
Step 1: Configure Sentry for Production
├── Verify: Sentry DSN is correct
├── Test: Trigger test error to verify capturing
├── Configure: Error alerts (email/slack)
└── Set up: Release tracking

Step 2: Configure PostHog Analytics
├── Verify: PostHog project key
├── Configure: Key events to track
│   ├── User signup
│   ├── Task created
│   ├── Task completed (celebration moment!)
│   ├── Pro upgrade initiated
│   └── Pro upgrade completed
├── Create: Dashboard for key metrics
└── Set up: Funnels for conversion tracking
```

### Phase 4: Launch Preparation (Day 3-4 - 8 hours)

```
Step 1: Create Waitlist/Launch Page
├── If not exists: Create beautiful landing page
├── Include:
│   ├── Clear value proposition
│   ├── Email capture for "iOS coming soon" list
│   ├── Screenshots/video demo
│   ├── Pricing display
│   └── CTA: "Start free" or "Get notified for iOS"
├── Tools to consider:
│   ├── Waitlist software (getwaitlist.com)
│   └── Or simple Supabase form
└── Action: Deploy and test

Step 2: Create Onboarding Flow
├── First-run experience for new users
├── Steps:
│   1. Welcome screen (emotional connection)
│   2. Create first task (quick win)
│   3. Experience celebration (hook them)
│   4. Set up Daily Focus (AI value)
│   5. Optional: Upgrade prompt (at celebration moment)
├── Principle: "Make them FEEL productive in 60 seconds"
└── Test: Full flow yourself

Step 3: Prepare Launch Announcement
├── Create: Launch copy for various channels
│   ├── Product Hunt
│   ├── Twitter/X
│   ├── Reddit (r/productivity, r/SideProject)
│   ├── Hacker News (Show HN)
│   └── LinkedIn
├── Draft: Short, medium, long versions
├── Include: Screenshots, demo video link
└── Prepare: Responses to common questions
```

### Phase 5: Soft Launch (Day 5-7 - 4 hours)

```
Step 1: Beta User Onboarding
├── Invite: 20-50 beta users (friends, communities)
├── Provide: Feedback mechanism (Typeform, Discord, etc.)
├── Monitor: Error rates, user behavior
├── Fix: Critical bugs immediately
└── Gather: testimonials for launch

Step 2: Public Launch
├── Choose: Launch day (weekday morning)
├── Execute: Launch across all channels
├── Monitor: Metrics real-time
├── Respond: To every comment/question
└── Celebrate: The wins (ship day!)
```

---

## 📊 Success Metrics

### Week 1 Targets

| Metric | Target | Why It Matters |
|--------|--------|----------------|
| Unique visitors | 500+ | Traffic generation |
| Signups | 100+ | Interest validation |
| Active users (day 7) | 50+ | Retention signal |
| Pro conversions | 5+ | Revenue validation |
| MRR | $50+ | Revenue exists! |

### Week 4 Targets

| Metric | Target | Why It Matters |
|--------|--------|----------------|
| Unique visitors | 2,000+ | Growth trajectory |
| Active users | 500+ | User base formed |
| Pro conversions | 25+ | Revenue scaling |
| MRR | $500+ | Meaningful revenue |
| iOS waitlist | 200+ | Pre-selling mobile |

---

## 🚨 Known Blockers & Solutions

| Blocker | Solution | Contact |
|---------|----------|---------|
| Vercel deployment fails | Check logs, verify env vars | Coordinator |
| Payment testing fails | Use Paddle sandbox first | Paddle support |
| Custom domain DNS issues | Vercel DNS guide, 24-48h propagation | Registrar |
| High error rate | Check Sentry, fix immediately | Coordinator |
| Low conversion | Review onboarding, pricing | Marketing expertise |

---

## 📚 Reference Documentation

| Document | Location | Purpose |
|----------|----------|---------|
| TaskFlow v3 Spec | `/Users/p/dev/mvps/specs/taskflow-v3.md` | Feature reference |
| Web Strategy | `strategy/apple-waiting-period-strategy.md` | Web-first rationale |
| Vercel Docs | https://vercel.com/docs | Deployment reference |
| Paddle Docs | https://developer.paddle.com | Payment integration |
| Supabase Docs | https://supabase.com/docs | Database/auth |

---

## 🔄 Daily Workflow

### Morning (15 min):
1. Check Sentry for overnight errors
2. Check PostHog for yesterday's metrics
3. Review user feedback
4. Plan today's improvements

### During Day:
1. Fix critical bugs immediately
2. Implement user-requested features (priority by impact)
3. Monitor performance metrics
4. Respond to user inquiries

### Evening (15 min):
1. Update STATUS.json with progress
2. Document learnings for Brain
3. Plan tomorrow's priorities

---

## 🎬 Getting Started

1. **Read this entire document** (you are here)
2. **Navigate to project**: `cd /Users/p/dev/mvps/taskflow-v3/web`
3. **Verify current state**: Check what's deployed
4. **Create task list** from Phase 1 above
5. **Start with**: Vercel production deployment

---

## 💡 Pro Tips

1. **Test everything in staging first** - Production surprises are expensive
2. **Monitor errors constantly** - First week is critical for user retention
3. **Celebrate the wins** - First paying customer is HUGE
4. **Talk to users** - Every piece of feedback is gold
5. **Ship small improvements daily** - Better than weekly big releases

---

## 🎯 The North Star

> **"Generate real revenue from real users while waiting for Apple."**

This isn't just a web app. It's:
- **Revenue validation** of the product thesis
- **User feedback** to improve the iOS version
- **Marketing engine** for the App Store launch
- **Confidence builder** that people will pay

**Your work makes the iOS launch 10x more likely to succeed.**

---

**Go ship. The world is waiting.** 🚀
