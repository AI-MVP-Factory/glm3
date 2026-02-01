# TRACK 3: App Store Prep - Detailed Brief

**Mission:** Complete 80% of App Store submission requirements before Apple approval
**Model:** GLM-4.7 (Sonnet) via opus-router
**Timeline:** Week 1-4
**Success:** All metadata, legal, and marketing assets ready for 24-hour submission

---

## 🎯 Your Mission in One Sentence

**Prepare everything possible for App Store submission so when approval comes, we ship instantly.**

80% of App Store submission can be done WITHOUT a built app. Do that 80% now.

---

## 📋 What Can Be Done NOW (No App Required)

### ✅ Can Complete (80% of submission)

| Category | Status | Priority |
|----------|--------|----------|
| App Store Connect metadata | ❌ TODO | CRITICAL |
| Privacy policy | ❌ TODO | CRITICAL |
| App Privacy Details mapping | ❌ TODO | HIGH |
| Age rating assessment | ❌ TODO | HIGH |
| Screenshot planning | ❌ TODO | HIGH |
| TestFlight infrastructure | ❌ TODO | MEDIUM |
| Marketing assets | ❌ TODO | MEDIUM |
| Legal documentation | ❌ TODO | HIGH |

### ❌ Must Wait for App (20% of submission)

| Item | Why Wait |
|------|----------|
| Actual screenshots from app | Need built app |
| App icon (1024x1024) | Final design |
| App preview videos | Need app footage |
| Final app store description | May adjust based on final features |

---

## 🚀 Execution Plan (By Category)

### Category 1: App Store Connect Metadata (Week 1, 4 hours)

**For Each MVP (TaskFlow v3, TeenPopTastic, MemeCraftVibe):**

```
1. App Name (30 chars max)
├── TaskFlow v3: "TaskFlow" or "TaskFlow - Celebrate Done"
├── TeenPopTastic: "Vibe" or "TeenPopTastic"
└── MemeCraftVibe: "MemeCraft" or "MemeCraft Vibe"
├── Research: Search App Store to verify not taken
└── Action: Document chosen names

2. Subtitle (30 chars max)
├── Format: "[Key benefit] in [X words]"
├── TaskFlow v3: "The task app that celebrates your wins"
├── TeenPopTastic: "Music that matches your vibe"
└── MemeCraftVibe: "AI memes that actually get laughs"
└── Action: Draft all 3

3. Description (170+ characters)
├── Structure: Hook → Features → Social Proof → CTA
├── Include: Keywords for ASO
├── Action: Draft full descriptions for each app

4. Keywords (100 characters max)
├── Research: Competitor keywords
├── Format: comma-separated, no spaces
├── TaskFlow: tasks,todo,productivity,ai,celebration
├── TeenPopTastic: music,social,teen,vibe,match
└── MemeCraftVibe: meme,ai,generator,funny,viral
└── Action: Finalize keyword lists

5. Support URL & Marketing URL
├── Action: Create/verify domain exists
├── Action: Set up simple landing pages if needed
└── Action: Document URLs

6. Support Email
├── Action: Create dedicated support email
├── Action: Set up forwarding to main inbox
└── Action: Document email
```

**Deliverable:** `/Users/p/dev/mvps/docs/appstore-metadata.md` with all 3 apps' metadata

---

### Category 2: Privacy Policy (Week 1, 4 hours)

**Action:** Create privacy policy template and draft for each app

