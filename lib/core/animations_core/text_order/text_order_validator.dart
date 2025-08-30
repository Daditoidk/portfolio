import 'text_order_data.dart';
import 'text_section.dart';
import 'text_line.dart';
import 'text_element.dart';
import 'validation_result.dart';

/// Validator for text order data
class TextOrderValidator {
  /// Validate TextOrderData
  static ValidationResult validate(TextOrderData data) {
    final errors = <String>[];
    final warnings = <String>[];
    final metadata = <String, dynamic>{};

    try {
      // Basic structure validation
      if (data.sections.isEmpty) {
        errors.add('Data must contain at least one section');
      }

      // Validate each section
      for (int i = 0; i < data.sections.length; i++) {
        final section = data.sections[i];
        final sectionResult = _validateSection(section, i);

        if (sectionResult.hasErrors) {
          errors.addAll(
            sectionResult.errors.map((e) => 'Section ${i + 1}: $e'),
          );
        }

        if (sectionResult.hasWarnings) {
          warnings.addAll(
            sectionResult.warnings.map((w) => 'Section ${i + 1}: $w'),
          );
        }
      }

      // Cross-section validation
      final crossSectionResult = _validateCrossSection(data);
      if (crossSectionResult.hasErrors) {
        errors.addAll(crossSectionResult.errors);
      }
      if (crossSectionResult.hasWarnings) {
        warnings.addAll(crossSectionResult.warnings);
      }

      // Collect metadata
      metadata['totalSections'] = data.totalSections;
      metadata['totalLines'] = data.totalLines;
      metadata['totalTexts'] = data.totalTextElements;
      metadata['uniqueTextIds'] = data.allTextIds.toSet().length;

      // Check for duplicate text IDs
      final duplicateIds = _findDuplicateTextIds(data);
      if (duplicateIds.isNotEmpty) {
        errors.add('Duplicate text IDs found: ${duplicateIds.join(', ')}');
      }

      // Check for empty text content
      final emptyTexts = _findEmptyTexts(data);
      if (emptyTexts.isNotEmpty) {
        warnings.add(
          'Empty text content found in ${emptyTexts.length} elements',
        );
      }

      // Check for very long text content
      final longTexts = _findVeryLongTexts(data);
      if (longTexts.isNotEmpty) {
        warnings.add(
          'Very long text content found in ${longTexts.length} elements (may affect performance)',
        );
      }
    } catch (e) {
      errors.add('Validation failed with error: $e');
    }

    // Determine if validation passed
    final isValid = errors.isEmpty;

    return ValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      metadata: metadata,
    );
  }

  /// Validate a single section
  static ValidationResult _validateSection(
    TextSection section,
    int sectionIndex,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check section properties
    if (section.id.isEmpty) {
      errors.add('Section ID cannot be empty');
    }

    if (section.name.isEmpty) {
      warnings.add('Section name is empty');
    }

    if (section.lines.isEmpty) {
      errors.add('Section must contain at least one line');
    }

    // Validate each line in the section
    for (int i = 0; i < section.lines.length; i++) {
      final line = section.lines[i];
      final lineResult = _validateLine(line, i);

      if (lineResult.hasErrors) {
        errors.addAll(lineResult.errors.map((e) => 'Line ${i + 1}: $e'));
      }

      if (lineResult.hasWarnings) {
        warnings.addAll(lineResult.warnings.map((w) => 'Line ${i + 1}: $w'));
      }
    }

    // Check line ordering
    final lineOrders = section.lines.map((l) => l.order).toList();
    final uniqueOrders = lineOrders.toSet();
    if (uniqueOrders.length != lineOrders.length) {
      errors.add('Duplicate line orders found');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate a single line
  static ValidationResult _validateLine(TextLine line, int lineIndex) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check line properties
    if (line.id.isEmpty) {
      errors.add('Line ID cannot be empty');
    }

    if (line.detectedTexts.isEmpty) {
      errors.add('Line must contain at least one text element');
    }

    // Validate each text element in the line
    for (int i = 0; i < line.detectedTexts.length; i++) {
      final text = line.detectedTexts[i];
      final textResult = _validateTextElement(text, i);

      if (textResult.hasErrors) {
        errors.addAll(textResult.errors.map((e) => 'Text ${i + 1}: $e'));
      }

      if (textResult.hasWarnings) {
        warnings.addAll(textResult.warnings.map((w) => 'Text ${i + 1}: $w'));
      }
    }

    // Check Y position
    if (line.yPosition < 0) {
      warnings.add('Line Y position is negative: ${line.yPosition}');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate a single text element
  static ValidationResult _validateTextElement(
    TextElement text,
    int textIndex,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check text properties
    if (text.id.isEmpty) {
      errors.add('Text ID cannot be empty');
    }

    if (text.text.isEmpty) {
      warnings.add('Text content is empty');
    }

    if (text.fontSize <= 0) {
      errors.add('Font size must be positive: ${text.fontSize}');
    }

    if (text.fontSize > 100) {
      warnings.add('Font size is very large: ${text.fontSize}');
    }

    // Check timestamp
    if (text.timestamp.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      warnings.add('Text timestamp is in the future: ${text.timestamp}');
    }

    // Check text length
    if (text.text.length > 1000) {
      warnings.add('Text content is very long: ${text.text.length} characters');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate cross-section relationships
  static ValidationResult _validateCrossSection(TextOrderData data) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check for duplicate section names
    final sectionNames = data.sections.map((s) => s.name).toList();
    final uniqueSectionNames = sectionNames.toSet();
    if (uniqueSectionNames.length != sectionNames.length) {
      warnings.add('Duplicate section names found');
    }

    // Check for duplicate line IDs across sections
    final allLineIds = <String>[];
    for (final section in data.sections) {
      allLineIds.addAll(section.lines.map((l) => l.id));
    }
    final uniqueLineIds = allLineIds.toSet();
    if (uniqueLineIds.length != allLineIds.length) {
      errors.add('Duplicate line IDs found across sections');
    }

    // Check for duplicate text IDs across all sections
    final allTextIds = data.allTextIds;
    final uniqueTextIds = allTextIds.toSet();
    if (uniqueTextIds.length != allTextIds.length) {
      errors.add('Duplicate text IDs found across all sections');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Find duplicate text IDs
  static List<String> _findDuplicateTextIds(TextOrderData data) {
    final allIds = data.allTextIds;
    final seen = <String>{};
    final duplicates = <String>{};

    for (final id in allIds) {
      if (seen.contains(id)) {
        duplicates.add(id);
      } else {
        seen.add(id);
      }
    }

    return duplicates.toList();
  }

  /// Find empty text content
  static List<String> _findEmptyTexts(TextOrderData data) {
    final emptyIds = <String>[];

    for (final section in data.sections) {
      for (final line in section.lines) {
        for (final text in line.detectedTexts) {
          if (text.text.trim().isEmpty) {
            emptyIds.add(text.id);
          }
        }
      }
    }

    return emptyIds;
  }

  /// Find very long text content
  static List<String> _findVeryLongTexts(TextOrderData data) {
    final longTextIds = <String>[];
    const maxLength = 500; // Characters

    for (final section in data.sections) {
      for (final line in section.lines) {
        for (final text in line.detectedTexts) {
          if (text.text.length > maxLength) {
            longTextIds.add(text.id);
          }
        }
      }
    }

    return longTextIds;
  }

  /// Quick validation check
  static bool isValid(TextOrderData data) {
    return validate(data).isValid;
  }

  /// Get validation errors only
  static List<String> getErrors(TextOrderData data) {
    return validate(data).errors;
  }

  /// Get validation warnings only
  static List<String> getWarnings(TextOrderData data) {
    return validate(data).warnings;
  }
}

