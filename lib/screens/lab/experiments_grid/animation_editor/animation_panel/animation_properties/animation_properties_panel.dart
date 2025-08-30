import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/styles.dart';
import 'properties/widgets/index.dart';

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
    switch (selectedAnimation) {
      case 'scramble':
        return _buildScrambleProperties();
      case 'fade':
        return _buildFadeProperties();
      case 'slide':
        return _buildSlideProperties();
      default:
        return _buildDefaultProperties();
    }
  }

  Widget _buildScrambleProperties() {
    return Column(
      children: [
        // Speed slider - using professional SliderProperty
        SliderPropertyWidget(
          propertyName: 'Speed',
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
          propertyName: 'Scramble Intensity',
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
          propertyName: 'Direction',
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
          propertyName: 'Loop',
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
          propertyName: 'Speed',
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
          propertyName: 'Fade Duration',
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
          propertyName: 'Fade Type',
          description: 'Type of fade effect',
          defaultValue: 'Fade In',
          options: ['Fade In', 'Fade Out', 'Fade In Out'],
        ),

        const SizedBox(height: 16),

        // Loop checkbox
        CheckboxPropertyWidget(
          propertyName: 'Loop',
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
          propertyName: 'Speed',
          description: 'Animation speed multiplier',
          defaultValue: 1.0,
          min: 0.1,
          max: 5.0,
          divisions: 50,
          unit: 'x',
        ),

        const SizedBox(height: 16),

        // Slide distance slider
        SliderPropertyWidget(
          propertyName: 'Slide Distance',
          description: 'How far the text slides',
          defaultValue: 100.0,
          min: 20.0,
          max: 300.0,
          divisions: 28,
          unit: 'px',
        ),

        const SizedBox(height: 16),

        // Direction dropdown
        DropdownPropertyWidget(
          propertyName: 'Direction',
          description: 'Slide direction',
          defaultValue: 'Left to Right',
          options: [
            'Left to Right',
            'Right to Left',
            'Top to Bottom',
            'Bottom to Top',
          ],
        ),

        const SizedBox(height: 16),

        // Easing dropdown
        DropdownPropertyWidget(
          propertyName: 'Easing',
          description: 'Animation easing curve',
          defaultValue: 'Ease In Out',
          options: ['Ease In Out', 'Ease In', 'Ease Out', 'Linear', 'Bounce'],
        ),

        const SizedBox(height: 16),

        // Loop checkbox
        CheckboxPropertyWidget(
          propertyName: 'Loop',
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
          propertyName: 'Speed',
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
          propertyName: 'Loop',
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
