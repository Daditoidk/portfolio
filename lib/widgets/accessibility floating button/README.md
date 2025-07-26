# Accessibility Floating Button - Mason Brick

A comprehensive Flutter accessibility component designed as a Mason brick for easy integration across projects. This component provides a complete accessibility solution with a floating button that opens a menu with various accessibility features.

## Features

- **Floating Accessibility Button**: Easy-to-access button that opens the accessibility menu
- **Comprehensive Accessibility Settings**: 13+ accessibility features including contrast, text scaling, animations, and more
- **Automatic Widget Integration**: All widgets automatically respond to accessibility settings
- **Multi-language Support**: Built-in support for English, Spanish, and Japanese
- **Reusable Components**: Designed as bricks for Mason templates for easy reuse across projects
- **Test Coverage**: Each widget includes comprehensive test files
- **Customizable**: All widgets support custom styling and behavior

## Folder Structure

```
accessibility floating button/
├── core/                    # Core functionality and state management
│   ├── accessibility_settings.dart
│   └── accessibility_text_style.dart
├── widgets/                 # Reusable accessibility widgets
│   ├── accessible_text.dart
│   ├── accessible_tooltip.dart
│   ├── accessible_high_contrast.dart
│   ├── accessible_hide_images.dart
│   ├── accessible_highlight_links.dart
│   ├── accessible_pause_animations.dart
│   ├── accessible_custom_cursor.dart
│   ├── accessible_page_structure.dart
│   └── accessible_text_align.dart
├── features/               # Feature-specific implementations
│   ├── accessibility_menu.dart
│   └── accessibility_menu_content.dart
├── themes/                 # Theme and styling
│   └── accessibility_menu_theme.dart
├── utils/                  # Utility functions and helpers
├── docs/                   # Documentation
└── README.md              # This file
```

## Accessibility Features

### Core Settings

- **Font Size Scaling** (0-3 levels): Adjust text size for better readability
- **Letter Spacing** (0-3 levels): Increase spacing between letters
- **Line Height** (0-3 levels): Adjust spacing between lines
- **Text Alignment** (0-3 levels): Left, center, right, or justify text
- **Saturation** (0-3 levels): Adjust color saturation

### Toggle Features

- **High Contrast**: Apply high contrast colors and styling
- **Dyslexia Font**: Use OpenDyslexic font for better readability
- **Hide Images**: Replace images with descriptive text
- **Highlight Links**: Visually highlight clickable elements
- **Pause Animations**: Disable animations and transitions
- **Custom Cursor**: Show custom cursors for clickable elements
- **Tooltips**: Enable/disable tooltip display
- **Page Structure**: Show page structure overlay

## Widgets Overview

### 1. AccessibleHighContrast

Applies high contrast styling when the accessibility setting is enabled.

```dart
AccessibleHighContrast(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  child: YourContent(),
)
```

### 2. AccessibleHideImages

Hides images and shows alt text when the hide images setting is enabled.

```dart
AccessibleHideImages(
  altText: "Description of the image",
  child: Image.asset('path/to/image.png'),
)
```

### 3. AccessibleHighlightLinks

Highlights clickable elements when the highlight links setting is enabled.

```dart
AccessibleHighlightLinks(
  highlightColor: Colors.blue,
  child: YourClickableContent(),
)
```

### 4. AccessiblePauseAnimations

Pauses animations when the pause animations setting is enabled.

```dart
AccessiblePauseAnimations(
  child: AnimatedContainer(
    duration: Duration(seconds: 1),
    child: YourAnimatedContent(),
  ),
)
```

### 5. AccessibleCustomCursor

Shows custom cursors when the custom cursor setting is enabled.

```dart
AccessibleCustomCursor(
  customCursor: SystemMouseCursors.click,
  child: YourClickableWidget(),
)
```

### 6. AccessiblePageStructure

Shows page structure overlay when the page structure setting is enabled.

```dart
AccessiblePageStructure(
  structureItems: [
    PageStructureItem(
      label: "Header",
      type: PageStructureType.heading,
    ),
  ],
  child: YourPageContent(),
)
```

### 7. AccessibleTextAlign

Applies text alignment based on accessibility settings.

```dart
AccessibleTextAlign(
  child: Text("Your text content"),
)
```

### 8. AccessibleText

A specialized Text widget that respects all accessibility settings.

```dart
AccessibleText(
  'Your text content',
  baseFontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.black,
)
```

### 9. AccessibleTooltip

A specialized Tooltip widget that applies accessibility styling.

