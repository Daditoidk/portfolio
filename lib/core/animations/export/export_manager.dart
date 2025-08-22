import '../base/index.dart';
import 'animation_exporter.dart';

/// Main coordinator for animation export operations
class ExportManager {
  static ExportManager? _instance;
  factory ExportManager() => _instance ??= ExportManager._internal();
  ExportManager._internal();

  /// Export an animation with the specified configuration
  static Map<String, dynamic> exportAnimation({
    required String animationType,
    required Map<String, dynamic> config,
    required ExportType exportType,
    String? widgetType,
    Map<String, dynamic>? textOrderData,
  }) {
    // Add metadata to config
    final enhancedConfig = Map<String, dynamic>.from(config);
    enhancedConfig['widgetType'] = widgetType;
    enhancedConfig['textOrder'] = textOrderData;

    return AnimationExporter.exportAnimation(
      animationType,
      enhancedConfig,
      exportType,
    );
  }

  /// Export animation as JSON file content
  static String exportAsJsonString({
    required String animationType,
    required Map<String, dynamic> config,
    String? widgetType,
    Map<String, dynamic>? textOrderData,
  }) {
    final exportData = exportAnimation(
      animationType: animationType,
      config: config,
      exportType: ExportType.json,
      widgetType: widgetType,
      textOrderData: textOrderData,
    );

    return _formatJson(exportData);
  }

  /// Export animation as Dart code string
  static String exportAsDartCodeString({
    required String animationType,
    required Map<String, dynamic> config,
  }) {
    final exportData = exportAnimation(
      animationType: animationType,
      config: config,
      exportType: ExportType.dartCode,
    );

    return exportData['code'] as String;
  }

  /// Get export file extension based on export type
  static String getFileExtension(ExportType exportType) {
    switch (exportType) {
      case ExportType.json:
        return 'json';
      case ExportType.dartCode:
        return 'dart';
    }
    // ignore: dead_code
    throw UnimplementedError('Unsupported export type: $exportType');
  }

  /// Get suggested filename for export
  static String getSuggestedFilename({
    required String animationType,
    required ExportType exportType,
    String? widgetType,
  }) {
    final widgetSuffix = widgetType != null ? '_$widgetType' : '';

    switch (exportType) {
      case ExportType.json:
        return '${animationType}_animation$widgetSuffix.json';
      case ExportType.dartCode:
        return '${animationType}_animation.dart';
    }
    // ignore: dead_code
    throw UnimplementedError('Unsupported export type: $exportType');
  }

  /// Validate export configuration
  static bool validateExportConfig({
    required String animationType,
    required Map<String, dynamic> config,
    required ExportType exportType,
  }) {
    try {
      // Basic validation
      if (animationType.isEmpty) return false;
      if (config.isEmpty) return false;

      // Type-specific validation
      switch (exportType) {
        case ExportType.json:
          // For JSON export, we need at least basic config
          return config.containsKey('properties') ||
              config.containsKey('settings');
        case ExportType.dartCode:
          // For Dart code export, we need at least duration
          return config.containsKey('duration') || config.containsKey('curve');
      }
      // ignore: dead_code
      throw UnimplementedError('Unsupported export type: $exportType');
    } catch (e) {
      return false;
    }
  }

  /// Get export preview (first few lines)
  static String getExportPreview({
    required String animationType,
    required Map<String, dynamic> config,
    required ExportType exportType,
    int maxLines = 10,
  }) {
    try {
      final exportData = exportAnimation(
        animationType: animationType,
        config: config,
        exportType: exportType,
      );

      switch (exportType) {
        case ExportType.json:
          return _getJsonPreview(exportData, maxLines);
        case ExportType.dartCode:
          return _getDartCodePreview(exportData['code'] as String, maxLines);
      }
      // ignore: dead_code
      throw UnimplementedError('Unsupported export type: $exportType');
    } catch (e) {
      return 'Error generating preview: $e';
    }
  }

  /// Format JSON with proper indentation
  static String _formatJson(Map<String, dynamic> data) {
    const encoder = JsonEncoder.withIndent;
    return encoder.convert(data);
  }

  /// Get JSON preview
  static String _getJsonPreview(Map<String, dynamic> data, int maxLines) {
    final jsonString = _formatJson(data);
    final lines = jsonString.split('\n');

    if (lines.length <= maxLines) {
      return jsonString;
    }

    final previewLines = lines.take(maxLines).toList();
    previewLines.add('...');
    previewLines.add('(showing $maxLines of ${lines.length} lines)');

    return previewLines.join('\n');
  }

  /// Get Dart code preview
  static String _getDartCodePreview(String code, int maxLines) {
    final lines = code.split('\n');

    if (lines.length <= maxLines) {
      return code;
    }

    final previewLines = lines.take(maxLines).toList();
    previewLines.add('...');
    previewLines.add('(showing $maxLines of ${lines.length} lines)');

    return previewLines.join('\n');
  }
}

/// JSON encoder with custom formatting
class JsonEncoder {
  static const JsonEncoder withIndent = JsonEncoder._();

  const JsonEncoder._();

  String convert(dynamic object) {
    return _convertWithIndent(object, 0);
  }

  String _convertWithIndent(dynamic object, int indentLevel) {
    final indent = '  ' * indentLevel;

    if (object is Map) {
      if (object.isEmpty) return '{}';

      final entries = object.entries.toList();
      final buffer = StringBuffer('{\n');

      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final isLast = i == entries.length - 1;

        buffer.write('$indent  "${entry.key}": ');
        buffer.write(_convertWithIndent(entry.value, indentLevel + 1));

        if (!isLast) buffer.write(',');
        buffer.write('\n');
      }

      buffer.write('$indent}');
      return buffer.toString();
    } else if (object is List) {
      if (object.isEmpty) return '[]';

      final buffer = StringBuffer('[\n');

      for (int i = 0; i < object.length; i++) {
        final isLast = i == object.length - 1;

        buffer.write('$indent  ');
        buffer.write(_convertWithIndent(object[i], indentLevel + 1));

        if (!isLast) buffer.write(',');
        buffer.write('\n');
      }

      buffer.write('$indent]');
      return buffer.toString();
    } else if (object is String) {
      return '"${object.replaceAll('"', '\\"')}"';
    } else if (object is num || object is bool) {
      return object.toString();
    } else if (object == null) {
      return 'null';
    } else {
      return '"${object.toString()}"';
    }
  }
}
