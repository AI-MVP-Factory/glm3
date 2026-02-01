# Spacing System

## Overview

A consistent, 4px-based spacing system that creates visual harmony and reduces cognitive load. All spacing values are multiples of 4px, ensuring consistency across the design system.

---

## 4px Base Unit Scale

The spacing system uses a 4px base unit scaled up through powers of 2:

| Value | Size | Use Case |
|-------|------|----------|
| 4px | Ultra-tight | Icon padding, tight text spacing |
| 8px | Small | Component padding, icon spacing |
| 12px | Compact | Button padding, small gaps |
| 16px | Default | Standard padding, margins |
| 24px | Comfortable | Card spacing, form elements |
| 32px | Spacious | Section gaps, large padding |
| 48px | Section | Page sections, hero spacing |
| 64px | Large | Full-width sections |
| 96px | XL | Page containers, wide spacing |
| 128px | XXL | Full-page sections, dramatic spacing |

---

## Semantic Names

Each spacing value has semantic meaning to guide usage:

### Size Tiers
- **xs** (4px) - Ultra-tight spacing for icon-only layouts
- **sm** (8px) - Compact spacing for dense interfaces
- **md** (16px) - Default spacing for most components
- **lg** (24px) - Comfortable spacing for good legibility
- **xl** (32px) - Spacious spacing for important elements
- **2xl** (48px+) - Section spacing for visual grouping

### Usage Guidelines

```md
- Use **xs** for: Icon padding, tight text blocks, pixel-perfect alignments
- Use **sm** for: Button padding, small cards, list items
- Use **md** for: Standard components, form fields, card content
- Use **lg** for: Card spacing, navigation, section dividers
- Use **xl** for: Hero sections, large cards, main content areas
- Use **2xl** for: Page sections, full-width containers
```

---

## CSS Variables

Define spacing tokens in CSS for consistent usage:

```css
:root {
  /* Core spacing scale (4px base) */
  --spacing-xs: 0.25rem;   /* 4px */
  --spacing-sm: 0.5rem;    /* 8px */
  --spacing-md: 1rem;      /* 16px */
  --spacing-lg: 1.5rem;    /* 24px */
  --spacing-xl: 2rem;      /* 32px */
  --spacing-2xl: 3rem;     /* 48px */
  --spacing-3xl: 4rem;     /* 64px */
  --spacing-4xl: 6rem;     /* 96px */
  --spacing-5xl: 8rem;     /* 128px */

  /* Responsive spacing */
  --spacing-xs-mobile: calc(0.25rem * 0.8);   /* 3.2px */
  --spacing-sm-mobile: calc(0.5rem * 0.8);    /* 6.4px */
  --spacing-md-mobile: calc(1rem * 0.8);     /* 12.8px */

  /* Special spacing */
  --spacing-none: 0;
  --spacing-auto: auto;
}

/* Dark mode adjustments */
@media (prefers-color-scheme: dark) {
  :root {
    --spacing-gutter: var(--spacing-lg);
    --spacing-container: var(--spacing-2xl);
  }
}
```

---

## Implementation Examples

### Basic Usage
```css
.card {
  padding: var(--spacing-md);      /* 16px */
  margin-bottom: var(--spacing-lg); /* 24px */
}

.button {
  padding: var(--spacing-sm) var(--spacing-lg); /* 8px 24px */
}

.title-section {
  margin-bottom: var(--spacing-2xl); /* 48px */
}
```

### Responsive Spacing
```css
.container {
  padding: var(--spacing-lg);
  @media (max-width: 768px) {
    padding: var(--spacing-md);
  }
}

.grid {
  display: grid;
  gap: var(--spacing-md);
  @media (min-width: 1024px) {
    gap: var(--spacing-lg);
  }
}
```

### Component Library Usage
```css
/* Typography spacing */
h1 { margin-bottom: var(--spacing-xl); }
h2 { margin-bottom: var(--spacing-lg); }
h3 { margin-bottom: var(--spacing-md); }
p { margin-bottom: var(--spacing-md); }

/* Form elements */
.input-group {
  margin-bottom: var(--spacing-lg);
}

.label {
  margin-bottom: var(--spacing-sm);
}

/* Navigation */
.nav-item {
  padding: var(--spacing-sm) var(--spacing-md);
}
```

---

## Tailwind CSS Extension

Extend Tailwind config to include the spacing system:

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      spacing: {
        'xs': '0.25rem',    // 4px
        'sm': '0.5rem',     // 8px
        'md': '1rem',       // 16px
        'lg': '1.5rem',     // 24px
        'xl': '2rem',       // 32px
        '2xl': '3rem',      // 48px
        '3xl': '4rem',      // 64px
        '4xl': '6rem',      // 96px
        '5xl': '8rem',      // 128px

        // Responsive variants
        'xs-mobile': 'calc(0.25rem * 0.8)',
        'sm-mobile': 'calc(0.5rem * 0.8)',
        'md-mobile': 'calc(1rem * 0.8)',

        // Special values
        'none': '0',
        'auto': 'auto'
      }
    }
  }
}
```

### Tailwind Usage Examples
```html
<div class="p-md">16px padding</div>
<div class="p-lg md:p-xl">Responsive padding</div>
<div class="space-y-lg">
  <div>Item 1</div>
  <div>Item 2</div>
</div>

<button class="px-lg py-sm">Button with spacing</button>
<nav class="space-x-md">
  <a>Link 1</a>
  <a>Link 2</a>
</nav>
```

---

## Spacing Hierarchy

### Component Spacing
- **Inline elements**: `xs` to `sm` (4-8px)
- **Buttons/Controls**: `sm` to `md` (8-16px)
- **Cards/Forms**: `md` to `lg` (16-24px)
- **Sections/Pages**: `lg` to `2xl` (24-48px)
- **Full-width**: `2xl` to `5xl` (48px+)

### Visual Rhythm
Create consistent rhythm with combinations:
```css
/* Tight layout (apps, dashboards) */
.compact-spacing {
  --spacing-unit: var(--spacing-sm);
}

/* Normal layout (websites, tools) */
.normal-spacing {
  --spacing-unit: var(--spacing-md);
}

/* Spacious layout (marketing, portfolios) */
.spacious-spacing {
  --spacing-unit: var(--spacing-lg);
}
```

---

## Best Practices

1. **Consistency**: Use semantic names, not pixel values
2. **Hierarchy**: Create clear visual relationships
3. **Responsiveness**: Adjust spacing for smaller screens
4. **Purpose**: Match spacing to content importance
5. **Scale**: Maintain the 4px base for consistency

### Avoid
- Random spacing values
- Inconsistent margins and padding
- Over-spacing on small screens
- Under-spacing for important elements