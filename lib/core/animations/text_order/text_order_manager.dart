import 'dart:convert';
import 'text_order_data.dart';
import 'text_section.dart';
import 'text_line.dart';
import 'text_element.dart';
import 'text_order_parser.dart';

/// Main manager for text order data operations
class TextOrderManager {
  TextOrderData? _currentData;
  final List<TextOrderData> _dataHistory = [];
  final int _maxHistorySize = 10;

  /// Get current text order data
  TextOrderData? get currentData => _currentData;

  /// Get data history
  List<TextOrderData> get dataHistory => List.unmodifiable(_dataHistory);

  /// Check if there's current data
  bool get hasData => _currentData != null;

  /// Check if data is empty
  bool get isEmpty => _currentData?.isEmpty ?? true;

  /// Load text order data from JSON string
  Future<TextOrderData> loadFromJsonString(String jsonString) async {
    try {
      final data = TextOrderParser.parseFromJsonString(jsonString);
      await _setCurrentData(data);
      return data;
    } catch (e) {
      throw FormatException('Failed to load JSON string: $e');
    }
  }

  /// Load text order data from JSON Map
  Future<TextOrderData> loadFromJson(Map<String, dynamic> json) async {
    try {
      final data = TextOrderParser.parseFromJson(json);
      await _setCurrentData(data);
      return data;
    } catch (e) {
      throw FormatException('Failed to load JSON: $e');
    }
  }

  /// Load legacy format data
  Future<TextOrderData> loadFromLegacyFormat(Map<String, dynamic> json) async {
    try {
      final data = TextOrderParser.parseFromLegacyFormat(json);
      await _setCurrentData(data);
      return data;
    } catch (e) {
      throw FormatException('Failed to load legacy format: $e');
    }
  }

  /// Set current data and update history
  Future<void> _setCurrentData(TextOrderData data) async {
    // Add current data to history if it exists
    if (_currentData != null) {
      _addToHistory(_currentData!);
    }

    _currentData = data;
  }

  /// Add data to history
  void _addToHistory(TextOrderData data) {
    _dataHistory.add(data);

    // Keep history size manageable
    if (_dataHistory.length > _maxHistorySize) {
      _dataHistory.removeAt(0);
    }
  }

  /// Get text element by ID
  TextElement? getTextElementById(String textId) {
    return _currentData?.getTextElementById(textId);
  }

  /// Get text content by ID
  String getTextById(String textId) {
    return _currentData?.getTextById(textId) ?? '';
  }

  /// Get section by text ID
  TextSection? getSectionByTextId(String textId) {
    return _currentData?.getSectionByTextId(textId);
  }

  /// Get line by text ID
  TextLine? getLineByTextId(String textId) {
    return _currentData?.getLineByTextId(textId);
  }

  /// Get all text IDs
  List<String> getAllTextIds() {
    return _currentData?.allTextIds ?? [];
  }

  /// Get all text contents
  List<String> getAllTextContents() {
    return _currentData?.allTextContents ?? [];
  }

  /// Get combined text content
  String getCombinedText() {
    return _currentData?.combinedText ?? '';
  }

  /// Check if text ID exists
  bool containsTextId(String textId) {
    return _currentData?.containsTextId(textId) ?? false;
  }

  /// Get text elements by section name
  List<TextElement> getTextElementsBySectionName(String sectionName) {
    return _currentData?.getTextElementsBySectionName(sectionName) ?? [];
  }

  /// Get text content by section name
  String getTextBySectionName(String sectionName) {
    return _currentData?.getTextBySectionName(sectionName) ?? '';
  }

  /// Get sections sorted by order
  List<TextSection> getSortedSections() {
    return _currentData?.sortedSections ?? [];
  }

  /// Get lines sorted by order
  List<TextLine> getSortedLines() {
    final sections = getSortedSections();
    final allLines = <TextLine>[];

    for (final section in sections) {
      allLines.addAll(section.sortedLines);
    }

    return allLines;
  }

  /// Get total statistics
  Map<String, int> getStatistics() {
    if (_currentData == null) {
      return {'sections': 0, 'lines': 0, 'texts': 0};
    }

    return {
      'sections': _currentData!.totalSections,
      'lines': _currentData!.totalLines,
      'texts': _currentData!.totalTextElements,
    };
  }

  /// Export current data to JSON string
  String exportToJsonString({bool pretty = true}) {
    if (_currentData == null) {
      throw StateError('No data to export');
    }

    final json = _currentData!.toJson();
    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } else {
      return jsonEncode(json);
    }
  }

  /// Export current data to JSON Map
  Map<String, dynamic> exportToJson() {
    if (_currentData == null) {
      throw StateError('No data to export');
    }

    return _currentData!.toJson();
  }

  /// Clear current data
  void clear() {
    if (_currentData != null) {
      _addToHistory(_currentData!);
      _currentData = null;
    }
  }

  /// Undo last operation (restore from history)
  bool undo() {
    if (_dataHistory.isEmpty) return false;

    final lastData = _dataHistory.removeLast();
    if (_currentData != null) {
      _addToHistory(_currentData!);
    }
    _currentData = lastData;
    return true;
  }

  /// Check if undo is available
  bool get canUndo => _dataHistory.isNotEmpty;

  /// Validate current data
  bool validate() {
    if (_currentData == null) return false;

    try {
      // Basic validation
      if (_currentData!.sections.isEmpty) return false;

      for (final section in _currentData!.sections) {
        if (section.lines.isEmpty) return false;

        for (final line in section.lines) {
          if (line.detectedTexts.isEmpty) return false;

          for (final text in line.detectedTexts) {
            if (text.id.isEmpty || text.text.isEmpty) return false;
          }
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (_currentData == null) {
      errors.add('No data loaded');
      return errors;
    }

    if (_currentData!.sections.isEmpty) {
      errors.add('No sections found');
    }

    for (int i = 0; i < _currentData!.sections.length; i++) {
      final section = _currentData!.sections[i];

      if (section.lines.isEmpty) {
        errors.add('Section "${section.name}" has no lines');
      }

      for (int j = 0; j < section.lines.length; j++) {
        final line = section.lines[j];

        if (line.detectedTexts.isEmpty) {
          errors.add('Line ${j + 1} in section "${section.name}" has no texts');
        }

        for (int k = 0; k < line.detectedTexts.length; k++) {
          final text = line.detectedTexts[k];

          if (text.id.isEmpty) {
            errors.add(
              'Text ${k + 1} in line ${j + 1} of section "${section.name}" has no ID',
            );
          }

          if (text.text.isEmpty) {
            errors.add(
              'Text ${k + 1} in line ${j + 1} of section "${section.name}" has no content',
            );
          }
        }
      }
    }

    return errors;
  }

  /// Get supported formats
  List<String> getSupportedFormats() {
    return TextOrderParser.getSupportedFormats();
  }

  /// Dispose resources
  void dispose() {
    _currentData = null;
    _dataHistory.clear();
  }
}

