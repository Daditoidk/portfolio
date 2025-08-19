import 'package:flutter/material.dart';
import 'dart:convert';

/// Represents a detected text element with position and content information
class DetectedTextElement {
  final String text;
  final String? id;
  final Offset position;
  final Size size;
  final String? section;
  final double confidence;
  final Map<String, dynamic> metadata;

  DetectedTextElement({
    required this.text,
    this.id,
    required this.position,
    required this.size,
    this.section,
    this.confidence = 1.0,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'id': id,
      'position': {'x': position.dx, 'y': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'section': section,
      'confidence': confidence,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'DetectedTextElement(text: "$text", position: $position, section: $section)';
  }
}

/// Text detection system that analyzes and visualizes text elements on the page
class TextDetectionSystem {
  static final TextDetectionSystem _instance = TextDetectionSystem._internal();
  factory TextDetectionSystem() => _instance;
  TextDetectionSystem._internal();

  bool _isActive = false;
  final List<DetectedTextElement> _detectedElements = [];
  final Map<String, GlobalKey> _textKeys = {};

  /// Check if text detection is currently active
  bool get isActive => _isActive;

  /// Get the list of detected text elements
  List<DetectedTextElement> get detectedElements => List.unmodifiable(_detectedElements);

  /// Activate text detection
  void activate() {
    _isActive = true;
    _detectTextElements();
  }

  /// Deactivate text detection
  void deactivate() {
    _isActive = false;
    _detectedElements.clear();
  }

  /// Toggle text detection state
  void toggle() {
    if (_isActive) {
      deactivate();
    } else {
      activate();
    }
  }

  /// Register a text element for detection
  void registerTextElement({
    required String text,
    String? id,
    required GlobalKey key,
    String? section,
  }) {
    final elementId = id ?? '${text.hashCode}_${key.hashCode}';
    _textKeys[elementId] = key;
    
    if (_isActive) {
      _detectTextElements();
    }
  }

  /// Unregister a text element
  void unregisterTextElement(String id) {
    _textKeys.remove(id);
    _detectedElements.removeWhere((element) => element.id == id);
  }

  /// Detect text elements on the current page
  void _detectTextElements() {
    _detectedElements.clear();
    
    for (final entry in _textKeys.entries) {
      final elementId = entry.key;
      final key = entry.value;
      
      if (key.currentContext != null) {
        final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          
          // Try to find the text content from the widget
          final text = _extractTextFromWidget(key.currentContext!);
          
          if (text.isNotEmpty) {
            final element = DetectedTextElement(
              text: text,
              id: elementId,
              position: position,
              size: size,
              section: _classifySection(text, position),
              confidence: _calculateConfidence(text, position),
              metadata: _extractMetadata(key.currentContext!),
            );
            
            _detectedElements.add(element);
          }
        }
      }
    }
  }

  /// Extract text content from a widget context
  String _extractTextFromWidget(BuildContext context) {
    try {
      // This is a simplified text extraction
      // In a real implementation, you might want to traverse the widget tree
      // or use reflection to get the actual text content
      return 'Sample Text'; // Placeholder
    } catch (e) {
      return '';
    }
  }

  /// Classify text into sections based on content and position
  String? _classifySection(String text, Offset position) {
    final lowerText = text.toLowerCase();
    
    // Content-based classification
    if (lowerText.contains('portfolio') || lowerText.contains('home')) return 'navigation';
    if (lowerText.contains('camilo') || lowerText.contains('santacruz')) return 'header';
    if (lowerText.contains('about') || lowerText.contains('me')) return 'about';
    if (lowerText.contains('skill') || lowerText.contains('flutter')) return 'skills';
    if (lowerText.contains('resume') || lowerText.contains('experience')) return 'resume';
    if (lowerText.contains('project') || lowerText.contains('demo')) return 'projects';
    if (lowerText.contains('contact') || lowerText.contains('email')) return 'contact';
    
    // Position-based classification (simplified)
    if (position.dy < 100) return 'header';
    if (position.dy < 300) return 'about';
    if (position.dy < 600) return 'skills';
    if (position.dy < 900) return 'resume';
    if (position.dy < 1200) return 'projects';
    if (position.dy < 1500) return 'contact';
    
    return 'other';
  }

  /// Calculate confidence score for detection
  double _calculateConfidence(String text, Offset position) {
    double confidence = 1.0;
    
    // Reduce confidence for very short text
    if (text.length < 3) confidence *= 0.7;
    
    // Reduce confidence for text at extreme positions
    if (position.dy < 0 || position.dy > 2000) confidence *= 0.8;
    
    return confidence.clamp(0.0, 1.0);
  }

  /// Extract metadata from widget context
  Map<String, dynamic> _extractMetadata(BuildContext context) {
    try {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;
      
      return {
        'theme': theme.brightness.name,
        'textStyle': textTheme.bodyMedium?.fontSize?.toString() ?? 'unknown',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Export detection results as JSON
  String exportDetectionResults() {
    if (!_isActive) {
      throw StateError('Text detection must be active to export results');
    }
    
    final exportData = {
      'timestamp': DateTime.now().toIso8601String(),
      'detectionActive': _isActive,
      'totalElements': _detectedElements.length,
      'elements': _detectedElements.map((e) => e.toJson()).toList(),
      'summary': {
        'sections': _getSectionSummary(),
        'confidence': _getConfidenceSummary(),
      },
    };
    
    return jsonEncode(exportData);
  }

  /// Get summary of detected sections
  Map<String, int> _getSectionSummary() {
    final summary = <String, int>{};
    for (final element in _detectedElements) {
      final section = element.section ?? 'unknown';
      summary[section] = (summary[section] ?? 0) + 1;
    }
    return summary;
  }

  /// Get confidence score summary
  Map<String, double> _getConfidenceSummary() {
    if (_detectedElements.isEmpty) return {};
    
    final confidences = _detectedElements.map((e) => e.confidence).toList();
    final avgConfidence = confidences.reduce((a, b) => a + b) / confidences.length;
    final minConfidence = confidences.reduce((a, b) => a < b ? a : b);
    final maxConfidence = confidences.reduce((a, b) => a > b ? a : b);
    
    return {
      'average': avgConfidence,
      'minimum': minConfidence,
      'maximum': maxConfidence,
    };
  }

  /// Get detection statistics
  Map<String, dynamic> getDetectionStatistics() {
    return {
      'isActive': _isActive,
      'totalElements': _detectedElements.length,
      'sections': _getSectionSummary(),
      'confidence': _getConfidenceSummary(),
      'lastDetection': _detectedElements.isNotEmpty ? DateTime.now().toIso8601String() : null,
    };
  }

  /// Clear all detected elements
  void clearDetections() {
    _detectedElements.clear();
  }

  /// Force a new detection cycle
  void refreshDetection() {
    if (_isActive) {
      _detectTextElements();
    }
  }
}
