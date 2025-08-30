import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';
import '../../data/index.dart';
import '../../../../../../../../core/animations_core/animations/text/text_animation_widget.dart';
import '../../../../../../../../core/animations_core/base/animation_types.dart';
import '../../../../../../../../core/animations_core/controllers/index.dart';

/// Preview property widget with Riverpod integration
class PreviewPropertyWidget extends PropertyWidget {
  const PreviewPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        final properties = ref.watch(animationPropertiesProvider);
        final previewController = ref.watch(
          previewAnimationControllerProvider.notifier,
        );

        // Determine the animation type and create the appropriate TextAnimation
        if (properties is ScrambleTextPropertiesData) {
          return _PreviewPropertyContent(
            properties: properties,
            previewController: previewController,
            child: TextAnimation<ScrambleTextPropertiesData>(
              text: properties.previewText,
              type: AnimationType.scramble,
              config: properties,
              onControllerReady: (controller) {
                // Connect the TextAnimation's internal controller to our preview controller
                previewController.setTextAnimationController(controller);
              },
            ),
          );
        } else if (properties is FadeTextPropertiesData) {
          return _PreviewPropertyContent(
            properties: properties,
            previewController: previewController,
            child: TextAnimation<FadeTextPropertiesData>(
              text: properties.previewText,
              type: AnimationType.fade,
              config: properties,
              onControllerReady: (controller) {
                previewController.setTextAnimationController(controller);
              },
            ),
          );
        } else if (properties is SlideTextPropertiesData) {
          return _PreviewPropertyContent(
            properties: properties,
            previewController: previewController,
            child: TextAnimation<SlideTextPropertiesData>(
              text: properties.previewText,
              type: AnimationType.slide,
              config: properties,
              onControllerReady: (controller) {
                previewController.setTextAnimationController(controller);
              },
            ),
          );
        }

        // Fallback for unknown animation types
        return const Text('Unknown animation type');
      },
    );
  }
}

/// Content widget for preview property with animation controls
class _PreviewPropertyContent extends ConsumerWidget {
  final BaseAnimationPropertiesData properties;
  final Widget child;
  final PreviewAnimationController previewController;

  const _PreviewPropertyContent({
    required this.properties,
    required this.child,
    required this.previewController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewAnimationControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animation controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: previewController.canPlay
                  ? previewController.playPreview
                  : null,
              icon: Icon(Icons.play_arrow),
              tooltip: 'Play Animation',
            ),
            IconButton(
              onPressed: previewController.canPause
                  ? previewController.pausePreview
                  : null,
              icon: const Icon(Icons.pause),
              tooltip: 'Pause Animation',
            ),
            IconButton(
              onPressed: previewController.canReset
                  ? previewController.resetPreview
                  : null,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Animation',
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Animation preview
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: child),
        ),
      ],
    );
  }
}
