# Card Components - Design Specification

## Overview

Modern, interactive card components with smooth animations and micro-interactions for enhanced user experience.

---

## 1. Task Card

### Purpose
Display individual tasks with interactive actions and status indicators.

### Styling

#### Base Styles
```jsx
<div className="
  relative bg-white rounded-xl shadow-sm border border-gray-200
  transition-all duration-300 ease-out
  overflow-hidden
  min-h-[120px]
  cursor-pointer
">
  {/* Card content */}
</div>
```

#### Hover Effects
```jsx
/* Lift and glow on hover */
<div className="
  hover:shadow-lg
  hover:border-blue-300
  hover:-translate-y-1
  transition-all duration-300 ease-out
">
  {/* Optional glow effect */}
  <div className="absolute inset-0 bg-blue-500 opacity-0 hover:opacity-10 transition-opacity duration-300 rounded-xl"></div>
</div>
```

#### Drag Feedback
```jsx
/* When dragging */
<div className="
  active:shadow-xl
  active:border-blue-400
  active:scale-105
  active:z-50
  transition-all duration-200 ease-out
">
  {/* Shadow layer for depth */}
  <div className="absolute inset-0 bg-black opacity-20 active:opacity-30 transition-opacity duration-200 -translate-y-2 rounded-xl"></div>
</div>
```

#### Completed State
```jsx
<div className="
  opacity-70
  bg-gray-50
  border-gray-300
">
  {/* Checkmark animation */}
  <div className="absolute top-4 right-4 w-6 h-6">
    <svg className="w-full h-full text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2"
            className="opacity-0 animate-checkmark"
            d="M5 13l4 4L19 7"></path>
    </svg>
  </div>
</div>

/* Checkmark animation */
<style jsx>{`
  @keyframes checkmark {
    0% { stroke-dashoffset: 20; }
    100% { stroke-dashoffset: 0; }
  }
  .animate-checkmark {
    stroke-dasharray: 20;
    animation: checkmark 0.4s ease-out forwards;
  }
`}</style>
```

#### Swipe Actions
```jsx
<div className="
  relative
  group
  transform transition-transform duration-300
">
  {/* Main content */}
  <div className="absolute inset-0 bg-white rounded-xl shadow-lg"></div>

  {/* Action buttons that slide in */}
  <div className="
    absolute right-0 top-0 h-full flex
    transform translate-x-full
    group-hover:translate-x-0
    transition-transform duration-300 ease-out
  ">
    <button className="text-red-500 px-6 hover:bg-red-50 transition-colors">
      Delete
    </button>
    <button className="text-blue-500 px-6 hover:bg-blue-50 transition-colors">
      Snooze
    </button>
  </div>
</div>
```

### Complete Example
```jsx
const TaskCard = ({ task, isCompleted, onDrag }) => (
  <div className="
    relative bg-white rounded-xl shadow-sm border border-gray-200
    transition-all duration-300 ease-out
    overflow-hidden
    min-h-[120px]
    cursor-pointer
    group
    hover:shadow-lg hover:border-blue-300 hover:-translate-y-1
  ">
    {/* Glow overlay */}
    <div className="absolute inset-0 bg-blue-500 opacity-0 group-hover:opacity-10
                    transition-opacity duration-300 rounded-xl"></div>

    {/* Task content */}
    <div className="relative p-6 pr-20">
      <h3 className="text-lg font-medium text-gray-900">{task.title}</h3>
      <p className="text-sm text-gray-600 mt-1">{task.description}</p>

      {/* Priority indicator */}
      <div className={`w-2 h-2 rounded-full mt-3 ${
        task.priority === 'high' ? 'bg-red-500' :
        task.priority === 'medium' ? 'bg-yellow-500' : 'bg-green-500'
      }`}></div>
    </div>

    {/* Checkmark for completed tasks */}
    {isCompleted && (
      <div className="absolute top-4 right-4 w-6 h-6">
        <svg className="w-full h-full text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2"
                className="opacity-0 animate-checkmark"
                d="M5 13l4 4L19 7"></path>
        </svg>
      </div>
    )}

    {/* Swipe actions */}
    <div className="
      absolute right-0 top-0 h-full flex
      transform translate-x-full
      group-hover:translate-x-0
      transition-transform duration-300 ease-out
    ">
      <button className="text-red-500 px-6 hover:bg-red-50 transition-colors">
        Delete
      </button>
      <button className="text-blue-500 px-6 hover:bg-blue-50 transition-colors">
        Snooze
      </button>
    </div>
  </div>
);
```

