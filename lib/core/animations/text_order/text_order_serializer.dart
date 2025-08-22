import 'dart:convert';
import 'text_order_data.dart';
import 'text_order_parser.dart';

/// Serializer for text order data operations
class TextOrderSerializer {
  /// Serialize TextOrderData to JSON string
  static String serializeToString(TextOrderData data, {bool pretty = true}) {
    try {
      final json = data.toJson();
      if (pretty) {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(json);
      } else {
        return jsonEncode(json);
      }
    } catch (e) {
      throw FormatException('Failed to serialize data: $e');
    }
  }

  /// Serialize TextOrderData to JSON Map
  static Map<String, dynamic> serializeToMap(TextOrderData data) {
    try {
      return data.toJson();
    } catch (e) {
      throw FormatException('Failed to serialize data: $e');
    }
  }

  /// Deserialize JSON string to TextOrderData
  static TextOrderData deserializeFromString(String jsonString) {
    try {
      return TextOrderParser.parseFromJsonString(jsonString);
    } catch (e) {
      throw FormatException('Failed to deserialize JSON string: $e');
    }
  }

  /// Deserialize JSON Map to TextOrderData
  static TextOrderData deserializeFromMap(Map<String, dynamic> json) {
    try {
      return TextOrderParser.parseFromJson(json);
    } catch (e) {
      throw FormatException('Failed to deserialize JSON map: $e');
    }
  }

  /// Convert to legacy format (for backward compatibility)
  static Map<String, dynamic> convertToLegacyFormat(TextOrderData data) {
    try {
      final legacyFormat = <String, dynamic>{};
      
      for (final section in data.sections) {
        for (final line in section.lines) {
          final lineKey = 'L${_getLineIndex(line.yPosition)}';
          final lineData = <String, dynamic>{};
          
          for (final text in line.detectedTexts) {
            lineData[text.id] = text.text;
          }
          
          legacyFormat[lineKey] = lineData;
        }
      }
      
      return legacyFormat;
    } catch (e) {
      throw FormatException('Failed to convert to legacy format: $e');
    }
  }

  /// Convert from legacy format
  static TextOrderData convertFromLegacyFormat(Map<String, dynamic> legacyData) {
    try {
      return TextOrderParser.parseFromLegacyFormat(legacyData);
    } catch (e) {
      throw FormatException('Failed to convert from legacy format: $e');
    }
  }

  /// Export to different formats
  static String exportToFormat(TextOrderData data, String format) {
    switch (format.toLowerCase()) {
      case 'json':
      case 'json_pretty':
        return serializeToString(data, pretty: format == 'json_pretty');
      case 'json_compact':
        return serializeToString(data, pretty: false);
      case 'legacy':
        final legacy = convertToLegacyFormat(data);
        return jsonEncode(legacy);
      case 'csv':
        return _convertToCsv(data);
      case 'xml':
        return _convertToXml(data);
      case 'yaml':
        return _convertToYaml(data);
      default:
        throw FormatException('Unsupported export format: $format');
    }
  }

  /// Get supported export formats
  static List<String> getSupportedExportFormats() {
    return [
      'json',
      'json_pretty',
      'json_compact',
      'legacy',
      'csv',
      'xml',
      'yaml',
    ];
  }

  /// Validate JSON string format
  static bool isValidJsonString(String jsonString) {
    try {
      final json = jsonDecode(jsonString);
      return json is Map<String, dynamic>;
    } catch (e) {
      return false;
    }
  }

  /// Get line index from Y position
  static int _getLineIndex(double yPosition) {
    // Map Y positions to line indices based on the known layout
    final yPositions = [0.0, 420.0, 540.0, 600.0, 660.0, 720.0, 780.0, 840.0, 900.0, 960.0, 1080.0, 1140.0, 1260.0, 1320.0, 1500.0, 1620.0];
    
    for (int i = 0; i < yPositions.length; i++) {
      if ((yPosition - yPositions[i]).abs() < 50) {
        return i;
      }
    }
    
    // Fallback: calculate approximate index
    return (yPosition / 100).round();
  }

  /// Convert to CSV format
  static String _convertToCsv(TextOrderData data) {
    final csvLines = <String>[];
    
    // Header
    csvLines.add('Section,Line,Y_Position,Text_ID,Text_Content,Font_Size,Font_Weight,Timestamp');
    
    // Data rows
    for (final section in data.sections) {
      for (final line in section.lines) {
        for (final text in line.detectedTexts) {
          final row = [
            section.name,
            line.id,
            line.yPosition.toString(),
            text.id,
            text.text.replaceAll('"', '""'), // Escape quotes
            text.fontSize.toString(),
            text.fontWeight,
            text.timestamp.toIso8601String(),
          ];
          
          // Wrap fields in quotes and join
          csvLines.add(row.map((field) => '"$field"').join(','));
        }
      }
    }
    
    return csvLines.join('\n');
  }

