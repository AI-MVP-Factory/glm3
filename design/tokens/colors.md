# Color System

> **Emotional Branding + OLED-Optimized Design**

A curated color system designed for emotional impact and OLED performance.

---

## Primary Colors (Emotional Branding)

Each product has a unique personality expressed through its primary color.

### TaskFlow v3
- **Name:** Productivity Purple
- **Hex:** `#8B5CF6`
- **Role:** Main brand color, CTAs, highlights
- **Emotion:** Creative, focused, productive
- **Usage:** Primary buttons, active states, brand accents

### TeenPopTastic
- **Name:** Vibe Coral
- **Hex:** `#F97316`
- **Role:** Main brand color, CTAs, highlights
- **Emotion:** Energetic, warm, youthful
- **Usage:** Primary buttons, active states, brand accents

### MemeCraftVibe
- **Name:** Meme Electric
- **Hex:** `#22D3EE`
- **Role:** Main brand color, CTAs, highlights
- **Emotion:** Fun, viral, playful
- **Usage:** Primary buttons, active states, brand accents

---

## Semantic Colors

Meaningful colors that communicate purpose without being boring defaults.

### Success
- **Name:** Celebration Gold
- **Hex:** `#FBBF24`
- **Usage:** Success messages, positive feedback, completed states
- **Token:** `--color-success`

### Error
- **Name:** Gentle Rose
- **Hex:** `#FDA4AF`
- **Usage:** Error messages, validation failures, destructive actions
- **Token:** `--color-error`

### Warning
- **Name:** Helpful Amber
- **Hex:** `#FBBF24`
- **Usage:** Warnings, cautionary messages, pending states
- **Token:** `--color-warning`

### Info
- **Name:** Calm Sky
- **Hex:** `#7DD3FC`
- **Usage:** Informational messages, hints, neutral feedback
- **Token:** `--color-info`

---

## Neutrals (OLED-Optimized)

True black background with subtle elevation hierarchy for OLED screens.

### Background
- **Background:** `#000000` (True Black)
- **Surface 1:** `#0A0A0A` (10% white)
- **Surface 2:** `#141414` (8% white)
- **Surface 3:** `#1C1C1C` (11% white)

### Text
- **Text Primary:** `#FAFAFA` (98% white)
- **Text Secondary:** `#A1A1AA` (63% white)
- **Text Tertiary:** `#71717A` (44% white)

### Borders
- **Border Default:** `#27272A` (15% white)
- **Border Strong:** `#3F3F46` (25% white)

---

## CSS Variables

### :root Variables

```css
:root {
  /* ===== Primary Colors ===== */
  --color-primary: #8B5CF6;
  --color-primary-light: #A78BFA;
  --color-primary-dark: #7C3AED;

  /* ===== Semantic Colors ===== */
  --color-success: #FBBF24;
  --color-error: #FDA4AF;
  --color-warning: #FBBF24;
  --color-info: #7DD3FC;

  /* ===== Neutrals ===== */
  --color-bg: #000000;
  --color-surface-1: #0A0A0A;
  --color-surface-2: #141414;
  --color-surface-3: #1C1C1C;

  --color-text-primary: #FAFAFA;
  --color-text-secondary: #A1A1AA;
  --color-text-tertiary: #71717A;

  --color-border-default: #27272A;
  --color-border-strong: #3F3F46;
}

[data-theme="light"] {
  --color-bg: #FFFFFF;
  --color-surface-1: #F9FAFB;
  --color-surface-2: #F3F4F6;
  --color-surface-3: #E5E7EB;

  --color-text-primary: #111827;
  --color-text-secondary: #6B7280;
  --color-text-tertiary: #9CA3AF;

  --color-border-default: #E5E7EB;
  --color-border-strong: #D1D5DB;
}
```

### Product-Specific Variants

```css
/* TeenPopTastic Theme */
[data-brand="teenpop"] {
  --color-primary: #F97316;
  --color-primary-light: #FB923C;
  --color-primary-dark: #EA580C;
}

/* MemeCraftVibe Theme */
[data-brand="memecraft"] {
  --color-primary: #22D3EE;
  --color-primary-light: #67E8F9;
  --color-primary-dark: #06B6D4;
}
```

