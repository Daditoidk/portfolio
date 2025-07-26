import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';

/// A widget that provides a custom cursor when accessibility setting is enabled
///
/// This widget automatically shows a custom cursor when the custom cursor
/// setting is enabled.
class AccessibleCustomCursor extends ConsumerWidget {
  final Widget child;
  final SystemMouseCursor? defaultCursor;
  final SystemMouseCursor? customCursor;
  final bool showCustomCursor;

  const AccessibleCustomCursor({
    super.key,
    required this.child,
    this.defaultCursor,
    this.customCursor,
    this.showCustomCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.customCursor || !showCustomCursor) {
      return MouseRegion(
        cursor: defaultCursor ?? SystemMouseCursors.basic,
        child: child,
      );
    }

    return MouseRegion(
      cursor: customCursor ?? SystemMouseCursors.click,
      child: child,
    );
  }
}

/// A specialized button that shows a custom cursor when accessibility is enabled
class AccessibleButton extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final SystemMouseCursor? defaultCursor;
  final SystemMouseCursor? customCursor;
  final bool showCustomCursor;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.defaultCursor,
    this.customCursor,
    this.showCustomCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final cursor = settings.customCursor && showCustomCursor
        ? (customCursor ?? SystemMouseCursors.click)
        : (defaultCursor ?? SystemMouseCursors.basic);

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}

/// A specialized link widget that shows a custom cursor when accessibility is enabled
class AccessibleLink extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final SystemMouseCursor? defaultCursor;
  final SystemMouseCursor? customCursor;
  final bool showCustomCursor;

  const AccessibleLink({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.defaultCursor,
    this.customCursor,
    this.showCustomCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final cursor = settings.customCursor && showCustomCursor
        ? (customCursor ?? SystemMouseCursors.click)
        : (defaultCursor ?? SystemMouseCursors.basic);

    return MouseRegion(
      cursor: cursor,
      child: InkWell(onTap: onTap, onLongPress: onLongPress, child: child),
    );
  }
}

/// A specialized text link that shows a custom cursor when accessibility is enabled
class AccessibleTextLink extends ConsumerWidget {
  final String text;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TextStyle? style;
  final SystemMouseCursor? defaultCursor;
  final SystemMouseCursor? customCursor;
  final bool showCustomCursor;

  const AccessibleTextLink({
    super.key,
    required this.text,
    this.onTap,
    this.onLongPress,
    this.style,
    this.defaultCursor,
    this.customCursor,
    this.showCustomCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final cursor = settings.customCursor && showCustomCursor
        ? (customCursor ?? SystemMouseCursors.click)
        : (defaultCursor ?? SystemMouseCursors.basic);

    final theme = Theme.of(context);
    final linkStyle =
        style ??
        TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        );

    return MouseRegion(
      cursor: cursor,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Text(text, style: linkStyle),
      ),
    );
  }
}

/// A specialized icon button that shows a custom cursor when accessibility is enabled
class AccessibleIconButton extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final SystemMouseCursor? defaultCursor;
  final SystemMouseCursor? customCursor;
  final bool showCustomCursor;

  const AccessibleIconButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.defaultCursor,
    this.customCursor,
    this.showCustomCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final cursor = settings.customCursor && showCustomCursor
        ? (customCursor ?? SystemMouseCursors.click)
        : (defaultCursor ?? SystemMouseCursors.basic);

    return MouseRegion(
      cursor: cursor,
      child: IconButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        icon: child,
      ),
    );
  }
}
