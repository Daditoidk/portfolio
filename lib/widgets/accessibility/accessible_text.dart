import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';
import '../../core/accessibility/menu/accessibility_text_style.dart';

class AccessibleText extends StatelessWidget {
  final String text;
  final String? semanticsLabel;
  final double? baseFontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool applyPortfolioOnlyFeatures; // New parameter

  const AccessibleText(
    this.text, {
    super.key,
    this.semanticsLabel,
    this.baseFontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.applyPortfolioOnlyFeatures =
        true, // Default to true for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: Consumer(
        builder: (context, ref, _) {
          final settings = ref.watch(accessibilitySettingsProvider);
          return Text(
            text,
            style: AccessibilityTextStyle.fromSettings(
              settings,
              baseFontSize: baseFontSize ?? 16,
              fontWeight: fontWeight,
              color: color,
              applyPortfolioOnlyFeatures: applyPortfolioOnlyFeatures,
            ),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        },
      ),
    );
  }
}
