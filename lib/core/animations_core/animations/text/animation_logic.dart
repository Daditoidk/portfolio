import 'package:flutter/material.dart';
import '../../base/animation_types.dart';
import '../../orchestrator/animation_state.dart';
import '../../orchestrator/animation_command.dart';
import '../../providers/animation_orchestrator_provider.dart';
import '../../text_order/text_order_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'animation_mixins.dart';
import '../../../../screens/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

/// Animation logic that handles the business rules for text animations
class AnimationLogic with AnimationBehaviors {
  final AnimationController animationEngine;
  final BaseAnimationPropertiesData config;
  final String? textOrderId;
  final TextOrderData? textOrderData;
  final TextAnimationType type;
  final WidgetRef ref;

  AnimationInstanceState? _animationState;

  AnimationLogic({
    required this.animationEngine,
    required this.config,
    this.textOrderId,
    this.textOrderData,
    required this.type,
    required this.ref,
  }) {
    debugPrint(
      'AnimationLogic: Constructor called with config: ${config.runtimeType}',
    );
    debugPrint('AnimationLogic: Loop value in constructor: ${config.loop}');
  }

  /// Check if this animation should run in orchestrated mode
  bool get isOrchestratedMode {
    return textOrderId != null &&
        textOrderId!.isNotEmpty &&
        textOrderData != null &&
        textOrderData!.sections.isNotEmpty;
  }

  /// Setup orchestrator integration
  void setupOrchestrator() {
    if (isOrchestratedMode) {
      _setupOrchestratedMode();
    } else {
      _setupIndependentMode();
    }
  }

  /// Setup for orchestrated mode
  void _setupOrchestratedMode() {
    _animationState = AnimationInstanceState.initial(
      id: textOrderId!,
      type: textAnimationTypeToString(type) ?? 'unknown',
      config: _configToMap(), // Convert typed config to map for orchestrator
    );

    final orchestrator = ref.read(animationOrchestratorProvider.notifier);
    orchestrator.registerAnimation(textOrderId!, _animationState!);
  }

  /// Convert typed config to map for orchestrator compatibility
  Map<String, dynamic> _configToMap() {
    // Basic conversion - can be extended as needed
    return {
      'loop': config.loop,
      'speed': config.speed,
      'previewText': config.previewText,
      // Add other properties as needed
    };
  }

  /// Setup for independent mode
  void _setupIndependentMode() {
    // No special setup needed for independent mode
  }

  /// Start the animation
  void startAnimation() {
    debugPrint('AnimationLogic: startAnimation() called');
    debugPrint(
      'AnimationLogic: animationEngine.isAnimating: ${animationEngine.isAnimating}',
    );
    debugPrint(
      'AnimationLogic: animationEngine.status: ${animationEngine.status}',
    );

    if (animationEngine.isAnimating) {
      debugPrint('AnimationLogic: Cannot start - already animating');
      return;
    }

    if (animationEngine.status == AnimationStatus.completed) {
      debugPrint('AnimationLogic: Resetting completed animation');
      animationEngine.reset();
    }

    debugPrint('AnimationLogic: Applying configuration and starting');
    _applyConfiguration();
    animationEngine.forward();
  }

  /// Stop and reset the animation to beginning
  void resetAnimation() {
    if (animationEngine.isAnimating) {
      animationEngine.stop();
    }
    animationEngine.reset(); // Reset to beginning (0.0)
  }

  /// Pause the animation (can be resumed)
  void pauseAnimation() {
    if (animationEngine.isAnimating) {
      animationEngine.stop(); // Pause at current position
    }
  }

  /// Resume the animation from where it was paused
  void resumeAnimation() {
    if (!animationEngine.isAnimating && animationEngine.value > 0) {
      animationEngine.forward(); // Continue from current position
    }
  }

  /// Handle animation completion
  void handleAnimationComplete() {
    debugPrint('AnimationLogic: Animation completed!');

    debugPrint('AnimationLogic: Loop config from typed config: ${config.loop}');

    if (config.loop) {
      debugPrint('AnimationLogic: 🔄 Looping enabled - restarting animation');
      animationEngine.reset();
      startAnimation();
    } else {
      debugPrint('AnimationLogic: ⏹️ Looping disabled - just resetting');
      // animationEngine.reset();
    }
  }

  /// Apply configuration to animation engine
  void _applyConfiguration() {
    final newDuration = applySpeed(getDuration(config), getSpeed(config));
    animationEngine.duration = newDuration;

    final delayDuration = getDelay(config);
    if (delayDuration.inMilliseconds > 0) {
      debugPrint('AnimationLogic: Applying delay of $delayDuration');
      Future.delayed(delayDuration, () {
        if (animationEngine.status != AnimationStatus.completed) {
          debugPrint('AnimationLogic: Delay finished, starting animation');
          animationEngine.forward();
        } else {
          debugPrint(
            'AnimationLogic: Delay finished but animation already completed, not restarting',
          );
        }
      });
    } else {
      debugPrint('AnimationLogic: No delay applied');
    }
  }

  /// Notify orchestrator about reset
  void notifyOrchestratorReset() {
    if (!isOrchestratedMode) return;

    try {
      final orchestrator = ref.read(animationOrchestratorProvider.notifier);
      orchestrator.addCommand(
        StopAnimationCommand(
          id: 'reset_${textOrderId}_${DateTime.now().millisecondsSinceEpoch}',
          animationId: textOrderId!,
        ),
      );
    } catch (e) {
      debugPrint('Failed to notify orchestrator about reset: $e');
    }
  }

  /// Notify orchestrator about pause
  void notifyOrchestratorPause() {
    if (!isOrchestratedMode) return;

    try {
      final orchestrator = ref.read(animationOrchestratorProvider.notifier);
      orchestrator.addCommand(
        PauseAnimationCommand(
          id: 'pause_${textOrderId}_${DateTime.now().millisecondsSinceEpoch}',
          animationId: textOrderId!,
        ),
      );
    } catch (e) {
      debugPrint('Failed to notify orchestrator about pause: $e');
    }
  }

  /// Get current animation state
  AnimationInstanceState? get animationState => _animationState;
}
