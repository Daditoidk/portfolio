import 'package:flutter/material.dart';
import '../base/base_animation.dart';
import '../base/animation_config.dart';
import 'text_scramble_config.dart';

/// Base class for all text animations
abstract class TextAnimationBase extends BaseAnimation {
  const TextAnimationBase({
    required super.name,
    required super.type,
    required super.exportType,
    required super.config,
  });

  /// Get the list of text IDs that this animation will affect
  List<String> get textIds;

  /// Get the animation sequence (order of text animation)
  List<String> get animationSequence;

  /// Check if a specific text should be animated
  bool shouldAnimateText(String textId);

  /// Get animation delay for a specific text
  Duration getDelayForText(String textId);

  /// Get animation duration for a specific text
  Duration getDurationForText(String textId);

  /// Get animation curve for a specific text
  Curve getCurveForText(String textId);
}

/// Configuration specific to text animations
abstract class TextAnimationConfig extends AnimationConfig {
  final List<String> textIds;
  final Map<String, dynamic> textOrderData;
  final AnimationMode mode;
  final AnimationDirection direction;
  final AnimationTimingMode timing;

  const TextAnimationConfig({
    required super.name,
    required super.type,
    required super.properties,
    required this.textIds,
    required this.textOrderData,
    required this.mode,
    required this.direction,
    required this.timing,
  });

  /// Get animation sequence based on mode and direction
  List<String> getAnimationSequence();

  /// Validate text order data
  bool isTextOrderDataValid();
}
