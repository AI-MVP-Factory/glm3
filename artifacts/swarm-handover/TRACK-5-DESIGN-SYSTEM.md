# TRACK 5: Design System & UI Pre-Build - Detailed Brief

**Mission:** Create the visual language, components, and mockups that make products feel delightful
**Model:** GLM-4.7 (Sonnet) via opus-router
**Timeline:** Week 1-4
**Success:** Complete design system, Figma mockups for all 3 MVPs, screenshot templates ready

---

## 🎯 Your Mission in One Sentence

**Design how the products FEEL before they're built - because feelings are why users stay.**

> *"Products succeed by how they make users FEEL. Not features, but emotions."*

---

## 📋 What You're Building

### The Emotional Design System

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                   EMOTIONAL DESIGN SYSTEM                   │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   COLORS    │  │  TYPOGRAPHY │  │   SPACING   │        │
│  │   (Feel)    │  │   (Voice)   │  │  (Breath)   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ ANIMATIONS  │  │ COMPONENTS  │  │  PATTERNS   │        │
│  │  (Delight)  │  │  (Building) │  │ (Language)  │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Execution Plan (By Category)

### Category 1: Design Tokens Foundation (Week 1, 6 hours)

**Create the atomic design language:**

```
1. Color System (Emotional First)
├── Primary Colors
│   ├── TaskFlow v3: "Productivity Purple" (#8B5CF6) - creative, focused
│   ├── TeenPopTastic: "Vibe Coral" (#F97316) - energetic, warm
│   └── MemeCraftVibe: "Meme Electric" (#22D3EE) - fun, viral
├── Semantic Colors
│   ├── Success: Not just green → "Celebration Gold" (#FBBF24)
│   ├── Error: Not just red → "Gentle Rose" (#FDA4AF)
│   ├── Warning: "Helpful Amber" (#FBBF24)
│   └── Info: "Calm Sky" (#7DD3FC)
├── Neutrals (True Black for OLED)
│   ├── Background: #000000 (pure black for OLED)
│   ├── Surface: #0A0A0A, #141414, #1C1C1C (elevation)
│   ├── Text Primary: #FAFAFA
│   ├── Text Secondary: #A1A1AA
│   └── Text Tertiary: #71717A
└── Documentation: /design/tokens/colors.md

2. Typography System
├── Font Families
│   ├── Display: "SF Pro Display" / "Inter" (bold, personality)
│   ├── Body: "SF Pro Text" / "Inter" (readable, neutral)
│   └── Monospace: "SF Mono" / "JetBrains Mono" (code, data)
├── Type Scale (Major Third for headings)
│   ├── Display: 48px, 40px, 32px
│   ├── Heading: 24px, 20px, 18px
│   ├── Body: 16px, 14px, 12px
│   └── Caption: 11px
├── Font Weights
│   ├── Regular: 400 (body, secondary)
│   ├── Medium: 500 (emphasis, UI text)
│   ├── Semibold: 600 (headings, buttons)
│   └── Bold: 700 (display, celebration)
└── Documentation: /design/tokens/typography.md

3. Spacing System (4px base unit)
├── Scale: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128
├── Usage:
│   ├── xs: 4px (tight spacing)
│   ├── sm: 8px (compact)
│   ├── md: 16px (default)
│   ├── lg: 24px (comfortable)
│   ├── xl: 32px (spacious)
│   └── 2xl: 48px+ (sections)
└── Documentation: /design/tokens/spacing.md

4. Border Radius (Friendly, approachable)
├── sm: 4px (buttons, small cards)
├── md: 8px (cards, inputs)
├── lg: 12px (modals, large cards)
├── xl: 16px (hero elements)
├── full: 9999px (pills, badges)
└── pill: 9999px (completely rounded)

5. Shadows (OLED-optimized, minimal)
├── Use borders and elevation instead of traditional shadows
├── For dark mode: subtle lighter borders for elevation
└── For light mode: 0-4px rgba(0,0,0,0.1) increments
```

