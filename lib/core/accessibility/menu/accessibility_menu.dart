import 'package:flutter/material.dart';
import '../../../widgets/accessibility/accessible_tooltip.dart';
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
            message: 'Open Accessibility Menu',
            child: InkWell(
              borderRadius: BorderRadius.circular(t.buttonSize / 2),
              onTap: onPressed,
              child: Container(
                width: t.buttonSize,
                height: t.buttonSize,
                decoration: BoxDecoration(
                  color: t.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.borderColor,
                    width: t.borderWidth,
                  ),
                  boxShadow: t.boxShadow,
                ),
                child: Center(
                  child: Icon(
                    Icons.accessibility_new,
                    color: t.iconColor,
                    size: t.iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
