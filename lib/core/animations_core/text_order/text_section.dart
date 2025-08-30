import 'text_line.dart';
import 'text_element.dart';

/// A section of content containing multiple text lines
class TextSection {
  final String id;
  final String name;
  final List<TextLine> lines;
  final int order;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  const TextSection({
    required this.id,
    required this.name,
    required this.lines,
    required this.order,
    this.properties = const {},
    required this.timestamp,
  });

  /// Create TextSection from JSON
  factory TextSection.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? [];
    final lines = linesJson
        .map((lineJson) => TextLine.fromJson(lineJson as Map<String, dynamic>))
        .toList();

    return TextSection(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lines: lines,
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
      'name': name,
      'lines': lines.map((line) => line.toJson()).toList(),
      'order': order,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create a copy with modifications
  TextSection copyWith({
    String? id,
    String? name,
    List<TextLine>? lines,
    int? order,
    Map<String, dynamic>? properties,
    DateTime? timestamp,
  }) {
    return TextSection(
      id: id ?? this.id,
      name: name ?? this.name,
      lines: lines ?? this.lines,
      order: order ?? this.order,
      properties: properties ?? this.properties,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Get all text IDs from this section
  List<String> get allTextIds {
    final ids = <String>[];
    for (final line in lines) {
      ids.addAll(line.textIds);
    }
    return ids;
  }

  /// Get all text content from this section
  List<String> get allTextContents {
    final contents = <String>[];
    for (final line in lines) {
      contents.addAll(line.textContents);
    }
    return contents;
  }

  /// Get combined text content for the entire section
  String get combinedText => allTextContents.join(' ');

  /// Check if section contains a specific text ID
  bool containsTextId(String textId) => allTextIds.contains(textId);

  /// Get text element by ID across all lines
  TextElement? getTextElementById(String textId) {
    for (final line in lines) {
      final element = line.getTextElementById(textId);
      if (element != null) return element;
    }
    return null;
  }

  /// Get text content by ID
  String getTextById(String textId) {
    final element = getTextElementById(textId);
    return element?.text ?? '';
  }

  /// Get line by text ID
  TextLine? getLineByTextId(String textId) {
    for (final line in lines) {
      if (line.containsTextId(textId)) {
        return line;
      }
    }
    return null;
  }

  /// Get lines sorted by order
  List<TextLine> get sortedLines {
    final sorted = List<TextLine>.from(lines);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  /// Get total number of text elements
  int get totalTextElements {
    return lines.fold(0, (sum, line) => sum + line.detectedTexts.length);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextSection &&
        other.id == id &&
        other.name == name &&
        other.order == order &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, order, timestamp);
  }

  @override
  String toString() {
    return 'TextSection(id: $id, name: $name, order: $order, lines: ${lines.length}, texts: $totalTextElements)';
  }
}
