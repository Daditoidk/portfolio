/// Result of a validation operation
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final Map<String, dynamic> metadata;

  const ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    this.metadata = const {},
  });

  /// Create successful validation result
  factory ValidationResult.success({
    List<String> warnings = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    return ValidationResult(
      isValid: true,
      errors: const [],
      warnings: warnings,
      metadata: metadata,
    );
  }

  /// Create failed validation result
  factory ValidationResult.failure({
    required List<String> errors,
    List<String> warnings = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    return ValidationResult(
      isValid: false,
      errors: errors,
      warnings: warnings,
      metadata: metadata,
    );
  }

  /// Check if there are any errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check if there are any warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Get error count
  int get errorCount => errors.length;

  /// Get warning count
  int get warningCount => warnings.length;

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, errors: $errorCount, warnings: $warningCount)';
  }
}

