# Screenshot Template System

## Overview

This document provides a comprehensive guide for creating consistent, professional screenshots across all GLM applications. The template system ensures visual consistency and supports marketing, app store, and documentation needs.

---

## 1. Device Frames

### Mobile Devices

| Device | Resolution | Aspect Ratio | Use Case |
|--------|------------|--------------|----------|
| **iPhone 15 Pro Max** | 1290×2796 | 19.5:9 | Primary marketing, app store |
| **iPhone 15 Pro** | 1290×2796 | 19.5:9 | Secondary marketing, documentation |
| **iPad 13"** | 2048×2732 | 4:3 | Feature demonstrations, tutorials |

### Desktop Devices

| Device | Resolution | Use Case |
|--------|------------|----------|
| **MacBook 14"** | 1512×982 | Productivity app context |
| **MacBook 16"** | 1728×1117 | Professional context |
| **iMac 24"** | 1080×1920 | Desktop app showcase |

---

## 2. Layout Templates

### Single Screen with Caption
```
┌─────────────────────────────────────┐
│                                     │
│        [SCREEN CONTENT]             │
│                                     │
├─────────────────────────────────────┤
│      SCREEN TITLE and Caption       │
│          [Optional description]     │
└─────────────────────────────────────┘
```

### Two-Screen Comparison
```
┌──────────────┐  ┌──────────────┐
│              │  │              │
│  SCREEN A    │  │  SCREEN B    │
│              │  │              │
├──────────────┤  ├──────────────┤
│  Version 1   │  │  Version 2   │
└──────────────┘  └──────────────┘
```

### Three-Screen Feature Flow
```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  SCREEN 1    │  │  SCREEN 2    │  │  SCREEN 3    │
│  Step 1      │  │  Step 2      │  │  Step 3      │
│  Initial     │  │  Process     │  │  Complete    │
└──────────────┘  └──────────────┘  └──────────────┘
```

### Before/After Transformation
```
┌──────────────┐  ┌──────────────┐
│              │  │              │
│    BEFORE    │  │    AFTER     │
│     Original │  │  Transformed │
└──────────────┘  └──────────────┘
   [Difference]      [Improvement]
```

---

## 3. Text Overlay System

### Headline
- **Style**: Bold, prominent
- **Position**: Top or bottom center
- **Font**: San Francisco Pro (SF Pro Display)
- **Size**: 28-32pt
- **Color**: White on dark, black on light
- **Example**: "Transform Your Tasks in Minutes"

### Subheading
- **Style**: Regular or Medium weight
- **Position**: Below headline
- **Font**: SF Pro Text
- **Size**: 16-18pt
- **Color**: Slightly muted
- **Example**: "Streamline your workflow with AI-powered automation"

### Callout
- **Style**: Bold with arrow/pointer
- **Position**: Points to specific UI element
- **Font**: SF Pro Display
- **Size**: 14-16pt
- **Color**: High contrast (yellow, red, or white)
- **Example**: "AI Smart Suggestions →"

### Badge
- **Style**: Rounded rectangle with text
- **Position**: Top-right corner
- **Font**: SF Pro Display Bold
- **Size**: 12-14pt
- **Background**: Vibrant color (red, green, blue)
- **Text**: White
- **Examples**: "NEW", "PRO", "BETA", "TOP RATED"

---

## 4. Export Specifications

### File Format
- **Format**: PNG
- **Quality**: Maximum quality (no compression)
- **Color Profile**: sRGB
- **Resolution**: Native device resolution

### Naming Convention
```
[app]-[screen]-[device]-[locale].png
```

Examples:
- `taskflow-home-iphone15-en.png`
- `teenpoptastic-profile-ipad13-es.png`
- `memecraftcreate-mac-us.png`

### File Organization
```
/design/screenshots/
├── taskflow/
│   ├── marketing/
│   ├── appstore/
│   └── documentation/
├── teenpoptastic/
│   ├── marketing/
│   ├── appstore/
│   └── documentation/
└── memecraftvibe/
    ├── marketing/
    ├── appstore/
    └── documentation/
```

---

## 5. Per-App Guidelines

### TaskFlow v3 Screenshot Priorities

1. **Primary Screens** (Required):
   - Home Dashboard
   - Task Creation Flow
   - Calendar View
   - Analytics Dashboard

2. **Feature Showcase**:
   - AI Task Suggestions
   - Team Collaboration
   - Progress Tracking
   - Templates Library

3. **Marketing Angle**:
   - Productivity focus
   - Business/professional context
   - Time-saving features

### TeenPopTastic Screenshot Priorities

1. **Primary Screens** (Required):
   - Profile Creation
   - Video Editor
   - Effects Library
   - Sharing Interface

2. **Feature Showcase**:
   - Trending Filters
   - Music Sync
   - Collaborative Videos
   - Viral Templates

3. **Marketing Angle**:
   - Fun and trendy
   - Social media focus
   - Youth-oriented design

### MemeCraftVibe Screenshot Priorities

1. **Primary Screens** (Required):
   - Meme Creation
   - Template Gallery
   - Text Styling
   - Export Options

2. **Feature Showcase**:
   - AI Meme Suggestions
   - Trending Templates
   - Custom Stickers
   - Social Sharing

3. **Marketing Angle**:
   - Humor and creativity
   - Viral potential
   - Easy-to-use interface

---

## 6. Figma Template Instructions

### Creating New Templates

1. **Device Frame Setup**:
   - Create new frame with specified dimensions
   - Add device mockup layer
   - Position content within safe areas

