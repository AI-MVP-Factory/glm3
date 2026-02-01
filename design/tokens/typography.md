# Typography System

A comprehensive typography system for the GLM3 project, built on a major third scale for optimal visual hierarchy and readability.

## Font Families

### Primary Fonts

| Category | Font Stack | Use Case |
|----------|------------|----------|
| Display | `"SF Pro Display", "Inter", system-ui, -apple-system, sans-serif` | Headings, titles, hero text, UI elements requiring personality |
| Body | `"SF Pro Text", "Inter", system-ui, -apple-system, sans-serif` | Body text, paragraphs, content areas, primary reading matter |
| Monospace | `"SF Mono", "JetBrains Mono", "Fira Code", Menlo, Monaco, monospace` | Code blocks, technical content, data visualization, system messages |

### Font Stacks

```css
/* Display Font Stack */
:root {
  --font-display: "SF Pro Display", "Inter", system-ui, -apple-system, sans-serif;
}

/* Body Font Stack */
:root {
  --font-body: "SF Pro Text", "Inter", system-ui, -apple-system, sans-serif;
}

/* Monospace Font Stack */
:root {
  --font-mono: "SF Mono", "JetBrains Mono", "Fira Code", Menlo, Monaco, monospace;
}
```

## Type Scale

Major third scale ratio (1.25) for harmonious visual relationships.

### Display Type

| Size | px | rem | CSS Variable | Use Case |
|------|----|-----|--------------|----------|
| Display 1 | 48px | 3rem | --text-4xl | Hero titles, featured content |
| Display 2 | 40px | 2.5rem | --text-3xl | Page titles, major sections |
| Display 3 | 32px | 2rem | --text-2xl | Section headers, important UI elements |

### Heading Type

| Size | px | rem | CSS Variable | Use Case |
|------|----|-----|--------------|----------|
| Heading 1 | 24px | 1.5rem | --text-xl | H1 pages, main headings |
| Heading 2 | 20px | 1.25rem | --text-lg | H2 sections, subheadings |
| Heading 3 | 18px | 1.125rem | --text-base-large | H3 subsections, group headers |

### Body Type

| Size | px | rem | CSS Variable | Use Case |
|------|----|-----|--------------|----------|
| Body Large | 16px | 1rem | --text-base | Standard body text, paragraphs |
| Body Medium | 14px | 0.875rem | --text-sm | Secondary text, metadata, captions |
| Body Small | 12px | 0.75rem | --text-sm-smaller | Fine print, disclaimers, microcopy |

### Caption Type

| Size | px | rem | CSS Variable | Use Case |
|------|----|-----|--------------|----------|
| Caption | 11px | 0.6875rem | --text-xs | Photo credits, timestamps, tooltips |

## Font Weights

| Weight | CSS Variable | Use Case |
|--------|--------------|----------|
| Regular (400) | --font-regular | Body text, secondary content, neutral elements |
| Medium (500) | --font-medium | Emphasis, UI text, interactive elements |
| Semibold (600) | --font-semibold | Headings, buttons, important UI elements |
| Bold (700) | --font-bold | Display text, celebration moments, key CTAs |

## CSS Variables

```css
:root {
  /* Typography Base */
  --font-display: "SF Pro Display", "Inter", system-ui, -apple-system, sans-serif;
  --font-body: "SF Pro Text", "Inter", system-ui, -apple-system, sans-serif;
  --font-mono: "SF Mono", "JetBrains Mono", "Fira Code", Menlo, Monaco, monospace;

  /* Font Weights */
  --font-regular: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;

  /* Type Scale */
  --text-4xl: 3rem;     /* 48px */
  --text-3xl: 2.5rem;   /* 40px */
  --text-2xl: 2rem;     /* 32px */
  --text-xl: 1.5rem;    /* 24px */
  --text-lg: 1.25rem;   /* 20px */
  --text-base-large: 1.125rem; /* 18px */
  --text-base: 1rem;    /* 16px */
  --text-sm: 0.875rem;  /* 14px */
  --text-sm-smaller: 0.75rem; /* 12px */
  --text-xs: 0.6875rem; /* 11px */

  /* Line Heights */
  --lh-display: 1.2;
  --lh-heading: 1.3;
  --lh-body: 1.5;
  --lh-caption: 1.4;

  /* Letter Spacing */
  --ls-tight: -0.025em;
  --ls-normal: 0;
  --ls-wide: 0.025em;
  --ls-wide-lg: 0.05em;
}
```

## Line Height Recommendations

| Context | Line Height | Use Case |
|---------|-------------|----------|
| Display Text | 1.2 | Hero titles, short impactful text |
| Headings | 1.3 | H1-H3, ensures readability at larger sizes |
| Body Text | 1.5 | Standard body text, optimal for reading |
| Monospace | 1.4 | Code blocks, balances readability with vertical density |
| Caption | 1.4 | Small text, prevents line crowding |

## Letter Spacing Guidelines

