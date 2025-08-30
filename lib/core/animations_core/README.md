# Text Animation & Detection System

This directory contains the core text animation and detection system for the portfolio website. The system provides automatic text detection, classification, and animation capabilities for language changes and scroll effects.

## Components

### 1. Text Animation Registry (`text_animation_registry.dart`)

The central registry that tracks all text elements on the page and manages their animation states.

**Key Features:**

- Global text element tracking
- Automatic line and block detection
- Manual override support
- Position-based organization
- Content-based classification

**Usage:**

```dart
// Register a text element
TextAnimationRegistry().registerText(
  context: context,
  text: "Hello World",
  id: "greeting",
  key: myGlobalKey,
);

// Get sorted elements
final elements = TextAnimationRegistry().getSortedElements();

// Configure detection parameters
TextAnimationRegistry().setLineThreshold(25.0);
TextAnimationRegistry().setBlockSize(5);
```

### 2. Text Detection System (`text_detection_system.dart`)

Advanced text detection and classification system that automatically analyzes and organizes text elements.

**Key Features:**

- **Content Pattern Recognition**: Identifies text based on keywords and patterns
- **Position-Based Detection**: Groups text by Y-position with configurable thresholds
- **Smart Classification**: Automatically assigns sections and line numbers
- **Confidence Scoring**: Provides accuracy metrics for each detection
- **Multi-Language Support**: Works with English and Spanish content
- **Export Capabilities**: JSON export for analysis and debugging

**Configuration:**

```dart
final detectionSystem = TextDetectionSystem();

detectionSystem.configure(
  lineThreshold: 25.0,        // Pixels between lines
  sectionThreshold: 150.0,    // Pixels between sections
  enableSmartDetection: true, // Use advanced algorithms
  enableContentAnalysis: true, // Analyze text content
  enablePositionTracking: true, // Track position changes
);
```

**Usage:**

```dart
// Detect and classify text elements
final elements = await detectionSystem.detectTextElements(context);

// Get detection statistics
final stats = detectionSystem.getDetectionStatistics(elements);

// Export results
final jsonData = detectionSystem.exportDetectionResults(elements);
```

### 3. Animated Text Widget (`animated_text_widget.dart`)

Widget wrapper that automatically registers text for animation and provides smooth transitions.

**Features:**

- Automatic registration with animation registry
- Language change animation support
- Scroll-based animation support
- Accessibility integration

**Usage:**

```dart
AnimatedText(
  "Hello World",
  id: "greeting",
  style: TextStyle(fontSize: 24),
  registerForLanguageAnimation: true,
  registerForScrollAnimation: true,
)
```

### 4. Language Animated Text (`animated_text_widget.dart`)

Specialized widget for language change animations with manual positioning control.

**Features:**

- Manual line and block index overrides
- Language-specific animation timing
- Integration with accessibility system

**Usage:**

```dart
LanguageAnimatedText(
  "Hello World",
  id: "greeting",
  manualLineIndex: 0,
  manualBlockIndex: 1,
  style: TextStyle(fontSize: 24),
)
```

## Text Detection Algorithm

### 1. Content Analysis

The system analyzes text content using predefined patterns for each section:

- **Navigation**: portfolio, home, about, skills, resume, projects, contact
- **Header**: camilo, santacruz, abadiano, mobile developer
- **About**: about me, curious, passionate, technology, enthusiast
- **Skills**: flutter, dart, kotlin, swift, design, animation
- **Resume**: resume, curriculum, download, experience
- **Projects**: projects, recent, selection, brain4goals
- **Contact**: contact, email, phone, location, colombia

### 2. Position Detection

Text elements are grouped into lines and sections based on Y-position:

- **Line Detection**: Groups text within `lineThreshold` pixels (default: 25px)
- **Section Detection**: Groups lines within `sectionThreshold` pixels (default: 150px)
- **Smart Positioning**: Adjusts thresholds based on content analysis

### 3. Confidence Scoring

Each detection receives a confidence score (0.0-10.0):

- **High (7.0-10.0)**: Strong content match + good positioning
- **Medium (4.0-6.9)**: Moderate content match or positioning
- **Low (0.0-3.9)**: Weak content match or poor positioning

