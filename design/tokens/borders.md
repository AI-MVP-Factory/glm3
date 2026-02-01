# Border System

## Overview

A border and shadow system optimized for OLED displays with a focus on clarity, approachability, and performance. The system uses borders and elevation techniques instead of traditional shadows for better battery life on OLED screens.

---

## Border Radius

Friendly, approachable border radii that create a modern, welcoming aesthetic:

| Size | Value | Use Case | Examples |
|------|-------|----------|----------|
| **sm** | 4px | Small interactive elements | Buttons, badges, inputs |
| **md** | 8px | Standard components | Cards, modals, panels |
| **lg** | 12px | Medium components | Large cards, content areas |
| **xl** | 16px | Hero elements | Headers, feature cards |
| **full** | 9999px | Completely rounded | Avatars, pills, icons |

### Usage Guidelines

```md
- Use **sm** (4px): Buttons, badges, form inputs
- Use **md** (8px): Cards, modals, panels
- Use **lg** (12px): Large cards, content containers
- Use **xl** (16px): Hero elements, headers
- Use **full** (9999px): Avatars, pill buttons, circular icons
```

---

## Border Radius CSS Variables

```css
:root {
  /* Border radius scale */
  --radius-sm: 0.25rem;      /* 4px */
  --radius-md: 0.5rem;       /* 8px */
  --radius-lg: 0.75rem;      /* 12px */
  --radius-xl: 1rem;        /* 16px */
  --radius-full: 9999px;    /* Pill shape */

  /* Component-specific radii */
  --radius-button: var(--radius-sm);
  --radius-card: var(--radius-md);
  --radius-modal: var(--radius-lg);
  --radius-input: var(--radius-md);

  /* Dynamic radius (for interactive states) */
  --radius-pressed: calc(var(--radius-sm) * 0.5);
  --radius-hover: var(--radius-lg);
}

/* State-based variations */
.hover\:radius-lg:hover {
  border-radius: var(--radius-lg);
}

.pressed\:radius-sm:active {
  border-radius: var(--radius-pressed);
}
```

### Border Radius Implementation
```css
/* Buttons */
.button {
  border-radius: var(--radius-button);
}

.button-pill {
  border-radius: var(--radius-full);
}

/* Cards */
.card {
  border-radius: var(--radius-card);
}

/* Modals */
.modal {
  border-radius: var(--radius-modal);
}

/* Inputs */
.input {
  border-radius: var(--radius-input);
}

/* Avatars */
.avatar {
  border-radius: var(--radius-full);
}

/* Hero elements */
.hero {
  border-radius: var(--radius-xl);
}
```

---

## Shadows & Elevation

OLED-optimized elevation system using borders and subtle shadows:

### Elevation Levels

| Level | Dark Mode | Light Mode | Use Case |
|-------|-----------|------------|----------|
| **0** | none | none | Background elements |
| **1** | #ffffff08 | 0 1px 3px rgba(0,0,0,0.1) | Cards |
| **2** | #ffffff10 | 0 2px 6px rgba(0,0,0,0.1) | Dropdowns, popups |
| **3** | #ffffff15 | 0 4px 12px rgba(0,0,0,0.1) | Modals, dialogs |
| **4** | #ffffff20 | 0 8px 24px rgba(0,0,0,0.1) | Overlay panels |

### Shadow CSS Variables

```css
:root {
  /* Elevation shadows */
  --shadow-0: none;

  /* Dark mode (OLED-friendly) */
  --shadow-1-dark: 0 0 0 1px rgba(255, 255, 255, 0.08);
  --shadow-2-dark: 0 0 0 2px rgba(255, 255, 255, 0.12);
  --shadow-3-dark: 0 0 0 3px rgba(255, 255, 255, 0.15);
  --shadow-4-dark: 0 0 0 4px rgba(255, 255, 255, 0.2);

  /* Light mode (subtle shadows) */
  --shadow-1-light: 0 1px 3px rgba(0, 0, 0, 0.1);
  --shadow-2-light: 0 2px 6px rgba(0, 0, 0, 0.1);
  --shadow-3-light: 0 4px 12px rgba(0, 0, 0, 0.1);
  --shadow-4-light: 0 8px 24px rgba(0, 0, 0, 0.1);

  /* Responsive shadows */
  --shadow-1: var(--shadow-1-dark);
  --shadow-2: var(--shadow-2-dark);
  --shadow-3: var(--shadow-3-dark);
  --shadow-4: var(--shadow-4-dark);

  /* Accent shadows */
  --shadow-glow: 0 0 12px rgba(99, 102, 241, 0.3);
  --shadow-focus: 0 0 0 3px rgba(99, 102, 241, 0.3);
}

/* Theme detection */
@media (prefers-color-scheme: light) {
  :root {
    --shadow-1: var(--shadow-1-light);
    --shadow-2: var(--shadow-2-light);
    --shadow-3: var(--shadow-3-light);
    --shadow-4: var(--shadow-4-light);
  }
}
```

### Shadow Utilities
```css
.shadow-none { box-shadow: var(--shadow-0); }
.shadow-sm { box-shadow: var(--shadow-1); }
.shadow { box-shadow: var(--shadow-2); }
.shadow-lg { box-shadow: var(--shadow-3); }
.shadow-xl { box-shadow: var(--shadow-4); }

.shadow-glow { box-shadow: var(--shadow-glow); }
.shadow-focus { box-shadow: var(--shadow-focus); }

/* Floating effect */
.floating {
  box-shadow: var(--shadow-3);
  transition: box-shadow 0.2s ease;
}

.floating:hover {
  box-shadow: var(--shadow-4);
}
```

---

## Border Colors

Consistent border colors for different states:

