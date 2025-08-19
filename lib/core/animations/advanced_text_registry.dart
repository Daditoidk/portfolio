import 'package:flutter/material.dart';
import 'text_animation_registry.dart';

/// Advanced text registry with real-time position updates
class AdvancedTextRegistry {
  static final AdvancedTextRegistry _instance = AdvancedTextRegistry._internal();
  factory AdvancedTextRegistry() => _instance;
  AdvancedTextRegistry._internal();

  final Map<String, TextElement> _textElements = {};
  final List<TextElement> _sortedElements = [];
  bool _isDirty = true;
  
  // Configuration
  double _lineThreshold = 20.0;
  int _blockSize = 3;
  bool _autoUpdatePositions = true;

  /// Set line threshold (pixels between lines)
  void setLineThreshold(double threshold) {
    _lineThreshold = threshold;
    _isDirty = true;
  }

  /// Set block size (number of lines per block)
  void setBlockSize(int size) {
    _blockSize = size;
    _isDirty = true;
  }

  /// Enable/disable auto position updates
  void setAutoUpdatePositions(bool enabled) {
    _autoUpdatePositions = enabled;
  }

  /// Register a text element with advanced features
  void registerText({
    required BuildContext context,
    required String text,
    String? id,
    GlobalKey? key,
    bool autoUpdate = true,
  }) {
    final elementKey = key ?? GlobalKey();
    final elementId = id ?? '${text.hashCode}_${elementKey.hashCode}';
    
    // Get initial position
    final position = _getTextPosition(context, elementKey);
    
    final element = TextElement(
      text: text,
      id: id,
      key: elementKey,
      yPosition: position.dy,
      lineIndex: 0,
      blockIndex: 0,
    );
    
    _textElements[elementId] = element;
    _isDirty = true;
    
    // Set up auto position updates if enabled
    if (autoUpdate && _autoUpdatePositions) {
      _setupPositionUpdates(elementId, context);
    }
  }

