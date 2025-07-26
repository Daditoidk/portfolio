import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/accessibility_settings.dart';

/// A widget that conditionally pauses animations when accessibility setting is enabled
///
/// This widget automatically disables animations and transitions when the
/// pause animations setting is enabled.
class AccessiblePauseAnimations extends ConsumerWidget {
  final Widget child;
  final Duration? defaultDuration;
  final bool pauseTransitions;
  final bool pausePageTransitions;
  final bool pauseImplicitAnimations;

  const AccessiblePauseAnimations({
    super.key,
    required this.child,
    this.defaultDuration,
    this.pauseTransitions = true,
    this.pausePageTransitions = true,
    this.pauseImplicitAnimations = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.pauseAnimations) {
      return child;
    }

    return _AnimationPauser(
      defaultDuration: defaultDuration,
      pauseTransitions: pauseTransitions,
      pausePageTransitions: pausePageTransitions,
      pauseImplicitAnimations: pauseImplicitAnimations,
      child: child,
    );
  }
}

class _AnimationPauser extends StatelessWidget {
  final Widget child;
  final Duration? defaultDuration;
  final bool pauseTransitions;
  final bool pausePageTransitions;
  final bool pauseImplicitAnimations;

  const _AnimationPauser({
    required this.child,
    this.defaultDuration,
    required this.pauseTransitions,
    required this.pausePageTransitions,
    required this.pauseImplicitAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        // Disable page transitions
        pageTransitionsTheme: pausePageTransitions
            ? const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              )
            : theme.pageTransitionsTheme,
        // Disable other animations
        splashFactory: pauseImplicitAnimations
            ? NoSplash.splashFactory
            : theme.splashFactory,
        highlightColor: pauseImplicitAnimations
            ? Colors.transparent
            : theme.highlightColor,
      ),
      child: child,
    );
  }
}

/// A specialized AnimatedContainer that respects pause animations setting
class AccessibleAnimatedContainer extends ConsumerWidget {
  final Widget? child;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? curve;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final Clip? clipBehavior;
  final Widget? foregroundChild;

  const AccessibleAnimatedContainer({
    super.key,
    this.child,
    this.duration,
    this.reverseDuration,
    this.curve,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.clipBehavior,
    this.foregroundChild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.pauseAnimations) {
      // Return a regular Container when animations are paused
      return Container(
        alignment: alignment,
        padding: padding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        transform: transform,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        child: child,
      );
    }

    return AnimatedContainer(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}

/// A specialized AnimatedOpacity that respects pause animations setting
class AccessibleAnimatedOpacity extends ConsumerWidget {
  final Widget child;
  final double opacity;
  final Duration? duration;
  final Curve? curve;
  final bool alwaysIncludeSemantics;

  const AccessibleAnimatedOpacity({
    super.key,
    required this.child,
    required this.opacity,
    this.duration,
    this.curve,
    this.alwaysIncludeSemantics = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.pauseAnimations) {
      return Opacity(
        opacity: opacity,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: child,
      );
    }

    return AnimatedOpacity(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    );
  }
}

/// A specialized AnimatedSwitcher that respects pause animations setting
class AccessibleAnimatedSwitcher extends ConsumerWidget {
  final Widget child;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  const AccessibleAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.pauseAnimations) {
      return child;
    }

    return AnimatedSwitcher(
      duration: duration ?? const Duration(milliseconds: 300),
      reverseDuration: reverseDuration,
      switchInCurve: switchInCurve ?? Curves.easeInOut,
      switchOutCurve: switchOutCurve ?? Curves.easeInOut,
      transitionBuilder: transitionBuilder ?? (child, animation) => child,
      layoutBuilder:
          layoutBuilder ??
          (currentChild, previousChildren) => currentChild ?? const SizedBox(),
      child: child,
    );
  }
}

/// A specialized Hero that respects pause animations setting
class AccessibleHero extends ConsumerWidget {
  final Widget child;
  final Object tag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final bool placeholderBuilder;
  final bool transitionOnUserGestures;

  const AccessibleHero({
    super.key,
    required this.child,
    required this.tag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder = false,
    this.transitionOnUserGestures = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.pauseAnimations) {
      return child;
    }

    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder
          ? (context, heroSize, child) => child
          : null,
      transitionOnUserGestures: transitionOnUserGestures,
      child: child,
    );
  }
}