```dart
AccessibleTooltip(
  message: "This is a tooltip message",
  baseFontSize: 12,
  color: Colors.white,
  child: Container(
    padding: EdgeInsets.all(8),
    child: Text("Hover me for tooltip"),
  ),
)
```

## Specialized Widgets

### AccessibleImage

A specialized Image widget that automatically handles accessibility hiding.

```dart
AccessibleImage(
  imagePath: 'assets/image.png',
  altText: 'Description of the image',
  width: 200,
  height: 150,
)
```

### AccessibleInkWell

A specialized InkWell that automatically applies link highlighting.

```dart
AccessibleInkWell(
  onTap: () => print('Tapped'),
  child: Text('Clickable Text'),
)
```

### AccessibleGestureDetector

A specialized GestureDetector that automatically applies link highlighting.

```dart
AccessibleGestureDetector(
  onTap: () => print('Tapped'),
  child: Text('Clickable Text'),
)
```

### AccessibleAnimatedContainer

A specialized AnimatedContainer that respects pause animations setting.

```dart
AccessibleAnimatedContainer(
  duration: Duration(seconds: 1),
  child: YourContent(),
)
```

### AccessibleAnimatedOpacity

A specialized AnimatedOpacity that respects pause animations setting.

```dart
AccessibleAnimatedOpacity(
  opacity: 0.5,
  child: YourContent(),
)
```

### AccessibleAnimatedSwitcher

A specialized AnimatedSwitcher that respects pause animations setting.

```dart
AccessibleAnimatedSwitcher(
  child: YourContent(),
)
```

### AccessibleHero

A specialized Hero that respects pause animations setting.

```dart
AccessibleHero(
  tag: 'hero-tag',
  child: YourContent(),
)
```

### AccessibleButton

A specialized button that shows custom cursors when accessibility is enabled.

```dart
AccessibleButton(
  onPressed: () => print('Pressed'),
  child: Text('Button Text'),
)
```

### AccessibleLink

A specialized link widget that shows custom cursors when accessibility is enabled.

```dart
AccessibleLink(
  onTap: () => print('Tapped'),
  child: Text('Link Text'),
)
```

### AccessibleRichText

A specialized RichText widget that respects text alignment settings.

```dart
AccessibleRichText(
  TextSpan(text: 'Your rich text content'),
)
```

### AccessibleTextField

A specialized TextField that respects text alignment settings.

```dart
AccessibleTextField(
  decoration: InputDecoration(labelText: 'Enter text'),
)
```

## Page Structure Types

The `PageStructureType` enum provides various types for page structure items:

- `heading` - Page headings
- `navigation` - Navigation elements
- `main` - Main content areas
- `section` - Content sections
- `article` - Article content
- `aside` - Sidebar content
- `footer` - Footer content
- `button` - Button elements
- `link` - Link elements
- `form` - Form elements
- `other` - Other elements

## Usage Examples

### Basic Integration

```dart
import 'package:your_app/widgets/accessibility floating button/widgets/accessible_high_contrast.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccessibleHighContrast(
      child: Column(
        children: [
          AccessibleText('Welcome to our app'),
          AccessibleImage(
            imagePath: 'assets/logo.png',
            altText: 'Company logo',
          ),
          AccessibleButton(
            onPressed: () => print('Button pressed'),
            child: Text('Click me'),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Integration

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: "Header",
          type: PageStructureType.heading,
        ),
        PageStructureItem(
          label: "Navigation",
          type: PageStructureType.navigation,
        ),
        PageStructureItem(
          label: "Main Content",
          type: PageStructureType.main,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: AccessibleText('My App'),
        ),
        body: AccessiblePauseAnimations(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AccessibleHideImages(
                  altText: "Hero image",
                  child: Image.asset('assets/hero.jpg'),
                ),
                AccessibleHighlightLinks(
                  child: Column(
                    children: [
                      AccessibleLink(
                        onTap: () => print('Link tapped'),
                        child: Text('Learn more'),
                      ),
                      AccessibleButton(
                        onPressed: () => print('Button pressed'),
                        child: Text('Get started'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Floating Button Integration

```dart
import 'package:your_app/widgets/accessibility floating button/features/accessibility_menu.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: YourContent(),
        floatingActionButton: AccessibilityMenu(
          languageCode: 'en',
          onLanguageChanged: (code) => print('Language changed to $code'),
          onPressed: () => print('Accessibility menu opened'),
        ),
      ),
    );
  }
}
```

## Testing

Each widget includes comprehensive test files that verify:

- Widget behavior when accessibility settings are disabled
- Widget behavior when accessibility settings are enabled
- Custom parameter handling
- Integration with accessibility settings provider

Run tests with:

```bash
flutter test test/accessible_*.dart
```

## Dependencies

These widgets require the following dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
```

