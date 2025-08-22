import 'package:flutter/material.dart';
import '../widgets/animated_text_widget.dart';
import '../orchestrator/animation_command.dart';

/// Mixin that provides enhanced animation controller functionality
mixin AnimationControllerMixin<T extends AnimatedTextWidget>
    on AnimatedTextWidgetState<T> {
  /// List of secondary animation controllers for complex animations
  final List<AnimationController> _secondaryControllers = [];

  /// Map of named animations for easy access
  final Map<String, Animation> _namedAnimations = {};

  /// Current animation speed multiplier
  double _speedMultiplier = 1.0;

  /// Whether the animation is currently paused
  bool _isPaused = false;

  /// Saved animation value when paused
  double _pausedValue = 0.0;

  /// Animation listeners
  final List<VoidCallback> _animationListeners = [];

  /// Status listeners
  final List<AnimationStatusListener> _statusListeners = [];

  /// Progress callbacks
  final List<ValueChanged<double>> _progressCallbacks = [];

  /// Get animation speed multiplier
  double get speedMultiplier => _speedMultiplier;

  /// Check if animation is paused
  bool get isPaused => _isPaused;

  /// Get all secondary controllers
  List<AnimationController> get secondaryControllers =>
      List.unmodifiable(_secondaryControllers);

  /// Get named animations
  Map<String, Animation> get namedAnimations =>
      Map.unmodifiable(_namedAnimations);

  @override
  void initializeAnimationSpecific() {
    super.initializeAnimationSpecific();
    _setupEnhancedController();
  }

  /// Setup enhanced controller functionality
  void _setupEnhancedController() {
    // Add default listeners
    addAnimationListener(_onDefaultAnimationUpdate);
    addStatusListener(_onDefaultStatusChange);
  }

  /// Default animation update handler
  void _onDefaultAnimationUpdate() {
    // Notify progress callbacks
    for (final callback in _progressCallbacks) {
      callback(animationController.value);
    }
  }

  /// Default status change handler
  void _onDefaultStatusChange(AnimationStatus status) {
    // Handle automatic looping if configured
    if (status == AnimationStatus.completed && shouldLoop()) {
      if (shouldReverse()) {
        reverseAnimation();
      } else {
        resetAndRestart();
      }
    }
  }

  /// Check if animation should loop
  bool shouldLoop() {
    return widget.config.properties['loop'] as bool? ?? false;
  }

  /// Check if animation should reverse
  bool shouldReverse() {
    return widget.config.properties['reverse'] as bool? ?? false;
  }

  /// Create a secondary animation controller
  AnimationController createSecondaryController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double? value,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel:
          debugLabel ?? 'SecondaryController${_secondaryControllers.length}',
      value: value,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: this,
    );

    _secondaryControllers.add(controller);
    return controller;
  }

  /// Remove a secondary controller
  void removeSecondaryController(AnimationController controller) {
    if (_secondaryControllers.contains(controller)) {
      controller.dispose();
      _secondaryControllers.remove(controller);
    }
  }

  /// Create and register a named animation
  Animation<T> createNamedAnimation<T>(
    String name,
    Animatable<T> animatable, {
    AnimationController? controller,
    Curve? curve,
  }) {
    final effectiveController = controller ?? animationController;

    Animation<T> animation;
    if (curve != null) {
      animation = animatable.animate(
        CurvedAnimation(parent: effectiveController, curve: curve),
      );
    } else {
      animation = animatable.animate(effectiveController);
    }

    _namedAnimations[name] = animation;
    return animation;
  }

  /// Get a named animation
  Animation<T>? getNamedAnimation<T>(String name) {
    return _namedAnimations[name] as Animation<T>?;
  }

  /// Remove a named animation
  void removeNamedAnimation(String name) {
    _namedAnimations.remove(name);
  }

  /// Set animation speed multiplier
  void setSpeedMultiplier(double multiplier) {
    if (multiplier <= 0) {
      throw ArgumentError('Speed multiplier must be positive');
    }

    _speedMultiplier = multiplier;

    // Update main controller
    final newDuration = Duration(
      milliseconds: (duration.inMilliseconds / multiplier).round(),
    );

    // Create new controller with updated duration
    final oldValue = animationController.value;
    final wasAnimating = animationController.isAnimating;

    animationController.dispose();
    animationController = AnimationController(
      duration: newDuration,
      vsync: this,
      value: oldValue,
    );

    // Re-add listeners
    for (final listener in _animationListeners) {
      animationController.addListener(listener);
    }
    for (final listener in _statusListeners) {
      animationController.addStatusListener(listener);
    }

    // Restart if was animating
    if (wasAnimating && !_isPaused) {
      animationController.forward(from: oldValue);
    }

    // Update secondary controllers
    for (final _ in _secondaryControllers) {
      // Note: In a real implementation, you'd need to recreate secondary controllers
      // This is a simplified version
    }
  }

  /// Pause animation
  @override
  void pauseAnimation() {
    if (!_isPaused && animationController.isAnimating) {
      _isPaused = true;
      _pausedValue = animationController.value;
      animationController.stop();

      // Pause secondary controllers
      for (final controller in _secondaryControllers) {
        if (controller.isAnimating) {
          controller.stop();
        }
      }
    }
    super.pauseAnimation();
  }

  /// Resume animation
  @override
  void resumeAnimation() {
    if (_isPaused) {
      _isPaused = false;
      animationController.forward(from: _pausedValue);

      // Resume secondary controllers
      for (final controller in _secondaryControllers) {
        controller.forward();
      }
    }
    super.resumeAnimation();
  }

  /// Reset and restart animation
  void resetAndRestart() {
    animationController.reset();
    for (final controller in _secondaryControllers) {
      controller.reset();
    }
    startAnimation();
  }

  /// Reverse animation
  void reverseAnimation() {
    animationController.reverse();
    for (final controller in _secondaryControllers) {
      controller.reverse();
    }
  }

  /// Stop all animations
  @override
  void stopAnimation() {
    animationController.stop();
    for (final controller in _secondaryControllers) {
      controller.stop();
    }
    super.stopAnimation();
  }

  /// Reset all animations
  @override
  void resetAnimation() {
    animationController.reset();
    for (final controller in _secondaryControllers) {
      controller.reset();
    }
    super.resetAnimation();
  }

  /// Add animation listener
  void addAnimationListener(VoidCallback listener) {
    _animationListeners.add(listener);
    animationController.addListener(listener);
  }

  /// Remove animation listener
  void removeAnimationListener(VoidCallback listener) {
    _animationListeners.remove(listener);
    animationController.removeListener(listener);
  }

  /// Add status listener
  void addStatusListener(AnimationStatusListener listener) {
    _statusListeners.add(listener);
    animationController.addStatusListener(listener);
  }

  /// Remove status listener
  void removeStatusListener(AnimationStatusListener listener) {
    _statusListeners.remove(listener);
    animationController.removeStatusListener(listener);
  }

  /// Add progress callback
  void addProgressCallback(ValueChanged<double> callback) {
    _progressCallbacks.add(callback);
  }

  /// Remove progress callback
  void removeProgressCallback(ValueChanged<double> callback) {
    _progressCallbacks.remove(callback);
  }

  /// Animate to specific value
  Future<void> animateToValue(double targetValue, {Duration? duration}) async {
    final effectiveDuration =
        duration ??
        Duration(
          milliseconds:
              ((targetValue - animationController.value).abs() *
                      this.duration.inMilliseconds)
                  .round(),
        );

    final controller = AnimationController(
      duration: effectiveDuration,
      vsync: this,
    );

    final animation = Tween<double>(
      begin: animationController.value,
      end: targetValue,
    ).animate(controller);

    animation.addListener(() {
      animationController.value = animation.value;
    });

    try {
      await controller.forward();
    } finally {
      controller.dispose();
    }
  }

  /// Create complex animation sequence
  Future<void> playAnimationSequence(List<AnimationSequenceStep> steps) async {
    for (final step in steps) {
      switch (step.type) {
        case AnimationStepType.play:
          if (step.controller != null) {
            await step.controller!.forward();
          } else {
            await animationController.forward();
          }
          break;
        case AnimationStepType.reverse:
          if (step.controller != null) {
            await step.controller!.reverse();
          } else {
            await animationController.reverse();
          }
          break;
        case AnimationStepType.reset:
          if (step.controller != null) {
            step.controller!.reset();
          } else {
            animationController.reset();
          }
          break;
        case AnimationStepType.wait:
          await Future.delayed(
            step.duration ?? const Duration(milliseconds: 500),
          );
          break;
        case AnimationStepType.animateToValue:
          await animateToValue(
            step.targetValue ?? 1.0,
            duration: step.duration,
          );
          break;
      }
    }
  }

  /// Create synchronized animation group
  void createSynchronizedGroup(List<AnimationController> controllers) {
    final masterController = animationController;

    for (final controller in controllers) {
      controller.addListener(() {
        if (controller.value != masterController.value) {
          masterController.value = controller.value;
        }
      });

      masterController.addListener(() {
        if (masterController.value != controller.value) {
          controller.value = masterController.value;
        }
      });
    }
  }

  /// Get animation statistics
  Map<String, dynamic> getControllerStats() {
    return {
      'mainController': {
        'value': animationController.value,
        'status': animationController.status.toString(),
        'duration': animationController.duration?.inMilliseconds,
        'isAnimating': animationController.isAnimating,
        'isCompleted': animationController.isCompleted,
        'isDismissed': animationController.isDismissed,
      },
      'secondaryControllers': _secondaryControllers
          .map(
            (controller) => {
              'value': controller.value,
              'status': controller.status.toString(),
              'duration': controller.duration?.inMilliseconds,
              'isAnimating': controller.isAnimating,
            },
          )
          .toList(),
      'speedMultiplier': _speedMultiplier,
      'isPaused': _isPaused,
      'pausedValue': _pausedValue,
      'namedAnimationsCount': _namedAnimations.length,
      'listenersCount': _animationListeners.length,
      'statusListenersCount': _statusListeners.length,
      'progressCallbacksCount': _progressCallbacks.length,
    };
  }

  /// Handle animation command from orchestrator
  void handleAnimationCommand(AnimationCommand command) {
    // Handle controller-specific commands
    if (command is UpdateAnimationConfigCommand) {
      final newSpeedMultiplier =
          command.newConfig['speedMultiplier'] as double?;
      if (newSpeedMultiplier != null &&
          newSpeedMultiplier != _speedMultiplier) {
        setSpeedMultiplier(newSpeedMultiplier);
      }
    }
  }

  @override
  void dispose() {
    // Dispose secondary controllers
    for (final controller in _secondaryControllers) {
      controller.dispose();
    }
    _secondaryControllers.clear();

    // Clear collections
    _namedAnimations.clear();
    _animationListeners.clear();
    _statusListeners.clear();
    _progressCallbacks.clear();

    super.dispose();
  }
}

