import 'package:flutter/material.dart';

/// Base class for all animation controllers
abstract class BaseAnimationController {
  late AnimationController controller;
  late Animation<double> animation;

  void dispose() {
    controller.dispose();
  }

  void forward() {
    controller.forward();
  }

  void reverse() {
    controller.reverse();
  }

  void reset() {
    controller.reset();
  }
}

/// Settings for animation triggers
class AnimationTriggerSettings {
  final bool useViewport;
  final bool useScroll;
  final bool useHover;
  final bool useTap;
  final double? scrollThreshold;
  final Duration viewportDelay;

  const AnimationTriggerSettings({
    this.useViewport = false,
    this.useScroll = false,
    this.useHover = false,
    this.useTap = false,
    this.scrollThreshold,
    this.viewportDelay = Duration.zero,
  });
}

/// Settings for animation behavior
class AnimationBehaviorSettings {
  final Duration duration;
  final Curve curve;
  final bool autoReverse;
  final int repeatCount;
  final bool repeat;

  const AnimationBehaviorSettings({
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.autoReverse = false,
    this.repeatCount = 1,
    this.repeat = false,
  });
}

/// Base animation settings that combines trigger and behavior
class AnimationSettings {
  final AnimationTriggerSettings trigger;
  final AnimationBehaviorSettings behavior;

  const AnimationSettings({
    this.trigger = const AnimationTriggerSettings(),
    this.behavior = const AnimationBehaviorSettings(),
  });

  const AnimationSettings.fast({
    this.trigger = const AnimationTriggerSettings(),
  }) : behavior = const AnimationBehaviorSettings(
         duration: Duration(milliseconds: 300),
         curve: Curves.easeOut,
       );

  const AnimationSettings.slow({
    this.trigger = const AnimationTriggerSettings(),
  }) : behavior = const AnimationBehaviorSettings(
         duration: Duration(milliseconds: 1200),
         curve: Curves.easeInOut,
       );
}
