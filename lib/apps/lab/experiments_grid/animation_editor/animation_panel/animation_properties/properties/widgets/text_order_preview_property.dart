import 'package:flutter/material.dart';
import 'base_property_widget.dart';

/// Property widget for previewing text order structure in column layout
class TextOrderPreviewProperty extends PropertyWidget {
  final dynamic value;
  final Function(dynamic) onChanged;

  const TextOrderPreviewProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Name Row (right-aligned)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Property name with units
            Text(
              unit != null ? '$propertyName($unit)' : propertyName,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(width: 5), // 5px padding
            if (description != null)
              Tooltip(
                message: description!,
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
              )
            else
              const SizedBox(width: 16), // Placeholder for consistent alignment
          ],
        ),

        const SizedBox(height: 8),

        // Value (Preview Container)
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _buildPreviewContent(),
        ),
      ],
    );
  }

  @override
  Widget buildPropertyContent() {
    // Not used as we override build() for custom column layout
    return const SizedBox.shrink();
  }

  Widget _buildPreviewContent() {
    print(
      'TextOrderPreviewProperty - _buildPreviewContent called with value: ${value != null ? value.runtimeType : 'null'}',
    );

    if (value == null || value.isEmpty) {
      print('TextOrderPreviewProperty - Value is null or empty');
      return _buildNoDataMessage();
    }

    // Check if the value has the expected structure
    if (!_isValidTextOrderData(value)) {
      print('TextOrderPreviewProperty - Value failed validation');
      return _buildNoDataMessage();
    }

    print(
      'TextOrderPreviewProperty - Value passed validation, building preview',
    );
    try {
      return _buildStructuredPreview(value);
    } catch (e) {
      print('TextOrderPreviewProperty - Error building preview: $e');
      return _buildErrorMessage();
    }
  }

  bool _isValidTextOrderData(dynamic data) {
    print('TextOrderPreviewProperty - Validating data: ${data.runtimeType}');

    if (data is! Map<String, dynamic>) {
      print('TextOrderPreviewProperty - Data is not Map<String, dynamic>');
      return false;
    }

    print('TextOrderPreviewProperty - Data keys: ${data.keys}');

    // Check if we have the required top-level keys
    final hasSections = data.containsKey('sections');
    final hasLines = data.containsKey('lines');

    if (!hasSections || !hasLines) {
      print(
        'TextOrderPreviewProperty - Missing required keys. Has sections: $hasSections, Has lines: $hasLines',
      );
      return false;
    }

    final sections = data['sections'];
    if (sections is! List) {
      print(
        'TextOrderPreviewProperty - Sections is not List: ${sections.runtimeType}',
      );
      return false;
    }

    if (sections.isEmpty) {
      print('TextOrderPreviewProperty - Sections is empty');
      return false;
    }

    final lines = data['lines'];
    if (lines is! List) {
      print(
        'TextOrderPreviewProperty - Lines is not List: ${lines.runtimeType}',
      );
      return false;
    }

    if (lines.isEmpty) {
      print('TextOrderPreviewProperty - Lines is empty');
      return false;
    }

    print('TextOrderPreviewProperty - Validation passed successfully');
    return true;
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.text_fields, size: 32, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'No text order data to preview',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Import JSON data to see the structure',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 32, color: Colors.orange.shade400),
          const SizedBox(height: 8),
          Text(
            'Invalid data format',
            style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStructuredPreview(Map<String, dynamic> data) {
    final sections = data['sections'] as List<dynamic>? ?? [];
    final lines = data['lines'] as List<dynamic>? ?? [];

    print(
      'Building preview with ${sections.length} sections and ${lines.length} lines',
    );

    if (sections.isEmpty && lines.isEmpty) {
      return _buildNoDataMessage();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show sections if they exist
          if (sections.isNotEmpty) ...[
            ...sections.map<Widget>((section) {
              print('Section data: ${section.keys}');
              return _buildExpandableSectionPreview(section, data);
            }),
          ],

          // Show lines if they exist and sections don't
          if (sections.isEmpty && lines.isNotEmpty) ...[
            ...lines.map<Widget>((line) {
              return _buildExpandableLinePreview(line, 0);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandableSectionPreview(
    Map<String, dynamic> section,
    Map<String, dynamic> data,
  ) {
    final sectionName = section['name'] as String? ?? 'Unnamed Section';
    final sectionOrder = section['order'] as int? ?? 0;
    final lineOrders = section['lineOrders'] as List<dynamic>? ?? [];

    // Get the actual lines for this section using lineOrders
    final allLines = data['lines'] as List<dynamic>? ?? [];
    final sectionLines = allLines
        .where((line) => lineOrders.contains(line['order']))
        .toList();

    print(
      'Building section: $sectionName with ${lineOrders.length} lineOrders, found ${sectionLines.length} lines',
    );

    return ExpansionTile(
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Bloque $sectionOrder ($sectionName)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.blue.shade700,
          ),
        ),
      ),
      children: sectionLines.map<Widget>((line) {
        print('Building line in section $sectionName: ${line['order']}');
        return _buildExpandableLinePreview(line, sectionOrder);
      }).toList(),
    );
  }

  Widget _buildExpandableLinePreview(
    Map<String, dynamic> line,
    int sectionOrder,
  ) {
    final lineOrder = line['order'] as int? ?? 0;
    final texts = line['detectedTexts'] as List<dynamic>? ?? [];

    print('Building line $lineOrder with ${texts.length} texts');

    // Sort texts by x position (left to right)
    final sortedTexts = List<dynamic>.from(texts);
    sortedTexts.sort((a, b) {
      final aX = a['x'] as num? ?? 0;
      final bX = b['x'] as num? ?? 0;
      return aX.compareTo(bX);
    });

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ExpansionTile(
        title: Text(
          'Línea $lineOrder',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
        children: sortedTexts.map<Widget>((text) {
          print('Building text: ${text['text']} at x: ${text['x']}');
          return _buildTextPreview(text, sectionOrder, lineOrder);
        }).toList(),
      ),
    );
  }

  Widget _buildTextPreview(
    Map<String, dynamic> text,
    int sectionOrder,
    int lineOrder,
  ) {
    final textX = text['x'] as num? ?? 0;
    final textContent = text['text'] as String? ?? 'No text';

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Text(
            '    Text (x: ${textX.toStringAsFixed(1)})',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '($textContent)',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