---

## 2. Profile Card

### Purpose
Display user profile with avatar, stats, and expandable details.

### Base Styles
```jsx
<div className="
  bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl shadow-sm
  border border-purple-100
  transition-all duration-300 ease-out
  overflow-hidden
  group
">
  {/* Card content */}
</div>
```

#### Avatar with Ring
```jsx
<div className="
  relative mx-auto w-24 h-24 mt-6
  group-hover:scale-110
  transition-transform duration-300 ease-out
">
  {/* Activity ring */}
  <div className="
    absolute inset-0 rounded-full
    transition-all duration-300
    ${
      isActive ? 'bg-green-400 opacity-50' : 'bg-gray-300 opacity-30'
    }
    group-hover:opacity-70
  "></div>

  {/* Avatar image */}
  <img
    src={user.avatar}
    alt={user.name}
    className="
      relative w-full h-full rounded-full
      border-4 border-white
      shadow-lg
    "
  />
</div>
```

#### Stats with Mini-Sparklines
```jsx
<div className="mt-6 space-y-3">
  {stats.map((stat, index) => (
    <div key={stat.label} className="
      flex items-center justify-between
      px-6 py-3 hover:bg-white/50 rounded-lg
      transition-colors duration-200
    ">
      <div className="flex items-center space-x-3">
        <div className="text-gray-600">{stat.label}</div>
        <div className="font-medium text-gray-900">{stat.value}</div>
      </div>

      {/* Mini sparkline */}
      <div className="w-20 h-8 relative">
        <svg className="w-full h-full" viewBox="0 0 80 32">
          <polyline
            className="stroke-purple-500 fill-none"
            strokeWidth="2"
            strokeLinejoin="round"
            strokeLinecap="round"
            points={generateSparklineData(stat.data)}
          />
        </svg>
      </div>
    </div>
  ))}
</div>
```

#### Hover Expansion
```jsx
<div className="
  max-h-40 transition-all duration-300 ease-out overflow-hidden
  group-hover:max-h-[400px]
">
  {/* Expandable content */}
  <div className="px-6 pb-6 space-y-4">
    <div className="text-sm text-gray-700">
      {user.bio}
    </div>

    <div className="flex space-x-2">
      {user.tags.map(tag => (
        <span key={tag} className="
          px-3 py-1 bg-purple-100 text-purple-700
          rounded-full text-xs font-medium
        ">
          {tag}
        </span>
      ))}
    </div>
  </div>
</div>
```