## Accessibility Settings

All widgets automatically respond to the following accessibility settings:

- `highContrastEnabled` - High contrast mode
- `hideImages` - Hide/show images
- `highlightLinks` - Highlight clickable elements
- `pauseAnimations` - Pause/stop animations
- `customCursor` - Show custom cursors
- `pageStructureEnabled` - Show page structure overlay
- `textAlignLevel` - Text alignment (0-3)
- `fontSizeLevel` - Font size scaling (0-3)
- `letterSpacingLevel` - Letter spacing (0-3)
- `lineHeightLevel` - Line height (0-3)
- `saturationLevel` - Color saturation (0-3)
- `dyslexiaFontEnabled` - Dyslexia-friendly font
- `tooltipsEnabled` - Enable/disable tooltips

## Migration from Custom Tooltips

If you were using custom overlay-based tooltips, replace them with `AccessibleTooltip`:

**Before:**

```dart
GestureDetector(
  onTap: () => _showCustomTooltip(context, message),
  child: Container(...),
)
```

**After:**

```dart
AccessibleTooltip(
  message: message,
  child: Container(...),
)
```

This provides better accessibility, consistent styling, and automatic integration with the accessibility menu settings.

## Contributing

When adding new accessibility widgets:

1. Follow the existing naming convention (`Accessible[WidgetName]`)
2. Include comprehensive test coverage
3. Add documentation to this README
4. Ensure the widget automatically responds to relevant accessibility settings
5. Make the widget customizable and reusable
6. Place files in the appropriate folder structure

## License

This accessibility widgets collection is part of the portfolio web project and follows the same license terms.

---

## 📋 TODO List

### 🔧 **Immediate Fixes**

1. **✅ Header Navigation Fixed** - Changed sectionId from "header" to "home" to match portfolio screen key

### 🎯 **Page Structure Improvements**

2. **Research Landmarks** - Check what is a landmark and understand WCAG guidelines
3. **Fix Landmark Navigation** - Investigate why some landmarks send to sections but others don't
4. **Add Hierarchy Indentation** - Add space to the left in nested landmarks for better hierarchy understanding
5. **Implement L10n in Page Structure Dialog** - Add localization support to the page structure dialog

### 🎨 **UI/UX Enhancements**

6. **Add Tooltips to AFB and Language Switcher** - Implement tooltips for better user guidance
7. **Fix Custom Cursor Implementation** - Currently sets big cursor for entire page, should change cursor for specific widgets only
8. **Create Clickable Cursor Widget** - Make a dedicated widget for cursor changes to use throughout the project
9. **Apply Cursor Widget to Switch Flag and Expandable Chips** - Add the new cursor widget to the switch flag and expandable chips in skills section

### 🚀 **Feature Completion**

10. **Finish Projects Section Accessibility** - Complete accessibility implementation for projects section
11. **Complete Contact Section Accessibility** - Finish "Get in Touch" section accessibility features
12. **Hide Unimplemented Features** - Hide accessibility features that are not yet implemented
13. **Create Detailed B4S Project** - Develop the detailed B4S project implementation
14. **Update Contact Section with Real Data** - Replace placeholder data with real contact information

### 🔄 **Git Workflow**

15. **Create New Branch** - Create a new branch called "accessibility-floating-button" (corrected English)
16. **Push Changes** - Push all accessibility floating button changes to the new branch
17. **Merge B4S Demo Branch** - Merge the b4s_demo branch with main branch

### 📚 **Documentation & Research**

18. **Landmark Research** - Research WCAG landmark roles and their proper implementation
19. **Navigation Hierarchy** - Understand proper page structure navigation patterns
20. **Accessibility Guidelines** - Review WCAG 2.1 guidelines for proper implementation

### 🧪 **Testing & Quality**

21. **Test Page Structure Navigation** - Verify all landmarks navigate correctly
22. **Test Cursor Implementation** - Ensure cursor changes work properly on specific widgets
23. **Test L10n Implementation** - Verify localization works in page structure dialog
24. **Cross-browser Testing** - Test accessibility features across different browsers

### 🎯 **Priority Order**

**High Priority:**

- Items 2-5 (Page Structure improvements)
- Items 6-9 (UI/UX enhancements)
- Items 15-17 (Git workflow)

**Medium Priority:**

- Items 10-14 (Feature completion)
- Items 21-24 (Testing & Quality)

**Low Priority:**

- Items 18-20 (Documentation & Research)

---

_Last Updated: [Current Date]_
_Status: In Progress_
