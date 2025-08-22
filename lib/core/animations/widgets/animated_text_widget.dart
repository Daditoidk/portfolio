import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/animation_config.dart';
import '../base/animation_status.dart';
import '../orchestrator/animation_command.dart';
import '../orchestrator/animation_state.dart';
import '../providers/animation_orchestrator_provider.dart';
import '../providers/animation_state_provider.dart';
import '../text_order/text_order_data.dart';

/// Base class for all animated text widgets
abstract class AnimatedTextWidget extends ConsumerStatefulWidget {
  /// Unique identifier for this animation instance
  final String animationId;

  /// Text content to animate
  final String text;

  /// Animation configuration
  final AnimationConfig config;

  /// Text order data for complex animations
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

  const AnimatedTextWidget({
    super.key,
    required this.animationId,
    required this.text,
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
  });
}

/// Base state for animated text widgets
abstract class AnimatedTextWidgetState<T extends AnimatedTextWidget>
    extends ConsumerState<T>
    with TickerProviderStateMixin {
  /// Animation controller for this widget
  late AnimationController animationController;

  /// Current animation instance state
  AnimationInstanceState? _animationState;

  /// Whether the widget has been initialized
  bool _isInitialized = false;

  /// Whether the animation is currently running
  bool get isAnimating => _animationState?.isRunning ?? false;

  /// Current animation progress (0.0 to 1.0)
  double get progress => _animationState?.progress ?? 0.0;

  /// Current animation status
  AnimationState get status => _animationState?.status ?? AnimationState.idle;

  /// Animation duration
  Duration get duration => Duration(
    milliseconds:
        (widget.config.properties['duration'] as num?)?.toInt() ?? 1000,
  );

  /// Animation delay
  Duration get delay => Duration(
    milliseconds: (widget.config.properties['delay'] as num?)?.toInt() ?? 0,
  );

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize if animation ID or config changed
    if (oldWidget.animationId != widget.animationId ||
        oldWidget.config != widget.config) {
      _initializeAnimation();
    }
  }

  @override
  void dispose() {
    _disposeAnimation();
    super.dispose();
  }

  /// Initialize the animation
  void _initializeAnimation() {
    // Dispose previous animation if exists
    if (_isInitialized) {
      _disposeAnimation();
    }

    // Create animation controller
    animationController = AnimationController(duration: duration, vsync: this);

    // Listen to animation controller
    animationController.addListener(_onAnimationUpdate);
    animationController.addStatusListener(_onAnimationStatusChange);

    // Initialize animation-specific setup
    initializeAnimationSpecific();

    _isInitialized = true;

    // Auto-start if enabled
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startAnimation();
      });
    }
  }

  /// Dispose animation resources
  void _disposeAnimation() {
    if (_isInitialized) {
      animationController.removeListener(_onAnimationUpdate);
      animationController.removeStatusListener(_onAnimationStatusChange);
      animationController.dispose();
      _isInitialized = false;
    }
  }

  /// Animation controller update callback
  void _onAnimationUpdate() {
    final newProgress = animationController.value;

    // Update progress in orchestrator
    _updateAnimationProgress(newProgress);

    // Notify progress callback
    widget.onProgressUpdate?.call(newProgress);

    // Trigger rebuild
    if (mounted) {
      setState(() {});
    }
  }

  /// Animation status change callback
  void _onAnimationStatusChange(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _updateAnimationStatus(AnimationState.running);
        widget.onAnimationStart?.call();
        break;
      case AnimationStatus.completed:
        _updateAnimationStatus(AnimationState.completed);
        widget.onAnimationComplete?.call();
        break;
      case AnimationStatus.dismissed:
        _updateAnimationStatus(AnimationState.idle);
        break;
      case AnimationStatus.reverse:
        _updateAnimationStatus(AnimationState.running);
        break;
    }
  }

  /// Update animation progress in orchestrator
  void _updateAnimationProgress(double progress) {
    final orchestrator = ref.read(animationOrchestratorProvider);
    final currentState = orchestrator.getAnimation(widget.animationId);

    if (currentState != null) {
      currentState.updateProgress(progress);
      orchestrator.addCommand(
        UpdateAnimationConfigCommand(
          id: '${widget.animationId}_progress_${DateTime.now().millisecondsSinceEpoch}',
          animationId: widget.animationId,
          newConfig: currentState.config,
        ),
      );
    }
  }

  /// Update animation status in orchestrator
  void _updateAnimationStatus(AnimationState newStatus) {
    final orchestrator = ref.read(animationOrchestratorProvider);
    final currentState = orchestrator.getAnimation(widget.animationId);

    if (currentState != null) {
      currentState.copyWith(status: newStatus);
      // Update the animation state directly in orchestrator
      orchestrator.removeAnimation(widget.animationId);
      // Add updated animation state (this would need a method in orchestrator)
    }
  }

  /// Start the animation
  void startAnimation() {
    if (!_isInitialized) return;

    final orchestrator = ref.read(animationOrchestratorProvider);
    orchestrator.addCommand(
      StartAnimationCommand(
        id: '${widget.animationId}_start_${DateTime.now().millisecondsSinceEpoch}',
        animationId: widget.animationId,
        config: widget.config.toJson(),
      ),
    );

    // Start the animation controller with delay
    if (delay.inMilliseconds > 0) {
      Future.delayed(delay, () {
        if (mounted && _isInitialized) {
          animationController.forward();
        }
      });
    } else {
      animationController.forward();
    }
  }

  /// Stop the animation
  void stopAnimation() {
    if (!_isInitialized) return;

    final orchestrator = ref.read(animationOrchestratorProvider);
    orchestrator.addCommand(
      StopAnimationCommand(
        id: '${widget.animationId}_stop_${DateTime.now().millisecondsSinceEpoch}',
        animationId: widget.animationId,
      ),
    );

    animationController.stop();
  }

  /// Pause the animation
  void pauseAnimation() {
    if (!_isInitialized) return;

    final orchestrator = ref.read(animationOrchestratorProvider);
    orchestrator.addCommand(
      PauseAnimationCommand(
        id: '${widget.animationId}_pause_${DateTime.now().millisecondsSinceEpoch}',
        animationId: widget.animationId,
      ),
    );

    animationController.stop();
  }

  /// Resume the animation
  void resumeAnimation() {
    if (!_isInitialized) return;

    final orchestrator = ref.read(animationOrchestratorProvider);
    orchestrator.addCommand(
      ResumeAnimationCommand(
        id: '${widget.animationId}_resume_${DateTime.now().millisecondsSinceEpoch}',
        animationId: widget.animationId,
      ),
    );

    animationController.forward();
  }

  /// Reset the animation
  void resetAnimation() {
    if (!_isInitialized) return;

    final orchestrator = ref.read(animationOrchestratorProvider);
    orchestrator.addCommand(
      ResetAnimationCommand(
        id: '${widget.animationId}_reset_${DateTime.now().millisecondsSinceEpoch}',
        animationId: widget.animationId,
      ),
    );

    animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    // Watch animation state from provider
    _animationState = ref.watch(animationStateByIdProvider(widget.animationId));

    // Build the animated widget
    return buildAnimatedWidget(context);
  }

  /// Initialize animation-specific setup
  /// Override in subclasses for custom initialization
  void initializeAnimationSpecific() {}

  /// Build the animated widget
  /// Must be implemented by subclasses
  Widget buildAnimatedWidget(BuildContext context);

  /// Get the current animated text
  /// Can be overridden by subclasses for custom text transformation
  String getCurrentText() {
    return widget.text;
  }

  /// Get the current text style
  /// Can be overridden by subclasses for custom styling
  TextStyle getCurrentTextStyle(BuildContext context) {
    return widget.style ??
        Theme.of(context).textTheme.bodyLarge ??
        const TextStyle();
  }

  /// Handle animation errors
  void handleAnimationError(String error) {
    debugPrint('Animation Error (${widget.animationId}): $error');
    widget.onAnimationError?.call(error);

    final orchestrator = ref.read(animationOrchestratorProvider);
    final currentState = orchestrator.getAnimation(widget.animationId);

    if (currentState != null) {
      currentState.addError(error);
      // Update error state in orchestrator
    }
  }

  /// Get animation value for specific property
  double getAnimationValue(String property, {double defaultValue = 0.0}) {
    if (!_isInitialized) return defaultValue;

    final value = widget.config.properties[property];
    if (value is num) {
      return value.toDouble() * animationController.value;
    }

    return defaultValue;
  }

  /// Get interpolated value between two values
  double interpolateValue(double start, double end) {
    if (!_isInitialized) return start;
    return start + (end - start) * animationController.value;
  }

  /// Get curved animation value
  double getCurvedValue({Curve curve = Curves.easeInOut}) {
    if (!_isInitialized) return 0.0;
    return curve.transform(animationController.value);
  }
}

/// Mixin for listening to animation commands from orchestrator
mixin AnimationListener<T extends AnimatedTextWidget>
    on AnimatedTextWidgetState<T> {
  @override
  void initState() {
    super.initState();
    _listenToCommands();
  }

  /// Listen to animation commands
  void _listenToCommands() {
    // This would be implemented with a stream or listener
    // For now, we'll use the provider system to react to state changes
  }

  /// Handle incoming animation command
  void handleAnimationCommand(AnimationCommand command) {
    if (command is StartAnimationCommand &&
        command.animationId == widget.animationId) {
      startAnimation();
    } else if (command is StopAnimationCommand &&
        command.animationId == widget.animationId) {
      stopAnimation();
    } else if (command is PauseAnimationCommand &&
        command.animationId == widget.animationId) {
      pauseAnimation();
    } else if (command is ResumeAnimationCommand &&
        command.animationId == widget.animationId) {
      resumeAnimation();
    } else if (command is ResetAnimationCommand &&
        command.animationId == widget.animationId) {
      resetAnimation();
    }
  }
}
