import 'package:flutter/material.dart';

/// Scans the live preview (PortfolioScreen) to detect text widgets and their positions
///
/// CURRENT SUPPORT:
/// - ✅ Text widgets (fully supported)
///
/// PLANNED SUPPORT:
/// - 🔄 RichText widgets (commented out for future)
/// - 🔄 SelectableText widgets (commented out for future)
class LivePreviewTextScanner {
  /// Scan the live preview for text widgets and return detected texts
  static List<DetectedText> scanLivePreview(BuildContext context) {
    final detectedTexts = <DetectedText>[];

    try {
      print('🔍 Starting live preview scan...');
      // Use Element tree traversal to get real coordinates
      final element = context as Element;
      _scanElementTreeRecursively(element, detectedTexts);
      _logScanResults(detectedTexts);
    } catch (e) {
      print('❌ Error scanning live preview: $e');
    }

    return detectedTexts;
  }

  /// Get AppBar height for coordinate correction
  static double getAppBarHeight() {
    return kToolbarHeight; // Standard AppBar height
  }

  /// Scan Element tree recursively to get real coordinates
  static void _scanElementTreeRecursively(
    Element element,
    List<DetectedText> texts,
  ) {
    try {
      // Check if this element represents a text widget
      if (element.widget is Text) {
        _processTextElement(element, texts);
      }
      // TODO: Add RichText support in the future
      // else if (element.widget is RichText) {
      //   _processRichTextElement(element, texts);
      // }
      // TODO: Add SelectableText support in the future
      // else if (element.widget is SelectableText) {
      //   _processSelectableTextElement(element, texts);
      // }

      // Continue scanning child elements
      element.visitChildren((childElement) {
        _scanElementTreeRecursively(childElement, texts);
      });
    } catch (e) {
      print('⚠️ Error scanning element: $e');
    }
  }

  /// Process a Text element and extract its position
  static void _processTextElement(Element element, List<DetectedText> texts) {
    final textWidget = element.widget as Text;
    final textContent = textWidget.data ?? '';

    // Skip empty or very short texts
    if (textContent.trim().isEmpty || textContent.length < 2) return;

    try {
      // Get the render object to calculate position
      final renderBox = element.renderObject as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        // Calculate absolute position on the page
        final position = renderBox.localToGlobal(Offset.zero);

        final detectedText = DetectedText(
          id: _generateTextId(textWidget.key, textContent),
          text: textContent,
          style: _extractTextStyleInfo(textWidget.style),
          timestamp: DateTime.now(),
        );

        // Set the real coordinates
        detectedText._setPosition(position.dx, position.dy);
        texts.add(detectedText);

        print(
          '📍 Found text: "$textContent" at Y=${position.dy.toStringAsFixed(1)}',
        );
      }
    } catch (e) {
      print('⚠️ Error processing text element: $e');
    }
  }

  /// Process a RichText element and extract its position
  /// TODO: Uncomment when RichText support is needed
  /*
  static void _processRichTextElement(
    Element element,
    List<DetectedText> texts,
  ) {
    final richTextWidget = element.widget as RichText;
    final textContent = _extractTextFromTextSpan(
      richTextWidget.text as TextSpan?,
    );

    // Skip empty texts
    if (textContent.trim().isEmpty || textContent.length < 2) return;

    try {
      // Get the render object to calculate position
      final renderBox = element.renderObject as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        // Calculate absolute position on the page
        final position = renderBox.localToGlobal(Offset.zero);

        final detectedText = DetectedText(
          id: _generateTextId(richTextWidget.key, textContent),
          text: textContent,
          style: _extractTextStyleInfo(
            (richTextWidget.text as TextSpan?)?.style,
          ),
          timestamp: DateTime.now(),
        );

        // Set the real coordinates
        detectedText._setPosition(position.dx, position.dy);
        texts.add(detectedText);

        print(
          '📍 Found rich text: "$textContent" at Y=${position.dy.toStringAsFixed(1)}',
        );
      }
    } catch (e) {
      print('⚠️ Error processing rich text element: $e');
    }
  }
  */

  /// Process a SelectableText element and extract its position
  static void _processSelectableTextElement(
    Element element,
    List<DetectedText> texts,
  ) {
    final selectableTextWidget = element.widget as SelectableText;
    final textContent = selectableTextWidget.data ?? '';

    // Skip empty or very short texts
    if (textContent.trim().isEmpty || textContent.length < 2) return;

    try {
      // Get the render object to calculate position
      final renderBox = element.renderObject as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        // Calculate absolute position on the page
        final position = renderBox.localToGlobal(Offset.zero);

        final detectedText = DetectedText(
          id: _generateTextId(selectableTextWidget.key, textContent),
          text: textContent,
          style: _extractTextStyleInfo(selectableTextWidget.style),
          timestamp: DateTime.now(),
        );

        // Set the real coordinates
        detectedText._setPosition(position.dx, position.dy);
        texts.add(detectedText);

        print(
          '📍 Found selectable text: "$textContent" at Y=${position.dy.toStringAsFixed(1)}',
        );
      }
    } catch (e) {
      print('⚠️ Error processing selectable text element: $e');
    }
  }

  /// Extract text content from TextSpan recursively
  static String _extractTextFromTextSpan(TextSpan? textSpan) {
    if (textSpan == null) return '';

    String text = textSpan.text ?? '';

    // Add text from children
    if (textSpan.children != null) {
      for (final child in textSpan.children!) {
        if (child is TextSpan) {
          text += _extractTextFromTextSpan(child);
        }
      }
    }

    return text;
  }

  /// Generate a unique ID for the text
  static String _generateTextId(Key? key, String text) {
    if (key != null) {
      return key.toString().replaceAll(RegExp(r'[^\w]'), '_');
    }

    // Generate ID from text content
    final cleanText = text
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();

    return 'text_${cleanText}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Extract text style information
  static TextStyleInfo _extractTextStyleInfo(TextStyle? style) {
    return TextStyleInfo(
      fontSize: style?.fontSize ?? 14.0,
      fontWeight: style?.fontWeight ?? FontWeight.normal,
      color: style?.color ?? Colors.black,
      isBold: style?.fontWeight == FontWeight.bold,
      isItalic: style?.fontStyle == FontStyle.italic,
    );
  }

  /// Log scan results for debugging
  static void _logScanResults(List<DetectedText> texts) {
    print('🔍 LivePreviewTextScanner Results:');
    print('📊 Total texts detected: ${texts.length}');

    for (int i = 0; i < texts.length; i++) {
      final text = texts[i];
      print('  ${i + 1}. ID: ${text.id}');
      print('     Text: "${text.text}"');
      print(
        '     Style: ${text.style.fontSize}px, ${text.style.isBold ? "Bold" : "Normal"}',
      );
      print('     Timestamp: ${text.timestamp}');
      print('');
    }
  }
}

