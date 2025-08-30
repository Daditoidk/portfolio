import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/index.dart';

// =============================================================================
// PROVIDERS
// =============================================================================

/// Single notifier that manages animation properties directly
class AnimationPropertiesNotifier
    extends StateNotifier<BaseAnimationPropertiesData> {
  AnimationPropertiesNotifier()
    : super(ScrambleTextPropertiesData.defaultValues());

  /// Update a single property
  void updateProperty(String propertyName, dynamic value) {
    final newProperties = state.updateProperty(propertyName, value);
    if (newProperties != state) {
      print('AnimationPropertiesNotifier: Updating $propertyName to $value');
      state = newProperties;
    }
  }

  /// Update multiple properties at once
  void updateMultipleProperties(Map<String, dynamic> properties) {
    var newProperties = state;
    for (final entry in properties.entries) {
      newProperties = newProperties.updateProperty(entry.key, entry.value);
    }
    if (newProperties != state) {
      print(
        'AnimationPropertiesNotifier: Updating multiple properties: $properties',
      );
      state = newProperties;
    }
  }

  /// Reset to default values
  void resetToDefaults() {
    BaseAnimationPropertiesData defaultProperties;

    // Get the right default values based on current state type
    if (state is ScrambleTextPropertiesData) {
      defaultProperties = ScrambleTextPropertiesData.defaultValues();
    } else if (state is FadeTextPropertiesData) {
      defaultProperties = FadeTextPropertiesData.defaultValues();
    } else if (state is SlideTextPropertiesData) {
      defaultProperties = SlideTextPropertiesData.defaultValues();
    } else {
      // Fallback to scramble defaults
      defaultProperties = ScrambleTextPropertiesData.defaultValues();
    }

    if (state != defaultProperties) {
      print('AnimationPropertiesNotifier: Resetting to defaults');
      state = defaultProperties;
    }
  }

  /// Get a property value with type safety
  T? getProperty<T>(String propertyName) {
    return state.getProperty<T>(propertyName);
  }

  /// Check if a property exists
  bool hasProperty(String propertyName) {
    return state.getProperty<dynamic>(propertyName) != null;
  }

  /// Switch to a different animation type
  void switchToAnimationType(BaseAnimationPropertiesData newProperties) {
    state = newProperties;
  }
}

/// Main provider for animation properties
final animationPropertiesProvider =
    StateNotifierProvider<
      AnimationPropertiesNotifier,
      BaseAnimationPropertiesData
    >((ref) => AnimationPropertiesNotifier());

/// Provider for animation ID (derived from the type of properties)
final animationIdProvider = Provider<String?>((ref) {
  final properties = ref.watch(animationPropertiesProvider);
  if (properties is ScrambleTextPropertiesData) return 'text_scramble';
  if (properties is FadeTextPropertiesData) return 'text_fade';
  if (properties is SlideTextPropertiesData) return 'text_slide';
  return null;
});
