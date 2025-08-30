import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../text_order/text_order_data.dart';

/// Controller for canvas-level animations that orchestrates multiple TextAnimation widgets
class CanvasAnimationController extends ChangeNotifier {
  /// Current animation state
  bool _isPlaying = false;
  bool _isPaused = false;

  /// Text order data for orchestration
  TextOrderData? _textOrderData;

  /// List of active animation IDs
  final List<String> _activeAnimationIds = [];

  /// Animation controllers for each TextAnimation widget
  final Map<String, AnimationController> _animationControllers = {};

  /// Callbacks for external control
  VoidCallback? onAnimationStart;
  VoidCallback? onAnimationComplete;
  VoidCallback? onAnimationPause;
  VoidCallback? onAnimationReset;

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  TextOrderData? get textOrderData => _textOrderData;
  List<String> get activeAnimationIds => List.unmodifiable(_activeAnimationIds);

  /// Set text order data for orchestration
  void setTextOrderData(TextOrderData? textOrderData) {
    _textOrderData = textOrderData;
    notifyListeners();
  }

  /// Register an animation controller
  void registerAnimation(String animationId, AnimationController controller) {
    _animationControllers[animationId] = controller;
    _activeAnimationIds.add(animationId);
    notifyListeners();
  }

  /// Unregister an animation controller
  void unregisterAnimation(String animationId) {
    _animationControllers.remove(animationId);
    _activeAnimationIds.remove(animationId);
    notifyListeners();
  }

  /// Play all canvas animations with orchestration
  void playCanvas() {
    if (_isPlaying) return;

    _isPlaying = true;
    _isPaused = false;

    if (_textOrderData != null) {
      _playOrchestratedAnimations();
    } else {
      _playAllAnimations();
    }

    onAnimationStart?.call();
    notifyListeners();
  }

  /// Pause all canvas animations
  void pauseCanvas() {
    if (!_isPlaying || _isPaused) return;

    _isPaused = true;

    for (final controller in _animationControllers.values) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }

    onAnimationPause?.call();
    notifyListeners();
  }

  /// Resume all canvas animations
  void resumeCanvas() {
    if (!_isPlaying || !_isPaused) return;

    _isPaused = false;

    if (_textOrderData != null) {
      _playOrchestratedAnimations();
    } else {
      _playAllAnimations();
    }

    notifyListeners();
  }

  /// Reset all canvas animations
  void resetCanvas() {
    _isPlaying = false;
    _isPaused = false;

    for (final controller in _animationControllers.values) {
      controller.reset();
    }

    onAnimationReset?.call();
    notifyListeners();
  }

  /// Play orchestrated animations based on text order data
  void _playOrchestratedAnimations() {
    if (_textOrderData == null) return;

    // TODO: Implement orchestrated animation logic
    // This would coordinate the timing of multiple animations
    // based on the text order data structure

    // For now, just play all animations
    _playAllAnimations();
  }

  /// Play all animations simultaneously
  void _playAllAnimations() {
    for (final controller in _animationControllers.values) {
      if (controller.status != AnimationStatus.completed) {
        controller.forward();
      }
    }
  }

  /// Stop all animations
  void stopCanvas() {
    _isPlaying = false;
    _isPaused = false;

    for (final controller in _animationControllers.values) {
      controller.stop();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    _animationControllers.clear();
    super.dispose();
  }
}

/// Riverpod provider for canvas animation controller
final canvasAnimationControllerProvider =
    ChangeNotifierProvider<CanvasAnimationController>((ref) {
      return CanvasAnimationController();
    });
