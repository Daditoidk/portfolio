import 'package:flutter/material.dart';
import '../core/l10n/app_localizations.dart';
import '../core/constants/semantic_labels.dart';

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

    return Semantics(
      label: SemanticLabels.languageSwitcher,
      hint: l10n.a11yLanguageSwitcherHint,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFlagButton(context, '🇺🇸', const Locale('en'), 'English'),
              const SizedBox(width: 5),
              Container(
                width: 1.5,
                height: 30,
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              const SizedBox(width: 5),
              _buildFlagButton(context, '🇨🇴', const Locale('es'), 'Español'),
              const SizedBox(width: 5),
              Container(
                width: 1.5,
                height: 30,
                color: Colors.grey.withValues(alpha: 0.25),
              ),
              const SizedBox(width: 5),
              _buildFlagButton(context, '🇯🇵', const Locale('ja'), '日本語'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlagButton(
    BuildContext context,
    String flag,
    Locale locale,
    String languageName,
  ) {
    final isActive = currentLocale.languageCode == locale.languageCode;
    final isEnglish = locale.languageCode == 'en';
    final isSpanish = locale.languageCode == 'es';
    final isJapanese = locale.languageCode == 'ja';

    String getLabel() {
      if (isEnglish) return SemanticLabels.switchToEnglish;
      if (isSpanish) return SemanticLabels.switchToSpanish;
      if (isJapanese) return SemanticLabels.switchToJapanese;
      return SemanticLabels.switchToEnglish;
    }

    String getHint() {
      if (isActive) return SemanticLabels.currentlySelectedLanguage;
      if (isEnglish) return SemanticLabels.doubleTapToSwitchToEnglish;
      if (isSpanish) return SemanticLabels.doubleTapToSwitchToSpanish;
      if (isJapanese) return SemanticLabels.doubleTapToSwitchToJapanese;
      return SemanticLabels.doubleTapToSwitchToEnglish;
    }

    // Custom border radius based on position and selection state
    BorderRadius getBorderRadius() {
      if (!isActive) {
        return BorderRadius.circular(25);
      }

      if (isEnglish) {
        // First item: no border on right corners (adjacent to divider)
        return const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          topRight: Radius.zero,
          bottomRight: Radius.zero,
        );
      } else if (isSpanish) {
        // Middle item: no border on both sides (adjacent to dividers)
        return BorderRadius.zero;
      } else if (isJapanese) {
        // Last item: no border on left corners (adjacent to divider)
        return const BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        );
      }

      return BorderRadius.circular(25);
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
              onTap: isActive ? null : () => onLocaleChanged(locale),
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
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: getBorderRadius(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          label: SemanticLabels.americanFlag,
                          child: Text(
                            flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 8),
                          Semantics(
                            label: SemanticLabels.selected,
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
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
}
