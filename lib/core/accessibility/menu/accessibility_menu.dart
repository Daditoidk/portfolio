import 'package:flutter/material.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/theme/portfolio_theme.dart';
import '../../../shared/accessibility/accessible_tooltip.dart';
import '../../theme/accessibility_menu_theme.dart';

/// Alignment for the menu panel: AlignmentDirectional.end (right) or AlignmentDirectional.start (left)
class AccessibilityMenu extends StatelessWidget {
  final String languageCode;
  final void Function(String languageCode)? onLanguageChanged;
  final AccessibilityMenuTheme theme;
  final AlignmentDirectional menuAlignment;
  final VoidCallback? onPressed;

  const AccessibilityMenu({
    super.key,
    this.languageCode = 'en',
    this.onLanguageChanged,
    this.theme = defaultAccessibilityMenuTheme,
    this.menuAlignment = AlignmentDirectional.bottomEnd, // right by default
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final isRight = menuAlignment == AlignmentDirectional.bottomEnd;
    return Align(
      alignment: isRight ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          color: Colors.transparent,
          child: AccessibleTooltip(
            // message: 'Open accessibility settings',
            message: 'We are still working on this feature',
            child: InkWell(
              borderRadius: BorderRadius.circular(t.buttonSize / 2),
              onTap: onPressed,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: PortfolioTheme.orangeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PortfolioTheme.shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.accessibility,
                  color: PortfolioTheme.whiteColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
