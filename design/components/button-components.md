# Button Components Documentation

This document provides comprehensive documentation for all button components in our UI system, including their states, animations, and accessibility features.

## Table of Contents

1. [Primary Button](#primary-button)
2. [Secondary Button](#secondary-button)
3. [Destructive Button](#destructive-button)
4. [Common Properties](#common-properties)
5. [Animation Specifications](#animation-specifications)
6. [Accessibility Guidelines](#accessibility-guidelines)

---

## Primary Button

The primary button is our main call-to-action component with a gradient background and subtle shimmer effect.

### Default State

```tsx
import { Button } from '@/components/ui/button';

// Basic usage
<Button>Primary Button</Button>

// With variant prop (default)
<Button variant="primary">Primary Button</Button>
```

**Tailwind Classes:**
```css
bg-gradient-to-r from-indigo-500 to-purple-600
text-white
font-medium
relative
overflow-hidden
transition-all
duration-200
ease-out
```

### Hover State

```tsx
<Button variant="primary" className="hover:from-indigo-600 hover:to-purple-700">
  Primary Button (Hover)
</Button>
```

**Effects:**
- Gradient brightens slightly
- Button lifts up by 2px
- Subtle shadow appears
- Shimmer effect intensifies

### Active/Press State

```tsx
<Button variant="primary" className="active:scale-95">
  Primary Button (Pressed)
</Button>
```

**Effects:**
- Scales down to 98% of original size
- Ripple effect spreads from point of contact
- Gradient shifts slightly

### Loading State

```tsx
import { useState } from 'react';
import { Loader2 } from 'lucide-react';

function LoadingButton() {
  const [isLoading, setIsLoading] = useState(false);

  return (
    <Button
      variant="primary"
      disabled={isLoading}
      className="disabled:opacity-70 disabled:cursor-not-allowed"
    >
      {isLoading ? (
        <>
          <Loader2 className="w-4 h-4 mr-2 animate-spin" />
          Processing...
        </>
      ) : (
        'Submit'
      )}
    </Button>
  );
}
```

**Effects:**
- Spinner icon appears with rotation animation
- Button text dims to 70% opacity
- All other interactions disabled
- Ripple effect disabled

### Success State

```tsx
import { CheckCircle } from 'lucide-react';

function SuccessButton() {
  const [isSuccess, setIsSuccess] = useState(false);

  return (
    <Button
      variant="primary"
      onClick={() => {
        setIsSuccess(true);
        setTimeout(() => setIsSuccess(false), 2000);
      }}
      className={isSuccess ? 'bg-green-500' : ''}
    >
      {isSuccess ? (
        <>
          <CheckCircle className="w-4 h-4 mr-2" />
          Success!
        </>
      ) : (
        'Save Changes'
      )}
    </Button>
  );
}
```

**Effects:**
- Green flash animation on success
- Checkmark icon slides in from left
- Text changes to "Success!"
- Background flashes green briefly

### Disabled State

```tsx
<Button variant="primary" disabled>
  Disabled Button
</Button>
```

**Tailwind Classes:**
```css
opacity-50
cursor-not-allowed
pointer-events-none
```

**Effects:**
- Reduced opacity to 50%
- No hover or active states
- Cannot receive focus
- Disabled pointer events

### Size Variants

```tsx
// Small
<Button variant="primary" size="sm">
  Small Button
</Button>

// Medium (default)
<Button variant="primary" size="md">
  Medium Button
</Button>

// Large
<Button variant="primary" size="lg">
  Large Button
</Button>
```

**Size Classes:**
- **sm**: `px-3 py-1.5 text-sm h-8`
- **md**: `px-4 py-2 text-base h-10` (default)
- **lg**: `px-6 py-3 text-lg h-12`

---

## Secondary Button

The secondary button has an outlined style with transparent background, perfect for secondary actions.

### Default State

```tsx
<Button variant="secondary">
  Secondary Button
</Button>
```

**Tailwind Classes:**
```css
border-2
border-indigo-500
bg-transparent
text-indigo-600
font-medium
transition-all
duration-200
ease-out
```

### Hover State

```tsx
<Button variant="secondary" className="hover:bg-indigo-50">
  Secondary Button (Hover)
</Button>
```

**Effects:**
- Background fills with primary color at 10% opacity
- Border brightens
- Text color deepens
- Subtle lift effect

### Active/Press State

```tsx
<Button variant="secondary" className="active:scale-95 active:bg-indigo-100">
  Secondary Button (Pressed)
</Button>
```

**Effects:**
- Scales down to 98%
- Background darkens to 20% opacity
- Border becomes more saturated

### Loading State

```tsx
<Button variant="secondary" disabled>
  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
  Processing...
</Button>
```

**Effects:**
- Spinner appears
- Border dims to 50% opacity
- Text dims to 50% opacity
- No interactions allowed

### Success State

```tsx
<Button
  variant="secondary"
  className="border-green-500 text-green-600 hover:bg-green-50"
>
  <CheckCircle className="w-4 h-4 mr-2" />
  Success!
</Button>
```

**Effects:**
- Border turns green
- Text turns green
- Hover background is light green
- Checkmark icon appears

### Disabled State

```tsx
<Button variant="secondary" disabled>
  Disabled Secondary Button
</Button>
```

**Tailwind Classes:**
```css
opacity-50
cursor-not-allowed
border-opacity-50
```

### Size Variants

```tsx
// Small
<Button variant="secondary" size="sm">
  Small
</Button>

// Medium
<Button variant="secondary" size="md">
  Medium
</Button>

// Large
<Button variant="secondary" size="lg">
  Large
</Button>
```

---

## Destructive Button

The destructive button indicates dangerous or destructive actions with a red gradient.

### Default State

```tsx
<Button variant="destructive">
  Delete Item
</Button>
```

**Tailwind Classes:**
```css
bg-gradient-to-r from-red-500 to-red-600
text-white
font-medium
transition-all
duration-200
ease-out
```

### Hover State

```tsx
<Button variant="destructive" className="hover:from-red-600 hover:to-red-700">
  Delete Item (Hover)
</Button>
```

**Effects:**
- Gradient darkens
- Button warns with subtle shake animation
- Shadow appears
- Text becomes brighter

### Active/Press State

```tsx
<Button variant="destructive" className="active:scale-95 active:from-red-700 active:to-red-800">
  Delete Item (Pressed)
</Button>
```

**Effects:**
- Scales down to 98%
- Gradient darkens significantly
- Ripple effect
- Strong visual feedback

### Loading State

```tsx
<Button variant="destructive" disabled>
  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
  Deleting...
</Button>
```

**Effects:**
- Red spinner
- Text dims but maintains red tint
- All interactions disabled
- Warning icons may appear

### Success State (for undo/confirm)

```tsx
<Button
  variant="destructive"
  className="bg-green-500 hover:bg-green-600"
>
  <CheckCircle className="w-4 h-4 mr-2" />
  Restored!
</Button>
```

**Effects:**
- Green gradient appears
- Success animation
- Text changes to positive

### Disabled State

```tsx
<Button variant="destructive" disabled>
  Disabled Delete
</Button>
```

**Effects:**
- Red dims to 50% opacity
- No hover states
- Cannot receive focus

### Size Variants

```tsx
// Small
<Button variant="destructive" size="sm">
  Delete
</Button>

// Medium
<Button variant="destructive" size="md">
  Delete Item
</Button>

// Large
<Button variant="destructive" size="lg">
  Permanently Delete
</Button>
```

---

## Common Properties

All button components support these common props:

```tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'destructive';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  success?: boolean;
  className?: string;
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
  ariaLabel?: string;
  ariaDescribedBy?: string;
  tabIndex?: number;
}
```

### Example with All Props

```tsx
<Button
  variant="primary"
  size="md"
  disabled={isLoading}
  loading={isLoading}
  success={isSuccess}
  className="mt-4"
  onClick={handleSubmit}
  type="submit"
  ariaLabel="Submit form"
  ariaDescribedBy="submit-help"
  tabIndex={0}
>
  {isLoading ? 'Processing...' : 'Submit'}
</Button>
```

---

## Animation Specifications

### Shimmer Effect (Primary Button)

```css
.shimmer {
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.3),
    transparent
  );
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  100% {
    left: 200%;
  }
}
```

### Ripple Effect

```css
.ripple {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.6);
  transform: scale(0);
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  to {
    transform: scale(4);
    opacity: 0;
  }
}
```

### Shake Animation (Destructive Button)

```css
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-2px); }
  20%, 40%, 60%, 80% { transform: translateX(2px); }
}

.shake {
  animation: shake 0.5s ease-in-out;
}
```

### Success Checkmark Animation

```css
@keyframes checkmark {
  0% { transform: scale(0) rotate(45deg); opacity: 0; }
  50% { transform: scale(1.2) rotate(45deg); }
  100% { transform: scale(1) rotate(45deg); opacity: 1; }
}

.checkmark {
  animation: checkmark 0.3s ease-out;
}
```

---

## Accessibility Guidelines

### ARIA Attributes

```tsx
<Button
  aria-label="Submit form"
  aria-describedby="submit-help"
  aria-busy={isLoading}
  aria-disabled={disabled}
>
  Submit
</Button>

<div id="submit-help" className="sr-only">
  Click to submit your form. Required fields must be filled.
</div>
```

### Keyboard Navigation

All buttons should be keyboard accessible:

- **Tab**: Navigate to button
- **Enter/Space**: Activate button
- **Shift+Tab**: Navigate backward
- **Escape**: Cancel action (if applicable)

### Focus States

```css
/* Default focus */
button:focus {
  outline: 2px solid #4f46e5;
  outline-offset: 2px;
}

/* Keyboard focus only */
button:focus:not(:focus-visible) {
  outline: none;
}

button:focus-visible {
  outline: 2px solid #4f46e5;
  outline-offset: 2px;
}
```

### Screen Reader Support

```tsx
// Loading state
<button aria-busy="true">
  <span aria-hidden="true">
    <Loader2 className="animate-spin" />
  </span>
  <span className="sr-only">Loading, please wait...</span>
  Processing...
</button>

// Success state
<button aria-live="polite">
  <CheckCircle className="w-4 h-4 mr-2" />
  <span className="sr-only">Success!</span>
  Success!
</button>
```

### Color Contrast

All button variants meet WCAG AA contrast standards:
- Primary: 4.5:1 contrast ratio
- Secondary: 3:1 contrast ratio
- Text: 4.5:1 contrast ratio

### Visual Indicators

- **Disabled**: 50% opacity + "disabled" in ARIA
- **Loading**: Spinner + "loading" in ARIA
- **Success**: Checkmark + success color
- **Error**: X icon + error color (if implemented)