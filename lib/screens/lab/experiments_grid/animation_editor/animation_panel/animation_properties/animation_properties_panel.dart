import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/styles.dart';
import 'properties/widgets/index.dart';
import '../../../../../../core/animations_core/base/animation_types.dart';
import 'constants/property_names.dart';

/// Simplified animation properties panel - Pure Riverpod implementation
class AnimationPropertiesPanel extends ConsumerWidget {
  final String? selectedAnimation;

  const AnimationPropertiesPanel({
    super.key,
    required this.selectedAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedAnimation == null) {
      return _buildNoAnimationSelected();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.settings, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Animation Properties',
              style: AnimationPanelStyles.subheading.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Professional property controls using separated widgets
        _buildProperties(ref),

        const SizedBox(height: 24),

        // Preview animation using existing PreviewProperty
        PreviewPropertyWidget(
          propertyName: 'Animation Preview',
          description: 'Live preview of the animation with controls',
        ),

        // Note: PreviewProperty already includes animation controls, so we don't need separate ones
      ],
    );
  }

  Widget _buildProperties(WidgetRef ref) {
    // Convert string ID to enum for type safety
    final textAnimationType = stringToTextAnimationType(selectedAnimation);

    if (textAnimationType != null) {
      // Use enum-based switching for better type safety
      switch (textAnimationType) {
        case TextAnimationType.text_scramble:
          return _buildScrambleProperties();
        case TextAnimationType.text_fade_in:
          return _buildFadeProperties();
        case TextAnimationType.text_typewriter:
          // For now, show scramble properties since typewriter is not implemented
          return _buildScrambleProperties();
        case TextAnimationType.text_wave:
          // For now, show scramble properties since wave is not implemented
          return _buildScrambleProperties();
        case TextAnimationType.text_slide:
          return _buildSlideProperties();
        case TextAnimationType.none:
          return _buildDefaultProperties();
      }
    }
    
    // Fallback for unknown animation types
    return _buildDefaultProperties();
  }

  Widget _buildScrambleProperties() {
    return Column(
      children: [
        // Speed slider - using professional SliderProperty
        SliderPropertyWidget(
          propertyName: PropertyNames.speed,
          description: 'Animation speed multiplier',
          defaultValue: 1.0,
          min: 0.1,
          max: 5.0,
          divisions: 50,
          unit: 'x',
        ),

        const SizedBox(height: 16),

        // Scramble intensity slider - using professional SliderProperty
        SliderPropertyWidget(
          propertyName: PropertyNames.scrambleIntensity,
          description: 'How much the text gets scrambled during animation',
          defaultValue: 0.5,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          unit: '%',
        ),
        
        const SizedBox(height: 16),

        // Direction dropdown - using professional DropdownProperty
        DropdownPropertyWidget(
          propertyName: PropertyNames.direction,
          description: 'Animation direction and flow',
          defaultValue: 'Left to Right',
          options: [
            'Left to Right',
            'Right to Left',
            'Top to Bottom',
            'Bottom to Top',
          ],
        ),

        const SizedBox(height: 16),

        // Loop checkbox - using professional CheckboxProperty
        CheckboxPropertyWidget(
          propertyName: PropertyNames.loop,
          description: 'Enable continuous looping of the animation',
        ),
      ],
    );
  }

  Widget _buildFadeProperties() {
    return Column(
      children: [
        // Speed slider
        SliderPropertyWidget(
          propertyName: PropertyNames.speed,
          description: 'Animation speed multiplier',
          defaultValue: 1.0,
          min: 0.1,
          max: 5.0,
          divisions: 50,
          unit: 'x',
        ),

        const SizedBox(height: 16),

        // Fade duration slider
        SliderPropertyWidget(
          propertyName: PropertyNames.fadeDuration,
          description: 'How long the fade effect takes',
          defaultValue: 1.0,
          min: 0.1,
          max: 3.0,
          divisions: 30,
          unit: 's',
        ),

        const SizedBox(height: 16),

        // Fade type dropdown
        DropdownPropertyWidget(
          propertyName: PropertyNames.fadeType,
          description: 'Type of fade effect',
          defaultValue: 'Fade In',
          options: ['Fade In', 'Fade Out', 'Fade In Out'],
        ),

        const SizedBox(height: 16),

        // Loop checkbox
        CheckboxPropertyWidget(
          propertyName: PropertyNames.loop,
          description: 'Enable continuous looping of the animation',
        ),
      ],
    );
  }

  Widget _buildDefaultProperties() {
    return Column(
      children: [
        // Speed slider - common to all animations
        SliderPropertyWidget(
          propertyName: PropertyNames.speed,
          description: 'Animation speed multiplier',
          defaultValue: 1.0,
          min: 0.1,
          max: 5.0,
          divisions: 50,
          unit: 'x',
        ),

        const SizedBox(height: 16),

        // Loop checkbox - common to all animations
        CheckboxPropertyWidget(
          propertyName: PropertyNames.loop,
          description: 'Enable continuous looping of the animation',
        ),
      ],
    );
  }

  Widget _buildSlideProperties() {
    return Column(
      children: [
        // Speed slider
        SliderPropertyWidget(
          propertyName: PropertyNames.speed,
          description: 'Animation speed multiplier',
          defaultValue: 1.0,
          min: 0.1,
          max: 5.0,
          divisions: 50,
          unit: 'x',
        ),

        const SizedBox(height: 16),

        // Slide direction dropdown
        DropdownPropertyWidget(
          propertyName: PropertyNames.direction,
          description: 'Direction in which the text slides',
          defaultValue: 'Left',
          options: ['Left', 'Right', 'Up', 'Down'],
        ),

        const SizedBox(height: 16),

        // Loop checkbox
        CheckboxPropertyWidget(
          propertyName: PropertyNames.loop,
          description: 'Enable continuous looping of the animation',
        ),
      ],
    );
  }


  Widget _buildNoAnimationSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.animation, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Select an animation to configure properties',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
