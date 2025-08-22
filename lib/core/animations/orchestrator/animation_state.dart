import '../base/animation_status.dart';
import '../text_order/text_order_data.dart';

/// State of an individual animation
class AnimationInstanceState {
  final String id;
  final String type;
  final AnimationState status;
  final Map<String, dynamic> config;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final double progress; // 0.0 to 1.0
  final Map<String, dynamic> metadata;
  final List<String> errors;
  final List<String> warnings;

  const AnimationInstanceState({
    required this.id,
    required this.type,
    required this.status,
    required this.config,
    required this.startTime,
    this.endTime,
    this.duration,
    this.progress = 0.0,
    this.metadata = const {},
    this.errors = const [],
    this.warnings = const [],
  });

  /// Create initial state
  factory AnimationInstanceState.initial({
    required String id,
    required String type,
    required Map<String, dynamic> config,
  }) {
    return AnimationInstanceState(
      id: id,
      type: type,
      status: AnimationState.idle,
      config: config,
      startTime: DateTime.now(),
    );
  }

  /// Create running state
  factory AnimationInstanceState.running({
    required String id,
    required String type,
    required Map<String, dynamic> config,
    required DateTime startTime,
    double progress = 0.0,
  }) {
    return AnimationInstanceState(
      id: id,
      type: type,
      status: AnimationState.running,
      config: config,
      startTime: startTime,
      progress: progress,
    );
  }

  /// Create completed state
  factory AnimationInstanceState.completed({
    required String id,
    required String type,
    required Map<String, dynamic> config,
    required DateTime startTime,
    required DateTime endTime,
    Map<String, dynamic>? metadata,
  }) {
    final duration = endTime.difference(startTime);
    return AnimationInstanceState(
      id: id,
      type: type,
      status: AnimationState.completed,
      config: config,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      progress: 1.0,
      metadata: metadata ?? {},
    );
  }

  /// Create error state
  factory AnimationInstanceState.error({
    required String id,
    required String type,
    required Map<String, dynamic> config,
    required DateTime startTime,
    required List<String> errors,
    List<String> warnings = const [],
  }) {
    return AnimationInstanceState(
      id: id,
      type: type,
      status: AnimationState.error,
      config: config,
      startTime: startTime,
      endTime: DateTime.now(),
      errors: errors,
      warnings: warnings,
    );
  }

  /// Create paused state
  factory AnimationInstanceState.paused({
    required String id,
    required String type,
    required Map<String, dynamic> config,
    required DateTime startTime,
    required double progress,
  }) {
    return AnimationInstanceState(
      id: id,
      type: type,
      status: AnimationState.paused,
      config: config,
      startTime: startTime,
      progress: progress,
    );
  }

  /// Check if animation is running
  bool get isRunning => status == AnimationState.running;

  /// Check if animation is completed
  bool get isCompleted => status == AnimationState.completed;

  /// Check if animation has errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check if animation has warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Check if animation is idle
  bool get isIdle => status == AnimationState.idle;

  /// Check if animation is paused
  bool get isPaused => status == AnimationState.paused;

