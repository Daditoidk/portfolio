import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessibilitySettings {
  final int fontSizeLevel; // 0-3
  final int letterSpacingLevel; // 0-3
  final int lineHeightLevel; // 0-3
  final bool dyslexiaFontEnabled;
  final bool highContrastEnabled;
  final bool hideImages;
  final bool highlightLinks;
  final bool pauseAnimations;
  final bool customCursor;
  final bool tooltipsEnabled;
  final bool pageStructureEnabled;
  final int textAlignLevel; // 0: left, 1: center, 2: right, 3: justify
  final int saturationLevel; // 0-3

  const AccessibilitySettings({
    this.fontSizeLevel = 0,
    this.letterSpacingLevel = 0,
    this.lineHeightLevel = 0,
    this.dyslexiaFontEnabled = false,
    this.highContrastEnabled = false,
    this.hideImages = false,
    this.highlightLinks = false,
    this.pauseAnimations = false,
    this.customCursor = false,
    this.tooltipsEnabled = true,
    this.pageStructureEnabled = false,
    this.textAlignLevel = 0,
    this.saturationLevel = 0,
  });

  AccessibilitySettings copyWith({
    int? fontSizeLevel,
    int? letterSpacingLevel,
    int? lineHeightLevel,
    bool? dyslexiaFontEnabled,
    bool? highContrastEnabled,
    bool? hideImages,
    bool? highlightLinks,
    bool? pauseAnimations,
    bool? customCursor,
    bool? tooltipsEnabled,
    bool? pageStructureEnabled,
    int? textAlignLevel,
    int? saturationLevel,
  }) {
    return AccessibilitySettings(
      fontSizeLevel: fontSizeLevel ?? this.fontSizeLevel,
      letterSpacingLevel: letterSpacingLevel ?? this.letterSpacingLevel,
      lineHeightLevel: lineHeightLevel ?? this.lineHeightLevel,
      dyslexiaFontEnabled: dyslexiaFontEnabled ?? this.dyslexiaFontEnabled,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      hideImages: hideImages ?? this.hideImages,
      highlightLinks: highlightLinks ?? this.highlightLinks,
      pauseAnimations: pauseAnimations ?? this.pauseAnimations,
      customCursor: customCursor ?? this.customCursor,
      tooltipsEnabled: tooltipsEnabled ?? this.tooltipsEnabled,
      pageStructureEnabled: pageStructureEnabled ?? this.pageStructureEnabled,
      textAlignLevel: textAlignLevel ?? this.textAlignLevel,
      saturationLevel: saturationLevel ?? this.saturationLevel,
    );
  }
}

class AccessibilitySettingsNotifier
    extends StateNotifier<AccessibilitySettings> {
  AccessibilitySettingsNotifier() : super(const AccessibilitySettings());

  void setFontSizeLevel(int level) =>
      state = state.copyWith(fontSizeLevel: level);
  void setLetterSpacingLevel(int level) =>
      state = state.copyWith(letterSpacingLevel: level);
  void setLineHeightLevel(int level) =>
      state = state.copyWith(lineHeightLevel: level);
  void setDyslexiaFontEnabled(bool enabled) =>
      state = state.copyWith(dyslexiaFontEnabled: enabled);
  void setHighContrastEnabled(bool enabled) =>
      state = state.copyWith(highContrastEnabled: enabled);
  void setHideImages(bool enabled) =>
      state = state.copyWith(hideImages: enabled);
  void setHighlightLinks(bool enabled) =>
      state = state.copyWith(highlightLinks: enabled);
  void setPauseAnimations(bool enabled) =>
      state = state.copyWith(pauseAnimations: enabled);
  void setCustomCursor(bool enabled) =>
      state = state.copyWith(customCursor: enabled);
  void setTooltipsEnabled(bool enabled) =>
      state = state.copyWith(tooltipsEnabled: enabled);
  void setPageStructureEnabled(bool enabled) =>
      state = state.copyWith(pageStructureEnabled: enabled);
  void setTextAlignLevel(int level) =>
      state = state.copyWith(textAlignLevel: level);
  void setSaturationLevel(int level) =>
      state = state.copyWith(saturationLevel: level);
  void reset() => state = const AccessibilitySettings();
}

final accessibilitySettingsProvider =
    StateNotifierProvider<AccessibilitySettingsNotifier, AccessibilitySettings>(
      (ref) => AccessibilitySettingsNotifier(),
    );
