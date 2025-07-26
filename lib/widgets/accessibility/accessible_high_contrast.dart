import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';

/// A widget that applies high contrast styling to its child when enabled
///
/// This widget automatically applies high contrast colors and styling
/// based on the accessibility settings. It's designed to be a reusable
/// brick for Mason templates.
class AccessibleHighContrast extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool applyToText;
  final bool applyToIcons;
  final bool applyToButtons;

  const AccessibleHighContrast({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.applyToText = true,
    this.applyToIcons = true,
    this.applyToButtons = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.highContrastEnabled) {
      return child;
    }

    return _HighContrastWrapper(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      applyToText: applyToText,
      applyToIcons: applyToIcons,
      applyToButtons: applyToButtons,
      child: child,
    );
  }
}

class _HighContrastWrapper extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool applyToText;
  final bool applyToIcons;
  final bool applyToButtons;

  const _HighContrastWrapper({
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    required this.applyToText,
    required this.applyToIcons,
    required this.applyToButtons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // High contrast colors
    final bgColor = backgroundColor ?? (isDark ? Colors.black : Colors.white);
    final fgColor = foregroundColor ?? (isDark ? Colors.white : Colors.black);

    return Theme(
      data: theme.copyWith(
        // Apply high contrast to text if enabled
        textTheme: applyToText
            ? _getHighContrastTextTheme(theme.textTheme, fgColor)
            : theme.textTheme,
        // Apply high contrast to icons if enabled
        iconTheme: applyToIcons
            ? _getHighContrastIconTheme(theme.iconTheme, fgColor)
            : theme.iconTheme,
        // Apply high contrast to buttons if enabled
        elevatedButtonTheme: applyToButtons
            ? _getHighContrastButtonTheme(theme, bgColor, fgColor)
            : theme.elevatedButtonTheme,
        textButtonTheme: applyToButtons
            ? _getHighContrastTextButtonTheme(theme, fgColor)
            : theme.textButtonTheme,
        outlinedButtonTheme: applyToButtons
            ? _getHighContrastOutlinedButtonTheme(theme, bgColor, fgColor)
            : theme.outlinedButtonTheme,
      ),
      child: Container(color: bgColor, child: child),
    );
  }

  TextTheme _getHighContrastTextTheme(TextTheme textTheme, Color fgColor) {
    return textTheme.apply(bodyColor: fgColor, displayColor: fgColor);
  }

  IconThemeData _getHighContrastIconTheme(
    IconThemeData iconTheme,
    Color fgColor,
  ) {
    return iconTheme.copyWith(color: fgColor);
  }

  ElevatedButtonThemeData _getHighContrastButtonTheme(
    ThemeData theme,
    Color bgColor,
    Color fgColor,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: fgColor,
        foregroundColor: bgColor,
        side: BorderSide(color: fgColor, width: 2),
      ),
    );
  }

  TextButtonThemeData _getHighContrastTextButtonTheme(
    ThemeData theme,
    Color fgColor,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: fgColor,
        side: BorderSide(color: fgColor, width: 2),
      ),
    );
  }

  OutlinedButtonThemeData _getHighContrastOutlinedButtonTheme(
    ThemeData theme,
    Color bgColor,
    Color fgColor,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: fgColor,
        side: BorderSide(color: fgColor, width: 2),
      ),
    );
  }
}