**Privacy Policy Structure:**
```markdown
# Privacy Policy for [App Name]

**Effective:** [Date]
**Company:** [Your Legal Business Name]

## 1. Information We Collect

### Data You Provide
- Account information (email, name)
- User-generated content (tasks, messages, memes)
- Preferences and settings

### Data Collected Automatically
- Device information (model, OS)
- Usage data (features used, time spent)
- Analytics and crash reports

### Third-Party Data
- Data from APIs (Google OAuth, Spotify, etc.)
- [List all third-party services]

## 2. How We Use Your Information

- Provide and maintain the service
- Send technical notices and updates
- Respond to comments and questions
- Monitor and analyze trends
- Detect, prevent, and address technical issues
- [Add app-specific uses]

## 3. Data Sharing

We do not sell your personal data. We may share:
- With service providers who operate for us
- To comply with legal obligations
- To protect our rights
- [Add app-specific sharing]

## 4. Data Storage and Security

- Data stored in: [Supabase/AWS location]
- Encryption: [In transit and at rest]
- Retention: [Until account deletion]
- Security measures: [List measures]

## 5. Your Rights (GDPR/CCPA)

- Right to access
- Right to deletion
- Right to portability
- Right to opt-out
- Right to withdraw consent

## 6. Children's Privacy

- [For TeenPopTastic: COPPA compliance details]
- [For others: Not directed to children under 13]

## 7. Changes to This Policy

- [Policy on updates and notifications]

## 8. Contact Information

- Privacy inquiries: [email]
- Company address: [physical address]
```

**Deliverables:**
- Privacy policy hosted at a URL (e.g., `yourdomain.com/privacy`)
- App-specific customizations for each of 3 apps

---

### Category 3: App Privacy Details (Week 2, 4 hours)

**Action:** Map all data collection for App Privacy Label

**Data Collection Template:**
```markdown
# App Privacy Details for [App Name]

## Data Used to Track You:
- [ ] Cross-app tracking (none planned)
- [ ] Third-party tracking

## Data Linked to You:
- [ ] Contact Info (email)
- [ ] User Content (tasks, messages, memes)
- [ ] Identifiers (user ID)
- [ ] Usage Data
- [ ] Diagnostics

## Data Not Linked to You:
- [ ] Crash data
- [ ] Performance data
- [ ] Other diagnostics

## Third-Party SDK Data Collection:
- [ ] Supabase: [what they collect]
- [ ] Sentry: [what they collect]
- [ ] PostHog: [what they collect]
- [ ] Paddle/Stripe: [what they collect]
- [ ] Google OAuth: [what they collect]
```

**Deliverable:** `/Users/p/dev/mvps/docs/appstore-privacy-details.md` with all mappings

---

### Category 4: Age Rating (Week 2, 2 hours)

**Action:** Complete age rating assessment for each app

**Age Rating Worksheet:**

| App | Violence | Sexual Content | Gambling | Drugs | Language | User Content | Recommended |
|-----|----------|----------------|----------|-------|----------|--------------|-------------|
| TaskFlow v3 | None | None | None | None | Mild | None | 4+ |
| TeenPopTastic | None | None | None | None | Mild | Yes (moderated) | 13+ |
| MemeCraftVibe | Mild | Mild | None | Mild | Mild | Yes (moderated) | 12+ or 16+ |

**Deliverable:** Age rating justification document for each app

---

### Category 5: Screenshots Planning (Week 2, 4 hours)

**Action:** Create screenshot specifications and templates

**Device Requirements (2026):**
```
iPhone 15 Pro Max: 1290 × 2796 pixels
iPhone 15 Pro: 1290 × 2796 pixels
iPad 13": 2048 × 2732 pixels
Max screenshots: 10 per platform
```

**Screenshot Content Strategy:**

| Screenshot | Content | Text Overlay |
|------------|---------|--------------|
| 1 | Hero/Landing view | App name, tagline |
| 2 | Core feature 1 | Feature description |
| 3 | Core feature 2 | Feature description |
| 4 | Core feature 3 | Feature description |
| 5 | Social proof/celebration | "Join X users" |
| 6-10 | Additional features | Various highlights |

**For Each App:**

**TaskFlow v3:**
1. Dashboard with tasks
2. Kanban board
3. Daily Focus AI
4. Celebration animation
5. Analytics dashboard
6. Dark mode
7. Natural language input
8. Goal tracking
9. Pomodoro timer
10. Pricing/upgrade

