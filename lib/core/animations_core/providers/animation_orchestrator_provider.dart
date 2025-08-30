import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../orchestrator/animation_orchestrator.dart';

/// Provider for the global animation orchestrator
final animationOrchestratorProvider =
    ChangeNotifierProvider<AnimationOrchestrator>((ref) {
      return AnimationOrchestrator();
    });

/// Provider for the orchestrator's notifier (for sending commands)
final animationOrchestratorNotifierProvider = Provider<AnimationOrchestrator>((
  ref,
) {
  return ref.read(animationOrchestratorProvider.notifier);
});
