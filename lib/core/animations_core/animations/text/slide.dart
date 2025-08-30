import 'package:flutter/material.dart';
import '../../../../screens/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

mixin SimpleSlideMixin {
  /// Builds a text widget with slide animation effect
  Widget buildSlideText({
    required String text,
    required SlideTextPropertiesData config,
    required AnimationController controller,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    // Direct access to properties - no casting needed!
    final direction = config.direction;
    // Speed is used by the animation controller, not directly in this mixin

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        Offset offset;

        switch (direction.toLowerCase()) {
          case 'slide in left':
            offset = Offset(-100 * (1 - controller.value), 0);
            break;
          case 'slide in right':
            offset = Offset(100 * (1 - controller.value), 0);
            break;
          case 'slide in top':
            offset = Offset(0, -100 * (1 - controller.value));
            break;
          case 'slide in bottom':
            offset = Offset(0, 100 * (1 - controller.value));
            break;
          case 'slide in center':
            // Slide from center with scale effect
            final scale = 0.5 + (controller.value * 0.5);
            return Transform.scale(
              scale: scale,
              child: Text(
                text,
                style: style,
                textAlign: textAlign,
                maxLines: maxLines,
                overflow: overflow,
              ),
            );
          default:
            offset = Offset(-100 * (1 - controller.value), 0);
        }

        return Transform.translate(
          offset: offset,
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