**Deliverable:** Complete design token library in code format (CSS variables, Tailwind config)

---

### Category 2: Emotional Component Library (Week 2, 12 hours)

**Components that FEEL good:**

```
1. Celebration Components
├── Confetti Animation
│   ├── Trigger: Task completed, goal reached, milestone
│   ├── Duration: 1.5-2 seconds (not annoying)
│   ├── Style: Colorful but tasteful, physics-based
│   └── Sound: Subtle "pop" or chime (optional)
├── Success Modal
│   ├── Illustration: Friendly character or abstract
│   ├── Message: Personalized ("You crushed it, [Name]!")
│   ├── Action: "Share" or "Keep going"
│   └── Animation: Staggered entrance, warm colors
├── Progress Celebration
│   ├── Milestones: 10%, 25%, 50%, 75%, 100%
│   ├── Each milestone: Micro-celebration
│   ├── Visual: Progress bar pulses, colors warm up
│   └── 100%: Full celebration modal
└── Streak Counter
    ├── Visual: Fire/glow that intensifies
    ├── Animation: Subtle pulse when active
    └── Message: "X days in a row! You're on fire!"

2. Button Components (With Personality)
├── Primary Button
│   ├── Default: Gradient, subtle shimmer
│   ├── Hover: Lift, brighten
│   ├── Press: Scale down 0.98, ripple
│   ├── Loading: Spinner, button text dims
│   └── Success: Checkmark animation, green flash
├── Secondary Button
│   ├── Outlined, transparent background
│   ├── Hover: Fill with primary color at 10%
│   └── Press: Scale down 0.98
└── Destructive Button
    ├── Red gradient (not flat red)
    ├── Hover: Warn with subtle shake
    └── Press: Scale down 0.98

3. Input Components (Encouraging)
├── Text Input
│   ├── Focus: Glow, helper text appears
│   ├── Error: Gentle red, helpful message (not "INVALID")
│   ├── Success: Subtle green checkmark
│   └── Empty: Friendly placeholder "What's on your mind?"
├── Textarea
│   ├── Auto-expand as user types
│   ├── Character count: Encouraging ("Keep going!")
│   └── Focus: Smooth expand animation
└── Select/Dropdown
    ├── Custom styling (not browser default)
    ├── Search/filter in dropdown
    └── Selected: Pill with clear option

4. Card Components (Breathing, alive)
├── Task Card
│   ├── Hover: Lift, subtle glow
│   ├── Drag: Visual feedback (lift, shadow)
│   ├── Completed: Dim, checkmark animation
│   └── Swipe: Actions slide in (delete, snooze, etc.)
├── Profile Card
│   ├── Avatar with ring (color based on activity)
│   ├── Stats with mini-sparklines
│   └── Hover: Expand to show more
└── Notification Card
    ├── Slide in from top/right
    ├── Dismissible with swipe or button
    ├── Action buttons prominent
    └── New items: Pulse glow

5. Loading States (Not boring spinners)
├── Skeleton Screens
│   ├── Shimmer effect (left to right)
│   ├── Approximate actual content shape
│   └── Multiple skeletons pulse at different times
├── Progress Bar
│   ├── Animated fill (not jerky)
│   ├── Percentage text counts up
│   └── Color changes as it progresses
└── Full-page Loading
    ├── Animated illustration
    ├── Encouraging messages ("Almost there...")
    └── Progress indicator
```

**Deliverable:** Component library documented, with examples

---

### Category 3: Figma Mockups for All 3 MVPs (Week 2-3, 16 hours)

**Create actual screens:**

