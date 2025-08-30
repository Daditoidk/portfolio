import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/index.dart';
import '../../../../../../../core/animations_core/base/animation_types.dart';

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

  // /// Update multiple properties at once
  // void updateMultipleProperties(Map<String, dynamic> properties) {
  //   var newProperties = state;
  //   for (final entry in properties.entries) {
  //     newProperties = newProperties.updateProperty(entry.key, entry.value);
  //   }
  //   if (newProperties != state) {
  //     print(
  //       'AnimationPropertiesNotifier: Updating multiple properties: $properties',
  //     );
  //     state = newProperties;
  //   }
  // }

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

  /// Get a property value with type-specific access for better type safety
  /// This method leverages the existing getProperty methods from each subclass
  T? getTypedProperty<T>(String propertyName) {
    // For all properties, just use the existing getProperty method
    // Each subclass already handles its own properties correctly
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

  /// Get the current animation type as an enum
  TextAnimationType getCurrentAnimationType() {
    if (state is ScrambleTextPropertiesData) {
      return TextAnimationType.text_scramble;
    }
    if (state is FadeTextPropertiesData) {
      return TextAnimationType.text_fade_in;
    }
    if (state is SlideTextPropertiesData) {
      return TextAnimationType.text_slide;
    }
    return TextAnimationType.none;
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

/// Provider for current animation type as enum
final currentAnimationTypeProvider = Provider<TextAnimationType>((ref) {
  final notifier = ref.watch(animationPropertiesProvider.notifier);
  return notifier.getCurrentAnimationType();
});
