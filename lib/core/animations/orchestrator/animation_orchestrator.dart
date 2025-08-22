import 'dart:async';
import 'package:flutter/foundation.dart';
import '../base/animation_status.dart';

import '../text_order/text_order_manager.dart';
import 'animation_command.dart';
import 'animation_state.dart';
import 'animation_queue.dart';

/// Main orchestrator for managing all animations
class AnimationOrchestrator extends ChangeNotifier {
  final TextOrderManager _textOrderManager;
  final AnimationQueue _commandQueue;
  final Map<String, AnimationInstanceState> _animations;
  final Map<String, dynamic> _globalConfig;

  Timer? _processingTimer;
  bool _isProcessing = false;
  final List<String> _globalErrors = [];
  final List<String> _globalWarnings = [];

  AnimationOrchestrator({
    TextOrderManager? textOrderManager,
    int maxQueueSize = 100,
  }) : _textOrderManager = textOrderManager ?? TextOrderManager(),
       _commandQueue = AnimationQueue(maxHistorySize: maxQueueSize),
       _animations = {},
       _globalConfig = {};

  /// Get text order manager
  TextOrderManager get textOrderManager => _textOrderManager;

  /// Get command queue
  AnimationQueue get commandQueue => _commandQueue;

  /// Get all animations
  Map<String, AnimationInstanceState> get animations =>
      Map.unmodifiable(_animations);

  /// Get global configuration
  Map<String, dynamic> get globalConfig => Map.unmodifiable(_globalConfig);

  /// Get global errors
  List<String> get globalErrors => List.unmodifiable(_globalErrors);

  /// Get global warnings
  List<String> get globalWarnings => List.unmodifiable(_globalWarnings);

  /// Check if orchestrator is processing
  bool get isProcessing => _isProcessing;

  /// Get running animations count
  int get runningCount =>
      _animations.values.where((anim) => anim.isRunning).length;

  /// Get completed animations count
  int get completedCount =>
      _animations.values.where((anim) => anim.isCompleted).length;

  /// Get error animations count
  int get errorCount =>
      _animations.values.where((anim) => anim.hasErrors).length;

  /// Get total animations count
  int get totalCount => _animations.length;