```
1. TaskFlow v3 Screens (15+ screens)
├── Onboarding Flow (4 screens)
│   ├── Welcome: "Get things done, celebrate wins"
│   ├── Value: "AI helps you focus on what matters"
│   ├── First task: "Create your first task"
│   └── Celebration: "Your first win! You're awesome."
├── Main Dashboard (2 states)
│   ├── Empty state: Friendly character, CTA
│   ├── Populated: Tasks, progress, celebration button
├── Kanban Board (1 screen)
│   ├── Columns: Today, Upcoming, Someday
│   ├── Task cards with drag affordance
│   └── Quick add button
├── Task Detail (1 screen)
│   ├── Task info, subtasks, notes
│   ├── AI Focus button prominent
│   └── Complete button (celebration trigger)
├── Settings (1 screen)
│   ├── Profile, preferences, themes
│   ├── Pro upgrade banner
│   └── Celebration settings
├── Analytics (1 screen)
│   ├── Completion trends
│   ├── Streak visualization
│   └── Achievement badges
└── Screenshots for App Store (10 screens)
    ├── Curated best moments
    ├── Feature highlights
    └── Emotional payoff moments

2. TeenPopTastic Screens (12+ screens)
├── Onboarding (3 screens)
│   ├── Vibe check: Select music preferences
│   ├── Permission: Explain why we need music access
│   └── Profile: Create your music identity
├── Vibe Matching (2 screens)
│   ├── Card stack of potential matches
│   ├── Match reveal with celebration
├── Profile (1 screen)
│   ├── Music taste visualization
│   ├── Vibe personality result
│   └── Photos/moments
├── Chat (1 screen)
│   ├── Message thread
│   ├── Music sharing
│   └── Voice note recording
├── Stories (1 screen)
│   ├── Ephemeral moments
│   ├── Music reactions
│   └── Swipe to navigate
└── Safety Features (2 screens)
    ├── Parent verification
    └── Reporting/Blocking

3. MemeCraftVibe Screens (10+ screens)
├── Template Gallery (1 screen)
│   ├── Trending badges
│   ├── Category filters
│   └── Search
├── Editor (1 screen)
│   ├── Template preview
│   ├── AI prompt input
│   ├── Generate button
│   └── Edit/share actions
├── Generated Result (1 screen)
│   ├── Meme display
│   ├── Share sheet prominent
│   ├── Save/favorite
│   └── Regenerate option
├── Saved/Favorites (1 screen)
│   ├── Grid of saved memes
│   ├── Collections/folders
│   └── Quick share
└── Templates with Categories (1 screen)
    ├── Fresh, Trending, Classic
    ├── Vertical scrolling
    └── Preview on tap
```

**Deliverable:** Figma file with all screens, organized by app

---

### Category 4: Screenshot Templates for Track 3 (Week 3, 4 hours)

**Create templates Track 3 can use:**

```
Screenshot Template System:
├── Device Frames
│   ├── iPhone 15 Pro Max (1290×2796)
│   ├── iPhone 15 Pro (1290×2796)
│   ├── iPad 13" (2048×2732)
│   └── Mac (various window sizes)
├── Layout Templates
│   ├── Single screen with caption
│   ├── Two-screen comparison
│   ├── Three-screen feature flow
│   └── Before/after transformation
├── Text Overlay System
│   ├── Headline: Bold, top or bottom
│   ├── Subheading: Explains the benefit
│   ├── Callout: Points to specific feature
│   └── Badge: "NEW", "PRO", etc.
└── Export Specs
    ├── PNG, high quality
    ├── Named: [app]-[screen]-[device]-[locale].png
    └── Organized in: /design/screenshots/
```

**Deliverable:** Screenshot template files Track 3 can populate

---

### Category 5: Animation Library (Week 4, 8 hours)

**Delightful micro-interactions:**

