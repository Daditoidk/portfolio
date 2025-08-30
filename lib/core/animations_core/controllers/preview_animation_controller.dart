import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for preview-level animations that controls a single TextAnimation widget
class PreviewAnimationController extends ChangeNotifier {
  /// Current animation state
  bool _isPlaying = false;
  bool _isPaused = false;

  /// Reference to the TextAnimation's internal controller
  AnimationController? _textAnimationController;

  /// Callbacks for external control
  VoidCallback? onAnimationStart;
  VoidCallback? onAnimationComplete;
  VoidCallback? onAnimationPause;
  VoidCallback? onAnimationReset;

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  AnimationController? get textAnimationController => _textAnimationController;

  /// Set the TextAnimation's internal controller
  void setTextAnimationController(AnimationController controller) {
    _textAnimationController = controller;

    // Add listener to track animation completion
    controller.addStatusListener(_onAnimationStatusChange);
  }

  /// Play or resume the preview animation
  void playPreview() {
    if (_textAnimationController == null) return;

    final controller = _textAnimationController!;

    // If animation is paused, resume it
    if (_isPlaying && _isPaused) {
      _isPaused = false;
      controller.forward(); // Resume from current position
      notifyListeners();
      return;
    }

    // If animation is already playing, don't do anything
    if (_isPlaying && !_isPaused) return;

    // Start new animation
    _isPlaying = true;
    _isPaused = false;

    if (controller.status == AnimationStatus.completed) {
      controller.reset();
    }

    controller.forward();
    onAnimationStart?.call();
    notifyListeners();
  }

  /// Pause the preview animation
  void pausePreview() {
    if (!_isPlaying || _isPaused || _textAnimationController == null) return;

    _isPaused = true;

    final controller = _textAnimationController!;
    if (controller.isAnimating) {
      controller.stop();
    }

    onAnimationPause?.call();
    notifyListeners();
  }

  /// Resume the preview animation
  void resumePreview() {
    if (!_isPlaying || !_isPaused || _textAnimationController == null) return;

    _isPaused = false;

    final controller = _textAnimationController!;
    if (controller.value > 0 &&
        controller.status != AnimationStatus.completed) {
      controller.forward();
    }

    notifyListeners();
  }

  /// Reset the preview animation
  void resetPreview() {
    if (_textAnimationController == null) return;

    _isPlaying = false;
    _isPaused = false;

    final controller = _textAnimationController!;
    controller.reset();

    onAnimationReset?.call();
    notifyListeners();
  }

  /// Stop the preview animation
  void stopPreview() {
    if (_textAnimationController == null) return;

    _isPlaying = false;
    _isPaused = false;

    final controller = _textAnimationController!;
    controller.stop();

    notifyListeners();
  }

  /// Handle animation status changes
  void _onAnimationStatusChange(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        _isPlaying = false;
        onAnimationComplete?.call();
        notifyListeners();
        break;
      case AnimationStatus.dismissed:
        _isPlaying = false;
        _isPaused = false;
        notifyListeners();
        break;
      case AnimationStatus.forward:
        // Animation is running
        break;
      case AnimationStatus.reverse:
        // Animation is reversing
        break;
    }
  }

  /// Check if animation can be played
  bool get canPlay =>
      _textAnimationController != null && (!_isPlaying || _isPaused);

  /// Check if animation can be paused
  bool get canPause =>
      _textAnimationController != null && _isPlaying && !_isPaused;

  /// Check if animation can be resumed
  bool get canResume =>
      _textAnimationController != null && _isPlaying && _isPaused;

  /// Check if animation can be reset
  bool get canReset => _textAnimationController != null;

  @override
  void dispose() {
    // Remove listener from controller
    if (_textAnimationController != null) {
      _textAnimationController!.removeStatusListener(_onAnimationStatusChange);
    }
    super.dispose();
  }
}

/// Riverpod provider for preview animation controller
final previewAnimationControllerProvider =
    ChangeNotifierProvider<PreviewAnimationController>((ref) {
      return PreviewAnimationController();
    });