  /// Convert to XML format
  static String _convertToXml(TextOrderData data) {
    final buffer = StringBuffer();
    
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<textOrderData>');
    buffer.writeln('  <metadata>');
    buffer.writeln('    <id>${data.id}</id>');
    buffer.writeln('    <name>${data.name}</name>');
    buffer.writeln('    <description>${data.description}</description>');
    buffer.writeln('    <version>${data.version}</version>');
    buffer.writeln('    <createdAt>${data.createdAt.toIso8601String()}</createdAt>');
    buffer.writeln('    <updatedAt>${data.updatedAt.toIso8601String()}</updatedAt>');
    buffer.writeln('  </metadata>');
    
    for (final section in data.sections) {
      buffer.writeln('  <section id="${section.id}" name="${section.name}" order="${section.order}">');
      
      for (final line in section.lines) {
        buffer.writeln('    <line id="${line.id}" yPosition="${line.yPosition}" order="${line.order}">');
        
        for (final text in line.detectedTexts) {
          buffer.writeln('      <text id="${text.id}" fontSize="${text.fontSize}" fontWeight="${text.fontWeight}">');
          buffer.writeln('        <![CDATA[${text.text}]]>');
          buffer.writeln('      </text>');
        }
        
        buffer.writeln('    </line>');
      }
      
      buffer.writeln('  </section>');
    }
    
    buffer.writeln('</textOrderData>');
    
    return buffer.toString();
  }

  /// Convert to YAML format
  static String _convertToYaml(TextOrderData data) {
    final buffer = StringBuffer();
    
    buffer.writeln('id: ${data.id}');
    buffer.writeln('name: ${data.name}');
    buffer.writeln('description: ${data.description}');
    buffer.writeln('version: ${data.version}');
    buffer.writeln('createdAt: ${data.createdAt.toIso8601String()}');
    buffer.writeln('updatedAt: ${data.updatedAt.toIso8601String()}');
    buffer.writeln('sections:');
    
    for (final section in data.sections) {
      buffer.writeln('  - id: ${section.id}');
      buffer.writeln('    name: ${section.name}');
      buffer.writeln('    order: ${section.order}');
      buffer.writeln('    lines:');
      
      for (final line in section.lines) {
        buffer.writeln('      - id: ${line.id}');
        buffer.writeln('        yPosition: ${line.yPosition}');
        buffer.writeln('        order: ${line.order}');
        buffer.writeln('        detectedTexts:');
        
        for (final text in line.detectedTexts) {
          buffer.writeln('          - id: ${text.id}');
          buffer.writeln('            text: ${text.text}');
          buffer.writeln('            fontSize: ${text.fontSize}');
          buffer.writeln('            fontWeight: ${text.fontWeight}');
          buffer.writeln('            timestamp: ${text.timestamp.toIso8601String()}');
        }
      }
    }
    
    return buffer.toString();
  }

  /// Create a summary of the data
  static Map<String, dynamic> createSummary(TextOrderData data) {
    return {
      'id': data.id,
      'name': data.name,
      'description': data.description,
      'version': data.version,
      'statistics': {
        'totalSections': data.totalSections,
        'totalLines': data.totalLines,
        'totalTexts': data.totalTextElements,
        'uniqueTextIds': data.allTextIds.toSet().length,
      },
      'sections': data.sections.map((section) => {
        'id': section.id,
        'name': section.name,
        'order': section.order,
        'lineCount': section.lines.length,
        'textCount': section.totalTextElements,
      }).toList(),
      'createdAt': data.createdAt.toIso8601String(),
      'updatedAt': data.updatedAt.toIso8601String(),
    };
  }

  /// Compare two TextOrderData instances
  static Map<String, dynamic> compare(TextOrderData data1, TextOrderData data2) {
    final comparison = <String, dynamic>{
      'identical': false,
      'differences': <String>[],
      'statistics': <String, dynamic>{},
    };

    // Check basic properties
    if (data1.id != data2.id) {
      comparison['differences'].add('Different IDs: ${data1.id} vs ${data2.id}');
    }

    if (data1.totalSections != data2.totalSections) {
      comparison['differences'].add('Different section counts: ${data1.totalSections} vs ${data2.totalSections}');
    }

    if (data1.totalLines != data2.totalLines) {
      comparison['differences'].add('Different line counts: ${data1.totalLines} vs ${data2.totalLines}');
    }

    if (data1.totalTextElements != data2.totalTextElements) {
      comparison['differences'].add('Different text counts: ${data1.totalTextElements} vs ${data2.totalTextElements}');
    }

    // Check if they are identical
    comparison['identical'] = comparison['differences'].isEmpty;

    // Add statistics
    comparison['statistics'] = {
      'data1': createSummary(data1),
      'data2': createSummary(data2),
    };

    return comparison;
  }
}
