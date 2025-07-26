import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

void main() {
  group('AccessibilitySettings', () {
    test('should create with default values', () {
      const settings = AccessibilitySettings();

      expect(settings.fontSizeLevel, 0);
      expect(settings.letterSpacingLevel, 0);
      expect(settings.lineHeightLevel, 0);
      expect(settings.dyslexiaFontEnabled, false);
      expect(settings.highContrastEnabled, false);
      expect(settings.hideImages, false);
      expect(settings.highlightLinks, false);
      expect(settings.pauseAnimations, false);
      expect(settings.customCursor, false);
      expect(settings.tooltipsEnabled, true);
      expect(settings.pageStructureEnabled, false);
      expect(settings.textAlignLevel, 0);
      expect(settings.saturationLevel, 0);
    });

    test('should create with custom values', () {
      const settings = AccessibilitySettings(
        fontSizeLevel: 2,
        letterSpacingLevel: 3,
        lineHeightLevel: 1,
        dyslexiaFontEnabled: true,
        highContrastEnabled: true,
        hideImages: true,
        highlightLinks: true,
        pauseAnimations: true,
        customCursor: true,
        tooltipsEnabled: false,
        pageStructureEnabled: true,
        textAlignLevel: 2,
        saturationLevel: 3,
      );

      expect(settings.fontSizeLevel, 2);
      expect(settings.letterSpacingLevel, 3);
      expect(settings.lineHeightLevel, 1);
      expect(settings.dyslexiaFontEnabled, true);
      expect(settings.highContrastEnabled, true);
      expect(settings.hideImages, true);
      expect(settings.highlightLinks, true);
      expect(settings.pauseAnimations, true);
      expect(settings.customCursor, true);
      expect(settings.tooltipsEnabled, false);
      expect(settings.pageStructureEnabled, true);
      expect(settings.textAlignLevel, 2);
      expect(settings.saturationLevel, 3);
    });

    test('should copy with new values', () {
      const original = AccessibilitySettings(
        fontSizeLevel: 1,
        dyslexiaFontEnabled: true,
      );

      final copied = original.copyWith(
        fontSizeLevel: 3,
        highContrastEnabled: true,
      );

      expect(copied.fontSizeLevel, 3);
      expect(copied.dyslexiaFontEnabled, true); // Preserved from original
      expect(copied.highContrastEnabled, true); // New value
      expect(copied.letterSpacingLevel, 0); // Default value
    });

    test('should copy with null values (preserve original)', () {
      const original = AccessibilitySettings(
        fontSizeLevel: 2,
        dyslexiaFontEnabled: true,
      );

      final copied = original.copyWith(
        fontSizeLevel: null,
        dyslexiaFontEnabled: null,
      );

      expect(copied.fontSizeLevel, 2); // Preserved
      expect(copied.dyslexiaFontEnabled, true); // Preserved
    });
  });

  group('AccessibilitySettingsNotifier', () {
    late AccessibilitySettingsNotifier notifier;

    setUp(() {
      notifier = AccessibilitySettingsNotifier();
    });

    test('should initialize with default settings', () {
      expect(notifier.state, const AccessibilitySettings());
    });

    test('should set font size level', () {
      notifier.setFontSizeLevel(3);
      expect(notifier.state.fontSizeLevel, 3);
    });

    test('should set letter spacing level', () {
      notifier.setLetterSpacingLevel(2);
      expect(notifier.state.letterSpacingLevel, 2);
    });

    test('should set line height level', () {
      notifier.setLineHeightLevel(1);
      expect(notifier.state.lineHeightLevel, 1);
    });

    test('should set dyslexia font enabled', () {
      notifier.setDyslexiaFontEnabled(true);
      expect(notifier.state.dyslexiaFontEnabled, true);
    });

    test('should set high contrast enabled', () {
      notifier.setHighContrastEnabled(true);
      expect(notifier.state.highContrastEnabled, true);
    });

    test('should set hide images', () {
      notifier.setHideImages(true);
      expect(notifier.state.hideImages, true);
    });

    test('should set highlight links', () {
      notifier.setHighlightLinks(true);
      expect(notifier.state.highlightLinks, true);
    });

    test('should set pause animations', () {
      notifier.setPauseAnimations(true);
      expect(notifier.state.pauseAnimations, true);
    });

    test('should set custom cursor', () {
      notifier.setCustomCursor(true);
      expect(notifier.state.customCursor, true);
    });

    test('should set tooltips enabled', () {
      notifier.setTooltipsEnabled(false);
      expect(notifier.state.tooltipsEnabled, false);
    });

    test('should set page structure enabled', () {
      notifier.setPageStructureEnabled(true);
      expect(notifier.state.pageStructureEnabled, true);
    });

    test('should set text align level', () {
      notifier.setTextAlignLevel(2);
      expect(notifier.state.textAlignLevel, 2);
    });

    test('should set saturation level', () {
      notifier.setSaturationLevel(3);
      expect(notifier.state.saturationLevel, 3);
    });

    test('should reset to default settings', () {
      // Set some custom values
      notifier.setFontSizeLevel(3);
      notifier.setDyslexiaFontEnabled(true);
      notifier.setHighContrastEnabled(true);

      // Reset
      notifier.reset();

      // Should be back to defaults
      expect(notifier.state, const AccessibilitySettings());
    });

    test('should preserve other settings when updating one', () {
      // Set multiple values
      notifier.setFontSizeLevel(2);
      notifier.setDyslexiaFontEnabled(true);
      notifier.setHighContrastEnabled(true);

      // Update one value
      notifier.setFontSizeLevel(3);

      // Others should be preserved
      expect(notifier.state.fontSizeLevel, 3);
      expect(notifier.state.dyslexiaFontEnabled, true);
      expect(notifier.state.highContrastEnabled, true);
    });
  });
}
