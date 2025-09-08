import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'animation_properties/index.dart';
import 'canvas_header_widget.dart';
import 'animation_selection_container.dart';
import 'animation_properties/providers/animation_properties_providers.dart';
import 'animation_properties/data/index.dart';
import '../../../../../../core/animations_core/base/animation_types.dart';

/// Widget for building the animation panel
class AnimationPanelWidget extends StatefulWidget {
  final String selectedCanvas;
  final List<Map<String, dynamic>> availableCanvases;
  final Function(String) onCanvasChanged;

  const AnimationPanelWidget({
    super.key,
    required this.selectedCanvas,
    required this.availableCanvases,
    required this.onCanvasChanged,
  });

  @override
  State<AnimationPanelWidget> createState() => _AnimationPanelWidgetState();
}

class _AnimationPanelWidgetState extends State<AnimationPanelWidget> {
  String? _selectedAnimation;
  bool _showAnimationSettings = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button and canvas dropdown
        CanvasHeaderWidget(
          selectedCanvas: widget.selectedCanvas,
          availableCanvases: widget.availableCanvases,
          onCanvasChanged: widget.onCanvasChanged,
        ),
    
        // Scrollable content area (combines animation selection and settings)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Animation Selection Container - Wrapped with Consumer for state access
                Consumer(
                  builder: (context, ref, child) {
                    return AnimationSelectionContainer(
                      onAnimationSelected: (animationId) {
                        setState(() {
                          _selectedAnimation = animationId;
                          _showAnimationSettings = animationId != null;
                        });
                        
                        // Switch animation type in the provider and set to defaults
                        if (animationId != null) {
                          _switchAnimationType(animationId, ref);
                        }
                      },
                      onShowSettingsChanged: (show) {
                        setState(() {
                          _showAnimationSettings = show;
                        });
                      },
                    );
                  },
                ),
    
                // Animation Properties Panel (appears when animation is selected)
                if (_showAnimationSettings) ...[
                  const SizedBox(height: 16),
                  AnimationPropertiesPanel(
                    selectedAnimation: _selectedAnimation,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Switch to a different animation type and set to default values
  void _switchAnimationType(String animationId, WidgetRef ref) {
    // Check if we're already on this animation type to avoid unnecessary updates
    if (_selectedAnimation == animationId) {
      print(
        'AnimationPanelWidget: Already on animation type: $animationId, skipping update',
      );
      return;
    }

    final notifier = ref.read(animationPropertiesProvider.notifier);

    print('AnimationPanelWidget: Switching to animation type: $animationId');

    // Convert string ID to enum for type safety
    final textAnimationType = stringToTextAnimationType(animationId);

    if (textAnimationType != null) {
      print('AnimationPanelWidget: Mapped to enum: $textAnimationType');

      // Use enum-based switching for better type safety
      switch (textAnimationType) {
        case TextAnimationType.text_scramble:
          print(
            'AnimationPanelWidget: Switching to ScrambleTextPropertiesData',
          );
          notifier.switchToAnimationType(
            ScrambleTextPropertiesData.defaultValues(),
          );
          break;
        case TextAnimationType.text_fade_in:
          print('AnimationPanelWidget: Switching to FadeTextPropertiesData');
          notifier.switchToAnimationType(
            FadeTextPropertiesData.defaultValues(),
          );
          break;
        case TextAnimationType.text_typewriter:
          // For now, fallback to scramble since typewriter is not implemented
          print(
            'AnimationPanelWidget: Typewriter not implemented, falling back to ScrambleTextPropertiesData',
          );
          notifier.switchToAnimationType(
            ScrambleTextPropertiesData.defaultValues(),
          );
          break;
        case TextAnimationType.text_wave:
          // For now, fallback to scramble since wave is not implemented
          print(
            'AnimationPanelWidget: Wave not implemented, falling back to ScrambleTextPropertiesData',
          );
          notifier.switchToAnimationType(
            ScrambleTextPropertiesData.defaultValues(),
          );
          break;
        case TextAnimationType.text_slide:
          print('AnimationPanelWidget: Switching to SlideTextPropertiesData');
          notifier.switchToAnimationType(
            SlideTextPropertiesData.defaultValues(),
          );
          break;
        case TextAnimationType.none:
          print('AnimationPanelWidget: No animation type selected');
          break;
      }
    } else {
      // Fallback to scramble if unknown animation type
      print(
        'AnimationPanelWidget: Unknown animation type "$animationId", falling back to ScrambleTextPropertiesData',
      );
      notifier.switchToAnimationType(
        ScrambleTextPropertiesData.defaultValues(),
      );
    }
  }
}