2. **Text Styles**:
   - Create text styles for headlines, subheadings, and callouts
   - Save in shared styles library
   - Update globally when needed

3. **Color System**:
   - Define brand colors for each app
   - Create color palettes for light/dark modes
   - Ensure accessibility compliance

4. **Component Library**:
   - Create badge, callout, and button components
   - Make them reusable across templates
   - Include all variants (NEW, PRO, etc.)

### Export Settings

1. **Figma Export**:
   - Format: PNG
   - Scale: 1x, 2x, 3x
   - Suffix: `@1x`, `@2x`, `@3x`
   - Export for development: OFF

2. **Optimization**:
   - Dithering: None
   - Compression: None
   - Interlacing: None

### Best Practices

1. **Consistency**:
   - Use the same font weights across all apps
   - Maintain consistent spacing (8pt grid)
   - Keep color schemes recognizable per app

2. **Quality**:
   - Ensure text is crisp and readable
   - Use high-quality mockups
   - Check for artifacts at 100% zoom

3. **Localization**:
   - Create separate templates for RTL languages
   - Consider text length variations
   - Test with different character sets

4. **Accessibility**:
   - Minimum 4.5:1 contrast ratio for text
   - Ensure interactive elements are large enough
   - Avoid color-only information conveyance

---

## 7. Best Practices

### General Guidelines

1. **Clean Backgrounds**:
   - Use solid colors or subtle gradients
   - Avoid cluttered backgrounds
   - Ensure product is the focus

2. **Realistic Content**:
   - Use realistic data and content
   - Avoid placeholder text when possible
   - Show actual app functionality

3. **Consistent Styling**:
   - Follow app design guidelines
   - Maintain visual hierarchy
   - Use proper spacing and alignment

### Lighting and Composition

1. **Consistent Lighting**:
   - Use the same time of day
   - Match lighting with device mockups
   - Avoid harsh shadows or glares

2. **Professional Angles**:
   - Straight-on shots for most screens
   - Slight angles for feature highlights
   - Consistent perspective across all screenshots

3. **Focus Points**:
   - Primary focus should be on key features
   - Secondary elements should support the main message
   - Background elements should not distract

### Text Guidelines

1. **Readability**:
   - Ensure text is large enough to read clearly
   - Use high contrast combinations
   - Avoid text over busy backgrounds

2. **Message Hierarchy**:
   - Lead with the most important information
   - Support with secondary details
   - Keep text concise and impactful

3. **Localization**:
   - Keep text short for translation
   - Avoid cultural idioms
   - Test with native speakers

---

## 8. Example File Names and Content

### TaskFlow Examples

```
taskflow-dashboard-iphone15-en.png
- Home screen with task overview
- Headline: "Your Tasks, Organized"
- Badge: "NEW AI Assistant"

taskflow-team-collab-ipad13-es.png
- Team collaboration view
- Subheading: "Work Together, Better"
- Callout: "Real-time updates →"

taskflow-analytics-mac-en.png
- Analytics dashboard
- Headline: "Track Your Progress"
- No badges needed
```

### TeenPopTastic Examples

```
teenpoptastic-video-editor-iphone15-es.png
- Video editing interface
- Headline: "Create Viral Videos"
- Badge: "PRO"

teenpoptastic-trends-ipad13-en.png
- Trending effects showcase
- Subheading: "Stay on Top"
- Callout: "New this week →"

teenpoptastic-share-mac-es.png
- Social sharing interface
- Headline: "Share & Grow"
- No text overlays needed
```

### MemeCraftVibe Examples

```
memecraftcreate-meme-iphone15-en.png
- Meme creation screen
- Headline: "Make Memes Instantly"
- Badge: "AI Powered"

memecrafttemplates-gallery-ipad13-en.png
- Template gallery
- Subheading: "Trending Now"
- Callout: "New templates daily →"

memecraftexport-mac-es.png
- Export and share options
- Headline: "Go Viral"
- No additional text needed
```

---

## 9. Template Creation Workflow

### Step-by-Step Process

1. **Plan the Screenshot**:
   - Define the purpose and message
   - Choose the appropriate layout template
   - Select the device frame

2. **Prepare Content**:
   - Set up the app screen
   - Position content appropriately
   - Add any necessary text

3. **Add Overlays**:
   - Apply headline and subheading
   - Add badges if needed
   - Include callouts for features

4. **Export and Name**:
   - Export as high-quality PNG
   - Follow naming convention
   - Save in appropriate folder

5. **Review and Update**:
   - Check for consistency
   - Update templates if needed
   - Share with team

### Quality Checklist

- [ ] Device frame is correct and clean
- [ ] Content shows actual app functionality
- [ ] Text overlays are readable and consistent
- [ ] Colors match brand guidelines
- [ ] File name follows convention
- [ ] File is saved in correct location
- [ ] Multiple languages have separate versions
- [ ] Marketing angle is clearly communicated

---

## 10. Maintenance and Updates

### Regular Review Schedule

- **Monthly**: Review all existing screenshots
- **Quarterly**: Update templates with new branding
- **Bi-annually**: Add new device frames as needed
- **Version Updates**: Refresh when app versions change

### Change Log

- **v1.0**: Initial template system (Date)
- **v1.1**: Added MemeCraftVibe guidelines (Date)
- **v1.2**: Updated for new iOS/macOS versions (Date)
- **v2.0**: Complete redesign with new branding (Date)

---

This template system ensures consistency across all GLM applications while allowing for each app's unique personality and marketing needs. Follow these guidelines to create professional, effective screenshots that showcase your apps at their best.