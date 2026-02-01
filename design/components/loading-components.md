# Loading Components - Design Specification

## Overview

Engaging loading states that provide feedback and improve perceived performance during data fetching and processing.

---

## 1. Skeleton Screens

### Purpose
Show placeholder content that mimics the actual layout while loading.

### Base Skeleton Component
```jsx
const Skeleton = ({ className }) => (
  <div className={`
    animate-pulse bg-gray-200
    rounded
    ${className}
  `}>
    <div className="
      h-full bg-gray-300 rounded
      animate-pulse
    ></div>
  </div>
);
```

### Shimmer Effect
```css
@keyframes shimmer {
  0% {
    transform: translateX(-100%);
    opacity: 0.6;
  }
  50% {
    opacity: 0.8;
  }
  100% {
    transform: translateX(100%);
    opacity: 0.6;
  }
}

.skeleton-shimmer {
  position: relative;
  overflow: hidden;
  background: linear-gradient(
    90deg,
    #f0f0f0 0%,
    #f8f8f8 50%,
    #f0f0f0 100%
  );
}

.skeleton-shimmer::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  transform: translateX(-100%);
  animation: shimmer 2s infinite;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.8) 50%,
    transparent 100%
  );
}
```

### Task List Skeleton
```jsx
const TaskListSkeleton = () => (
  <div className="space-y-4">
    {[1, 2, 3, 4, 5].map((index) => (
      <div key={index} className="
        bg-white rounded-xl shadow-sm border border-gray-200
        p-6 flex items-center space-x-4
      ">
        {/* Checkbox skeleton */}
        <div className="
          w-5 h-5 rounded
          skeleton-shimmer
        "></div>

        {/* Text skeleton */}
        <div className="flex-1 space-y-2">
          <div className="
            h-4 w-3/4 rounded-full
            skeleton-shimmer
          "></div>
          <div className="
            h-3 w-1/2 rounded-full
            skeleton-shimmer
          "></div>
        </div>

        {/* Priority indicator skeleton */}
        <div className="
          w-3 h-3 rounded-full
          skeleton-shimmer
        "></div>
      </div>
    ))}
  </div>
);
```

### Profile Card Skeleton
```jsx
const ProfileCardSkeleton = () => (
  <div className="
    bg-gradient-to-br from-purple-50 to-pink-50
    rounded-2xl border border-purple-100
    overflow-hidden
  ">
    {/* Avatar skeleton */}
    <div className="flex justify-center pt-6">
      <div className="
        w-24 h-24 rounded-full
        skeleton-shimmer
      "></div>
    </div>

    {/* Text skeleton */}
    <div className="px-6 pt-4 space-y-3">
      <div className="
        h-6 w-32 rounded-full
        skeleton-shimmer
      "></div>
      <div className="
        h-4 w-48 rounded-full
        skeleton-shimmer
      "></div>
    </div>

    {/* Stats skeleton */}
    <div className="mt-6 space-y-3 px-6">
      {[1, 2, 3].map((index) => (
        <div key={index} className="
          flex items-center justify-between py-3
        ">
          <div className="
            h-4 w-20 rounded-full
            skeleton-shimmer
          "></div>
          <div className="
            w-20 h-8
            skeleton-shimmer
          "></div>
        </div>
      ))}
    </div>

    {/* Expanded content skeleton */}
    <div className="mt-4 px-6 pb-6 space-y-3">
      <div className="
        h-4 w-full rounded-full
        skeleton-shimmer
      ></div>
      <div className="
        h-4 w-full rounded-full
        skeleton-shimmer
      ></div>
      <div className="
        h-4 w-2/3 rounded-full
        skeleton-shimmer
      ></div>
    </div>
  </div>
);
```

### Asynchronous Skeleton Loading
```jsx
const useSkeleton = (count, delay = 200) => {
  const [showSkeleton, setShowSkeleton] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      setShowSkeleton(false);
    }, delay);

    return () => clearTimeout(timer);
  }, [delay]);

  return showSkeleton;
};

const AsyncContent = ({ fetchData }) => {
  const [data, setData] = useState(null);
  const showSkeleton = useSkeleton();

  useEffect(() => {
    if (!showSkeleton) {
      fetchData().then(setData);
    }
  }, [showSkeleton, fetchData]);

  if (showSkeleton) {
    return <ProfileCardSkeleton />;
  }

  return <ProfileCard data={data} />;
};
```

---

## 2. Progress Bar