  /// Set up automatic position updates for a text element
  void _setupPositionUpdates(String elementId, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_textElements.containsKey(elementId)) {
        _updateElementPosition(elementId, context);
      }
    });
  }

  /// Update position of a specific element
  void _updateElementPosition(String elementId, BuildContext context) {
    final element = _textElements[elementId];
    if (element != null) {
      try {
        final renderBox = element.key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          element.yPosition = position.dy;
          _isDirty = true;
        }
      } catch (e) {
        // Handle error gracefully
      }
    }
  }

  /// Get text position with error handling
  Offset _getTextPosition(BuildContext context, GlobalKey key) {
    try {
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        return renderBox.localToGlobal(Offset.zero);
      }
    } catch (e) {
      // Handle error gracefully
    }
    return Offset.zero;
  }

  /// Get all text elements sorted by position with advanced line detection
  List<TextElement> getSortedElements() {
    if (_isDirty) {
      _sortedElements.clear();
      _sortedElements.addAll(_textElements.values);
      _sortedElements.sort((a, b) => a.yPosition.compareTo(b.yPosition));
      
      _calculateAdvancedLineAndBlockIndices();
      _isDirty = false;
    }
    return _sortedElements;
  }

  /// Advanced line and block calculation with better detection
  void _calculateAdvancedLineAndBlockIndices() {
    if (_sortedElements.isEmpty) return;
    
    int currentLine = 0;
    int currentBlock = 0;
    double lastY = _sortedElements.first.yPosition;
    List<TextElement> currentLineElements = [];
    
    for (int i = 0; i < _sortedElements.length; i++) {
      final element = _sortedElements[i];
      
      // Check if this element is on a new line
      if ((element.yPosition - lastY).abs() > _lineThreshold) {
        // Process the previous line
        _processLineElements(currentLineElements, currentLine, currentBlock);
        
        // Start new line
        currentLine++;
        if (currentLine % _blockSize == 0) {
          currentBlock++;
        }
        lastY = element.yPosition;
        currentLineElements = [element];
      } else {
        // Same line
        currentLineElements.add(element);
      }
    }
    
    // Process the last line
    if (currentLineElements.isNotEmpty) {
      _processLineElements(currentLineElements, currentLine, currentBlock);
    }
  }

  /// Process elements in a line and update their indices
  void _processLineElements(List<TextElement> elements, int lineIndex, int blockIndex) {
    for (int i = 0; i < elements.length; i++) {
      final element = elements[i];
      final elementIndex = _sortedElements.indexOf(element);
      
      if (elementIndex != -1) {
        _sortedElements[elementIndex] = TextElement(
          text: element.text,
          id: element.id,
          key: element.key,
          yPosition: element.yPosition,
          lineIndex: lineIndex,
          blockIndex: blockIndex,
          isVisible: element.isVisible,
        );
      }
    }
  }

  /// Get text elements by line index with validation
  List<TextElement> getElementsByLine(int lineIndex) {
    final elements = getSortedElements();
    return elements.where((element) => element.lineIndex == lineIndex).toList();
  }

  /// Get text elements by block index with validation
  List<TextElement> getElementsByBlock(int blockIndex) {
    final elements = getSortedElements();
    return elements.where((element) => element.blockIndex == blockIndex).toList();
  }

  /// Get all line indices sorted
  List<int> getLineIndices() {
    final elements = getSortedElements();
    return elements.map((e) => e.lineIndex).toSet().toList()..sort();
  }

  /// Get all block indices sorted
  List<int> getBlockIndices() {
    final elements = getSortedElements();
    return elements.map((e) => e.blockIndex).toSet().toList()..sort();
  }

  /// Get text elements by section (custom grouping)
  List<TextElement> getElementsBySection(String sectionId) {
    return _textElements.values
        .where((element) => element.id?.startsWith(sectionId) == true)
        .toList();
  }

  /// Get elements within a specific Y range
  List<TextElement> getElementsInRange(double startY, double endY) {
    final elements = getSortedElements();
    return elements
        .where((element) => element.yPosition >= startY && element.yPosition <= endY)
        .toList();
  }

  /// Get elements visible in viewport
  List<TextElement> getVisibleElements(double viewportHeight) {
    final elements = getSortedElements();
    return elements
        .where((element) => element.yPosition >= 0 && element.yPosition <= viewportHeight)
        .toList();
  }

  /// Update positions of all elements
  void updateAllPositions() {
    for (final element in _textElements.values) {
      try {
        final renderBox = element.key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          element.yPosition = position.dy;
        }
      } catch (e) {
        // Handle error gracefully
      }
    }
    _isDirty = true;
  }

  /// Unregister a text element
  void unregisterText(String id) {
    _textElements.remove(id);
    _isDirty = true;
  }

  /// Clear all registered text elements
  void clear() {
    _textElements.clear();
    _sortedElements.clear();
    _isDirty = true;
  }

  /// Get detailed debug information
  String getDetailedDebugInfo() {
    final elements = getSortedElements();
    final lineIndices = getLineIndices();
    final blockIndices = getBlockIndices();
    
    StringBuffer buffer = StringBuffer();
    buffer.writeln('AdvancedTextRegistry Debug Info:');
    buffer.writeln('Total elements: ${elements.length}');
    buffer.writeln('Lines: $lineIndices');
    buffer.writeln('Blocks: $blockIndices');
    buffer.writeln('Line threshold: $_lineThreshold');
    buffer.writeln('Block size: $_blockSize');
    buffer.writeln('Auto update positions: $_autoUpdatePositions');
    buffer.writeln('');
    
    // Elements by line
    buffer.writeln('Elements by line:');
    for (int line in lineIndices) {
      final lineElements = getElementsByLine(line);
      buffer.writeln('  Line $line (${lineElements.length} elements):');
      for (final element in lineElements) {
        buffer.writeln('    - "${element.text}" (Y: ${element.yPosition.toStringAsFixed(1)})');
      }
    }
    
    buffer.writeln('');
    
    // Elements by block
    buffer.writeln('Elements by block:');
    for (int block in blockIndices) {
      final blockElements = getElementsByBlock(block);
      buffer.writeln('  Block $block (${blockElements.length} elements):');
      for (final element in blockElements) {
        buffer.writeln('    - "${element.text}" (Line: ${element.lineIndex})');
      }
    }
    
    return buffer.toString();
  }

  /// Get statistics about the registry
  Map<String, dynamic> getStatistics() {
    final elements = getSortedElements();
    final lineIndices = getLineIndices();
    final blockIndices = getBlockIndices();
    
    return {
      'totalElements': elements.length,
      'totalLines': lineIndices.length,
      'totalBlocks': blockIndices.length,
      'averageElementsPerLine': elements.isEmpty ? 0 : elements.length / lineIndices.length,
      'averageElementsPerBlock': elements.isEmpty ? 0 : elements.length / blockIndices.length,
      'lineThreshold': _lineThreshold,
      'blockSize': _blockSize,
      'autoUpdatePositions': _autoUpdatePositions,
    };
  }
}

/// Widget that automatically registers with advanced features
class AdvancedAnimatedText extends StatelessWidget {
  final String text;
  final String? id;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;
  
  // Advanced features
  final bool autoUpdatePosition;
  final String? sectionId;
  
  const AdvancedAnimatedText(
    this.text, {
    super.key,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.autoUpdatePosition = true,
    this.sectionId,
  });
  
  @override
  Widget build(BuildContext context) {
    // Register with advanced features
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdvancedTextRegistry().registerText(
        context: context,
        text: text,
        id: sectionId != null ? '${sectionId}_$id' : id,
        key: key as GlobalKey?,
        autoUpdate: autoUpdatePosition,
      );
    });
    
    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
} 