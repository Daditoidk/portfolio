// Features free to implement in Flutter (no paid APIs required):
// - Contrast +, Highlight Links, Bigger Text, Text Spacing, Pause Animations, Hide Images, Dyslexia Friendly, Cursor, Tooltips, Page Structure, Line Height, Text Align, Saturation, Dictionary
// Not natively possible or require paid/external APIs: Screen Reader (web), Smart Contrast (advanced)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../shared/accessibility/accessible_text.dart';
import '../../constants/language_config.dart';
import 'accessibility_settings.dart';


class AccessibilityMenuContent extends ConsumerWidget {
  final String languageCode;
  final void Function(String languageCode) onLanguageChanged;
  final VoidCallback onClose;
  final VoidCallback? onPageStructureOpen; // Add callback for page structure

  const AccessibilityMenuContent({
    super.key,
    required this.languageCode,
    required this.onLanguageChanged,
    required this.onClose,
    this.onPageStructureOpen, // Add this parameter
  });

  static const Map<String, Map<String, String>> _texts = {
    'en': {
      'menuTitle': 'Accessibility Menu',
      'contrast': 'Contrast +',
      'highlightLinks': 'Highlight links',
      'enlargeText': 'Bigger Text',
      'textSpacing': 'Text Spacing',
      'stopAnimations': 'Pause Animations',
      'hideImages': 'Hide Images',
      'dyslexia': 'Dyslexia Friendly',
      'cursor': 'Cursor',
      'info': 'Tooltips',
      'lineHeight': 'Line Height',
      'alignText': 'Text Align',
      'saturation': 'Saturation',
      'reset': 'Reset All Accessibility Settings',
      'close': 'Close',
      'language': 'Language',
      'screenReader': 'Screen Reader',
      'smartContrast': 'Smart Contrast',
      'pageStructure': 'Page Structure',
      'dictionary': 'Dictionary',
      'oversizedWidget': 'Oversized Widget',
    },
    'es': {
      'menuTitle': 'Menú De Accesibilidad',
      'contrast': 'Contraste +',
      'highlightLinks': 'Resaltar enlaces',
      'enlargeText': 'Texto más grande',
      'textSpacing': 'Espaciado de texto',
      'stopAnimations': 'Pausar animaciones',
      'hideImages': 'Ocultar imágenes',
      'dyslexia': 'Apto para dislexia',
      'cursor': 'Cursor',
      'info': 'Información',
      'lineHeight': 'Altura de la línea',
      'alignText': 'Alinear texto',
      'saturation': 'Saturación',
      'reset': 'Restablecer todas las configuraciones de accesibilidad',
      'close': 'Cerrar',
      'language': 'Idioma',
      'screenReader': 'Lector de pantalla',
      'smartContrast': 'Contraste inteligente',
      'pageStructure': 'Estructura de la página',
      'dictionary': 'Diccionario',
      'oversizedWidget': 'Widget sobredimensionado',
    },
    'ja': {
      'menuTitle': 'アクセシビリティメニュー',
      'contrast': 'コントラスト +',
      'highlightLinks': 'リンクを強調表示',
      'enlargeText': 'テキストを大きく',
      'textSpacing': 'テキスト間隔',
      'stopAnimations': 'アニメーションを停止',
      'hideImages': '画像を非表示',
      'dyslexia': 'ディスレクシア対応',
      'cursor': 'カーソル',
      'info': 'ツールチップ',
      'lineHeight': '行の高さ',
      'alignText': 'テキストの整列',
      'saturation': '彩度',
      'reset': 'すべてのアクセシビリティ設定をリセット',
      'close': '閉じる',
      'language': '言語',
      'screenReader': 'スクリーンリーダー',
      'smartContrast': 'スマートコントラスト',
      'pageStructure': 'ページ構造',
      'dictionary': '辞書',
      'oversizedWidget': 'オーバーサイズウィジェット',
    },
  };

