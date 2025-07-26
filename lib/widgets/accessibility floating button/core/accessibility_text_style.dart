/// Usage:
/// final settings = ref.watch(accessibilitySettingsProvider);
/// Text('Hello', style: AccessibilityTextStyle.fromSettings(settings));
library;

import 'package:flutter/material.dart';
import 'accessibility_settings.dart';

class AccessibilityTextStyle extends TextStyle {
  const AccessibilityTextStyle({
    super.fontSize,
    super.letterSpacing,
    super.height,
    super.fontFamily,
    TextAlign? textAlign,
    super.color,
    super.fontWeight,
    super.fontStyle,
    super.decoration,
    // ...other TextStyle params
  });

  /// Factory to build from AccessibilitySettings
  factory AccessibilityTextStyle.fromSettings(
    AccessibilitySettings settings, {
    double? baseFontSize,
    FontWeight? fontWeight,
    Color? color,
    bool applyPortfolioOnlyFeatures =
        true, // New parameter to control feature application
  }) {
    // Multi-level increments - only apply if portfolio-only features are enabled
    final fontSize =
        (baseFontSize ?? 16) +
        (applyPortfolioOnlyFeatures ? settings.fontSizeLevel * 2.0 : 0);
    final letterSpacing = applyPortfolioOnlyFeatures
        ? (settings.letterSpacingLevel * 0.5).toDouble()
        : 0.0;
    final height = applyPortfolioOnlyFeatures
        ? (1.2 + settings.lineHeightLevel * 0.2)
        : 1.2;

    // Dyslexia font is always applied (global feature)
    final family = settings.dyslexiaFontEnabled ? 'OpenDyslexic' : null;

    return AccessibilityTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: family,
      letterSpacing: letterSpacing,
      height: height,
      // ... existing code ...
    );
  }
}
