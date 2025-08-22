import 'dart:ui' show ImageFilter;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/animated_text_widget.dart';
import '../text_order/text_order_data.dart';

/// Mixin that provides fade animation functionality
mixin FadeAnimationMixin<T extends AnimatedTextWidget>
    on AnimatedTextWidgetState<T> {
  /// Animation for opacity
  late Animation<double> _fadeAnimation;

  /// Animation for scale (optional)
  Animation<double>? _scaleAnimation;

  /// Animation for blur (optional)
  Animation<double>? _blurAnimation;

  /// Whether to include scale animation
  bool get includeScale =>
      widget.config.properties['includeScale'] as bool? ?? false;

  /// Whether to include blur animation
  bool get includeBlur =>
      widget.config.properties['includeBlur'] as bool? ?? false;

  /// Fade direction
  FadeDirection get fadeDirection {
    final direction =
        widget.config.properties['fadeDirection'] as String? ?? 'in';
    return direction == 'out' ? FadeDirection.fadeOut : FadeDirection.fadeIn;
  }

  /// Fade curve
  Curve get fadeCurve {
    final curveName =
        widget.config.properties['curve'] as String? ?? 'easeInOut';
    return _getCurveFromName(curveName);
  }

  /// Scale range
  double get scaleStart =>
      widget.config.properties['scaleStart'] as double? ?? 0.8;
  double get scaleEnd => widget.config.properties['scaleEnd'] as double? ?? 1.0;

  /// Blur range
  double get blurStart =>
      widget.config.properties['blurStart'] as double? ?? 5.0;
  double get blurEnd => widget.config.properties['blurEnd'] as double? ?? 0.0;

  @override
  void initializeAnimationSpecific() {
    super.initializeAnimationSpecific();
    _setupFadeAnimations();
  }

  /// Setup fade animations
  void _setupFadeAnimations() {
    // Setup opacity animation
    _fadeAnimation = Tween<double>(
      begin: fadeDirection == FadeDirection.fadeIn ? 0.0 : 1.0,
      end: fadeDirection == FadeDirection.fadeIn ? 1.0 : 0.0,
    ).animate(CurvedAnimation(parent: animationController, curve: fadeCurve));

    // Setup scale animation if enabled
    if (includeScale) {
      _scaleAnimation = Tween<double>(
        begin: scaleStart,
        end: scaleEnd,
      ).animate(CurvedAnimation(parent: animationController, curve: fadeCurve));
    }

    // Setup blur animation if enabled
    if (includeBlur) {
      _blurAnimation = Tween<double>(
        begin: blurStart,
        end: blurEnd,
      ).animate(CurvedAnimation(parent: animationController, curve: fadeCurve));
    }
  }

  /// Get current opacity value
  double getCurrentOpacity() {
    return _fadeAnimation.value;
  }

  /// Get current scale value
  double getCurrentScale() {
    return _scaleAnimation?.value ?? 1.0;
  }

  /// Get current blur value
  double getCurrentBlur() {
    return _blurAnimation?.value ?? 0.0;
  }

  /// Build fade animated widget
  Widget buildFadeAnimatedWidget(Widget child) {
    Widget result = child;

    // Apply opacity
    result = AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) =>
          Opacity(opacity: getCurrentOpacity(), child: child),
      child: result,
    );

    // Apply scale if enabled
    if (includeScale && _scaleAnimation != null) {
      result = AnimatedBuilder(
        animation: _scaleAnimation!,
        builder: (context, child) =>
            Transform.scale(scale: getCurrentScale(), child: child),
        child: result,
      );
    }

    // Apply blur if enabled
    if (includeBlur && _blurAnimation != null) {
      result = AnimatedBuilder(
        animation: _blurAnimation!,
        builder: (context, child) => ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: getCurrentBlur(),
            sigmaY: getCurrentBlur(),
          ),
          child: child,
        ),
        child: result,
      );
    }

    return result;
  }

  /// Create fade animation with text order data
  Widget buildFadeAnimatedWidgetWithOrder(
    Widget child,
    TextOrderData? textOrderData,
  ) {
    if (textOrderData == null) {
      return buildFadeAnimatedWidget(child);
    }

    // For text order-based animations, we might want to fade different parts
    // at different times. This is a simplified implementation.
    return buildFadeAnimatedWidget(child);
  }

  /// Create staggered fade effect
  Widget buildStaggeredFadeWidget(
    List<Widget> children, {
    Duration staggerDelay = const Duration(milliseconds: 100),
    double staggerOffset = 0.1,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = staggerOffset * index;

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final adjustedProgress = (animationController.value - delay).clamp(
              0.0,
              1.0,
            );
            final opacity = fadeDirection == FadeDirection.fadeIn
                ? adjustedProgress
                : 1.0 - adjustedProgress;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: includeScale
                    ? scaleStart + (scaleEnd - scaleStart) * adjustedProgress
                    : 1.0,
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  /// Create crossfade effect between two texts
  Widget buildCrossfadeWidget(Widget fromWidget, Widget toWidget) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final progress = animationController.value;

        return Stack(
          children: [
            Opacity(opacity: 1.0 - progress, child: fromWidget),
            Opacity(opacity: progress, child: toWidget),
          ],
        );
      },
    );
  }

  /// Create fade with slide effect
  Widget buildFadeSlideWidget(
    Widget child, {
    Offset slideBegin = const Offset(0.0, 0.3),
    Offset slideEnd = Offset.zero,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: slideEnd,
    ).animate(CurvedAnimation(parent: animationController, curve: fadeCurve));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: slideAnimation,
          child: Opacity(opacity: getCurrentOpacity(), child: child),
        );
      },
      child: child,
    );
  }

  /// Create fade with rotation effect
  Widget buildFadeRotateWidget(
    Widget child, {
    double rotationBegin = 0.0,
    double rotationEnd = 0.0,
  }) {
    final rotationAnimation = Tween<double>(
      begin: rotationBegin,
      end: rotationEnd,
    ).animate(CurvedAnimation(parent: animationController, curve: fadeCurve));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotationAnimation.value,
          child: Opacity(
            opacity: getCurrentOpacity(),
            child: Transform.scale(scale: getCurrentScale(), child: child),
          ),
        );
      },
      child: child,
    );
  }

  /// Create pulse fade effect
  Widget buildPulseFadeWidget(
    Widget child, {
    int pulseCount = 3,
    double minOpacity = 0.3,
    double maxOpacity = 1.0,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final pulseProgress = (animationController.value * pulseCount) % 1.0;
        final pulseValue = (math.sin(pulseProgress * 2 * math.pi) + 1) / 2;
        final opacity = minOpacity + (maxOpacity - minOpacity) * pulseValue;

        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }

  /// Get curve from name
  Curve _getCurveFromName(String curveName) {
    switch (curveName.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'easein':
        return Curves.easeIn;
      case 'easeout':
        return Curves.easeOut;
      case 'easeinout':
        return Curves.easeInOut;
      case 'fastouttoslowin':
        return Curves.fastOutSlowIn;
      case 'bounceout':
        return Curves.bounceOut;
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounceinout':
        return Curves.bounceInOut;
      case 'elasticout':
        return Curves.elasticOut;
      case 'elasticin':
        return Curves.elasticIn;
      case 'elasticinout':
        return Curves.elasticInOut;
      default:
        return Curves.easeInOut;
    }
  }

  /// Get fade animation statistics
  Map<String, dynamic> getFadeStats() {
    return {
      'currentOpacity': getCurrentOpacity(),
      'currentScale': getCurrentScale(),
      'currentBlur': getCurrentBlur(),
      'fadeDirection': fadeDirection.toString(),
      'includeScale': includeScale,
      'includeBlur': includeBlur,
      'curve': fadeCurve.toString(),
      'progress': animationController.value,
    };
  }

  /// Create custom fade transition
  Widget createCustomFadeTransition({
    required Widget child,
    required Animation<double> customAnimation,
    double opacityMultiplier = 1.0,
    Curve? customCurve,
  }) {
    final effectiveAnimation = customCurve != null
        ? CurvedAnimation(parent: customAnimation, curve: customCurve)
        : customAnimation;

    return AnimatedBuilder(
      animation: effectiveAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: (effectiveAnimation.value * opacityMultiplier).clamp(
            0.0,
            1.0,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Fade direction enum
enum FadeDirection { fadeIn, fadeOut }