```
1. Entry Animations
├── Fade In + Slide Up (0.3s, ease-out)
├── Stagger List Items (50ms delay each)
├── Scale In (0.2s, bounce)
└── Hero Animation (slow, 0.6s, ease-in-out)

2. Exit Animations
├── Fade Out + Scale Down (0.2s)
├── Slide Out (direction of navigation)
└── Dismiss (swipe away, 0.15s)

3. Interaction Feedback
├── Button Press: Scale 0.98, ripple
├── Card Hover: Lift, shadow increase
├── Toggle Switch: Spring animation
├── Checkbox: Bounce checkmark
└── Radio: Scale selection indicator

4. Celebration Animations
├── Confetti Burst (1.5s, physics-based)
├── Success Checkmark (draw animation, 0.5s)
├── Progress Fill (smooth, 0.3s)
├── Streak Fire (subtle pulse, infinite)
└── Achievement Reveal (slow scale, 0.8s)

5. Loading Animations
├── Skeleton Shimmer (1.5s, infinite)
├── Spinner (rotation, 1s, ease-in-out)
├── Progress Bar (fill, estimate duration)
└── Pulsing Dot (waiting state)
```

**Deliverable:** Lottie files or code snippets for each animation

---

### Category 6: Emotional Design Patterns (Week 4, 6 hours)

**Document the feeling:**

```
Emotional Design Patterns Guide:

1. Warmth Patterns
├── Greeting: Use user's name, friendly hello
├── Empty States: Encouraging, not sad
├── Errors: "Oops! Let's fix this together"
├── Success: Personalized celebration
└── Copy: Conversational, not robotic

2. Empathy Patterns
├── First Run: Acknowledge starting is hard
├── Returning: "Welcome back! Here's where you were"
├── After Break: "No worries, let's jump back in"
├── Struggling: Offer help, don't judge
└── Celebrating: Celebrate effort, not just results

3. Celebration Patterns
├── First Win: Big celebration (sets the tone)
├── Milestone: Recognition, not just notification
├── Streak: Visual intensity that grows
├── Achievement: Badge, animation, share moment
└── Surprise: Random delightful moments

4. Validation Patterns
├── Feelings Acknowledged: "It's okay to feel overwhelmed"
├── Progress Validated: "Look how far you've come"
├── Struggles Normalized: "Everyone has days like this"
└── Choices Affirmed: "Great choice! Here's what's next"

5. Encouragement Patterns
├── Starting: "You've got this!"
├── In Progress: "Keep going, you're doing great"
├── Stuck: "Need help? I'm here for you"
├── Almost There: "So close! One more push"
└── After Setback: "Tomorrow is a fresh start"
```

**Deliverable:** `/design/patterns/emotional-design.md` reference guide

---

## 📊 Success Metrics

| Metric | Target | Timeline |
|--------|--------|----------|
| Design Tokens | 100% defined | Week 1 |
| Component Library | 20+ components documented | Week 2 |
| Figma Mockups | 40+ screens across 3 apps | Week 3 |
| Screenshot Templates | Ready for Track 3 | Week 3 |
| Animation Library | 15+ animations | Week 4 |
| Emotional Patterns Guide | Complete | Week 4 |

---

## 📚 Reference Documentation

| Resource | Purpose |
|----------|---------|
| Figma | https://figma.com (design tool) |
| Lottie | https://lottiefiles.com (animations) |
| Radix UI | https://www.radix-ui.com (component patterns) |
| Tailwind Colors | https://tailwindcss.com/docs/customizing-colors |
| shadcn/ui | https://ui.shadcn.com (component examples) |

---

## 🔄 Daily Workflow

1. **Create** design artifacts (tokens, components, mockups)
2. **Document** decisions and patterns
3. **Sync with Track 3** (provide screenshot templates)
4. **Sync with Track 1** (web app can use components)
5. **Update STATUS.json** with progress

---

## 🎯 The North Star

> **"Users should smile when they use the product."**

Features are what the product DOES. Design is how it FEELS.

**When Track 1 and Track 2 build the products, Track 5 makes them delightful.**

---

**Go design the feelings.** 🎨