/// Animation sequence step
class AnimationSequenceStep {
  final AnimationStepType type;
  final Duration? duration;
  final AnimationController? controller;
  final double? targetValue;
  final String? name;

  const AnimationSequenceStep({
    required this.type,
    this.duration,
    this.controller,
    this.targetValue,
    this.name,
  });

  /// Create a play step
  factory AnimationSequenceStep.play({
    Duration? duration,
    AnimationController? controller,
    String? name,
  }) {
    return AnimationSequenceStep(
      type: AnimationStepType.play,
      duration: duration,
      controller: controller,
      name: name,
    );
  }

  /// Create a reverse step
  factory AnimationSequenceStep.reverse({
    Duration? duration,
    AnimationController? controller,
    String? name,
  }) {
    return AnimationSequenceStep(
      type: AnimationStepType.reverse,
      duration: duration,
      controller: controller,
      name: name,
    );
  }

  /// Create a reset step
  factory AnimationSequenceStep.reset({
    AnimationController? controller,
    String? name,
  }) {
    return AnimationSequenceStep(
      type: AnimationStepType.reset,
      controller: controller,
      name: name,
    );
  }

  /// Create a wait step
  factory AnimationSequenceStep.wait(Duration duration, {String? name}) {
    return AnimationSequenceStep(
      type: AnimationStepType.wait,
      duration: duration,
      name: name,
    );
  }

  /// Create an animate to value step
  factory AnimationSequenceStep.animateToValue(
    double targetValue, {
    Duration? duration,
    String? name,
  }) {
    return AnimationSequenceStep(
      type: AnimationStepType.animateToValue,
      targetValue: targetValue,
      duration: duration,
      name: name,
    );
  }
}

/// Animation step types
enum AnimationStepType { play, reverse, reset, wait, animateToValue }