### Complete Example
```jsx
const ProfileCard = ({ user }) => {
  const isActive = user.lastSeen < 5; // Last seen within 5 minutes

  return (
    <div className="
      bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl shadow-sm
      border border-purple-100
      transition-all duration-300 ease-out overflow-hidden group
      hover:shadow-lg hover:-translate-y-1
    ">
      {/* Avatar with activity ring */}
      <div className="relative mx-auto w-24 h-24 mt-6 group-hover:scale-110 transition-transform duration-300 ease-out">
        <div className="
          absolute inset-0 rounded-full
          transition-all duration-300
          ${isActive ? 'bg-green-400 opacity-50' : 'bg-gray-300 opacity-30'}
          group-hover:opacity-70
          animate-pulse
        "></div>
        <img
          src={user.avatar}
          alt={user.name}
          className="
            relative w-full h-full rounded-full
            border-4 border-white shadow-lg
          "
        />
      </div>

      {/* Name and status */}
      <div className="text-center mt-4">
        <h3 className="text-xl font-semibold text-gray-900">{user.name}</h3>
        <p className="text-sm text-gray-600">
          {isActive ? 'Online now' : `Last seen ${user.lastSeen}m ago`}
        </p>
      </div>

      {/* Stats */}
      <div className="mt-6 space-y-3">
        {user.stats.map((stat, index) => (
          <div key={stat.label} className="
            flex items-center justify-between
            px-6 py-3 hover:bg-white/50 rounded-lg
            transition-colors duration-200
          ">
            <div className="flex items-center space-x-3">
              <div className="text-gray-600">{stat.label}</div>
              <div className="font-medium text-gray-900">{stat.value}</div>
            </div>

            {/* Mini sparkline */}
            <div className="w-20 h-8 relative">
              <svg className="w-full h-full" viewBox="0 0 80 32">
                <polyline
                  className="stroke-purple-500 fill-none"
                  strokeWidth="2"
                  strokeLinejoin="round"
                  strokeLinecap="round"
                  points="0,20 15,15 30,25 45,10 60,20 75,5 80,15"
                />
              </svg>
            </div>
          </div>
        ))}
      </div>

      {/* Expandable details */}
      <div className="
        max-h-40 transition-all duration-300 ease-out overflow-hidden
        group-hover:max-h-[400px]
      ">
        <div className="px-6 pb-6 space-y-4">
          <div className="text-sm text-gray-700">
            {user.bio}
          </div>

          <div className="flex flex-wrap gap-2">
            {user.tags.map(tag => (
              <span key={tag} className="
                px-3 py-1 bg-purple-100 text-purple-700
                rounded-full text-xs font-medium
              ">
                {tag}
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
```

---

## 3. Notification Card

### Purpose
Display alerts, notifications, and system messages with actionable items.

### Slide-in Animation
```jsx
<div className="
  fixed top-0 right-0 w-full max-w-sm
  transform translate-x-full
  transition-transform duration-500 ease-out
  z-50
">
  {/* Entry animation */}
  <div className="
    transform translate-x-0
    transition-transform duration-500 ease-out
  ">
    {/* Card content */}
  </div>
</div>
```

### Dismissible Styles
```jsx
<div className="
  relative bg-white rounded-xl shadow-2xl border border-gray-200
  overflow-hidden
  animate-slideIn
  group
">
  {/* Close button */}
  <button className="
    absolute top-3 right-3 w-8 h-8
    flex items-center justify-center
    text-gray-400 hover:text-gray-600
    transition-colors duration-200
    group-hover:bg-gray-100
    rounded-full
  ">
    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
    </svg>
  </button>
</div>
```

### New Item Pulse Effect
```jsx
<div className="
  bg-gradient-to-r from-blue-500 to-purple-600
  relative overflow-hidden
  animate-pulse
">
  {/* Gradient overlay for pulse effect */}
  <div className="
    absolute inset-0 bg-white
    opacity-0 animate-pulseGradient
  "></div>

  {/* Content with white text */}
  <div className="relative text-white">
    <h3 className="font-semibold text-lg">New message</h3>
    <p className="text-sm opacity-90 mt-1">You have a new notification</p>
  </div>
</div>

/* Pulse animation keyframes */
@keyframes pulse {
  0% { opacity: 1; }
  50% { opacity: 0.8; }
  100% { opacity: 1; }
}

@keyframes pulseGradient {
  0% { transform: scale(0.95); opacity: 0.1; }
  50% { transform: scale(1.05); opacity: 0.3; }
  100% { transform: scale(1); opacity: 0.1; }
}
```