```css
:root {
  /* Border colors */
  --border-color-base: rgba(255, 255, 255, 0.12);
  --border-color-divider: rgba(255, 255, 255, 0.06);
  --border-color-subtle: rgba(255, 255, 255, 0.03);

  /* Interactive states */
  --border-color-hover: rgba(255, 255, 255, 0.18);
  --border-color-active: rgba(255, 255, 255, 0.24);
  --border-color-focus: rgba(99, 102, 241, 0.8);

  /* Status colors */
  --border-color-success: rgba(34, 197, 94, 0.5);
  --border-color-warning: rgba(234, 179, 8, 0.5);
  --border-color-error: rgba(239, 68, 68, 0.5);
}
```

### Border Implementation
```css
.border-base {
  border: 1px solid var(--border-color-base);
}

.border-divider {
  border: 1px solid var(--border-color-divider);
}

.border-subtle {
  border: 1px solid var(--border-color-subtle);
}

/* State variations */
.border-base:hover {
  border-color: var(--border-color-hover);
}

.border-base:focus-within {
  border-color: var(--border-color-focus);
}

.status-success {
  border-color: var(--border-color-success);
}

.status-warning {
  border-color: var(--border-color-warning);
}

.status-error {
  border-color: var(--border-color-error);
}
```

---

## Border Width Scale

Consistent border widths for different purposes:

```css
:root {
  /* Border widths */
  --border-width-sm: 1px;
  --border-width-md: 1.5px;
  --border-width-lg: 2px;
  --border-width-xl: 3px;
}

/* Utility classes */
.border-sm { border-width: var(--border-width-sm); }
.border-md { border-width: var(--border-width-md); }
.border-lg { border-width: var(--border-width-lg); }
.border-xl { border-width: var(--border-width-xl); }
```

---

## Component Examples

### Card Component
```css
.card {
  border: 1px solid var(--border-color-base);
  border-radius: var(--radius-card);
  box-shadow: var(--shadow-2);
  transition: all 0.2s ease;
}

.card:hover {
  border-color: var(--border-color-hover);
  box-shadow: var(--shadow-3);
}
```

### Button Component
```css
.button {
  border: 1px solid var(--border-color-base);
  border-radius: var(--radius-button);
  transition: all 0.2s ease;
}

.button:hover {
  border-color: var(--border-color-hover);
  box-shadow: var(--shadow-1);
}

.button:active {
  border-radius: var(--radius-pressed);
  box-shadow: var(--shadow-0);
}

.button-primary {
  border-color: var(--border-color-focus);
  box-shadow: var(--shadow-focus);
}
```

### Modal Component
```css
.modal {
  border: 1px solid var(--border-color-base);
  border-radius: var(--radius-modal);
  box-shadow: var(--shadow-4);
}

.modal-overlay {
  box-shadow: var(--shadow-1);
}
```

---

## Tailwind CSS Extension

Extend Tailwind to include the border system:

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      borderRadius: {
        'sm': '4px',
        'md': '8px',
        'lg': '12px',
        'xl': '16px',
        'full': '9999px',
        'button': '4px',
        'card': '8px',
        'modal': '12px',
      },
      boxShadow: {
        '0': 'none',
        '1': '0 0 0 1px rgba(255, 255, 255, 0.08)',
        '2': '0 0 0 2px rgba(255, 255, 255, 0.12)',
        '3': '0 0 0 3px rgba(255, 255, 255, 0.15)',
        '4': '0 0 0 4px rgba(255, 255, 255, 0.2)',
        'glow': '0 0 12px rgba(99, 102, 241, 0.3)',
        'focus': '0 0 0 3px rgba(99, 102, 241, 0.3)',
      },
      borderWidth: {
        'sm': '1px',
        'md': '1.5px',
        'lg': '2px',
        'xl': '3px',
      },
    }
  }
}
```

### Tailwind Usage Examples
```html
<!-- Border radius -->
<div class="rounded-md">8px border radius</div>
<div class="rounded-full">Circular element</div>
<button class="rounded-button">Button with custom radius</button>

<!-- Shadows -->
<div class="shadow-md">Medium elevation</div>
<div class="shadow-xl">High elevation</div>
<div class="shadow-glow">Glow effect</div>

<!-- Component examples -->
<div class="border border-base rounded-md shadow-md hover:shadow-lg">
  Card with hover effect
</div>

<button class="border border-sm rounded-button hover:border-active">
  Interactive button
</button>
```

---

## Best Practices

### Border Guidelines
1. **Consistency**: Use the defined scale, avoid arbitrary values
2. **Purpose**: Borders should either separate or decorate
3. **States**: Use border color changes for interactivity
4. **Performance**: Prefer borders over shadows when possible
5. **Accessibility**: Ensure contrast ratios are maintained

### Shadow Guidelines
1. **OLED optimization**: Use border-based elevation first
2. **Subtlety**: Shadows should enhance, not dominate
3. **Context**: Match shadow level to component importance
4. **Interactivity**: Show depth changes on hover/active states
5. **Theme-aware**: Adapt for light/dark mode

### Performance Tips
```css
/* Hardware acceleration */
.floating {
  transform: translateZ(0);
  will-change: box-shadow;
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  * {
    transition: none !important;
  }
}
```

---

## Anti-Patterns to Avoid

### Don't
- Mix multiple shadow techniques on one component
- Use excessive blur that creates eye strain
- Make borders too thick (max 3px for special cases)
- Create floating elements without proper contrast
- Use inconsistent border radius within components

### Do Instead
- Use consistent border widths from the scale
- Apply shadows only when needed for elevation
- Consider border color changes for interactivity
- Test on both light and dark backgrounds
- Ensure components remain accessible