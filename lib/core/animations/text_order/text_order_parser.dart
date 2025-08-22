import 'dart:convert';
import 'text_order_data.dart';
import 'text_section.dart';
import 'text_line.dart';
import 'text_element.dart';

/// Parser for converting JSON data into TextOrderData models
class TextOrderParser {
  /// Parse JSON string into TextOrderData
  static TextOrderData parseFromJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return parseFromJson(json);
    } catch (e) {
      throw FormatException('Failed to parse JSON string: $e');
    }
  }

  /// Parse JSON Map into TextOrderData
  static TextOrderData parseFromJson(Map<String, dynamic> json) {
    try {
      // Handle different JSON structures
      if (json.containsKey('sections')) {
        // Standard format with sections
        return TextOrderData.fromJson(json);
      } else if (json.containsKey('lines')) {
        // Format with lines directly (convert to single section)
        return _parseFromLinesFormat(json);
      } else if (json.containsKey('detectedTexts')) {
        // Format with detectedTexts directly (convert to single line in single section)
        return _parseFromDetectedTextsFormat(json);
      } else {
        throw FormatException(
          'Unknown JSON format. Expected sections, lines, or detectedTexts.',
        );
      }
    } catch (e) {
      throw FormatException('Failed to parse JSON: $e');
    }
  }

  /// Parse JSON that has lines structure
  static TextOrderData _parseFromLinesFormat(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? [];
    final lines = linesJson
        .map((lineJson) => TextLine.fromJson(lineJson as Map<String, dynamic>))
        .toList();

    // Create a single section with all lines
    final section = TextSection(
      id: 'main_section',
      name: 'Main Content',
      lines: lines,
      order: 0,
      timestamp: DateTime.now(),
    );

    return TextOrderData(
      id: json['id'] as String? ?? 'parsed_data',
      name: json['name'] as String? ?? 'Parsed Data',
      description: 'Data parsed from lines format',
      sections: [section],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Parse JSON that has detectedTexts structure
  static TextOrderData _parseFromDetectedTextsFormat(
    Map<String, dynamic> json,
  ) {
    final detectedTextsJson = json['detectedTexts'] as List<dynamic>? ?? [];
    final detectedTexts = detectedTextsJson
        .map(
          (textJson) => TextElement.fromJson(textJson as Map<String, dynamic>),
        )
        .toList();

    // Create a single line with all detected texts
    final line = TextLine(
      id: 'main_line',
      yPosition: (json['yPosition'] as num?)?.toDouble() ?? 0.0,
      detectedTexts: detectedTexts,
      order: 0,
      timestamp: DateTime.now(),
    );

    // Create a single section with the line
    final section = TextSection(
      id: 'main_section',
      name: 'Main Content',
      lines: [line],
      order: 0,
      timestamp: DateTime.now(),
    );

    return TextOrderData(
      id: json['id'] as String? ?? 'parsed_data',
      name: json['name'] as String? ?? 'Parsed Data',
      description: 'Data parsed from detectedTexts format',
      sections: [section],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Parse legacy format (from Text Order Visualizer)
  static TextOrderData parseFromLegacyFormat(Map<String, dynamic> json) {
    try {
      final lines = <TextLine>[];
      int lineOrder = 0;

      // Extract lines from the legacy format
      for (final entry in json.entries) {
        final key = entry.key;
        final value = entry.value;

        if (key.startsWith('L') && value is Map<String, dynamic>) {
          final yPosition = _extractYPosition(key);
          final detectedTexts = _extractDetectedTexts(value);

          if (detectedTexts.isNotEmpty) {
            final line = TextLine(
              id: key,
              yPosition: yPosition,
              detectedTexts: detectedTexts,
              order: lineOrder++,
              timestamp: DateTime.now(),
            );
            lines.add(line);
          }
        }
      }

      // Sort lines by Y position
      lines.sort((a, b) => a.yPosition.compareTo(b.yPosition));

      // Create a single section with all lines
      final section = TextSection(
        id: 'legacy_section',
        name: 'Legacy Content',
        lines: lines,
        order: 0,
        timestamp: DateTime.now(),
      );

      return TextOrderData(
        id: 'legacy_parsed_data',
        name: 'Legacy Parsed Data',
        description: 'Data parsed from legacy Text Order Visualizer format',
        sections: [section],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Failed to parse legacy format: $e');
    }
  }

  /// Extract Y position from line key (e.g., "L0" -> 0.0, "L1" -> 420.0)
  static double _extractYPosition(String lineKey) {
    try {
      final number = lineKey.substring(1);
      final yPositions = [
        0.0,
        420.0,
        540.0,
        600.0,
        660.0,
        720.0,
        780.0,
        840.0,
        900.0,
        960.0,
        1080.0,
        1140.0,
        1260.0,
        1320.0,
        1500.0,
        1620.0,
      ];
      final index = int.parse(number);
      if (index < yPositions.length) {
        return yPositions[index];
      }
      return index * 100.0; // Fallback calculation
    } catch (e) {
      return 0.0;
    }
  }

  /// Extract detected texts from legacy format
  static List<TextElement> _extractDetectedTexts(
    Map<String, dynamic> lineData,
  ) {
    final texts = <TextElement>[];
    int textOrder = 0;

    for (final entry in lineData.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key.startsWith('text_') && value is String) {
        final text = TextElement(
          id: key,
          text: value,
          style: 'Normal',
          fontSize: 14.0,
          fontWeight: 'Normal',
          timestamp: DateTime.now(),
          metadata: {'legacy_order': textOrder++},
        );
        texts.add(text);
      }
    }

    return texts;
  }

  /// Validate JSON structure
  static bool isValidJson(Map<String, dynamic> json) {
    try {
      // Check if it has at least one of the expected structures
      return json.containsKey('sections') ||
          json.containsKey('lines') ||
          json.containsKey('detectedTexts') ||
          _isLegacyFormat(json);
    } catch (e) {
      return false;
    }
  }

  /// Check if JSON is in legacy format
  static bool _isLegacyFormat(Map<String, dynamic> json) {
    return json.keys.any((key) => key.startsWith('L') && key.length > 1);
  }

  /// Get supported formats
  static List<String> getSupportedFormats() {
    return [
      'Standard (with sections)',
      'Lines format',
      'DetectedTexts format',
      'Legacy Text Order Visualizer format',
    ];
  }
}

