import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_change_animation.dart';
import 'text_animation_registry.dart';

final languageAnimationStrategyProvider = StateProvider<LanguageChangeStrategy>(
  (ref) => LanguageChangeStrategy.readingWave,
);

// Provider for text animation registry settings
class TextAnimationRegistrySettings {
  final double lineThreshold;
  final int blockSize;
  final bool manualOverridesEnabled;

  const TextAnimationRegistrySettings({
    required this.lineThreshold,
    required this.blockSize,
    required this.manualOverridesEnabled,
  });

  TextAnimationRegistrySettings copyWith({
    double? lineThreshold,
    int? blockSize,
    bool? manualOverridesEnabled,
  }) {
    return TextAnimationRegistrySettings(
      lineThreshold: lineThreshold ?? this.lineThreshold,
      blockSize: blockSize ?? this.blockSize,
      manualOverridesEnabled:
          manualOverridesEnabled ?? this.manualOverridesEnabled,
    );
  }
}

class TextAnimationRegistrySettingsNotifier
    extends StateNotifier<TextAnimationRegistrySettings> {
  TextAnimationRegistrySettingsNotifier()
    : super(
        const TextAnimationRegistrySettings(
          lineThreshold: 30.0,
          blockSize: 5,
          manualOverridesEnabled: true,
        ),
      );

  void setLineThreshold(double threshold) {
    state = state.copyWith(lineThreshold: threshold);
    TextAnimationRegistry().setLineThreshold(threshold);
  }

  void setBlockSize(int size) {
    state = state.copyWith(blockSize: size);
    TextAnimationRegistry().setBlockSize(size);
  }

  void setManualOverridesEnabled(bool enabled) {
    state = state.copyWith(manualOverridesEnabled: enabled);
    TextAnimationRegistry().setUseManualOverrides(enabled);
  }
}

final textAnimationRegistryProvider =
    StateNotifierProvider<
      TextAnimationRegistrySettingsNotifier,
      TextAnimationRegistrySettings
    >((ref) => TextAnimationRegistrySettingsNotifier());
