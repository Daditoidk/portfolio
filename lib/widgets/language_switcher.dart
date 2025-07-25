import 'package:flutter/material.dart';
import '../core/l10n/app_localizations.dart';
import '../core/constants/semantic_labels.dart';
import '../core/constants/language_config.dart';
import '../core/accessibility/accessibility_floating_button.dart';

class LanguageSwitcher extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const LanguageSwitcher({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Hide language switcher on mobile
    if (isMobile) {
      return const SizedBox.shrink();
    }

    final languages = LanguageConfig.getAllLanguages();

    return Semantics(
      label: SemanticLabels.languageSwitcher,
      hint: l10n.a11yLanguageSwitcherHint,
      child: AccessibleTooltip(
        message: 'Language Switcher',
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < languages.length; i++) ...[
                  if (i > 0) ...[
                    const SizedBox(width: 3),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.withValues(alpha: 0.25),
                    ),
                    const SizedBox(width: 3),
                  ],
                  ClickableCursor(
                    onTap: () => onLocaleChanged(languages[i].locale),
                    child: _buildFlagButton(context, languages[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlagButton(BuildContext context, LanguageInfo languageInfo) {
    final isActive = currentLocale.languageCode == languageInfo.code;

    String getLabel() {
      switch (languageInfo.code) {
        case 'en':
          return SemanticLabels.switchToEnglish;
        case 'es':
          return SemanticLabels.switchToSpanish;
        case 'ja':
          return SemanticLabels.switchToJapanese;
        default:
          return SemanticLabels.switchToEnglish;
      }
    }

    String getHint() {
      if (isActive) return SemanticLabels.currentlySelectedLanguage;
      
      switch (languageInfo.code) {
        case 'en':
          return SemanticLabels.doubleTapToSwitchToEnglish;
        case 'es':
          return SemanticLabels.doubleTapToSwitchToSpanish;
        case 'ja':
          return SemanticLabels.doubleTapToSwitchToJapanese;
        default:
          return SemanticLabels.doubleTapToSwitchToEnglish;
      }
    }

    // Custom border radius based on position and selection state
    BorderRadius getBorderRadius() {
      final languages = LanguageConfig.getAllLanguages();
      final index = languages.indexOf(languageInfo);
      
      if (!isActive) {
        return BorderRadius.circular(18);
      }

      if (index == 0) {
        // First item: no border on right corners (adjacent to divider)
        return const BorderRadius.only(
          topLeft: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          topRight: Radius.zero,
          bottomRight: Radius.zero,
        );
      } else if (index == languages.length - 1) {
        // Last item: no border on left corners (adjacent to divider)
        return const BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        );
      } else {
        // Middle item: no border on both sides (adjacent to dividers)
        return BorderRadius.zero;
      }
    }

    return Semantics(
      label: getLabel(),
      hint: getHint(),
      value: isActive ? SemanticLabels.selected : SemanticLabels.notSelected,
      button: true,
      enabled: !isActive,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isHovered = false;

          return MouseRegion(
            onEnter: (_) {
              if (!isActive) {
                setState(() => isHovered = true);
              }
            },
            onExit: (_) {
              setState(() => isHovered = false);
            },
            child: GestureDetector(
              onTap: isActive
                  ? null
                  : () => onLocaleChanged(languageInfo.locale),
              child: Builder(
                builder: (context) {
                  Color backgroundColor;
                  if (isActive) {
                    backgroundColor = Colors.blue.withValues(alpha: 0.1);
                  } else if (isHovered) {
                    backgroundColor = Colors.blue.withValues(alpha: 0.05);
                  } else {
                    backgroundColor = Colors.transparent;
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: getBorderRadius(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          label: _getFlagLabel(languageInfo.code),
                          child: Text(
                            languageInfo.flag,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 4),
                          Semantics(
                            label: SemanticLabels.selected,
                            child: Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFlagLabel(String languageCode) {
    switch (languageCode) {
      case 'en':
        return SemanticLabels.australianFlag;
      case 'es':
        return SemanticLabels.colombianFlag;
      case 'ja':
        return SemanticLabels.japaneseFlag;
      default:
        return SemanticLabels.australianFlag;
    }
  }
}
