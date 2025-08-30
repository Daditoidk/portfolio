import 'package:flutter/material.dart';
import '../../../../screens/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

/// Mixin for common animation behaviors
mixin AnimationBehaviors {
  /// Check if animation should loop based on config
  bool shouldLoop(BaseAnimationPropertiesData config) {
    final result = config.loop;
    debugPrint(
      'AnimationBehaviors: shouldLoop check - config: ${config.runtimeType}, result: $result',
    );
    return result;
  }

  /// Get animation duration from config
  Duration getDuration(BaseAnimationPropertiesData config) =>
      Duration(milliseconds: (config.speed * 1000).round());

  /// Get animation delay from config
  Duration getDelay(BaseAnimationPropertiesData config) =>
      Duration(milliseconds: 0); // Default no delay

  /// Get animation speed from config
  double getSpeed(BaseAnimationPropertiesData config) => config.speed;

  /// Apply speed to duration
  Duration applySpeed(Duration baseDuration, double speed) =>
      Duration(milliseconds: (baseDuration.inMilliseconds / speed).round());

  /// Check if animation is in a valid state to start
  bool canStartAnimation(AnimationController controller) {
    return !controller.isAnimating &&
        controller.status != AnimationStatus.completed;
  }

  /// Reset controller if needed for restart
  void resetControllerIfNeeded(AnimationController controller) {
    if (controller.status == AnimationStatus.completed) {
      controller.reset();
    }
  }
}
