import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';
import '../../core/accessibility/menu/accessibility_text_style.dart';

class AccessibleTooltip extends ConsumerWidget {
  final String message;
  final Widget child;
  final String? semanticsLabel;
  final double? baseFontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool applyPortfolioOnlyFeatures;

  const AccessibleTooltip({
    super.key,
    required this.message,
    required this.child,
    this.semanticsLabel,
    this.baseFontSize,
    this.fontWeight,
    this.color,
    this.applyPortfolioOnlyFeatures = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    // If tooltips are disabled, just return the child with semantics
    if (!settings.tooltipsEnabled) {
      return Semantics(label: semanticsLabel, child: child);
    }

    return Tooltip(
      message: message,
      textStyle: AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: baseFontSize ?? 12,
        fontWeight: fontWeight,
        color: color ?? Colors.white,
        applyPortfolioOnlyFeatures: applyPortfolioOnlyFeatures,
      ),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Semantics(label: semanticsLabel, child: child),
    );
  }
}
