import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';
import '../../core/accessibility/menu/accessibility_text_style.dart';
import '../../core/animations/animated_text_widget.dart';
import '../../core/animations/language_change_animation.dart';

class AccessibleText extends StatelessWidget {
  final String text;
  final double? baseFontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool applyPortfolioOnlyFeatures;
  final String? languageCode;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final int? manualLineIndex; // Manual override for line
  final int? manualBlockIndex; // Manual override for block

  const AccessibleText(
    this.text, {
    super.key,
    this.baseFontSize,
    this.fontWeight,
    this.color,
    this.applyPortfolioOnlyFeatures = true,
    this.languageCode,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
    this.manualLineIndex,
    this.manualBlockIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: Consumer(
        builder: (context, ref, _) {
          final settings = ref.watch(accessibilitySettingsProvider);
          // Link accessibility "pause animations" to language animation skip
          LanguageChangeAnimationController().setSkipAnimations(
            settings.pauseAnimations,
          );
          return LanguageAnimatedText(
            text,
            style: AccessibilityTextStyle.fromSettings(
              settings,
              baseFontSize: baseFontSize ?? 16,
              fontWeight: fontWeight,
              color: color,
              applyPortfolioOnlyFeatures: applyPortfolioOnlyFeatures,
              languageCode: languageCode,
            ),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            manualLineIndex: manualLineIndex,
            manualBlockIndex: manualBlockIndex,
          );
        },
      ),
    );
  }
}
