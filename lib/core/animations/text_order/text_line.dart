import 'text_element.dart';

/// A line of text containing multiple text elements
class TextLine {
  final String id;
  final double yPosition;
  final List<TextElement> detectedTexts;
  final int order;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  const TextLine({
    required this.id,
    required this.yPosition,
    required this.detectedTexts,
    required this.order,
    this.properties = const {},
    required this.timestamp,
  });

  /// Create TextLine from JSON
  factory TextLine.fromJson(Map<String, dynamic> json) {
    final detectedTextsJson = json['detectedTexts'] as List<dynamic>? ?? [];
    final detectedTexts = detectedTextsJson
        .map(
          (textJson) => TextElement.fromJson(textJson as Map<String, dynamic>),
        )
        .toList();

    return TextLine(
      id: json['id'] as String? ?? '',
      yPosition: (json['yPosition'] as num?)?.toDouble() ?? 0.0,
      detectedTexts: detectedTexts,
      order: json['order'] as int? ?? 0,
      properties: json['properties'] as Map<String, dynamic>? ?? {},
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yPosition': yPosition,
      'detectedTexts': detectedTexts.map((text) => text.toJson()).toList(),
      'order': order,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create a copy with modifications
  TextLine copyWith({
    String? id,
    double? yPosition,
    List<TextElement>? detectedTexts,
    int? order,
    Map<String, dynamic>? properties,
    DateTime? timestamp,
  }) {
    return TextLine(
      id: id ?? this.id,
      yPosition: yPosition ?? this.yPosition,
      detectedTexts: detectedTexts ?? this.detectedTexts,
      order: order ?? this.order,
      properties: properties ?? this.properties,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Get all text IDs from this line
  List<String> get textIds => detectedTexts.map((text) => text.id).toList();

  /// Get all text content from this line
  List<String> get textContents =>
      detectedTexts.map((text) => text.text).toList();

  /// Get combined text content
  String get combinedText => textContents.join(' ');

  /// Check if line contains a specific text ID
  bool containsTextId(String textId) => textIds.contains(textId);

  /// Get text element by ID
  TextElement? getTextElementById(String textId) {
    try {
      return detectedTexts.firstWhere((text) => text.id == textId);
    } catch (e) {
      return null;
    }
  }

  /// Get text content by ID
  String getTextById(String textId) {
    final element = getTextElementById(textId);
    return element?.text ?? '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextLine &&
        other.id == id &&
        other.yPosition == yPosition &&
        other.order == order &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, yPosition, order, timestamp);
  }

  @override
  String toString() {
    return 'TextLine(id: $id, yPosition: $yPosition, order: $order, texts: ${detectedTexts.length})';
  }
}