### Animated Progress Component
```jsx
const ProgressBar = ({ value, max = 100, color = 'blue' }) => {
  const [displayValue, setDisplayValue] = useState(0);

  useEffect(() => {
    const duration = 1000; // 1 second animation
    const start = Date.now();
    const end = start + duration;
    const finalValue = value;

    const animate = () => {
      const now = Date.now();
      const progress = Math.min((now - start) / duration, 1);

      // Easing function (ease-out)
      const easeOut = 1 - Math.pow(1 - progress, 3);
      setDisplayValue(easeOut * finalValue);

      if (progress < 1) {
        requestAnimationFrame(animate);
      }
    };

    if (value > displayValue) {
      animate();
    }
  }, [value]);

  const percentage = (displayValue / max) * 100;

  return (
    <div className="
      w-full bg-gray-200 rounded-full h-3
      overflow-hidden relative
    ">
      {/* Animated fill */}
      <div
        className={`
          h-full rounded-full transition-all duration-100 ease-out
          bg-gradient-to-r from-${color}-400 to-${color}-600
          flex items-center justify-end pr-2
        `}
        style={{ width: `${percentage}%` }}
      >
        {/* Percentage text */}
        <span className="
          text-xs text-white font-medium
          whitespace-nowrap
          transform transition-all duration-300
          ${percentage > 20 ? 'opacity-100' : 'opacity-0'}
        ">
          {Math.round(displayValue)}%
        </span>
      </div>

      {/* Sparkle effect */}
      {percentage > 0 && (
        <div className="
          absolute top-1/2 left-0
          w-full h-full pointer-events-none
        ">
          <div className="
            absolute w-3 h-3 bg-white rounded-full
            animate-pulse
          " style={{
            left: `${percentage}%`,
            top: '50%',
            transform: 'translate(-50%, -50%)',
            opacity: percentage === max ? 0 : 0.8
          }}></div>
        </div>
      )}
    </div>
  );
};
```

### Color Transitions
```css
/* Progress bar color classes */
.progress-bar-blue {
  background: linear-gradient(to right, #3b82f6, #2563eb);
}

.progress-bar-green {
  background: linear-gradient(to right, #10b981, #059669);
}

.progress-bar-purple {
  background: linear-gradient(to right, #8b5cf6, #7c3aed);
}

.progress-bar-orange {
  background: linear-gradient(to right, #f59e0b, #d97706);
}
```

### Multi-stage Progress
```jsx
const MultiStageProgress = ({ stages, currentStage }) => {
  return (
    <div className="flex items-center space-x-2">
      {stages.map((stage, index) => {
        const isCompleted = index < currentStage;
        const isCurrent = index === currentStage;

        return (
          <div key={stage.id} className="flex items-center">
            {/* Stage circle */}
            <div className={`
              w-10 h-10 rounded-full flex items-center justify-center
              transition-all duration-300 ease-out
              ${
                isCompleted
                  ? 'bg-green-500 text-white'
                  : isCurrent
                    ? 'bg-blue-500 text-white scale-110'
                    : 'bg-gray-200 text-gray-600'
              }
            `}>
              {isCompleted ? (
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                </svg>
              ) : (
                <span className="text-sm font-medium">{index + 1}</span>
              )}
            </div>

            {/* Progress line */}
            {index < stages.length - 1 && (
              <div className={`
                h-1 flex-1 mx-2
                transition-all duration-500 ease-out
                ${
                  index < currentStage
                    ? 'bg-green-500'
                    : 'bg-gray-200'
                }
              `}></div>
            )}
          </div>
        );
      })}
    </div>
  );
};
```

### Loading Animation with Message
```jsx
const LoadingProgress = ({ message }) => {
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setProgress(prev => {
        if (prev >= 100) {
          clearInterval(timer);
          return 100;
        }
        return prev + Math.random() * 10;
      });
    }, 300);

    return () => clearInterval(timer);
  }, []);

  return (
    <div className="text-center py-8">
      <div className="mb-4">
        <div className="
          w-16 h-16 mx-auto
          border-4 border-blue-200 border-t-blue-600
          rounded-full animate-spin
        "></div>
      </div>

      <p className="text-gray-600 mb-2">{message}</p>

      <div className="w-48 mx-auto">
        <ProgressBar value={progress} />
      </div>
    </div>
  );
};
```

---

## 3. Full-Page Loading

### Animated Illustration
```jsx
const LoadingIllustration = () => {
  return (
    <div className="relative w-64 h-64 mx-auto">
      {/* Central orb */}
      <div className="
        absolute inset-0 flex items-center justify-center
      ">
        <div className="
          w-24 h-24 bg-gradient-to-br from-blue-500 to-purple-600
          rounded-full animate-pulse
          shadow-lg
        "></div>
      </div>

      {/* Orbiting circles */}
      {[0, 120, 240].map((delay, index) => (
        <div
          key={index}
          className="
            absolute top-0 left-0 w-full h-full
            animate-spin
            "
          style={{ animationDelay: `${delay}ms` }}
        >
          <div className="
            absolute top-0 left-1/2
            transform -translate-x-1/2 -translate-y-1/2
            w-6 h-6 bg-blue-400 rounded-full
            shadow-md
          "></div>
        </div>
      ))}

      {/* Glow effect */}
      <div className="
        absolute inset-0 bg-gradient-to-br from-blue-500/20 to-purple-600/20
        rounded-full blur-2xl
        animate-pulse
      "></div>
    </div>
  );
};
```