  String t(String key) =>
      _texts[languageCode]?[key] ?? _texts['en']![key] ?? key;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);
    final notifier = ref.read(accessibilitySettingsProvider.notifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AccessibleText(
                  t('menuTitle'),
                  baseFontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  applyPortfolioOnlyFeatures:
                      false, // Only dyslexia font applies to menu
                  languageCode: languageCode,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: onClose,
                tooltip: t('close'),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ),
        // Language switcher below the title/app bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.language, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AccessibleText(
                        t('language'),
                        baseFontSize: 13,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        applyPortfolioOnlyFeatures:
                            false, // Only dyslexia font applies to menu
                        languageCode: languageCode,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: languageCode,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      selectedItemBuilder: (context) {
                        return LanguageConfig.supportedLanguageCodes.map((l) {
                          final languageInfo = LanguageConfig.getLanguageInfo(
                            l,
                          );
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                languageInfo.flag,
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(width: 2),
                              AccessibleText(
                                languageInfo.name,
                                baseFontSize: 12,
                                color: Colors.black,
                                applyPortfolioOnlyFeatures:
                                    false, // Only dyslexia font applies to menu
                                languageCode: languageCode,
                              ),
                            ],
                          );
                        }).toList();
                      },
                      items: LanguageConfig.supportedLanguageCodes.map((l) {
                        final isSelected = l == languageCode;
                        final languageInfo = LanguageConfig.getLanguageInfo(l);
                        return DropdownMenuItem(
                          value: l,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                languageInfo.flag,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 6),
                              AccessibleText(
                                languageInfo.name,
                                baseFontSize: 13,
                                color: Colors.black,
                                applyPortfolioOnlyFeatures:
                                    false, // Only dyslexia font applies to menu
                                languageCode: languageCode,
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null && val != languageCode) {
                          onLanguageChanged(val);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Reset button below language switcher
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: AccessibleText(
              t('reset'),
              baseFontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              textAlign: TextAlign.center,
              applyPortfolioOnlyFeatures:
                  false, // Only dyslexia font applies to menu
              languageCode: languageCode,
            ),
            onPressed: notifier.reset,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Multi-level features
                  _SliderFeatureRow(
                    icon: Icons.format_size,
                    label: t('enlargeText'),
                    value: settings.fontSizeLevel,
                    max: 3,
                    onChanged: notifier.setFontSizeLevel,
                    leftExample: 'A',
                    rightExample: 'A',
                    leftFontSize: 10,
                    rightFontSize: 20,
                    languageCode: languageCode,
                  ),
                  _SliderFeatureRow(
                    icon: Icons.space_bar,
                    label: t('textSpacing'),
                    value: settings.letterSpacingLevel,
                    max: 3,
                    onChanged: notifier.setLetterSpacingLevel,
                    leftExample: 'ABC',
                    rightExample: 'A  B  C',
                    leftFontSize: 12,
                    rightFontSize: 12,
                    languageCode: languageCode,
                  ),
                  _SliderFeatureRow(
                    icon: Icons.format_line_spacing,
                    label: t('lineHeight'),
                    value: settings.lineHeightLevel,
                    max: 3,
                    onChanged: notifier.setLineHeightLevel,
                    leftExample: 'A\nB',
                    rightExample: 'A\n\nB',
                    leftFontSize: 12,
                    rightFontSize: 12,
                    languageCode: languageCode,
                  ),
                  const Divider(height: 32),
                  // Toggles
                  _SwitchFeatureRow(
                    icon: Icons.info_outline,
                    label: t('dyslexia'),
                    value: settings.dyslexiaFontEnabled,
                    onChanged: notifier.setDyslexiaFontEnabled,
                    languageCode: languageCode,
                  ),
                  _SwitchFeatureRow(
                    icon: Icons.image_not_supported,
                    label: t('hideImages'),
                    value: settings.hideImages,
                    onChanged: notifier.setHideImages,
                    languageCode: languageCode,
                  ),
                  _SwitchFeatureRow(
                    icon: Icons.link,
                    label: t('highlightLinks'),
                    value: settings.highlightLinks,
                    onChanged: notifier.setHighlightLinks,
                    languageCode: languageCode,
                  ),
                  _SwitchFeatureRow(
                    icon: Icons.pause_circle,
                    label: t('stopAnimations'),
                    value: settings.pauseAnimations,
                    onChanged: notifier.setPauseAnimations,
                    languageCode: languageCode,
                  ),
                  _SwitchFeatureRow(
                    icon: Icons.mouse,
                    label: t('cursor'),
                    value: settings.customCursor,
                    onChanged: notifier.setCustomCursor,
                    languageCode: languageCode,
                  ),
                  _SwitchFeatureRow(
                    icon: Icons.info,
                    label: t('info'),
                    value: settings.tooltipsEnabled,
                    onChanged: notifier.setTooltipsEnabled,
                    languageCode: languageCode,
                  ),
                  // Page Structure as a list tile instead of toggle
                  _ListTileFeatureRow(
                    icon: Icons.layers,
                    label: t('pageStructure'),
                    onTap: () {
                      // Enable page structure and open modal
                      notifier.setPageStructureEnabled(true);
                      onPageStructureOpen?.call();
                    },
                    languageCode: languageCode,
                  ),
                  if (kDebugMode) ...[
                    const Divider(height: 32),
                    // Debug: Enable Language Animations (mirrors pauseAnimations)
                    _SwitchFeatureRow(
                      icon: Icons.auto_awesome,
                      label: 'Enable Language Animations (Debug)',
                      value: !settings.pauseAnimations,
                      onChanged: (enabled) {
                        notifier.setPauseAnimations(!enabled);
                      },
                      languageCode: languageCode,
                    ),
                    // Debug: Choose Language Animation Strategy
                    

                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwitchFeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? languageCode;

  const _SwitchFeatureRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: AccessibleText(
              label,
              baseFontSize: 13,
              color: Colors.grey.shade800,
              applyPortfolioOnlyFeatures: false,
              languageCode: languageCode,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue.shade600,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _ListTileFeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? languageCode;

  const _ListTileFeatureRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: AccessibleText(
                  label,
                  baseFontSize: 13,
                  color: Colors.grey.shade800,
                  applyPortfolioOnlyFeatures: false,
                  languageCode: languageCode,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderFeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;
  final String? leftExample;
  final String? rightExample;
  final double? leftFontSize;
  final double? rightFontSize;
  final String? languageCode;

  const _SliderFeatureRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    this.leftExample,
    this.rightExample,
    this.leftFontSize,
    this.rightFontSize,
    this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Expanded(
                child: AccessibleText(
                  label,
                  baseFontSize: 13,
                  color: Colors.grey.shade800,
                  applyPortfolioOnlyFeatures: false,
                  languageCode: languageCode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Examples row
          Row(
            children: [
              // Left example
              Text(
                leftExample ?? 'A',
                style: TextStyle(
                  fontSize: leftFontSize ?? 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              // Slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12.0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20.0,
                    ),
                    activeTrackColor: Colors.blue.shade600,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: Colors.blue.shade700,
                    overlayColor: Colors.blue.withValues(alpha: 0.2),
                    // Show divisions
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: Slider(
                    value: value.toDouble(),
                    min: 0,
                    max: max.toDouble(),
                    divisions: max,
                    onChanged: (val) {
                      onChanged(val.round());
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Right example
              Text(
                rightExample ?? 'A',
                style: TextStyle(
                  fontSize: rightFontSize ?? 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


