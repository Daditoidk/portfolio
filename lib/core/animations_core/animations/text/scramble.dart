import 'package:flutter/material.dart';
import '../../../../screens/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

mixin SimpleScrambleMixin {
  /// Builds a text widget with scramble animation effect
  Widget buildScrambleText({
    required String text,
    required ScrambleTextPropertiesData config,
    required AnimationController controller,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    // Direct access to properties - no casting needed!
    final scrambleIntensity = config.intensity;
    final direction = config.direction;
    // Speed is used by the animation controller, not directly in this mixin

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = controller.value;

        // Calculate visible characters based on progress and direction
        final totalChars = text.length;
        int visibleChars;

        switch (direction.toLowerCase()) {
          case 'left to right':
            visibleChars = (totalChars * progress).round();
            break;
          case 'right to left':
            visibleChars = (totalChars * (1 - progress)).round();
            break;
          case 'center out':
            final center = totalChars / 2;
            final halfProgress = progress / 2;
            final leftChars = (center * halfProgress).round();
            final rightChars = (center * halfProgress).round();
            visibleChars = leftChars + rightChars;
            break;
          default:
            visibleChars = (totalChars * progress).round();
        }

        // Ensure visibleChars is within bounds
        visibleChars = visibleChars.clamp(0, totalChars);

        // Build the visible text with scramble effect
        String displayText = '';
        for (int i = 0; i < totalChars; i++) {
          if (i < visibleChars) {
            // Show actual character
            displayText += text[i];
          } else {
            // Show scramble character based on intensity
            if (scrambleIntensity > 0.8) {
              displayText += _getRandomScrambleChar();
            } else if (scrambleIntensity > 0.5) {
              displayText += _getScrambleChar(text[i]);
            } else {
              displayText += ' ';
            }
          }
        }

        return Text(
          displayText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  /// Gets a random scramble character
  String _getRandomScrambleChar() {
    const scrambleChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?/~`';
    return scrambleChars[DateTime.now().millisecondsSinceEpoch %
        scrambleChars.length];
  }

  /// Gets a scramble character based on the original character
  String _getScrambleChar(String originalChar) {
    if (originalChar == ' ') return ' ';

    // Simple character substitution for scramble effect
    const charMap = {
      'a': '4',
      'e': '3',
      'i': '1',
      'o': '0',
      's': '5',
      'A': '4',
      'E': '3',
      'I': '1',
      'O': '0',
      'S': '5',
    };

    return charMap[originalChar] ?? _getRandomScrambleChar();
  }
}
