import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/animation_config.dart';
import '../base/base_animation.dart';
import '../text/text_scramble_config.dart';

/// Provider for animation configuration
final animationConfigProvider = StateProvider<AnimationConfig?>((ref) {
  return null;
});

/// Provider for text scramble configuration
final textScrambleConfigProvider = StateProvider<TextScrambleConfig?>((ref) {
  return null;
});

/// Provider for animation configuration properties
final animationConfigPropertiesProvider = Provider<Map<String, dynamic>>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return {};

  return config.properties;
});

/// Provider for animation configuration name
final animationConfigNameProvider = Provider<String>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return '';

  return config.name;
});

/// Provider for animation configuration type
final animationConfigTypeProvider = Provider<String>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return '';

  return config.type;
});

/// Provider for animation configuration validation
final animationConfigValidationProvider = Provider<bool>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return false;

  return config.isValid();
});

/// Provider for animation configuration default properties
final animationConfigDefaultPropertiesProvider = Provider<Map<String, dynamic>>(
  (ref) {
    final config = ref.watch(animationConfigProvider);
    if (config == null) return {};

    return config.getDefaultProperties();
  },
);

/// Provider for text scramble configuration properties
final textScrambleConfigPropertiesProvider = Provider<Map<String, dynamic>>((
  ref,
) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return {};

  return config.properties;
});

/// Provider for text scramble configuration mode
final textScrambleConfigModeProvider = Provider<AnimationMode>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return AnimationMode.line;

  return config.mode;
});

/// Provider for text scramble configuration direction
final textScrambleConfigDirectionProvider = Provider<AnimationDirection>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return AnimationDirection.leftToRight;

  return config.direction;
});

/// Provider for text scramble configuration timing
final textScrambleConfigTimingProvider = Provider<AnimationTimingMode>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return AnimationTimingMode.simultaneous;

  return config.timing;
});

/// Provider for text scramble configuration speed
final textScrambleConfigSpeedProvider = Provider<double>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return 1.0;

  return config.speed;
});

/// Provider for text scramble configuration delay
final textScrambleConfigDelayProvider = Provider<double>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return 0.0;

  return config.delay;
});

/// Provider for text scramble configuration loop
final textScrambleConfigLoopProvider = Provider<bool>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return false;

  return config.loop;
});

/// Provider for text scramble configuration reverse
final textScrambleConfigReverseProvider = Provider<bool>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return false;

  return config.reverse;
});

/// Provider for text scramble configuration scramble characters
final textScrambleConfigScrambleCharactersProvider = Provider<String>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return r'!@#$%^&*()';

  return config.scrambleCharacters;
});

/// Provider for text scramble configuration scramble iterations
final textScrambleConfigScrambleIterationsProvider = Provider<int>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return 10;

  return config.scrambleIterations;
});

/// Provider for text scramble configuration maintain case
final textScrambleConfigMaintainCaseProvider = Provider<bool>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return true;

  return config.maintainCase;
});

/// Provider for text scramble configuration text IDs
final textScrambleConfigTextIdsProvider = Provider<List<String>>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return [];

  return config.textIds;
});

/// Provider for text scramble configuration text order data
final textScrambleConfigTextOrderDataProvider = Provider<Map<String, dynamic>>((
  ref,
) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return {};

  return config.textOrderData;
});

/// Provider for text scramble configuration animation sequence
final textScrambleConfigAnimationSequenceProvider = Provider<List<String>>((
  ref,
) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return [];

  return config.getAnimationSequence();
});

/// Provider for text scramble configuration validation
final textScrambleConfigValidationProvider = Provider<bool>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return false;

  return config.isValid();
});

/// Provider for text scramble configuration text order data validation
final textScrambleConfigTextOrderDataValidationProvider = Provider<bool>((ref) {
  final config = ref.watch(textScrambleConfigProvider);
  if (config == null) return false;

  return config.isTextOrderDataValid();
});

/// Provider for animation configuration export type
final animationConfigExportTypeProvider = Provider<ExportType>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return ExportType.json;

  // For text scramble, use JSON export
  if (config.type == 'text_scramble') {
    return ExportType.json;
  }

  // For simple animations, use Dart code export
  return ExportType.dartCode;
});

/// Provider for animation configuration export data
final animationConfigExportDataProvider = Provider<Map<String, dynamic>>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return {};

  return config.toJson();
});

/// Provider for animation configuration export filename
final animationConfigExportFilenameProvider = Provider<String>((ref) {
  final config = ref.watch(animationConfigProvider);
  if (config == null) return 'animation_config';

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return '${config.name}_${config.type}_$timestamp';
});

/// Provider for animation configuration export extension
final animationConfigExportExtensionProvider = Provider<String>((ref) {
  final exportType = ref.watch(animationConfigExportTypeProvider);

  switch (exportType) {
    case ExportType.json:
      return 'json';
    case ExportType.dartCode:
      return 'dart';
  }
});

/// Provider for animation configuration export mime type
final animationConfigExportMimeTypeProvider = Provider<String>((ref) {
  final exportType = ref.watch(animationConfigExportTypeProvider);

  switch (exportType) {
    case ExportType.json:
      return 'application/json';
    case ExportType.dartCode:
      return 'text/x-dart';
  }
});
