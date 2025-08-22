import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../orchestrator/animation_orchestrator.dart';
import '../text_order/text_order_manager.dart';

/// Provider for the main animation orchestrator
final animationOrchestratorProvider = ChangeNotifierProvider<AnimationOrchestrator>((ref) {
  final textOrderManager = ref.read(textOrderManagerProvider);
  
  final orchestrator = AnimationOrchestrator(
    textOrderManager: textOrderManager,
    maxQueueSize: 100,
  );
  
  // Initialize the orchestrator
  orchestrator.initialize();
  
  // Dispose when provider is disposed
  ref.onDispose(() {
    orchestrator.dispose();
  });
  
  return orchestrator;
});

/// Provider for text order manager
final textOrderManagerProvider = Provider<TextOrderManager>((ref) {
  return TextOrderManager();
});

/// Provider for animation orchestrator state
final animationOrchestratorStateProvider = Provider<AnimationOrchestrator>((ref) {
  return ref.watch(animationOrchestratorProvider);
});

/// Provider for animation orchestrator notifier
final animationOrchestratorNotifierProvider = ChangeNotifierProvider<AnimationOrchestrator>((ref) {
  return ref.watch(animationOrchestratorProvider.notifier);
});