| Spacing | CSS Variable | Use Case |
|---------|--------------|----------|
| Tight | --ls-tight (-0.025em) | Display text, uppercase headings |
| Normal | --ls-normal (0) | Standard body text, buttons |
| Wide | --ls-wide (0.025em) | All caps text, emphasis |
| Extra Wide | --ls-wide-lg (0.05em) | Letter-spacing adjustments for specific effects |

## Tailwind Configuration Extension

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        display: ["SF Pro Display", "Inter", "system-ui", "-apple-system", "sans-serif"],
        body: ["SF Pro Text", "Inter", "system-ui", "-apple-system", "sans-serif"],
        mono: ["SF Mono", "JetBrains Mono", "Fira Code", "Menlo", "Monaco", "monospace"],
      },
      fontSize: {
        "4xl": "3rem",     // 48px
        "3xl": "2.5rem",   // 40px
        "2xl": "2rem",     // 32px
        "xl": "1.5rem",    // 24px
        "lg": "1.25rem",   // 20px
        "base-large": "1.125rem", // 18px
        base: "1rem",      // 16px
        sm: "0.875rem",   // 14px
        "sm-smaller": "0.75rem", // 12px
        xs: "0.6875rem",  // 11px
      },
      lineHeight: {
        display: "1.2",
        heading: "1.3",
        body: "1.5",
        caption: "1.4",
      },
      letterSpacing: {
        tight: "-0.025em",
        wide: "0.025em",
        "wide-lg": "0.05em",
      },
      fontWeight: {
        regular: 400,
        medium: 500,
        semibold: 600,
        bold: 700,
      },
    },
  },
  plugins: [],
};
```

## Usage Examples

### Basic Typography

```html
<!-- Display Title -->
<h1 class="text-4xl font-bold font-display tracking-tight lh-display">
  Welcome to GLM3
</h1>

<!-- Section Heading -->
<h2 class="text-xl font-semibold font-display tracking-normal lh-heading">
  Get Started
</h2>

<!-- Body Paragraph -->
<p class="text-base font-regular font-body tracking-normal lh-body">
  Experience the power of advanced language models with our intuitive interface.
</p>

<!-- Caption -->
<p class="text-xs font-medium font-body tracking-normal lh-caption">
  Last updated 2 hours ago
</p>
```

### CSS Custom Properties

```css
/* Component Example - Card Header */
.card-header {
  font-family: var(--font-display);
  font-size: var(--text-xl);
  font-weight: var(--font-semibold);
  line-height: var(--lh-heading);
  letter-spacing: var(--ls-normal);
}

/* Component Example - Code Block */
.code-block {
  font-family: var(--font-mono);
  font-size: var(--text-sm);
  font-weight: var(--font-regular);
  line-height: var(--lh-caption);
  letter-spacing: var(--ls-wide);
}

/* Component Example - Button */
.button-primary {
  font-family: var(--font-display);
  font-size: var(--text-base-large);
  font-weight: var(--font-semibold);
  line-height: var(--lh-body);
  letter-spacing: var(--ls-tight);
  text-transform: uppercase;
}
```

### Responsive Typography

```css
/* Fluid Typography System */
html {
  font-size: clamp(16px, 2.5vw, 18px);
}

/* Responsive Examples */
.hero-title {
  font-size: clamp(32px, 5vw, 48px);
  font-weight: var(--font-bold);
}

.section-title {
  font-size: clamp(20px, 3vw, 24px);
  font-weight: var(--font-semibold);
}

.body-text {
  font-size: clamp(14px, 1.5vw, 16px);
  line-height: var(--lh-body);
}
```

### Accessibility Considerations

```css
/* Minimum Text Sizes */
@media (max-width: 640px) {
  .text-base {
    font-size: 16px; /* Prevent zoom */
  }

  .text-sm {
    font-size: 14px;
  }
}

/* High Contrast Support */
@media (prefers-contrast: high) {
  body {
    font-weight: var(--font-medium);
  }

  h1, h2, h3 {
    font-weight: var(--font-bold);
  }
}

/* Reduce Motion Support */
@media (prefers-reduced-motion: reduce) {
  * {
    transition: none !important;
  }

  body {
    animation: none !important;
  }
}
```

## Typography Patterns

### Heading Hierarchy

```html
<h1 class="text-4xl font-bold font-display">Main Title</h1>
<h2 class="text-xl font-semibold font-display">Section Title</h2>
<h3 class="text-lg font-medium font-display">Subsection</h3>
```

### Card Component Typography

```html
<div class="card">
  <div class="card-header">
    <h3 class="text-xl font-semibold font-display mb-2">Project Overview</h3>
  </div>
  <div class="card-body">
    <p class="text-base font-regular font-body mb-4">
      Description of the project goes here with proper spacing and readability.
    </p>
    <div class="code-block">
      <pre class="text-sm font-regular font-mono">Code snippet example</pre>
    </div>
  </div>
  <div class="card-footer">
    <p class="text-xs font-medium font-body text-gray-500">
      Last updated: Dec 1, 2024
    </p>
  </div>
</div>
```

This typography system provides a consistent, scalable foundation for the GLM3 interface, ensuring readability, visual hierarchy, and brand personality across all touchpoints.