---

## Tailwind Config Extension

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Primary Colors
        primary: {
          50: '#F5F3FF',
          100: '#EDE9FE',
          200: '#DDD6FE',
          300: '#C4B5FD',
          400: '#A78BFA',
          500: '#8B5CF6',
          600: '#7C3AED',
          700: '#6D28D9',
          800: '#5B21B6',
          900: '#4C1D95',
        },

        // Semantic Colors
        success: '#FBBF24',
        error: '#FDA4AF',
        warning: '#FBBF24',
        info: '#7DD3FC',

        // Neutrals
        bg: '#000000',
        surface: {
          1: '#0A0A0A',
          2: '#141414',
          3: '#1C1C1C',
        },

        text: {
          primary: '#FAFAFA',
          secondary: '#A1A1AA',
          tertiary: '#71717A',
        },

        border: {
          default: '#27272A',
          strong: '#3F3F46',
        },
      },
    },
  },
}
```

---

## Usage Guidelines

### Buttons

```css
/* Primary Button */
.btn-primary {
  background-color: var(--color-primary);
  color: var(--color-text-primary);
}

/* Primary Button Hover */
.btn-primary:hover {
  background-color: var(--color-primary-dark);
}

/* Success Button */
.btn-success {
  background-color: var(--color-success);
  color: var(--color-text-primary);
}
```

### Text Elements

```css
/* Headings */
h1, h2, h3 {
  color: var(--color-text-primary);
}

/* Body Text */
p, span, div {
  color: var(--color-text-secondary);
}

/* Muted Text */
.muted {
  color: var(--color-text-tertiary);
}
```

### Cards & Surfaces

```css
/* Card Component */
.card {
  background-color: var(--color-surface-1);
  border: 1px solid var(--color-border-default);
}

/* Card Header */
.card-header {
  background-color: var(--color-surface-2);
  border-bottom: 1px solid var(--color-border-default);
}
```

### States

```css
/* Focus State */
.focus-ring {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Disabled State */
.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

---

## Accessibility

### Contrast Ratios

| Color Combination | Ratio | WCAG Level |
|-------------------|-------|------------|
| Text Primary on Surface 1 | 15.99:1 | AAA |
| Text Secondary on Surface 1 | 4.83:1 | AA |
| Text Tertiary on Surface 1 | 2.88:1 | AA Large |
| Primary Color on White | 5.89:1 | AA |
| Success Color on White | 1.55:1 | Fail |
| Error Color on White | 1.83:1 | Fail |

### Recommendations

1. **Text Contrast**
   - Always use `--color-text-primary` for important text
   - Use `--color-text-secondary` for supporting text
   - Use `--color-text-tertiary` for minimal/disabled text

2. **Color Blindness**
   - Don't rely on color alone for information
   - Add icons or patterns alongside semantic colors
   - Test with color blind simulation tools

3. **Focus States**
   - Always include visible focus indicators
   - Use both color and outline for accessibility
   - Ensure sufficient contrast for focus states

4. **Animation**
   - Avoid flashing colors or rapid changes
   - Ensure color transitions are smooth
   - Test for motion sensitivity

### Testing Tools

- [WebAIM Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Figma Color Blindness Plugin](https://www.figma.com/community/plugin/733675698074692489/Color-Blindness)
- [axe DevTools Accessibility Checker](https://www.deque.com/axe/devtools/)

---

## Implementation Tips

1. **Start with Base Colors**
   - Define your primary and semantic colors first
   - Use neutrals as elevations off the true black background

2. **Maintain Consistency**
   - Use CSS variables for easy theming
   - Create component-level color classes
   - Document exceptions in your design system

3. **Test on OLED**
   - Check for burn-in potential on OLED screens
   - Ensure colors work with true black backgrounds
   - Test dark mode extensively

4. **Update Incrementally**
   - Start with primary colors
   - Add semantic colors as needed
   - Expand neutrals as your design system grows

---

## Version History

- v1.0.0 - Initial color system with OLED optimization
- Future - May expand with product-specific variants and animation colors