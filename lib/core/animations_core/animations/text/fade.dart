import 'package:flutter/material.dart';
import '../../../../apps/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

mixin SimpleFadeMixin {
  /// Builds a text widget with fade animation effect
  Widget buildFadeText({
    required String text,
    required FadeTextPropertiesData config,
    required AnimationController controller,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    // Direct access to properties - no casting needed!
    final direction = config.fadeType;
    // Speed is used by the animation controller, not directly in this mixin

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double opacity;

        switch (direction.toLowerCase()) {
          case 'fade in':
            opacity = controller.value;
            break;
          case 'fade out':
            opacity = 1.0 - controller.value;
            break;
          case 'fade in out':
            // Fade in for first half, fade out for second half
            if (controller.value <= 0.5) {
              opacity = controller.value * 2; // 0 to 1
            } else {
              opacity = (1.0 - controller.value) * 2; // 1 to 0
            }
            break;
          default:
            opacity = controller.value;
        }

        return Opacity(
          opacity: opacity,
          child: Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        );
      },
    );
  }
}