  /// Get elapsed time
  Duration get elapsedTime {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Get remaining time (estimate)
  Duration? get remainingTime {
    if (duration == null || progress <= 0) return null;
    final elapsed = elapsedTime;
    if (elapsed >= duration!) return Duration.zero;
    return Duration(
      milliseconds: ((duration!.inMilliseconds - elapsed.inMilliseconds) / progress).round(),
    );
  }

  /// Create a copy with modifications
  AnimationInstanceState copyWith({
    String? id,
    String? type,
    AnimationState? status,
    Map<String, dynamic>? config,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    double? progress,
    Map<String, dynamic>? metadata,
    List<String>? errors,
    List<String>? warnings,
  }) {
    return AnimationInstanceState(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      config: config ?? this.config,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      metadata: metadata ?? this.metadata,
      errors: errors ?? this.errors,
      warnings: warnings ?? this.warnings,
    );
  }

  /// Update progress
  AnimationInstanceState updateProgress(double newProgress) {
    return copyWith(
      progress: newProgress.clamp(0.0, 1.0),
    );
  }

  /// Add error
  AnimationInstanceState addError(String error) {
    return copyWith(
      errors: [...errors, error],
    );
  }

  /// Add warning
  AnimationInstanceState addWarning(String warning) {
    return copyWith(
      warnings: [...warnings, warning],
    );
  }

  /// Clear errors
  AnimationInstanceState clearErrors() {
    return copyWith(errors: []);
  }

  /// Clear warnings
  AnimationInstanceState clearWarnings() {
    return copyWith(warnings: []);
  }

  /// Mark as completed
  AnimationInstanceState markCompleted({Map<String, dynamic>? metadata}) {
    final now = DateTime.now();
    return copyWith(
      status: AnimationState.completed,
      endTime: now,
      duration: now.difference(startTime),
      progress: 1.0,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Mark as error
  AnimationInstanceState markError(List<String> newErrors, {List<String>? newWarnings}) {
    return copyWith(
      status: AnimationState.error,
      endTime: DateTime.now(),
      errors: newErrors,
      warnings: newWarnings ?? warnings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimationInstanceState &&
        other.id == id &&
        other.status == status &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return Object.hash(id, status, progress);
  }

  @override
  String toString() {
    return 'AnimationInstanceState(id: $id, type: $type, status: $status, progress: ${(progress * 100).toStringAsFixed(1)}%)';
  }
}

/// Global state of all animations
class GlobalAnimationState {
  final Map<String, AnimationInstanceState> animations;
  final List<String> runningAnimations;
  final List<String> completedAnimations;
  final List<String> errorAnimations;
  final Map<String, dynamic> globalConfig;
  final TextOrderData? textOrderData;
  final DateTime lastUpdate;
  final List<String> globalErrors;
  final List<String> globalWarnings;

  const GlobalAnimationState({
    this.animations = const {},
    this.runningAnimations = const [],
    this.completedAnimations = const [],
    this.errorAnimations = const [],
    this.globalConfig = const {},
    this.textOrderData,
    required this.lastUpdate,
    this.globalErrors = const [],
    this.globalWarnings = const [],
  });

  /// Create initial state
  factory GlobalAnimationState.initial() {
    return GlobalAnimationState(
      lastUpdate: DateTime.now(),
    );
  }

  /// Get animation by ID
  AnimationInstanceState? getAnimation(String id) => animations[id];

  /// Check if animation exists
  bool hasAnimation(String id) => animations.containsKey(id);

  /// Get running animations count
  int get runningCount => runningAnimations.length;

  /// Get completed animations count
  int get completedCount => completedAnimations.length;

  /// Get error animations count
  int get errorCount => errorAnimations.length;

  /// Get total animations count
  int get totalCount => animations.length;

  /// Check if any animation is running
  bool get hasRunningAnimations => runningAnimations.isNotEmpty;

  /// Check if any animation has errors
  bool get hasErrors => errorAnimations.isNotEmpty || globalErrors.isNotEmpty;

  /// Check if any animation has warnings
  bool get hasWarnings => globalWarnings.isNotEmpty;

  /// Add or update animation
  GlobalAnimationState addAnimation(AnimationInstanceState animation) {
    final newAnimations = Map<String, AnimationInstanceState>.from(animations);
    newAnimations[animation.id] = animation;

    final newRunning = List<String>.from(runningAnimations);
    final newCompleted = List<String>.from(completedAnimations);
    final newError = List<String>.from(errorAnimations);

    // Update lists based on status
    if (animation.isRunning) {
      if (!newRunning.contains(animation.id)) {
        newRunning.add(animation.id);
      }
      newCompleted.remove(animation.id);
      newError.remove(animation.id);
    } else if (animation.isCompleted) {
      newRunning.remove(animation.id);
      if (!newCompleted.contains(animation.id)) {
        newCompleted.add(animation.id);
      }
      newError.remove(animation.id);
    } else if (animation.hasErrors) {
      newRunning.remove(animation.id);
      newCompleted.remove(animation.id);
      if (!newError.contains(animation.id)) {
        newError.add(animation.id);
      }
    }

    return copyWith(
      animations: newAnimations,
      runningAnimations: newRunning,
      completedAnimations: newCompleted,
      errorAnimations: newError,
      lastUpdate: DateTime.now(),
    );
  }

  /// Remove animation
  GlobalAnimationState removeAnimation(String id) {
    final newAnimations = Map<String, AnimationInstanceState>.from(animations);
    newAnimations.remove(id);

    final newRunning = List<String>.from(runningAnimations)..remove(id);
    final newCompleted = List<String>.from(completedAnimations)..remove(id);
    final newError = List<String>.from(errorAnimations)..remove(id);

    return copyWith(
      animations: newAnimations,
      runningAnimations: newRunning,
      completedAnimations: newCompleted,
      errorAnimations: newError,
      lastUpdate: DateTime.now(),
    );
  }

  /// Update text order data
  GlobalAnimationState updateTextOrderData(TextOrderData? newData) {
    return copyWith(
      textOrderData: newData,
      lastUpdate: DateTime.now(),
    );
  }

  /// Update global configuration
  GlobalAnimationState updateGlobalConfig(Map<String, dynamic> newConfig) {
    return copyWith(
      globalConfig: newConfig,
      lastUpdate: DateTime.now(),
    );
  }

  /// Add global error
  GlobalAnimationState addGlobalError(String error) {
    return copyWith(
      globalErrors: [...globalErrors, error],
      lastUpdate: DateTime.now(),
    );
  }

  /// Add global warning
  GlobalAnimationState addGlobalWarning(String warning) {
    return copyWith(
      globalWarnings: [...globalWarnings, warning],
      lastUpdate: DateTime.now(),
    );
  }

  /// Clear global errors
  GlobalAnimationState clearGlobalErrors() {
    return copyWith(
      globalErrors: [],
      lastUpdate: DateTime.now(),
    );
  }

  /// Clear global warnings
  GlobalAnimationState clearGlobalWarnings() {
    return copyWith(
      globalWarnings: [],
      lastUpdate: DateTime.now(),
    );
  }

  /// Create a copy with modifications
  GlobalAnimationState copyWith({
    Map<String, AnimationInstanceState>? animations,
    List<String>? runningAnimations,
    List<String>? completedAnimations,
    List<String>? errorAnimations,
    Map<String, dynamic>? globalConfig,
    TextOrderData? textOrderData,
    DateTime? lastUpdate,
    List<String>? globalErrors,
    List<String>? globalWarnings,
  }) {
    return GlobalAnimationState(
      animations: animations ?? this.animations,
      runningAnimations: runningAnimations ?? this.runningAnimations,
      completedAnimations: completedAnimations ?? this.completedAnimations,
      errorAnimations: errorAnimations ?? this.errorAnimations,
      globalConfig: globalConfig ?? this.globalConfig,
      textOrderData: textOrderData ?? this.textOrderData,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      globalErrors: globalErrors ?? this.globalErrors,
      globalWarnings: globalWarnings ?? this.globalWarnings,
    );
  }

  @override
  String toString() {
    return 'GlobalAnimationState(animations: $totalCount, running: $runningCount, completed: $completedCount, errors: $errorCount)';
  }
}
