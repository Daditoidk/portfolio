# Live Preview Text Scanner

This module provides real-time text detection and positioning for the portfolio's live preview in the Text Order Visualizer.

## 🔍 **How It Works**

### **1. Element Tree Traversal**

- Uses Flutter's Element tree to access rendered widgets
- Traverses recursively through all elements in the live preview
- **Currently detects Text widgets only** (RichText and SelectableText support planned)

### **2. Real Coordinate Calculation**

- Gets RenderBox from each text element
- Calculates absolute position using `localToGlobal(Offset.zero)`
- Returns precise Y coordinates for line detection

### **3. Text Data Extraction**

- Extracts text content, styling, and metadata
- Generates unique IDs for each text element
- Stores position data for line mapping

## 📋 **Classes**

### **`LivePreviewTextScanner`**

Main scanner class with static methods.

**Key Methods:**

- `scanLivePreview(BuildContext)` - Main entry point
- `_scanElementTreeRecursively()` - Recursive element traversal
- `_processTextElement()` - Process Text widgets
- `_processRichTextElement()` - **Commented out** (RichText support planned)
- `_processSelectableTextElement()` - **Commented out** (SelectableText support planned)

### **`DetectedText`**

Data model for detected text elements.

**Properties:**

- `id` - Unique identifier
- `text` - Text content
- `style` - Text styling information
- `xPosition` - X coordinate on page
- `yPosition` - Y coordinate on page
- `timestamp` - Detection timestamp

### **`TextStyleInfo`**

Text styling information container.

**Properties:**

- `fontSize` - Font size in pixels
- `fontWeight` - Font weight
- `color` - Text color
- `isBold` - Bold flag
- `isItalic` - Italic flag

## 🎯 **Usage**

```dart
// In text_order_visualizer.dart
void _runTextDetection() {
  final detectedTexts = LivePreviewTextScanner.scanLivePreview(
    _portfolioKey.currentContext!
  );

  // Map detected texts to lines
  for (final line in _lineStateManager.lines) {
    final textsInLine = detectedTexts.where((text) {
      return text.yPosition != null &&
             text.yPosition! >= line.yPosition &&
             text.yPosition! <= line.yPosition + line.height;
    }).toList();

    // Update line with detected texts
    _lineStateManager.updateLineTexts(line.id, textsInLine);
  }
}
```

## 🔧 **Performance Considerations**

### **Advantages:**

- ✅ Only scans live preview (isolated scope)
- ✅ Direct access to RenderBox (precise coordinates)
- ✅ No GlobalKey lookups (better web performance)
- ✅ Real-time position calculation
- ✅ Handles scroll positions automatically

### **Limitations:**

- ⚠️ Requires rendered elements (post-build)
- ⚠️ Element tree traversal has O(n) complexity
- ⚠️ Position calculation requires RenderBox

## 🐛 **Debugging**

### **Console Output:**

```
🔍 Starting live preview scan...
📍 Found text: "Camilo Santacruz Abadiano" at Y=120.5
📍 Found text: "Desarrollador Móvil" at Y=180.2
📍 Found text: "Sobre Mí" at Y=350.8
📊 Total texts detected: 25
```

**Note:** Currently only Text widgets are detected. RichText and SelectableText support is planned for future versions.

### **Common Issues:**

1. **No texts detected**: Check if context is valid and rendered
2. **Wrong coordinates**: Verify RenderBox has size
3. **Missing texts**: Ensure all text widgets are in element tree

## 🚀 **Integration**

### **With Text Order Visualizer:**

```dart
// Replace old TextAnimationRegistry scanning
final detectedTexts = LivePreviewTextScanner.scanLivePreview(context);

// Convert to line format
final lineTexts = detectedTexts.map((text) => {
  'id': text.id,
  'text': text.text,
  'y': text.yPosition,
  'x': text.xPosition,
}).toList();
```

### **With Line Detection:**

```dart
bool _isTextInLineBounds(DetectedText text, Line line) {
  if (text.yPosition == null) return false;

  return text.yPosition! >= line.yPosition &&
         text.yPosition! <= line.yPosition + line.height;
}
```

## 📈 **Future Enhancements**

- **Text Filtering**: Skip UI elements, buttons, etc.
- **Performance Optimization**: Batch processing, caching
- **Error Handling**: Better fallbacks for edge cases
- **Multi-line Text**: Handle text spans across multiple lines
- **Accessibility**: Screen reader compatibility

---

_This scanner provides the foundation for real-time text detection in the portfolio layout system._