  /// Initialize the orchestrator
  Future<void> initialize() async {
    try {
      // Start processing timer
      _startProcessingTimer();

      // Load any existing text order data
      if (_textOrderManager.hasData) {
        _addGlobalInfo('Text order data loaded from manager');
      }

      notifyListeners();
    } catch (e) {
      _addGlobalError('Failed to initialize orchestrator: $e');
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
  }

  /// Start processing timer
  void _startProcessingTimer() {
    _processingTimer?.cancel();
    _processingTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _processNextCommand();
    });
  }

  /// Process next command from queue
  Future<void> _processNextCommand() async {
    if (_isProcessing || _commandQueue.isEmpty) return;

    _isProcessing = true;

    try {
      final command = _commandQueue.next();
      if (command != null) {
        await _executeCommand(command);
      }
    } catch (e) {
      _addGlobalError('Error processing command: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Execute a single command
  Future<void> _executeCommand(AnimationCommand command) async {
    try {
      switch (command.type) {
        case 'start_animation':
          await _handleStartAnimation(command as StartAnimationCommand);
          break;
        case 'stop_animation':
          await _handleStopAnimation(command as StopAnimationCommand);
          break;
        case 'pause_animation':
          await _handlePauseAnimation(command as PauseAnimationCommand);
          break;
        case 'resume_animation':
          await _handleResumeAnimation(command as ResumeAnimationCommand);
          break;
        case 'reset_animation':
          await _handleResetAnimation(command as ResetAnimationCommand);
          break;
        case 'update_config':
          await _handleUpdateConfig(command as UpdateAnimationConfigCommand);
          break;
        case 'load_text_order':
          await _handleLoadTextOrder(command as LoadTextOrderDataCommand);
          break;
        case 'export_animation':
          await _handleExportAnimation(command as ExportAnimationCommand);
          break;
        case 'batch':
          await _handleBatchCommand(command as BatchCommand);
          break;
        default:
          _addGlobalWarning('Unknown command type: ${command.type}');
      }
    } catch (e) {
      _addGlobalError('Failed to execute command ${command.id}: $e');
    }
  }

  /// Handle start animation command
  Future<void> _handleStartAnimation(StartAnimationCommand command) async {
    final animationId = command.animationId;

    // Check if animation already exists
    if (_animations.containsKey(animationId)) {
      _addGlobalWarning(
        'Animation $animationId already exists, stopping first',
      );
      await _handleStopAnimation(
        StopAnimationCommand(
          id: '${command.id}_stop',
          animationId: animationId,
        ),
      );
    }

    // Create new animation state
    final animationState = AnimationInstanceState.running(
      id: animationId,
      type: 'text_scramble', // Default type, should come from config
      config: command.config,
      startTime: DateTime.now(),
    );

    _animations[animationId] = animationState;
    _addGlobalInfo('Started animation: $animationId');

    notifyListeners();
  }

  /// Handle stop animation command
  Future<void> _handleStopAnimation(StopAnimationCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    final currentState = _animations[animationId]!;
    final stoppedState = currentState.copyWith(
      status: AnimationState.completed,
      endTime: DateTime.now(),
    );

    _animations[animationId] = stoppedState;
    _addGlobalInfo('Stopped animation: $animationId');

    notifyListeners();
  }

  /// Handle pause animation command
  Future<void> _handlePauseAnimation(PauseAnimationCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    final currentState = _animations[animationId]!;
    if (!currentState.isRunning) {
      _addGlobalWarning('Animation $animationId is not running');
      return;
    }

    final pausedState = currentState.copyWith(status: AnimationState.paused);

    _animations[animationId] = pausedState;
    _addGlobalInfo('Paused animation: $animationId');

    notifyListeners();
  }

  /// Handle resume animation command
  Future<void> _handleResumeAnimation(ResumeAnimationCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    final currentState = _animations[animationId]!;
    if (!currentState.isPaused) {
      _addGlobalWarning('Animation $animationId is not paused');
      return;
    }

    final resumedState = currentState.copyWith(status: AnimationState.running);

    _animations[animationId] = resumedState;
    _addGlobalInfo('Resumed animation: $animationId');

    notifyListeners();
  }

  /// Handle reset animation command
  Future<void> _handleResetAnimation(ResetAnimationCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    final currentState = _animations[animationId]!;
    final resetState = currentState.copyWith(
      status: AnimationState.idle,
      progress: 0.0,
      endTime: null,
      duration: null,
      errors: [],
      warnings: [],
    );

    _animations[animationId] = resetState;
    _addGlobalInfo('Reset animation: $animationId');

    notifyListeners();
  }

  /// Handle update config command
  Future<void> _handleUpdateConfig(UpdateAnimationConfigCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    final currentState = _animations[animationId]!;
    final updatedState = currentState.copyWith(config: command.newConfig);

    _animations[animationId] = updatedState;
    _addGlobalInfo('Updated config for animation: $animationId');

    notifyListeners();
  }

  /// Handle load text order command
  Future<void> _handleLoadTextOrder(LoadTextOrderDataCommand command) async {
    try {
      await _textOrderManager.loadFromJson(command.textOrderData);
      _addGlobalInfo('Text order data loaded successfully');
      notifyListeners();
    } catch (e) {
      _addGlobalError('Failed to load text order data: $e');
    }
  }

  /// Handle export animation command
  Future<void> _handleExportAnimation(ExportAnimationCommand command) async {
    final animationId = command.animationId;

    if (!_animations.containsKey(animationId)) {
      _addGlobalWarning('Animation $animationId not found');
      return;
    }

    try {
      // TODO: Implement export logic
      _addGlobalInfo(
        'Exporting animation: $animationId to ${command.exportFormat}',
      );
      notifyListeners();
    } catch (e) {
      _addGlobalError('Failed to export animation $animationId: $e');
    }
  }

  /// Handle batch command
  Future<void> _handleBatchCommand(BatchCommand command) async {
    _addGlobalInfo(
      'Executing batch command with ${command.commands.length} commands',
    );

    for (final cmd in command.commands) {
      await _executeCommand(cmd);
    }

    _addGlobalInfo('Batch command completed');
  }

  /// Add command to queue
  void addCommand(AnimationCommand command) {
    _commandQueue.addCommand(command);
    notifyListeners();
  }

  /// Add command to front of queue
  void addCommandToFront(AnimationCommand command) {
    _commandQueue.addCommandToFront(command);
    notifyListeners();
  }

  /// Add multiple commands
  void addCommands(List<AnimationCommand> commands) {
    _commandQueue.addCommands(commands);
    notifyListeners();
  }

  /// Get animation state by ID
  AnimationInstanceState? getAnimation(String id) {
    return _animations[id];
  }

  /// Check if animation exists
  bool hasAnimation(String id) {
    return _animations.containsKey(id);
  }

  /// Remove animation
  void removeAnimation(String id) {
    if (_animations.remove(id) != null) {
      _addGlobalInfo('Removed animation: $id');
      notifyListeners();
    }
  }

  /// Update global configuration
  void updateGlobalConfig(Map<String, dynamic> config) {
    _globalConfig.addAll(config);
    _addGlobalInfo('Global configuration updated');
    notifyListeners();
  }

  /// Clear global errors
  void clearGlobalErrors() {
    _globalErrors.clear();
    notifyListeners();
  }

  /// Clear global warnings
  void clearGlobalWarnings() {
    _globalWarnings.clear();
    notifyListeners();
  }

  /// Add global error
  void _addGlobalError(String error) {
    _globalErrors.add(error);
    debugPrint('AnimationOrchestrator Error: $error');
  }

  /// Add global warning
  void _addGlobalWarning(String warning) {
    _globalWarnings.add(warning);
    debugPrint('AnimationOrchestrator Warning: $warning');
  }

  /// Add global info
  void _addGlobalInfo(String info) {
    debugPrint('AnimationOrchestrator Info: $info');
  }

  /// Get orchestrator statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalAnimations': totalCount,
      'runningAnimations': runningCount,
      'completedAnimations': completedCount,
      'errorAnimations': errorCount,
      'queueSize': _commandQueue.size,
      'queueHistorySize': _commandQueue.historySize,
      'globalErrors': _globalErrors.length,
      'globalWarnings': _globalWarnings.length,
      'isProcessing': _isProcessing,
      'textOrderDataLoaded': _textOrderManager.hasData,
    };
  }

  /// Get orchestrator summary
  String getSummary() {
    final stats = getStatistics();
    return 'Orchestrator: ${stats['totalAnimations']} animations, ${stats['runningAnimations']} running, Queue: ${stats['queueSize']} commands';
  }

  @override
  String toString() {
    return 'AnimationOrchestrator(animations: $totalCount, queue: ${_commandQueue.size})';
  }
}
