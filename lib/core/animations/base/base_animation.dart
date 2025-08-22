import 'package:flutter/material.dart';
import 'animation_config.dart';
import 'animation_status.dart';

/// Defines how an animation should be exported
enum ExportType {
  /// Export as JSON for complex animations (text scramble, etc.)
  json,

  /// Export as Dart code for simple animations (fade, slide, etc.)
  dartCode,
}

/// Base class for all animations
abstract class BaseAnimation {
  final String name;
  final String type;
  final ExportType exportType;
  final AnimationConfig config;

  const BaseAnimation({
    required this.name,
    required this.type,
    required this.exportType,
    required this.config,
  });

  /// Execute the animation
  Future<void> execute();

  /// Pause the animation
  void pause();

  /// Resume the animation
  void resume();

  /// Stop the animation
  void stop();

  /// Reset the animation to initial state
  void reset();

  /// Export the animation according to its export type
  Map<String, dynamic> export();

  /// Validate if the animation can be executed
  bool canExecute();

  /// Get animation status
  AnimationState get status;

  /// Dispose resources
  void dispose();
}

/// Base class for animation controllers
abstract class BaseAnimationController {
  late AnimationController controller;
  late Animation<double> animation;

  /// Current status of the animation
  AnimationState get status;

  /// Execute the animation
  Future<void> execute();

  /// Pause the animation
  void pause();

  /// Resume the animation
  void resume();

  /// Stop the animation
  void stop();

  /// Reset the animation
  void reset();

  /// Dispose resources
  void dispose();

  /// Get animation progress (0.0 to 1.0)
  double get progress;

  /// Check if animation is running
  bool get isRunning;

  /// Check if animation is completed
  bool get isCompleted;
}
