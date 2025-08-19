import 'package:flutter/material.dart';
import 'scroll_animations.dart';

/// Mixin to add fade-in animation to any widget
mixin FadeInAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  Duration _viewportDelay = Duration.zero;

  /// Initialize fade animation
  void initFadeAnimation({
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOut,
    bool triggerOnViewport = true,
    Duration viewportDelay = Duration.zero,
  }) {
    _viewportDelay = viewportDelay;
    _fadeController = AnimationController(
      duration: duration,
      vsync: this as TickerProvider,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: curve));

    if (!triggerOnViewport) {
      _startFadeAnimation();
    }
  }

  void _startFadeAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(_viewportDelay, () {
        if (mounted) {
          _fadeController.forward();
        }
      });
    }
  }

  /// Get the fade animation value
  double get fadeValue => _fadeAnimation.value;

  /// Get the fade animation
  Animation<double> get fadeAnimation => _fadeAnimation;

  /// Start fade animation manually
  void startFadeAnimation() {
    _fadeController.forward();
  }

  /// Reset fade animation
  void resetFadeAnimation() {
    _hasAnimated = false;
    _fadeController.reset();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}

/// Mixin to add slide animation to any widget
mixin SlideAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _hasSlideAnimated = false;
  Duration _slideViewportDelay = Duration.zero;

  /// Initialize slide animation
  void initSlideAnimation({
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOut,
    SlideDirection direction = SlideDirection.fromBottom,
    double distance = 50.0,
    bool triggerOnViewport = true,
    Duration viewportDelay = Duration.zero,
  }) {
    _slideViewportDelay = viewportDelay;
    _slideController = AnimationController(
      duration: duration,
      vsync: this as TickerProvider,
    );

    Offset beginOffset = _getBeginOffset(direction, distance);

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: curve));

    if (!triggerOnViewport) {
      _startSlideAnimation();
    }
  }

  Offset _getBeginOffset(SlideDirection direction, double distance) {
    switch (direction) {
      case SlideDirection.fromLeft:
        return Offset(-distance, 0);
      case SlideDirection.fromRight:
        return Offset(distance, 0);
      case SlideDirection.fromTop:
        return Offset(0, -distance);
      case SlideDirection.fromBottom:
        return Offset(0, distance);
    }
  }

  void _startSlideAnimation() {
    if (!_hasSlideAnimated) {
      _hasSlideAnimated = true;
      Future.delayed(_slideViewportDelay, () {
        if (mounted) {
          _slideController.forward();
        }
      });
    }
  }

  /// Get the slide animation value
  Offset get slideValue => _slideAnimation.value;

  /// Get the slide animation
  Animation<Offset> get slideAnimation => _slideAnimation;

  /// Start slide animation manually
  void startSlideAnimation() {
    _slideController.forward();
  }

  /// Reset slide animation
  void resetSlideAnimation() {
    _hasSlideAnimated = false;
    _slideController.reset();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
}

/// Mixin to add scale animation to any widget
mixin ScaleAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _hasAnimated = false;
  Duration _viewportDelay = Duration.zero;

  /// Initialize scale animation
  void initScaleAnimation({
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.elasticOut,
    double beginScale = 0.0,
    double endScale = 1.0,
    bool triggerOnViewport = true,
    Duration viewportDelay = Duration.zero,
  }) {
    _viewportDelay = viewportDelay;
    _scaleController = AnimationController(
      duration: duration,
      vsync: this as TickerProvider,
    );

    _scaleAnimation = Tween<double>(
      begin: beginScale,
      end: endScale,
    ).animate(CurvedAnimation(parent: _scaleController, curve: curve));

    if (!triggerOnViewport) {
      _startScaleAnimation();
    }
  }

  void _startScaleAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(_viewportDelay, () {
        if (mounted) {
          _scaleController.forward();
        }
      });
    }
  }

  /// Get the scale animation value
  double get scaleValue => _scaleAnimation.value;

  /// Get the scale animation
  Animation<double> get scaleAnimation => _scaleAnimation;

  /// Start scale animation manually
  void startScaleAnimation() {
    _scaleController.forward();
  }

  /// Reset scale animation
  void resetScaleAnimation() {
    _hasAnimated = false;
    _scaleController.reset();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }
}

/// Mixin to add rotation animation to any widget
mixin RotationAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _hasAnimated = false;
  Duration _viewportDelay = Duration.zero;

  /// Initialize rotation animation
  void initRotationAnimation({
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
    double beginAngle = 0.0,
    double endAngle = 2 * 3.14159, // Full rotation
    bool triggerOnViewport = true,
    Duration viewportDelay = Duration.zero,
  }) {
    _viewportDelay = viewportDelay;
    _rotationController = AnimationController(
      duration: duration,
      vsync: this as TickerProvider,
    );

    _rotationAnimation = Tween<double>(
      begin: beginAngle,
      end: endAngle,
    ).animate(CurvedAnimation(parent: _rotationController, curve: curve));

    if (!triggerOnViewport) {
      _startRotationAnimation();
    }
  }

  void _startRotationAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(_viewportDelay, () {
        if (mounted) {
          _rotationController.forward();
        }
      });
    }
  }

  /// Get the rotation animation value
  double get rotationValue => _rotationAnimation.value;

  /// Get the rotation animation
  Animation<double> get rotationAnimation => _rotationAnimation;

  /// Start rotation animation manually
  void startRotationAnimation() {
    _rotationController.forward();
  }

  /// Reset rotation animation
  void resetRotationAnimation() {
    _hasAnimated = false;
    _rotationController.reset();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }
}
