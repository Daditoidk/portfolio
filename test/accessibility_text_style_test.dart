import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_text_style.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessibilityTextStyle.fromSettings', () {
    test('Default settings produce base values', () {
      final settings = AccessibilitySettings();
      final style = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 16,
      );
      expect(style.fontSize, 16);
      expect(style.letterSpacing, 0);
      expect(style.height, 1.2);
      expect(style.fontFamily, isNull);
    });

    test('Increasing fontSizeLevel increases font size', () {
      final settings = AccessibilitySettings(fontSizeLevel: 2);
      final style = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 16,
      );
      expect(style.fontSize, 16 + 2 * 2.0);
    });

    test('Increasing letterSpacingLevel increases letter spacing', () {
      final settings = AccessibilitySettings(letterSpacingLevel: 3);
      final style = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 16,
      );
      expect(style.letterSpacing, 0 + 3 * 0.5);
    });

    test('Increasing lineHeightLevel increases line height', () {
      final settings = AccessibilitySettings(lineHeightLevel: 2);
      final style = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 16,
      );
      expect(style.height, 1.2 + 2 * 0.2);
    });

    test('Dyslexia font enabled sets fontFamily', () {
      final settings = AccessibilitySettings(dyslexiaFontEnabled: true);
      final style = AccessibilityTextStyle.fromSettings(settings);
      expect(style.fontFamily, 'OpenDyslexic');
    });

    test('applyPortfolioOnlyFeatures=false only applies dyslexia font', () {
      final settings = AccessibilitySettings(
        fontSizeLevel: 2,
        letterSpacingLevel: 3,
        lineHeightLevel: 2,
        dyslexiaFontEnabled: true,
      );
      final style = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 16,
        applyPortfolioOnlyFeatures: false,
      );
      // Only dyslexia font should be applied, other features should be ignored
      expect(style.fontSize, 16); // No increase
      expect(style.letterSpacing, 0.0); // No increase
      expect(style.height, 1.2); // No increase
      expect(style.fontFamily, 'OpenDyslexic'); // Still applied
    });
  });
}