/// Represents a detected text widget with its properties
class DetectedText {
  final String id;
  final String text;
  final TextStyleInfo style;
  final DateTime timestamp;
  double? _yPosition;
  double? _xPosition;

  DetectedText({
    required this.id,
    required this.text,
    required this.style,
    required this.timestamp,
  });

  /// Get Y position (calculated when needed)
  double? get yPosition => _yPosition;

  /// Get X position (calculated when needed)
  double? get xPosition => _xPosition;

  /// Get Y position relative to viewport (without AppBar)
  double? get yPositionViewport {
    if (_yPosition == null) return null;
    return _yPosition! - LivePreviewTextScanner.getAppBarHeight();
  }

  /// Get X position relative to viewport
  double? get xPositionViewport => _xPosition;

  /// Set position directly (used by scanner)
  void _setPosition(double x, double y) {
    _xPosition = x;
    _yPosition = y;
  }

  /// Calculate and set position from a BuildContext (legacy method)
  void calculatePosition(BuildContext context) {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        _xPosition = position.dx;
        _yPosition = position.dy;
      }
    } catch (e) {
      print('❌ Error calculating position for text "$text": $e');
    }
  }

  /// Convert to map for JSON export
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'fontSize': style.fontSize,
      'isBold': style.isBold,
      'isItalic': style.isItalic,
      'color': style.color.value,
      // Absolute coordinates (for export and real positioning)
      'xPosition': _xPosition,
      'yPosition': _yPosition,
      // Viewport coordinates (for UI display, without AppBar)
      'xPositionViewport': xPositionViewport,
      'yPositionViewport': yPositionViewport,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DetectedText(id: $id, text: "$text", y: $_yPosition)';
  }
}

/// Information about text styling
class TextStyleInfo {
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool isBold;
  final bool isItalic;

  TextStyleInfo({
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.isBold,
    required this.isItalic,
  });

  @override
  String toString() {
    return 'TextStyleInfo(size: ${fontSize}px, bold: $isBold, italic: $isItalic)';
  }
}
