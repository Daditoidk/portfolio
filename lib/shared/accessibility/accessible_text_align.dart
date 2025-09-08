import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/accessibility/menu/accessibility_settings.dart';

/// A widget that applies text alignment based on accessibility settings
///
/// This widget automatically applies text alignment (left, center, right, justify)
/// based on the accessibility settings.
class AccessibleTextAlign extends ConsumerWidget {
  final Widget child;
  final TextAlign? defaultAlign;
  final bool applyToText;
  final bool applyToRichText;
  final bool applyToTextFields;

  const AccessibleTextAlign({
    super.key,
    required this.child,
    this.defaultAlign,
    this.applyToText = true,
    this.applyToRichText = true,
    this.applyToTextFields = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.textAlignLevel == 0) {
      return child;
    }

    return _TextAlignWrapper(
      textAlignLevel: settings.textAlignLevel,
      defaultAlign: defaultAlign,
      applyToText: applyToText,
      applyToRichText: applyToRichText,
      applyToTextFields: applyToTextFields,
      child: child,
    );
  }
}

class _TextAlignWrapper extends StatelessWidget {
  final Widget child;
  final int textAlignLevel;
  final TextAlign? defaultAlign;
  final bool applyToText;
  final bool applyToRichText;
  final bool applyToTextFields;

  const _TextAlignWrapper({
    required this.child,
    required this.textAlignLevel,
    this.defaultAlign,
    required this.applyToText,
    required this.applyToRichText,
    required this.applyToTextFields,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign = _getTextAlign(textAlignLevel);

    return Theme(
      data: theme.copyWith(
        // Apply text alignment to input decoration theme
        inputDecorationTheme: applyToTextFields
            ? _getAlignedInputDecorationTheme(
                theme.inputDecorationTheme,
                textAlign,
              )
            : theme.inputDecorationTheme,
      ),
      child: child,
    );
  }

  TextAlign _getTextAlign(int level) {
    switch (level) {
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.right;
      case 3:
        return TextAlign.justify;
      default:
        return defaultAlign ?? TextAlign.left;
    }
  }

  InputDecorationTheme _getAlignedInputDecorationTheme(
    InputDecorationTheme? inputTheme,
    TextAlign textAlign,
  ) {
    return (inputTheme ?? const InputDecorationTheme()).copyWith(
      alignLabelWithHint: true,
    );
  }
}

/// A specialized Text widget that respects text alignment settings
class AccessibleTextWithAlign extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final bool? semanticsLabel;

  const AccessibleTextWithAlign(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final effectiveTextAlign = settings.textAlignLevel > 0
        ? _getTextAlign(settings.textAlignLevel)
        : (textAlign ?? TextAlign.left);

    return Text(
      text,
      style: style,
      textAlign: effectiveTextAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      semanticsLabel: semanticsLabel?.toString(),
    );
  }

  TextAlign _getTextAlign(int level) {
    switch (level) {
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.right;
      case 3:
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}

/// A specialized RichText widget that respects text alignment settings
class AccessibleRichText extends ConsumerWidget {
  final InlineSpan text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const AccessibleRichText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    final effectiveTextAlign = settings.textAlignLevel > 0
        ? _getTextAlign(settings.textAlignLevel)
        : (textAlign ?? TextAlign.left);

    return RichText(
      text: text,
      textAlign: effectiveTextAlign,
      textDirection: textDirection,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      textScaler: textScaleFactor != null
          ? TextScaler.linear(textScaleFactor!)
          : TextScaler.noScaling,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  TextAlign _getTextAlign(int level) {
    switch (level) {
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.right;
      case 3:
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }
}
