# Animation System Integration Guide

This guide explains how to use the animation system with and without the accessibility system.

## Architecture Overview

The animation system is designed to work in three scenarios:

1. **Animation System Only** - For projects without accessibility features
2. **Accessibility System Only** - For projects without animation features
3. **Both Systems** - For projects with both features (recommended)

## Scenario 1: Animation System Only

Use this when you only want scroll animations and language change animations.

### Basic Usage

```dart
import 'package:your_project/core/animations/animated_text_widget.dart';

// Replace Text widgets with AnimatedText
AnimatedText(
  'Hello World',
  style: TextStyle(fontSize: 18),
)

// For scroll animations only (no language registration)
ScrollAnimatedText(
  'This text only animates on scroll',
  style: TextStyle(fontSize: 16),
)
```

### Language Change Animation

```dart
import 'package:your_project/core/animations/language_change_animation.dart';

// Trigger language change animation
LanguageChangeAnimationController().animateLanguageChange(
  context: context,
  settings: const LanguageChangeSettings.readingWave(),
  onComplete: () {
    // Handle completion
  },
);
```

## Scenario 2: Accessibility System Only

Use this when you only want accessibility features without animations.

### Your Existing Accessibility Widget

```dart
// Your accessibility brick remains unchanged
class AccessibleText extends StatelessWidget {
  final String text;
  // ... accessibility properties

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getAccessibleStyle(),
      // ... accessibility properties
    );
  }
}
```

## Scenario 3: Both Systems (Recommended)

This is the most flexible approach. The accessibility system takes priority for language changes.

### Option A: Enhance Your Accessibility Widget

```dart
import 'package:your_project/core/animations/animated_text_widget.dart';

class AccessibleText extends StatelessWidget {
  final String text;
  // ... existing accessibility properties

  @override
  Widget build(BuildContext context) {
    // Use LanguageAnimatedText for automatic language animation registration
    return LanguageAnimatedText(
      text,
      style: _getAccessibleStyle(),
      // ... all your accessibility properties
    );
  }
}
```

### Option B: Use Both Widgets Separately

```dart
// For text that needs both accessibility and scroll animations
FadeInAnimation(
  child: AccessibleText('This text has both features'),
)

// For text that only needs scroll animations
FadeInAnimation(
  child: ScrollAnimatedText('This text only scrolls'),
)

// For text that only needs accessibility
AccessibleText('This text only has accessibility'),
```

## Integration Examples

### Example 1: Portfolio Header

```dart
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Both accessibility and language animation
        AccessibleText('Camilo Santacruz'),

        // Scroll animation only
        FadeInAnimation(
          slideDirection: SlideDirection.fromBottom,
          child: ScrollAnimatedText('Flutter Developer'),
        ),

        // Both accessibility and scroll animation
        FadeInAnimation(
          child: AccessibleText('Portfolio'),
        ),
      ],
    );
  }
}
```

### Example 2: Skills Section

```dart
class SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredAnimation(
      children: [
        // All skills have accessibility
        AccessibleText('Flutter'),
        AccessibleText('Dart'),
        AccessibleText('Firebase'),
        AccessibleText('Git'),
      ],
    );
  }
}
```

### Example 3: Project Cards

```dart
class ProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: Card(
        child: Column(
          children: [
            // Project title with accessibility
            AccessibleText('Project Name'),

            // Description with scroll animation only
            ScrollAnimatedText('Project description...'),

            // Technologies with accessibility
            AccessibleText('Flutter, Firebase'),
          ],
        ),
      ),
    );
  }
}
```

## Language Change Integration

### With Accessibility System

```dart
// In your language switcher
void changeLanguage(Locale newLocale) {
  // Your existing language change logic
  context.setLocale(newLocale);

  // Trigger animation (optional - accessibility system handles it)
  LanguageChangeAnimationController().animateLanguageChange(
    context: context,
    settings: const LanguageChangeSettings.fast(),
    onComplete: () {
      print('Language changed with animation');
    },
  );
}
```

### Without Accessibility System

```dart
// Direct language change with animation
void changeLanguage(Locale newLocale) {
  LanguageChangeAnimationController().animateLanguageChange(
    context: context,
    settings: const LanguageChangeSettings.readingWave(),
    onComplete: () {
      // Update your app's locale after animation
      context.setLocale(newLocale);
    },
  );
}
```

## Debug and Testing

### Check Registered Texts

```dart
// Print debug info about registered texts
print(TextAnimationHelper.getDebugInfo());

// Output example:
// TextAnimationRegistry Debug Info:
// Total elements: 15
// Lines: [0, 1, 2, 3, 4]
// Blocks: [0, 1]
// Elements by line:
//   Line 0: "Camilo Santacruz", "Flutter Developer"
//   Line 1: "Portfolio", "About Me"
//   Line 2: "Skills", "Projects"
```

### Test Different Scenarios

```dart
// Test scroll animations
FadeInAnimation(
  child: ScrollAnimatedText('Test scroll animation'),
)

// Test language animations
LanguageAnimatedText('Test language animation'),

// Test both
FadeInAnimation(
  child: AccessibleText('Test both features'),
)
```

## Best Practices

### 1. Choose the Right Widget

- **`AccessibleText`** - When you need accessibility features
- **`ScrollAnimatedText`** - When you only need scroll animations
- **`LanguageAnimatedText`** - When you only need language animations
- **`AnimatedText`** - When you need both (default)

### 2. Performance Considerations

- Use `ScrollAnimatedText` for large lists to avoid unnecessary language registration
- Use `AccessibleText` for important content that needs accessibility
- Clear registered texts when widgets are disposed

### 3. Accessibility Integration

- The accessibility system automatically handles language changes
- Animation system respects accessibility skip settings
- Both systems can coexist without conflicts

### 4. Testing Strategy

- Test with accessibility features enabled/disabled
- Test with animations enabled/disabled
- Test language changes with different animation strategies
- Verify scroll animations work correctly

## Migration Guide

### From Regular Text Widgets

```dart
// Before
Text('Hello World')

// After (choose based on needs)
AnimatedText('Hello World')           // Both features
ScrollAnimatedText('Hello World')     // Scroll only
LanguageAnimatedText('Hello World')   // Language only
```

### From Accessibility Widgets

```dart
// Before
AccessibleText('Hello World')

// After (enhanced)
AccessibleText('Hello World')  // Now includes language animation
```

### From Animation Widgets

```dart
// Before
FadeInAnimation(child: Text('Hello World'))

// After
FadeInAnimation(child: ScrollAnimatedText('Hello World'))
```

This architecture gives you maximum flexibility while maintaining clean separation of concerns!
