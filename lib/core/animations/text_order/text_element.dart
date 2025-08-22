/// Individual text element within a text line
class TextElement {
  final String id;
  final String text;
  final String style;
  final double fontSize;
  final String fontWeight;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const TextElement({
    required this.id,
    required this.text,
    required this.style,
    required this.fontSize,
    required this.fontWeight,
    required this.timestamp,
    this.metadata = const {},
  });

  /// Create TextElement from JSON
  factory TextElement.fromJson(Map<String, dynamic> json) {
    return TextElement(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      style: json['style'] as String? ?? '',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      fontWeight: json['fontWeight'] as String? ?? 'Normal',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'style': style,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy with modifications
  TextElement copyWith({
    String? id,
    String? text,
    String? style,
    double? fontSize,
    String? fontWeight,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return TextElement(
      id: id ?? this.id,
      text: text ?? this.text,
      style: style ?? this.style,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextElement &&
        other.id == id &&
        other.text == text &&
        other.style == style &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, text, style, fontSize, fontWeight, timestamp);
  }

  @override
  String toString() {
    return 'TextElement(id: $id, text: $text, style: $style, fontSize: $fontSize, fontWeight: $fontWeight)';
  }
}

