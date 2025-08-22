import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/animated_text_widget.dart';
import '../text_order/text_order_data.dart';

/// Mixin that provides slide animation functionality
mixin SlideAnimationMixin<T extends AnimatedTextWidget>
    on AnimatedTextWidgetState<T> {
  /// Animation for slide position
  late Animation<Offset> _slideAnimation;

  /// Animation for secondary slide (for complex effects)
  Animation<Offset>? _secondarySlideAnimation;

  /// Slide direction
  SlideDirection get slideDirection {
    final direction =
        widget.config.properties['slideDirection'] as String? ?? 'leftToRight';
    return _getSlideDirectionFromString(direction);
  }

  /// Slide distance
  double get slideDistance =>
      widget.config.properties['slideDistance'] as double? ?? 1.0;

  /// Slide curve
  Curve get slideCurve {
    final curveName =
        widget.config.properties['curve'] as String? ?? 'easeInOut';
    return _getCurveFromName(curveName);
  }

  /// Whether to use bounce effect
  bool get useBounce => widget.config.properties['useBounce'] as bool? ?? false;

  /// Bounce intensity
  double get bounceIntensity =>
      widget.config.properties['bounceIntensity'] as double? ?? 0.2;

  /// Whether to include rotation during slide
  bool get includeRotation =>
      widget.config.properties['includeRotation'] as bool? ?? false;

  /// Rotation angle (in radians)
  double get rotationAngle =>
      widget.config.properties['rotationAngle'] as double? ?? 0.1;

  @override
  void initializeAnimationSpecific() {
    super.initializeAnimationSpecific();
    _setupSlideAnimations();
  }

  /// Setup slide animations
  void _setupSlideAnimations() {
    final slideBegin = _getSlideBeginOffset();
    final slideEnd = _getSlideEndOffset();

    // Setup main slide animation
    _slideAnimation = Tween<Offset>(begin: slideBegin, end: slideEnd).animate(
      CurvedAnimation(
        parent: animationController,
        curve: useBounce ? Curves.bounceOut : slideCurve,
      ),
    );

    // Setup secondary slide for complex effects
    if (useBounce) {
      _secondarySlideAnimation =
          Tween<Offset>(
            begin: slideEnd,
            end: Offset(
              slideEnd.dx + (slideBegin.dx - slideEnd.dx) * bounceIntensity,
              slideEnd.dy + (slideBegin.dy - slideEnd.dy) * bounceIntensity,
            ),
          ).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
            ),
          );
    }
  }

  /// Get slide begin offset based on direction
  Offset _getSlideBeginOffset() {
    switch (slideDirection) {
      case SlideDirection.leftToRight:
        return Offset(-slideDistance, 0.0);
      case SlideDirection.rightToLeft:
        return Offset(slideDistance, 0.0);
      case SlideDirection.topToBottom:
        return Offset(0.0, -slideDistance);
      case SlideDirection.bottomToTop:
        return Offset(0.0, slideDistance);
      case SlideDirection.topLeftToBottomRight:
        return Offset(-slideDistance, -slideDistance);
      case SlideDirection.topRightToBottomLeft:
        return Offset(slideDistance, -slideDistance);
      case SlideDirection.bottomLeftToTopRight:
        return Offset(-slideDistance, slideDistance);
      case SlideDirection.bottomRightToTopLeft:
        return Offset(slideDistance, slideDistance);
      case SlideDirection.center:
        return const Offset(0.0, 0.0);
    }
  }

  /// Get slide end offset
  Offset _getSlideEndOffset() {
    return const Offset(0.0, 0.0); // Always slide to center
  }

  /// Get current slide offset
  Offset getCurrentSlideOffset() {
    if (_secondarySlideAnimation != null && animationController.value > 0.6) {
      return _secondarySlideAnimation!.value;
    }
    return _slideAnimation.value;
  }

  /// Build slide animated widget
  Widget buildSlideAnimatedWidget(Widget child) {
    Widget result = child;

    // Apply slide transformation
    result = AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(position: _slideAnimation, child: child);
      },
      child: result,
    );

    // Apply rotation if enabled
    if (includeRotation) {
      result = AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          final rotationValue =
              rotationAngle * (1.0 - animationController.value);
          return Transform.rotate(angle: rotationValue, child: child);
        },
        child: result,
      );
    }

    return result;
  }

  /// Create staggered slide effect
  Widget buildStaggeredSlideWidget(
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
            final slideOffset =
                _getSlideBeginOffset() * (1.0 - adjustedProgress);

            return Transform.translate(
              offset: Offset(slideOffset.dx * 100, slideOffset.dy * 100),
              child: child,
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  /// Create slide with text order data
  Widget buildSlideAnimatedWidgetWithOrder(
    Widget child,
    TextOrderData? textOrderData,
  ) {
    if (textOrderData == null) {
      return buildSlideAnimatedWidget(child);
    }

    // For text order-based animations, we can slide different sections
    // at different times. This is a simplified implementation.
    return buildSlideAnimatedWidget(child);
  }

  /// Create wave slide effect
  Widget buildWaveSlideWidget(
    List<Widget> children, {
    double waveAmplitude = 0.3,
    double waveFrequency = 2.0,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final waveOffset =
                waveAmplitude *
                math.sin(
                  waveFrequency * math.pi * animationController.value +
                      index * 0.5,
                );

            return Transform.translate(
              offset: Offset(waveOffset * 100, 0.0),
              child: child,
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  /// Create slide with scale effect
  Widget buildSlideScaleWidget(
    Widget child, {
    double scaleStart = 0.8,
    double scaleEnd = 1.0,
  }) {
    final scaleAnimation = Tween<double>(
      begin: scaleStart,
      end: scaleEnd,
    ).animate(CurvedAnimation(parent: animationController, curve: slideCurve));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      child: child,
    );
  }

  /// Create slide with fade effect
  Widget buildSlideFadeWidget(
    Widget child, {
    double opacityStart = 0.0,
    double opacityEnd = 1.0,
  }) {
    final opacityAnimation = Tween<double>(
      begin: opacityStart,
      end: opacityEnd,
    ).animate(CurvedAnimation(parent: animationController, curve: slideCurve));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(opacity: opacityAnimation, child: child),
        );
      },
      child: child,
    );
  }

  /// Create elastic slide effect
  Widget buildElasticSlideWidget(Widget child) {
    final elasticAnimation =
        Tween<Offset>(
          begin: _getSlideBeginOffset(),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.elasticOut,
          ),
        );

    return AnimatedBuilder(
      animation: elasticAnimation,
      builder: (context, child) {
        return SlideTransition(position: elasticAnimation, child: child);
      },
      child: child,
    );
  }

  /// Create slide with path effect
  Widget buildPathSlideWidget(
    Widget child, {
    required List<Offset> pathPoints,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final pathOffset = _interpolateAlongPath(
          pathPoints,
          animationController.value,
        );

        return Transform.translate(
          offset: Offset(pathOffset.dx * 100, pathOffset.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Interpolate along a path
  Offset _interpolateAlongPath(List<Offset> pathPoints, double progress) {
    if (pathPoints.isEmpty) return const Offset(0.0, 0.0);
    if (pathPoints.length == 1) return pathPoints.first;

    final totalSegments = pathPoints.length - 1;
    final segmentProgress = progress * totalSegments;
    final segmentIndex = segmentProgress.floor().clamp(0, totalSegments - 1);
    final localProgress = segmentProgress - segmentIndex;

    final startPoint = pathPoints[segmentIndex];
    final endPoint =
        pathPoints[(segmentIndex + 1).clamp(0, pathPoints.length - 1)];

    return Offset.lerp(startPoint, endPoint, localProgress) ??
        const Offset(0.0, 0.0);
  }

  /// Get slide direction from string
  SlideDirection _getSlideDirectionFromString(String direction) {
    switch (direction.toLowerCase()) {
      case 'leftttoright':
      case 'left':
        return SlideDirection.leftToRight;
      case 'righttoleft':
      case 'right':
        return SlideDirection.rightToLeft;
      case 'toptobottom':
      case 'top':
        return SlideDirection.topToBottom;
      case 'bottomtotop':
      case 'bottom':
        return SlideDirection.bottomToTop;
      case 'toplefttobottomright':
        return SlideDirection.topLeftToBottomRight;
      case 'toprighttobottomleft':
        return SlideDirection.topRightToBottomLeft;
      case 'bottomlefttotopright':
        return SlideDirection.bottomLeftToTopRight;
      case 'bottomrighttotopleft':
        return SlideDirection.bottomRightToTopLeft;
      case 'center':
        return SlideDirection.center;
      default:
        return SlideDirection.leftToRight;
    }
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

  /// Get slide animation statistics
  Map<String, dynamic> getSlideStats() {
    return {
      'currentOffset': getCurrentSlideOffset(),
      'slideDirection': slideDirection.toString(),
      'slideDistance': slideDistance,
      'useBounce': useBounce,
      'bounceIntensity': bounceIntensity,
      'includeRotation': includeRotation,
      'rotationAngle': rotationAngle,
      'curve': slideCurve.toString(),
      'progress': animationController.value,
    };
  }

  /// Create custom slide transition
  Widget createCustomSlideTransition({
    required Widget child,
    required Animation<Offset> customAnimation,
    bool includeOriginalSlide = true,
  }) {
    if (!includeOriginalSlide) {
      return SlideTransition(position: customAnimation, child: child);
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final combinedOffset = Offset(
          getCurrentSlideOffset().dx + customAnimation.value.dx,
          getCurrentSlideOffset().dy + customAnimation.value.dy,
        );

        return Transform.translate(
          offset: Offset(combinedOffset.dx * 100, combinedOffset.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Slide direction enum
enum SlideDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  topLeftToBottomRight,
  topRightToBottomLeft,
  bottomLeftToTopRight,
  bottomRightToTopLeft,
  center,
}
