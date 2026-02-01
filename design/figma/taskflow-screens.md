# TaskFlow MVP - Figma Screen Documentation

## Overview
TaskFlow is a productivity app that combines gamification with task management to create an engaging user experience. This document outlines all screens for the Figma design handoff.

---

## 1. Onboarding Flow

### Screen 1: Welcome
**Purpose:** First impression and brand introduction
**Layout:**
- Full-screen hero illustration showing productivity/achievement theme
- App logo and name "TaskFlow" prominently displayed
- Tagline: "Gamify Your Productivity"
- Primary CTA: "Get Started" (large, prominent button)
- Secondary option: "Sign In" (for returning users)

**Design Notes:**
- Clean, modern aesthetic with gradient background
- Illustration should convey energy and accomplishment
- Typography: Bold headline, friendly subtitle
- Color scheme: Primary blue (#3B82F6) with accent orange (#F97316)

### Screen 2: Value Proposition
**Purpose:** Explain core benefits and user value
**Layout:**
- Icon + text for 3 key benefits:
  1. "Gamified Tasks" - Icon of game controller
  2. "Progress Tracking" - Icon of chart/graph
  3. "Reward System" - Icon of trophy
- Brief description below each benefit
- "Continue" button at bottom

**Design Notes:**
- Use flat icons with slight depth
- Benefit cards with subtle shadows
- Progress indicator at top showing step 2/4
- Consistent color scheme with previous screen

### Screen 3: First Task Setup
**Purpose:** Guide user through creating their first task
**Layout:**
- Input field for task title with placeholder "What needs to get done?"
- Category selector (Work, Personal, Health, Learning)
- Priority slider (Low to High)
- Due date toggle with calendar picker
- "Create Task" CTA button

**Design Notes:**
- Focus on the input field
- Category pills with color coding
- Smooth animations for interactions
- Friendly mascot character providing encouragement

### Screen 4: Celebration
**Purpose:** Reward user for completing onboarding
**Layout:**
- Animated confetti/celebration graphic
- "Welcome to TaskFlow!" headline
- "Your first task is ready!" message
- Preview of the task created
- "Start Using TaskFlow" CTA
- Optional "Skip Tutorial" link

**Design Notes:**
- Celebratory tone with bright colors
- Playful animations
- Mascot character celebrating
- Reward unlocked badge display

---

## 2. Main Dashboard

### State 1: Empty State
**Purpose:** Welcome new users to their dashboard
**Layout:**
- Central illustration showing an empty productivity space
- Headline: "Your TaskFlow Awaits"
- Subtitle: "Create your first task to get started"
- 3 floating action buttons:
  1. "Quick Add Task"
  2. "View Templates"
  3. "Take a Tour"

**Design Notes:**
- Clean, minimalist aesthetic
- Subtle gradient background
- Floating buttons with shadows
- Illustration should be inviting and encouraging

### State 2: Populated State
**Purpose:** Show active tasks and user progress
**Layout:**
- Header with user avatar, greeting, and stats
- Today's date prominently displayed
- Progress ring showing daily completion percentage
- Task cards organized by priority:
  - High priority (top, red accent)
  - Medium priority (middle, yellow accent)
  - Low priority (bottom, green accent)
- Each task card shows:
  - Checkbox (unchecked)
  - Task title
  - Category tag
  - Due time (if applicable)
  - Priority indicator
- Floating action button (FAB) for quick task creation
- Bottom navigation bar

**Design Notes:**
- Card-based layout with subtle shadows
- Color-coded priority system
- Smooth transitions when checking tasks
- Progress visualization rings
- Consistent spacing and hierarchy

---

## 3. Kanban Board

**Purpose:** Visual task management with drag-and-drop
**Layout:**
- Header with board title and filter options
- 3 columns: To Do, In Progress, Done
- Column headers with:
  - Column title
  - Task count badge
  - Add task button
- Task cards within columns with:
  - Task title
  - Priority indicator (color-coded)
  - Category tag
  - Assignee avatar (if applicable)
  - Due date
- Drag handles on task cards
- Column headers show completion percentage

**Design Notes:**
- Clean column-based layout
- Task cards with subtle elevation
- Drag-and-drop visual feedback
- Column progress bars
- Category color coding consistent across app
- Touch-friendly for mobile

---

## 4. Task Detail

**Purpose:** Detailed view and editing of individual tasks
**Layout:**
- Header with back button and edit option
- Task title (editable)
- Status dropdown (To Do, In Progress, Done)
- Priority selector with visual indicators
- Category selection
- Description field (expandable)
- Due date and time picker
- Checklist subtasks
- Attachments section
- Comments/Notes area
- Delete button at bottom

**Design Notes:**
- Clean, organized layout
- Form elements with clear labels
- Expandable sections for complex information
- Priority visual hierarchy
- Smooth animations for state changes
- Mobile-optimized scrolling

---

## 5. Settings

**Purpose:** User preferences and app configuration
**Layout:**
- Header with "Settings" title
- Profile section:
  - User avatar
  - Name
  - Email
  - Edit profile button
- Preferences sections:
  - Notifications toggle
  - Theme selection (Light/Dark/System)
  - Sound effects toggle
  - Haptic feedback toggle
- Data & Privacy:
  - Export data option
  - Delete account option
  - Privacy policy link
- About:
  - App version
  - Terms of service link

**Design Notes:**
- Clear section organization
- Toggle switches with smooth animations
- Consistent typography hierarchy
- Safe spacing for touch targets
- Grouped related settings together

---

## 6. Analytics

**Purpose:** Visualize productivity trends and insights
**Layout:**
- Header with time period selector (Day/Week/Month/Year)
- Key metrics cards:
  - Tasks completed
  - Average completion rate
  - Streak days
  - Productivity score
- Charts section:
  - Daily completion bar chart
  - Category breakdown pie chart
  - Weekly trend line chart
- Insights section:
  - "Your most productive day is Tuesday"
  - "You complete 80% of work tasks on time"
  - "Trending: Health tasks increased 20%"

**Design Notes:**
- Data visualization focus
- Clean chart design with clear labels
- Color-coded categories
- Actionable insights with icons
- Responsive chart sizing
- Smooth transitions between time periods

---

## 7. App Store Screenshots

### Screen 1: Hero Shot
- App logo prominently displayed
- Main dashboard with task completion animation
- Tagline: "Gamify Your Productivity"
- App Store badges (iOS/Android)

### Screen 2: Task Creation
- Focus on task creation interface
- Show form elements and category selection
- Floating action button visible
- Clean, modern UI aesthetic

### Screen 3: Progress Tracking
- Analytics dashboard with charts
- Progress rings and statistics
- Achievement badges displayed
- Professional data visualization

### Screen 4: Kanban Board
- Drag-and-drop interface in action
- Multiple task cards in different columns
- Visual feedback for user interaction
- Organized workspace view

### Screen 5: Team Collaboration
- Multiple user avatars
- Shared task board
- Comment threads visible
- Real-time collaboration indicators

### Screen 6: Rewards & Achievements
- Achievement badges showcase
- Level progression display
- Reward animations
- Celebration effects

### Screen 7: Customization
- Theme selection interface
- Profile customization options
- Notification settings
- Personalization features

### Screen 8: Productivity Insights
- Advanced analytics charts
- Detailed breakdowns
- Productivity trends
- Actionable recommendations

### Screen 9: Integration Showcase
- Calendar sync visualization
- Third-party app logos
- Connected services display
- Workflow automation

### Screen 10: Final CTA
- Download button prominently featured
- "Join thousands of productive users"
- Social proof statistics
- App store links

---

## Design Specifications

### Color Palette
- Primary: #3B82F6 (Blue)
- Secondary: #F97316 (Orange)
- Success: #10B981 (Green)
- Warning: #F59E0B (Yellow)
- Danger: #EF4444 (Red)
- Neutral: #6B7280 (Gray)
- Background: #F9FAFB (Light gray)
- Text: #111827 (Dark gray)

### Typography
- Headings: Inter, Bold, 24px
- Subheadings: Inter, SemiBold, 18px
- Body: Inter, Regular, 16px
- Small text: Inter, Regular, 14px
- Labels: Inter, Medium, 12px

### Spacing
- Unit: 8px (base)
- Padding: 16px, 24px, 32px
- Margin: 8px, 16px, 24px, 32px
- Component spacing: 16px
- Card elevation: 4px

### Iconography
- Style: Linear, consistent weight
- Size: 20px (standard), 24px (large)
- Color: Inherit or primary brand color
- States: Default, hover, active, disabled

### Animation
- Duration: 200-300ms
- Easing: Cubic-bezier(0.4, 0, 0.2, 1)
- Micro-interactions on all interactive elements
- Staggered animations for lists
- Smooth transitions between states

### Accessibility
- Contrast ratio: 4.5:1 minimum
- Touch targets: 44px minimum
- Focus indicators: Visible and clear
- Screen reader friendly markup
- Dynamic text resizing support