### Action Buttons
```jsx
<div className="
  flex space-x-3 mt-4 pt-4 border-t border-gray-100
">
  <button className="
    flex-1 bg-blue-600 text-white py-2 px-4
    rounded-lg font-medium hover:bg-blue-700
    transform hover:scale-105 transition-all duration-200
    active:scale-95
  ">
    View Details
  </button>

  <button className="
    py-2 px-4 text-gray-600 hover:text-gray-800
    hover:bg-gray-100 rounded-lg
    transition-all duration-200
  ">
    Dismiss
  </button>
</div>
```

### Complete Example
```jsx
const NotificationCard = ({ notification, isNew }) => {
  return (
    <div className="
      fixed top-0 right-0 w-full max-w-sm
      transform translate-x-full
      transition-transform duration-500 ease-out
      z-50
    ">
      <div className="
        transform translate-x-0
        transition-transform duration-500 ease-out
      ">
        <div className={`
          relative bg-white rounded-xl shadow-2xl border border-gray-200
          overflow-hidden
          animate-slideIn
          group
          ${isNew ? 'bg-gradient-to-r from-blue-500 to-purple-600 text-white' : ''}
        `}>
          {/* Close button */}
          <button className="
            absolute top-3 right-3 w-8 h-8
            flex items-center justify-center
            ${isNew ? 'text-white hover:text-gray-100' : 'text-gray-400 hover:text-gray-600'}
            transition-colors duration-200
            group-hover:bg-white/10 ${!isNew ? 'group-hover:bg-gray-100' : ''}
            rounded-full
          ">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>

          {/* Content */}
          <div className="p-6">
            <div className="flex items-start space-x-3">
              {notification.icon && (
                <div className={`
                  flex-shrink-0 w-10 h-10 rounded-lg
                  ${isNew ? 'bg-white/20' : 'bg-blue-100 text-blue-600'}
                  flex items-center justify-center
                `}>
                  {notification.icon}
                </div>
              )}

              <div className="flex-1">
                <h3 className={`font-semibold text-lg ${isNew ? '' : 'text-gray-900'}`}>
                  {notification.title}
                </h3>
                <p className={`text-sm mt-1 ${isNew ? 'opacity-90' : 'text-gray-600'}`}>
                  {notification.message}
                </p>
              </div>
            </div>

            {/* Time stamp */}
            <p className={`text-xs mt-3 ${isNew ? 'opacity-70' : 'text-gray-500'}`}>
              {notification.timestamp}
            </p>

            {/* Action buttons */}
            {notification.actions && (
              <div className="
                flex space-x-3 mt-4 pt-4 border-t border-gray-100
              ">
                {notification.actions.map((action, index) => (
                  <button
                    key={index}
                    className={`
                      flex-1 py-2 px-4 rounded-lg font-medium
                      transition-all duration-200 transform hover:scale-105 active:scale-95
                      ${isNew
                        ? 'bg-white/20 text-white hover:bg-white/30'
                        : action.primary
                          ? 'bg-blue-600 text-white hover:bg-blue-700'
                          : 'text-gray-600 hover:bg-gray-100'
                      }
                    `}
                    onClick={action.onClick}
                  >
                    {action.label}
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* New item overlay */}
          {isNew && (
            <div className="
              absolute inset-0 bg-white
              opacity-0 animate-pulseGradient
            "></div>
          )}
        </div>
      </div>
    </div>
  );
};
```

---

## Animation Reference

### Durations
- Fast transitions: `150-200ms` (hover states)
- Medium animations: `300-500ms` (expansions, slides)
- Slow effects: `600-1000ms` (pulse, shimmer)

### Easing Functions
- Standard: `ease-out` (fast start, slow end)
- Bounce: `cubic-bezier(0.68, -0.55, 0.265, 1.55)`
- Smooth: `cubic-bezier(0.4, 0, 0.2, 1)`

### Performance Notes
1. Use `transform` and `opacity` for GPU-accelerated animations
2. Avoid animating `width`, `height`, or `margin` where possible
3. Implement `will-change` for complex animations
4. Use `requestAnimationFrame` for custom animations
5. Consider CSS containment for isolated animation targets