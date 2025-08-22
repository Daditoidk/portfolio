import 'package:flutter/material.dart';

/// Base configuration for all animations
abstract class AnimationConfig {
  final String name;
  final String type;
  final Map<String, dynamic> properties;

  const AnimationConfig({
    required this.name,
    required this.type,
    required this.properties,
  });

  /// Convert configuration to JSON
  Map<String, dynamic> toJson();

  /// Create configuration from JSON
  static AnimationConfig fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented by subclasses');
  }

  /// Validate configuration
  bool isValid();

  /// Get default values for this animation type
  Map<String, dynamic> getDefaultProperties();
}

/// Settings for animation triggers
class AnimationTriggerSettings {
  final bool useViewport;
  final bool useScroll;
  final bool useHover;
  final bool useTap;
  final double? scrollThreshold;
  final Duration viewportDelay;
  final double? viewportOffset; // Y position offset for viewport trigger

  const AnimationTriggerSettings({
    this.useViewport = false,
    this.useScroll = false,
    this.useHover = false,
    this.useTap = false,
    this.scrollThreshold,
    this.viewportDelay = Duration.zero,
    this.viewportOffset,
  });

  Map<String, dynamic> toJson() {
    return {
      'useViewport': useViewport,
      'useScroll': useScroll,
      'useHover': useHover,
      'useTap': useTap,
      'scrollThreshold': scrollThreshold,
      'viewportDelay': viewportDelay.inMilliseconds,
      'viewportOffset': viewportOffset,
    };
  }

  factory AnimationTriggerSettings.fromJson(Map<String, dynamic> json) {
    return AnimationTriggerSettings(
      useViewport: json['useViewport'] ?? false,
      useScroll: json['useScroll'] ?? false,
      useHover: json['useHover'] ?? false,
      useTap: json['useTap'] ?? false,
      scrollThreshold: json['scrollThreshold'],
      viewportDelay: Duration(milliseconds: json['viewportDelay'] ?? 0),
      viewportOffset: json['viewportOffset'],
    );
  }
}

/// Settings for animation behavior
class AnimationBehaviorSettings {
  final Duration duration;
  final Curve curve;
  final bool autoReverse;
  final int repeatCount;
  final bool repeat;
  final bool reverse;

  const AnimationBehaviorSettings({
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.autoReverse = false,
    this.repeatCount = 1,
    this.repeat = false,
    this.reverse = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inMilliseconds,
      'curve': curve.toString(),
      'autoReverse': autoReverse,
      'repeatCount': repeatCount,
      'repeat': repeat,
      'reverse': reverse,
    };
  }

  factory AnimationBehaviorSettings.fromJson(Map<String, dynamic> json) {
    return AnimationBehaviorSettings(
      duration: Duration(milliseconds: json['duration'] ?? 800),
      curve: _parseCurve(json['curve']),
      autoReverse: json['autoReverse'] ?? false,
      repeatCount: json['repeatCount'] ?? 1,
      repeat: json['repeat'] ?? false,
      reverse: json['reverse'] ?? false,
    );
  }

  static Curve _parseCurve(String curveString) {
    switch (curveString) {
      case 'Curves.easeInOut':
        return Curves.easeInOut;
      case 'Curves.easeIn':
        return Curves.easeIn;
      case 'Curves.easeOut':
        return Curves.easeOut;
      case 'Curves.fastOutSlowIn':
        return Curves.fastOutSlowIn;
      case 'Curves.bounceIn':
        return Curves.bounceIn;
      case 'Curves.bounceOut':
        return Curves.bounceOut;
      case 'Curves.elasticIn':
        return Curves.elasticIn;
      case 'Curves.elasticOut':
        return Curves.elasticOut;
      default:
        return Curves.easeInOut;
    }
  }
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

  Map<String, dynamic> toJson() {
    return {'trigger': trigger.toJson(), 'behavior': behavior.toJson()};
  }

  factory AnimationSettings.fromJson(Map<String, dynamic> json) {
    return AnimationSettings(
      trigger: AnimationTriggerSettings.fromJson(json['trigger'] ?? {}),
      behavior: AnimationBehaviorSettings.fromJson(json['behavior'] ?? {}),
    );
  }
}

