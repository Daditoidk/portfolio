import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/animation_status.dart';
import '../orchestrator/animation_state.dart';

import '../orchestrator/animation_queue.dart';
import 'animation_orchestrator_provider.dart';

/// Provider for animation state
final animationStateProvider = StateProvider<AnimationInstanceState?>((ref) {
  return null;
});

/// Provider for global animation state
final globalAnimationStateProvider = StateProvider<GlobalAnimationState>((ref) {
  return GlobalAnimationState.initial();
});

/// Provider for animation state by ID
final animationStateByIdProvider =
    Provider.family<AnimationInstanceState?, String>((ref, id) {
      final orchestrator = ref.watch(animationOrchestratorProvider);
      return orchestrator.getAnimation(id);
    });

/// Provider for animation state status
final animationStateStatusProvider = Provider.family<AnimationState, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return AnimationState.idle;

  return animation.status;
});

/// Provider for animation state progress
final animationStateProgressProvider = Provider.family<double, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return 0.0;

  return animation.progress;
});

/// Provider for animation state is running
final animationStateIsRunningProvider = Provider.family<bool, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.isRunning;
});

/// Provider for animation state is completed
final animationStateIsCompletedProvider = Provider.family<bool, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.isCompleted;
});

/// Provider for animation state is paused
final animationStateIsPausedProvider = Provider.family<bool, String>((ref, id) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.isPaused;
});

/// Provider for animation state is idle
final animationStateIsIdleProvider = Provider.family<bool, String>((ref, id) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.isIdle;
});

/// Provider for animation state has errors
final animationStateHasErrorsProvider = Provider.family<bool, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.hasErrors;
});

/// Provider for animation state has warnings
final animationStateHasWarningsProvider = Provider.family<bool, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return false;

  return animation.hasWarnings;
});

/// Provider for animation state errors
final animationStateErrorsProvider = Provider.family<List<String>, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return [];

  return animation.errors;
});

/// Provider for animation state warnings
final animationStateWarningsProvider = Provider.family<List<String>, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return [];

  return animation.warnings;
});

/// Provider for animation state elapsed time
final animationStateElapsedTimeProvider = Provider.family<Duration, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return Duration.zero;

  return animation.elapsedTime;
});

/// Provider for animation state remaining time
final animationStateRemainingTimeProvider = Provider.family<Duration?, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return null;

  return animation.remainingTime;
});

/// Provider for animation state duration
final animationStateDurationProvider = Provider.family<Duration?, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return null;

  return animation.duration;
});

/// Provider for animation state start time
final animationStateStartTimeProvider = Provider.family<DateTime, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return DateTime.now();

  return animation.startTime;
});

/// Provider for animation state end time
final animationStateEndTimeProvider = Provider.family<DateTime?, String>((
  ref,
  id,
) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return null;

  return animation.endTime;
});

/// Provider for animation state metadata
final animationStateMetadataProvider =
    Provider.family<Map<String, dynamic>, String>((ref, id) {
      final animation = ref.watch(animationStateByIdProvider(id));
      if (animation == null) return {};

      return animation.metadata;
    });

/// Provider for animation state config
final animationStateConfigProvider =
    Provider.family<Map<String, dynamic>, String>((ref, id) {
      final animation = ref.watch(animationStateByIdProvider(id));
      if (animation == null) return {};

      return animation.config;
    });

/// Provider for animation state type
final animationStateTypeProvider = Provider.family<String, String>((ref, id) {
  final animation = ref.watch(animationStateByIdProvider(id));
  if (animation == null) return '';

  return animation.type;
});

/// Provider for all running animations
final runningAnimationsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.animations.entries
      .where((entry) => entry.value.isRunning)
      .map((entry) => entry.key)
      .toList();
});

/// Provider for all completed animations
final completedAnimationsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.animations.entries
      .where((entry) => entry.value.isCompleted)
      .map((entry) => entry.key)
      .toList();
});

/// Provider for all error animations
final errorAnimationsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.animations.entries
      .where((entry) => entry.value.hasErrors)
      .map((entry) => entry.key)
      .toList();
});

/// Provider for all paused animations
final pausedAnimationsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.animations.entries
      .where((entry) => entry.value.isPaused)
      .map((entry) => entry.key)
      .toList();
});

/// Provider for all idle animations
final idleAnimationsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.animations.entries
      .where((entry) => entry.value.isIdle)
      .map((entry) => entry.key)
      .toList();
});

/// Provider for orchestrator statistics
final orchestratorStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.getStatistics();
});

/// Provider for orchestrator summary
final orchestratorSummaryProvider = Provider<String>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.getSummary();
});

/// Provider for orchestrator is processing
final orchestratorIsProcessingProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.isProcessing;
});

/// Provider for orchestrator running count
final orchestratorRunningCountProvider = Provider<int>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.runningCount;
});

/// Provider for orchestrator completed count
final orchestratorCompletedCountProvider = Provider<int>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.completedCount;
});

/// Provider for orchestrator error count
final orchestratorErrorCountProvider = Provider<int>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.errorCount;
});

/// Provider for orchestrator total count
final orchestratorTotalCountProvider = Provider<int>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.totalCount;
});

/// Provider for orchestrator has running animations
final orchestratorHasRunningAnimationsProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.runningCount > 0;
});

/// Provider for orchestrator has errors
final orchestratorHasErrorsProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.errorCount > 0 || orchestrator.globalErrors.isNotEmpty;
});

/// Provider for orchestrator has warnings
final orchestratorHasWarningsProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.globalWarnings.isNotEmpty;
});

/// Provider for orchestrator global errors
final orchestratorGlobalErrorsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.globalErrors;
});

/// Provider for orchestrator global warnings
final orchestratorGlobalWarningsProvider = Provider<List<String>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.globalWarnings;
});

/// Provider for orchestrator global config
final orchestratorGlobalConfigProvider = Provider<Map<String, dynamic>>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.globalConfig;
});

/// Provider for orchestrator command queue
final orchestratorCommandQueueProvider = Provider<AnimationQueue>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue;
});

/// Provider for orchestrator command queue size
final orchestratorCommandQueueSizeProvider = Provider<int>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue.size;
});

/// Provider for orchestrator command queue is empty
final orchestratorCommandQueueIsEmptyProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue.isEmpty;
});

/// Provider for orchestrator command queue can undo
final orchestratorCommandQueueCanUndoProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue.canUndo;
});

/// Provider for orchestrator command queue can redo
final orchestratorCommandQueueCanRedoProvider = Provider<bool>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue.canRedo;
});

/// Provider for orchestrator command queue statistics
final orchestratorCommandQueueStatisticsProvider =
    Provider<Map<String, dynamic>>((ref) {
      final orchestrator = ref.watch(animationOrchestratorProvider);
      return orchestrator.commandQueue.getStatistics();
    });

/// Provider for orchestrator command queue summary
final orchestratorCommandQueueSummaryProvider = Provider<String>((ref) {
  final orchestrator = ref.watch(animationOrchestratorProvider);
  return orchestrator.commandQueue.getSummary();
});