## Integration with Portfolio

### 1. Automatic Registration

Text elements are automatically registered when using:

- `AccessibleText` widget
- `AnimatedText` widget
- `LanguageAnimatedText` widget

### 2. Section Mapping

The system maps detected text to portfolio sections:

```dart
final sectionOrder = {
  'navigation': 0,
  'header': 1,
  'about': 2,
  'skills': 3,
  'resume': 4,
  'projects': 5,
  'contact': 6,
  'footer': 7,
};
```

### 3. Line Organization

Text is organized into lines (0-32) for precise animation control:

- **Line 0**: Navigation elements
- **Lines 1-3**: Header content
- **Lines 4-6**: About section
- **Lines 7-18**: Skills and technologies
- **Lines 19-22**: Resume section
- **Lines 23-27**: Projects showcase
- **Lines 28-30**: Contact information
- **Line 31+**: Footer content

## Debug and Testing

### 1. Text Detection Debug (`text_detection_debug.dart`)

Full-featured debug interface for testing the detection system:

- Real-time configuration controls
- Detection results visualization
- Confidence score analysis
- Export capabilities
- Statistics dashboard

### 2. Quick Detection Dialog

Fast analysis dialog for quick testing:

- Instant text detection
- Summary statistics
- Quick element overview
- Link to full debug interface

### 3. Lab Integration

The text detection system is integrated into the lab screen for easy testing:

```dart
// In lab_screen.dart
Positioned(
  bottom: 160,
  right: 20,
  child: const TextDetectionIntegration(),
),
```

## Configuration Options

### Detection Thresholds

```dart
// Line detection sensitivity
lineThreshold: 25.0,        // Lower = more precise lines

// Section detection sensitivity
sectionThreshold: 150.0,    // Lower = more sections

// Smart detection features
enableSmartDetection: true,     // Advanced algorithms
enableContentAnalysis: true,    // Text pattern matching
enablePositionTracking: true,   // Real-time updates
```

### Pattern Customization

You can customize text patterns for better classification:

```dart
// Add custom patterns to TextDetectionSystem
final customPatterns = {
  'custom_section': [
    'custom_keyword',
    'another_pattern',
    'more_keywords',
  ],
};
```

## Performance Considerations

### 1. Registration Timing

- Text elements are registered after the frame is built
- Use `WidgetsBinding.instance.addPostFrameCallback` for timing control
- Avoid registering during build phase

### 2. Position Updates

- Position updates are batched for performance
- Use `_isDirty` flag to avoid unnecessary recalculations
- Manual overrides reduce computation overhead

### 3. Memory Management

- Text elements are automatically cleaned up
- Use `unregisterText()` for manual cleanup
- Registry size is typically small (< 100 elements)

## Troubleshooting

### Common Issues

1. **Text not detected**: Check if text is wrapped in `AccessibleText` or `AnimatedText`
2. **Wrong classification**: Verify text content matches expected patterns
3. **Position errors**: Ensure GlobalKey is properly assigned and accessible
4. **Performance issues**: Reduce position update frequency or disable smart detection

### Debug Steps

1. Use `TextDetectionDebug` to visualize detection results
2. Check confidence scores for classification accuracy
3. Verify text patterns match your content
4. Adjust thresholds for better detection sensitivity

## Future Enhancements

### Planned Features

- **Machine Learning**: Improved pattern recognition using ML models
- **Dynamic Patterns**: Learn patterns from user interactions
- **Performance Optimization**: GPU-accelerated position detection
- **Accessibility**: Better integration with screen readers
- **Internationalization**: Support for more languages

### Extension Points

The system is designed for easy extension:

- Custom classification algorithms
- Additional detection methods
- Integration with external services
- Custom export formats

## Contributing

When contributing to the text detection system:

1. **Follow Patterns**: Use existing code structure and naming conventions
2. **Test Thoroughly**: Test with various text content and layouts
3. **Document Changes**: Update this README and add code comments
4. **Performance**: Ensure changes don't impact performance significantly
5. **Accessibility**: Maintain accessibility compliance

## License

This text detection system is part of the portfolio project and follows the same licensing terms.
