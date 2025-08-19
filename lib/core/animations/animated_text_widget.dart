import 'package:flutter/material.dart';
import 'text_animation_registry.dart';

/// Standalone animated text widget for scroll animations
/// Can be used independently or by accessibility system
class AnimatedText extends StatelessWidget {
  final String text;
  final String? id;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;

  // Animation-specific properties
  final bool registerForLanguageAnimation;
  final bool registerForScrollAnimation;

  const AnimatedText(
    this.text, {
    super.key,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.registerForLanguageAnimation = true,
    this.registerForScrollAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    // Register for language animation if enabled
    if (registerForLanguageAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TextAnimationRegistry().registerText(
          context: context,
          text: text,
          id: id,
          key: key as GlobalKey?,
        );
      });
    }

    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

/// Animated text widget specifically for language changes
/// Used by accessibility system
class LanguageAnimatedText extends StatelessWidget {
  final String text;
  final String? id;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;
  final int? manualLineIndex; // Manual override for line
  final int? manualBlockIndex; // Manual override for block

  const LanguageAnimatedText(
    this.text, {
    super.key,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.manualLineIndex,
    this.manualBlockIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Always register for language animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TextAnimationRegistry().registerText(
        context: context,
        text: text,
        id: id,
        key: key as GlobalKey?,
        manualLineIndex: manualLineIndex,
        manualBlockIndex: manualBlockIndex,
      );
    });

    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

/// Animated text widget specifically for scroll animations
/// Does NOT register for language changes
class ScrollAnimatedText extends StatelessWidget {
  final String text;
  final String? id;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;

  const ScrollAnimatedText(
    this.text, {
    super.key,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Only register for scroll animations, NOT language changes
    // This can be wrapped with FadeInAnimation, etc.

    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

/// Utility class to help with text registration
class TextAnimationHelper {
  /// Register text for language animation (used by accessibility system)
  static void registerForLanguageAnimation({
    required BuildContext context,
    required String text,
    String? id,
    GlobalKey? key,
  }) {
    TextAnimationRegistry().registerText(
      context: context,
      text: text,
      id: id,
      key: key,
    );
  }

  /// Unregister text from language animation
  static void unregisterFromLanguageAnimation(String id) {
    TextAnimationRegistry().unregisterText(id);
  }

  /// Get debug info about registered texts
  static String getDebugInfo() {
    return TextAnimationRegistry().getDebugInfo();
  }

  /// Clear all registered texts
  static void clearAll() {
    TextAnimationRegistry().clear();
  }
}
