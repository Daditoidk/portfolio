import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../text_order/text_order_data.dart';
import '../text_order/text_order_manager.dart';

import '../text_order/text_section.dart';
import '../text_order/text_line.dart';
import '../text_order/text_element.dart';
import '../text_order/validation_result.dart';

/// Provider for text order data
final textOrderDataProvider = StateProvider<TextOrderData?>((ref) {
  return null;
});

/// Provider for text order manager
final textOrderManagerProvider = Provider<TextOrderManager>((ref) {
  return TextOrderManager();
});

/// Provider for text order validation result
final textOrderValidationProvider = StateProvider<ValidationResult?>((ref) {
  return null;
});

/// Provider for text order loading state
final textOrderLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

/// Provider for text order error state
final textOrderErrorProvider = StateProvider<String?>((ref) {
  return null;
});

/// Provider for text order statistics
final textOrderStatisticsProvider = Provider<Map<String, int>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return {'sections': 0, 'lines': 0, 'texts': 0};

  return {
    'sections': data.totalSections,
    'lines': data.totalLines,
    'texts': data.totalTextElements,
  };
});

/// Provider for text order sections
final textOrderSectionsProvider = Provider<List<TextSection>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return [];

  return data.sortedSections;
});

/// Provider for text order lines
final textOrderLinesProvider = Provider<List<TextLine>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return [];

  final lines = <TextLine>[];
  for (final section in data.sections) {
    lines.addAll(section.sortedLines);
  }

  return lines;
});

/// Provider for text order text elements
final textOrderTextElementsProvider = Provider<List<TextElement>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return [];

  final elements = <TextElement>[];
  for (final section in data.sections) {
    for (final line in section.lines) {
      elements.addAll(line.detectedTexts);
    }
  }

  return elements;
});

/// Provider for text order text IDs
final textOrderTextIdsProvider = Provider<List<String>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return [];

  return data.allTextIds;
});

/// Provider for text order text contents
final textOrderTextContentsProvider = Provider<List<String>>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return [];

  return data.allTextContents;
});

/// Provider for text order combined text
final textOrderCombinedTextProvider = Provider<String>((ref) {
  final data = ref.watch(textOrderDataProvider);
  if (data == null) return '';

  return data.combinedText;
});

/// Provider for text order validation errors
final textOrderValidationErrorsProvider = Provider<List<String>>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return [];

  return validation.errors;
});

/// Provider for text order validation warnings
final textOrderValidationWarningsProvider = Provider<List<String>>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return [];

  return validation.warnings;
});

/// Provider for text order validation metadata
final textOrderValidationMetadataProvider = Provider<Map<String, dynamic>>((
  ref,
) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return {};

  return validation.metadata;
});

/// Provider for text order validation status
final textOrderValidationStatusProvider = Provider<bool>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return false;

  return validation.isValid;
});

/// Provider for text order validation has errors
final textOrderValidationHasErrorsProvider = Provider<bool>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return false;

  return validation.hasErrors;
});

/// Provider for text order validation has warnings
final textOrderValidationHasWarningsProvider = Provider<bool>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return false;

  return validation.hasWarnings;
});

/// Provider for text order validation error count
final textOrderValidationErrorCountProvider = Provider<int>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return 0;

  return validation.errorCount;
});

/// Provider for text order validation warning count
final textOrderValidationWarningCountProvider = Provider<int>((ref) {
  final validation = ref.watch(textOrderValidationProvider);
  if (validation == null) return 0;

  return validation.warningCount;
});
