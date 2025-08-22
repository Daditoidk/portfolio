import 'text_section.dart';
import 'text_line.dart';
import 'text_element.dart';

/// Main data model containing all text order information
class TextOrderData {
  final String id;
  final String name;
  final String description;
  final List<TextSection> sections;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String version;

  const TextOrderData({
    required this.id,
    required this.name,
    required this.description,
    required this.sections,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
    this.version = '1.0.0',
  });

  /// Create TextOrderData from JSON
  factory TextOrderData.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List<dynamic>? ?? [];
    final sections = sectionsJson
        .map(
          (sectionJson) =>
              TextSection.fromJson(sectionJson as Map<String, dynamic>),
        )
        .toList();

    return TextOrderData(
      id: json['id'] as String? ?? '',
      name: json['id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sections: sections,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      version: json['version'] as String? ?? '1.0.0',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sections': sections.map((section) => section.toJson()).toList(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
    };
  }

  /// Create a copy with modifications
  TextOrderData copyWith({
    String? id,
    String? name,
    String? description,
    List<TextSection>? sections,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? version,
  }) {
    return TextOrderData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sections: sections ?? this.sections,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  /// Get all text IDs from all sections
  List<String> get allTextIds {
    final ids = <String>[];
    for (final section in sections) {
      ids.addAll(section.allTextIds);
    }
    return ids;
  }

  /// Get all text content from all sections
  List<String> get allTextContents {
    final contents = <String>[];
    for (final section in sections) {
      contents.addAll(section.allTextContents);
    }
    return contents;
  }

  /// Get combined text content for the entire data
  String get combinedText => allTextContents.join(' ');

  /// Check if data contains a specific text ID
  bool containsTextId(String textId) => allTextIds.contains(textId);

  /// Get text element by ID across all sections
  TextElement? getTextElementById(String textId) {
    for (final section in sections) {
      final element = section.getTextElementById(textId);
      if (element != null) return element;
    }
    return null;
  }

  /// Get text content by ID
  String getTextById(String textId) {
    final element = getTextElementById(textId);
    return element?.text ?? '';
  }

  /// Get section by text ID
  TextSection? getSectionByTextId(String textId) {
    for (final section in sections) {
      if (section.containsTextId(textId)) {
        return section;
      }
    }
    return null;
  }

  /// Get line by text ID
  TextLine? getLineByTextId(String textId) {
    for (final section in sections) {
      final line = section.getLineByTextId(textId);
      if (line != null) return line;
    }
    return null;
  }

  /// Get sections sorted by order
  List<TextSection> get sortedSections {
    final sorted = List<TextSection>.from(sections);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  /// Get total number of text elements
  int get totalTextElements {
    return sections.fold(0, (sum, section) => sum + section.totalTextElements);
  }

  /// Get total number of lines
  int get totalLines {
    return sections.fold(0, (sum, section) => sum + section.lines.length);
  }

  /// Get total number of sections
  int get totalSections => sections.length;

  /// Get text elements by section name
  List<TextElement> getTextElementsBySectionName(String sectionName) {
    final section = sections.firstWhere(
      (s) => s.name == sectionName,
      orElse: () => TextSection(
        id: '',
        name: '',
        lines: [],
        order: 0,
        timestamp: DateTime.now(),
      ),
    );

    if (section.id.isEmpty) return [];

    final elements = <TextElement>[];
    for (final line in section.lines) {
      elements.addAll(line.detectedTexts);
    }
    return elements;
  }

  /// Get text content by section name
  String getTextBySectionName(String sectionName) {
    final elements = getTextElementsBySectionName(sectionName);
    return elements.map((e) => e.text).join(' ');
  }

  /// Check if data is empty
  bool get isEmpty => sections.isEmpty;

  /// Check if data is not empty
  bool get isNotEmpty => sections.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextOrderData &&
        other.id == id &&
        other.name == name &&
        other.version == version;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, version);
  }

  @override
  String toString() {
    return 'TextOrderData(id: $id, name: $name, sections: $totalSections, lines: $totalLines, texts: $totalTextElements)';
  }
}
