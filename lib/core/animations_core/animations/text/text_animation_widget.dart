import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/animation_types.dart';
import '../../text_order/text_order_data.dart';

import 'animation_logic.dart';
import 'animation_mixins.dart';
import 'scramble.dart';
import 'fade.dart';
import 'slide.dart';
import '../../../../screens/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

/// Unified text animation widget that handles all animation types
/// Generic type T ensures type safety for animation properties
class TextAnimation<T extends BaseAnimationPropertiesData>
    extends ConsumerStatefulWidget {
  /// Text content to animate
  final String text;

  /// Type of animation to apply
  final AnimationType type;

  /// Optional text order ID for orchestrated animations
  /// If null, the animation runs independently
  final String? textOrderId;

  /// Animation configuration (speed, intensity, direction, etc.)
  final BaseAnimationPropertiesData config;

  /// Text order data for complex orchestrated animations
  final TextOrderData? textOrderData;

  /// Style for the text
  final TextStyle? style;

  /// Text alignment
  final TextAlign textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow overflow;

  /// Whether to auto-start the animation
  final bool autoStart;

  /// Callback when animation starts
  final VoidCallback? onAnimationStart;

  /// Callback when animation completes
  final VoidCallback? onAnimationComplete;

  /// Callback when animation has an error
  final ValueChanged<String>? onAnimationError;

  /// Callback for animation progress updates
  final ValueChanged<double>? onProgressUpdate;

  /// Callback to get animation control methods
  final Function(Function() play, Function() pause, Function() reset)?
  onControlsReady;

  /// Callback to get the animation controller
  final Function(AnimationController)? onControllerReady;

  const TextAnimation({
    super.key,
    required this.text,
    required this.type,
    this.textOrderId,
    required this.config,
    this.textOrderData,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.autoStart = true,
    this.onAnimationStart,
    this.onAnimationComplete,
    this.onAnimationError,
    this.onProgressUpdate,
    this.onControlsReady,
    this.onControllerReady,
  });

  @override
  ConsumerState<TextAnimation> createState() => _TextAnimationState();
}

/// State for the unified text animation widget
class _TextAnimationState<T extends BaseAnimationPropertiesData>
    extends ConsumerState<TextAnimation<T>>
    with
        TickerProviderStateMixin,
        SimpleScrambleMixin,
        SimpleFadeMixin,
        SimpleSlideMixin,
        AnimationBehaviors {
  /// Animation engine for this widget
  late AnimationController _animationEngine;

  /// Animation business logic
  late AnimationLogic _animationLogic;

  /// Whether the widget has been initialized
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _setupOrchestrator();
      _isInitialized = true;
    }
  }

  /// Initialize the animation engine and logic
  void _initializeAnimation() {
    // Get duration from widget.config
    final duration = Duration(
      milliseconds: (widget.config.speed * 1000).round(),
    );

    _animationEngine = AnimationController(duration: duration, vsync: this);

    debugPrint(
      'TextAnimation: Creating AnimationLogic with config: ${widget.config}',
    );
    debugPrint(
      'TextAnimation: Loop value in widget.config: ${widget.config.loop}',
    );

    _animationLogic = AnimationLogic(
      animationEngine: _animationEngine,
      config: widget.config,
      textOrderId: widget.textOrderId,
      textOrderData: widget.textOrderData,
      type: widget.type,
      ref: ref,
    );

    // Add listeners
    _animationEngine.addStatusListener(_onAnimationStatusChange);
    _animationEngine.addListener(_onAnimationUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provide control methods to parent
      widget.onControlsReady?.call(play, pause, reset);

      // Provide controller to parent
      widget.onControllerReady?.call(_animationEngine);
    });

    // Auto-start if enabled
    if (widget.autoStart) {
      _startAnimation();
    }
  }

  /// Setup orchestrator integration
  void _setupOrchestrator() {
    _animationLogic.setupOrchestrator();
  }

  /// Start the animation
  void _startAnimation() {
    try {
      _animationLogic.startAnimation();
      widget.onAnimationStart?.call();
    } catch (e) {
      widget.onAnimationError?.call('Failed to start animation: $e');
    }
  }

  /// Public method to play animation (for external control)
  void play() {
    if (!_animationEngine.isAnimating) {
      _startAnimation();
    }
  }

  /// Public method to pause animation (for external control)
  void pause() {
    if (_animationEngine.isAnimating) {
      _animationLogic.pauseAnimation();
      _animationLogic.notifyOrchestratorPause();
    }
  }

  /// Public method to reset animation to beginning (for external control)
  void reset() {
    if (_animationEngine.isAnimating) {
      _animationLogic.resetAnimation();
      _animationLogic.notifyOrchestratorReset();
    }
  }

  /// Handle animation status changes
  void _onAnimationStatusChange(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        _animationLogic.handleAnimationComplete();
        widget.onAnimationComplete?.call();
        break;
      case AnimationStatus.dismissed:
        // Animation was stopped
        break;
      case AnimationStatus.forward:
        // Animation is running
        break;
      case AnimationStatus.reverse:
        // Animation is reversing
        break;
    }
  }

  /// Handle animation updates
  void _onAnimationUpdate() {
    final progress = _animationEngine.value;
    widget.onProgressUpdate?.call(progress);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AnimationType.scramble:
        return buildScrambleText(
          text: widget.text,
          config: widget.config as ScrambleTextPropertiesData,
          controller: _animationEngine,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      case AnimationType.fade:
        return buildFadeText(
          text: widget.text,
          config: widget.config as FadeTextPropertiesData,
          controller: _animationEngine,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      case AnimationType.slide:
        return buildSlideText(
          text: widget.text,
          config: widget.config as SlideTextPropertiesData,
          controller: _animationEngine,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      default:
        return Text(
          widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
    }
  }

  @override
  void dispose() {
    _animationEngine.dispose();
    super.dispose();
  }
}