### Encouraging Messages
```jsx
const encouragingMessages = [
  "Loading amazing content...",
  "Just a moment longer...",
  "Fetching your data...",
  "Almost there...",
  "Bringing your content to life...",
  "Loading...",
  "Finalizing your experience...",
  "Preparing your dashboard..."
];

const LoadingMessage = () => {
  const [messageIndex, setMessageIndex] = useState(0);
  const [fade, setFade] = useState(false);

  useEffect(() => {
    const messageInterval = setInterval(() => {
      setFade(true);
      setTimeout(() => {
        setMessageIndex(prev => (prev + 1) % encouragingMessages.length);
        setFade(false);
      }, 300);
    }, 3000);

    return () => clearInterval(messageInterval);
  }, []);

  return (
    <p className={`
      text-xl text-gray-700 transition-opacity duration-300
      ${fade ? 'opacity-0' : 'opacity-100'}
    `}>
      {encouragingMessages[messageIndex]}
    </p>
  );
};
```

### Complete Full-Page Loader
```jsx
const FullPageLoader = ({ show = true }) => {
  if (!show) return null;

  return (
    <div className="
      fixed inset-0 bg-white
      flex flex-col items-center justify-center
      z-50
      transition-opacity duration-500
    ">
      {/* Background pattern */}
      <div className="
        absolute inset-0 bg-gradient-to-br from-gray-50 to-gray-100
        opacity-50
      "></div>

      {/* Main content */}
      <div className="
        relative z-10 text-center
        space-y-8
        animate-fadeIn
      ">
        {/* Illustration */}
        <LoadingIllustration />

        {/* Message */}
        <div className="space-y-4">
          <LoadingMessage />

          <div className="
            w-64 mx-auto
            space-y-2
          ">
            <ProgressBar value={0} color="purple" />
            <div className="flex justify-between text-sm text-gray-500">
              <span>Loading</span>
              <span id="loading-percentage">0%</span>
            </div>
          </div>
        </div>

        {/* Additional info */}
        <div className="
          text-sm text-gray-500
          animate-pulse
        ">
          Please wait while we set everything up
        </div>
      </div>

      {/* Skip button for development */}
      {process.env.NODE_ENV === 'development' && (
        <button className="
          absolute bottom-8 right-8
          text-gray-500 hover:text-gray-700
          text-sm
          transition-colors
        " onClick={() => showLoading(false)}>
          Skip loading
        </button>
      )}
    </div>
  );
};
```

### Error State
```jsx
const LoadingError = ({ onRetry }) => (
  <div className="
    fixed inset-0 bg-white
    flex flex-col items-center justify-center
    z-50
  ">
    {/* Error illustration */}
    <div className="
      w-24 h-24 bg-red-100 rounded-full
      flex items-center justify-center
      mb-6
      animate-shake
    ">
      <svg className="w-12 h-12 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>
    </div>

    {/* Error message */}
    <h2 className="text-xl font-semibold text-gray-900 mb-2">
      Oops! Something went wrong
    </h2>
    <p className="text-gray-600 mb-6">
      We couldn't load the content. Please try again.
    </p>

    {/* Retry button */}
    <button
      onClick={onRetry}
      className="
        px-6 py-2 bg-blue-600 text-white
        rounded-lg hover:bg-blue-700
        transition-colors duration-200
        transform hover:scale-105 active:scale-95
      "
    >
      Try Again
    </button>
  </div>
);
```

---

## Animation Reference

### Keyframe Animations
```css
/* Fade in */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Spin */
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Pulse */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.8; }
}

/* Shake */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}

/* Bounce */
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}
```

### Animation Classes
```css
.animate-fadeIn {
  animation: fadeIn 0.5s ease-out;
}

.animate-spin {
  animation: spin 1s linear infinite;
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-pulse-slow {
  animation: pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-shake {
  animation: shake 0.5s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
}

.animate-bounce {
  animation: bounce 1s ease-in-out infinite;
}
```

### Performance Optimization
1. Use `transform` and `opacity` for animations
2. Implement `will-change` for animated elements:
   ```css
   .animate-will-change {
     will-change: transform, opacity;
   }
   ```
3. Use `contain: strict` for isolated components
4. Batch DOM operations for multiple animations
5. Consider using Web Animations API for complex sequences

### Accessibility Notes
1. Always provide loading states for screen readers
2. Use ARIA live regions for dynamic content
3. Implement keyboard navigation for loading states
4. Add skip options for long loading times
5. Ensure high contrast for loading indicators