import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';

/// A widget that highlights clickable links when accessibility setting is enabled
///
/// This widget automatically applies visual highlighting to clickable elements
/// when the highlight links setting is enabled.
class AccessibleHighlightLinks extends ConsumerWidget {
  final Widget child;
  final Color? highlightColor;
  final double? highlightThickness;
  final BorderRadius? highlightRadius;
  final bool applyToButtons;
  final bool applyToInkWell;
  final bool applyToGestureDetector;

  const AccessibleHighlightLinks({
    super.key,
    required this.child,
    this.highlightColor,
    this.highlightThickness,
    this.highlightRadius,
    this.applyToButtons = true,
    this.applyToInkWell = true,
    this.applyToGestureDetector = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.highlightLinks) {
      return child;
    }

    return _LinkHighlighter(
      highlightColor: highlightColor,
      highlightThickness: highlightThickness,
      highlightRadius: highlightRadius,
      applyToButtons: applyToButtons,
      applyToInkWell: applyToInkWell,
      applyToGestureDetector: applyToGestureDetector,
      child: child,
    );
  }
}

class _LinkHighlighter extends StatelessWidget {
  final Widget child;
  final Color? highlightColor;
  final double? highlightThickness;
  final BorderRadius? highlightRadius;
  final bool applyToButtons;
  final bool applyToInkWell;
  final bool applyToGestureDetector;

  const _LinkHighlighter({
    required this.child,
    this.highlightColor,
    this.highlightThickness,
    this.highlightRadius,
    required this.applyToButtons,
    required this.applyToInkWell,
    required this.applyToGestureDetector,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultHighlightColor = theme.colorScheme.primary;
    final defaultThickness = highlightThickness ?? 2.0;
    final defaultRadius = highlightRadius ?? BorderRadius.circular(4);

    return Theme(
      data: theme.copyWith(
        // Apply highlighting to buttons
        elevatedButtonTheme: applyToButtons
            ? _getHighlightedButtonTheme(
                theme,
                defaultHighlightColor,
                defaultThickness,
                defaultRadius,
              )
            : theme.elevatedButtonTheme,
        textButtonTheme: applyToButtons
            ? _getHighlightedTextButtonTheme(
                theme,
                defaultHighlightColor,
                defaultThickness,
                defaultRadius,
              )
            : theme.textButtonTheme,
        outlinedButtonTheme: applyToButtons
            ? _getHighlightedOutlinedButtonTheme(
                theme,
                defaultHighlightColor,
                defaultThickness,
                defaultRadius,
              )
            : theme.outlinedButtonTheme,
        // Apply highlighting to other clickable elements
        cardTheme: _getHighlightedCardTheme(
          theme,
          defaultHighlightColor,
          defaultThickness,
          defaultRadius,
        ),
      ),
      child: child,
    );
  }

  ElevatedButtonThemeData _getHighlightedButtonTheme(
    ThemeData theme,
    Color highlightColor,
    double thickness,
    BorderRadius radius,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: highlightColor, width: thickness),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    );
  }

  TextButtonThemeData _getHighlightedTextButtonTheme(
    ThemeData theme,
    Color highlightColor,
    double thickness,
    BorderRadius radius,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        side: BorderSide(color: highlightColor, width: thickness),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    );
  }

  OutlinedButtonThemeData _getHighlightedOutlinedButtonTheme(
    ThemeData theme,
    Color highlightColor,
    double thickness,
    BorderRadius radius,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: highlightColor, width: thickness),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    );
  }

  CardThemeData _getHighlightedCardTheme(
    ThemeData theme,
    Color highlightColor,
    double thickness,
    BorderRadius radius,
  ) {
    return CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: highlightColor, width: thickness),
      ),
    );
  }
}

/// A specialized InkWell that automatically applies link highlighting
class AccessibleInkWell extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? highlightColor;
  final double? highlightThickness;
  final BorderRadius? borderRadius;

  const AccessibleInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.highlightColor,
    this.highlightThickness,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.highlightLinks) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius,
        child: child,
      );
    }

    final theme = Theme.of(context);
    final defaultHighlightColor = highlightColor ?? theme.colorScheme.primary;
    final defaultThickness = highlightThickness ?? 2.0;
    final defaultRadius = borderRadius ?? BorderRadius.circular(4);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: defaultHighlightColor,
          width: defaultThickness,
        ),
        borderRadius: defaultRadius,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: defaultRadius,
        child: child,
      ),
    );
  }
}

/// A specialized GestureDetector that automatically applies link highlighting
class AccessibleGestureDetector extends ConsumerWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final Color? highlightColor;
  final double? highlightThickness;
  final BorderRadius? borderRadius;

  const AccessibleGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.highlightColor,
    this.highlightThickness,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.highlightLinks) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      );
    }

    final theme = Theme.of(context);
    final defaultHighlightColor = highlightColor ?? theme.colorScheme.primary;
    final defaultThickness = highlightThickness ?? 2.0;
    final defaultRadius = borderRadius ?? BorderRadius.circular(4);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: defaultHighlightColor,
          width: defaultThickness,
        ),
        borderRadius: defaultRadius,
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