**TeenPopTastic:**
1. Profile with music taste
2. Vibe matching interface
3. Chat with music sharing
4. Stories/moments
5. Group features
6. Safety features
7. Premium features
8. Discovery screen
9. Notifications
10. Onboarding

**MemeCraftVibe:**
1. Template gallery
2. AI generation interface
3. Generated meme
4. Sharing interface
5. Saved/favorites
6. Trending templates
7. Editor interface
8. Celebration on share
9. Premium features
10. Community/favorites

**Deliverable:** Screenshot specification document with content planned for each

---

### Category 6: TestFlight Infrastructure (Week 3, 4 hours)

**Action:** Set up beta testing infrastructure

**TestFlight Plan:**

```markdown
# TestFlight Plan for [App Name]

## Internal Testing (Phase 1)
- Duration: 1 week
- Testers: 5-10 (team, friends)
- Focus: Critical bugs, crashes
- Builds: As needed

## External Beta (Phase 2)
- Duration: 2 weeks
- Testers: Up to 10,000
- Focus: UX, feedback, edge cases
- Builds: Weekly

## Test Case Checklist:
- [ ] Sign up/create account
- [ ] Core user flows
- [ ] Payment flow (sandbox)
- [ ] Settings/preferences
- [ ] Push notifications
- [ ] Offline behavior
- [ ] Error states
- [ ] Performance on older devices

## Feedback Collection:
- Method: [Discord/Typeform/TestFlight feedback]
- Frequency: Daily review first week
- Response: Within 24 hours

## Release Notes Template:
### Version X.X (Date)
**What's New:**
- Feature 1
- Feature 2
- Bug fixes

**Known Issues:**
- [List any]

**Testers:**
- Thank [specific contributors]
```

**Deliverable:** TestFlight plan document for each app

---

### Category 7: Marketing Assets (Week 3-4, 8 hours)

**Action:** Create marketing materials

**Asset Checklist:**

| Asset | Specs | Status |
|-------|-------|--------|
| App Icon | 1024×1024 PNG | ⬜ TODO |
| App Icon (all sizes) | iOS auto-scaling | ⬜ TODO |
| Preview Video | 15-30s, 16:9, .mov | ⬜ TODO |
| Promotional Text | 170 chars | ⬜ TODO |
| Social Media Kit | Various sizes | ⬜ TODO |
| Launch Graphics | Blog, email, social | ⬜ TODO |

**Video Storyboard Template:**

```
Scene 1 (0-3s): Hook - Problem statement
Scene 2 (3-8s): Solution - Show app solving it
Scene 3 (8-15s): Key features - Quick montage
Scene 4 (15-25s): Delight - Celebration moment
Scene 5 (25-30s): CTA - Download now, app logo
```

**Deliverable:** Marketing asset templates and specifications

---

## 📊 Success Metrics

| Metric | Target | Timeline |
|--------|--------|----------|
| Metadata complete | 3/3 apps | Week 1 |
| Privacy policies hosted | 3/3 apps | Week 1 |
| Privacy details mapped | 3/3 apps | Week 2 |
| Screenshots planned | All devices × 3 apps | Week 2 |
| TestFlight plans written | 3/3 apps | Week 3 |
| Marketing assets ready | Templates created | Week 4 |

---

## 📚 Reference Documentation

| Resource | Location |
|----------|----------|
| App Store Review Guidelines | https://developer.apple.com/app-store/review/guidelines/ |
| App Store Connect Help | https://developer.apple.com/help/app-store-connect/ |
| App Privacy Details | https://developer.apple.com/app-store/app-privacy-details/ |
| Human Interface Guidelines | https://developer.apple.com/design/human-interface-guidelines/ |

---

## 🔄 Daily Workflow

1. Work through categories in order
2. Create documents as specified
3. Reference competitor apps for inspiration
4. Update STATUS.json with progress
5. Ask for clarification when needed

---

## 🎯 The North Star

> **"When Apple approval email arrives, we submit within 24 hours."**

Every document you create now shaves hours off submission day.

**Go prepare.**
