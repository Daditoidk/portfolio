import 'animation_command.dart';

/// Queue for managing animation commands
class AnimationQueue {
  final List<AnimationCommand> _commands;
  final List<AnimationCommand> _history;
  final int _maxHistorySize;

  AnimationQueue({int maxHistorySize = 100})
      : _commands = [],
        _history = [],
        _maxHistorySize = maxHistorySize;

  /// Get all commands in queue
  List<AnimationCommand> get commands => List.unmodifiable(_commands);

  /// Get command history
  List<AnimationCommand> get history => List.unmodifiable(_history);

  /// Get queue size
  int get size => _commands.length;

  /// Get history size
  int get historySize => _history.length;

  /// Check if queue is empty
  bool get isEmpty => _commands.isEmpty;

  /// Check if queue is not empty
  bool get isNotEmpty => _commands.isNotEmpty;

  /// Check if can undo
  bool get canUndo => _history.isNotEmpty;

  /// Check if can redo
  bool get canRedo => _commands.isNotEmpty;

  /// Add command to queue
  void addCommand(AnimationCommand command) {
    _commands.add(command);
    _addToHistory(command);
  }

  /// Add command to front of queue (high priority)
  void addCommandToFront(AnimationCommand command) {
    _commands.insert(0, command);
    _addToHistory(command);
  }

  /// Add multiple commands to queue
  void addCommands(List<AnimationCommand> commands) {
    _commands.addAll(commands);
    for (final command in commands) {
      _addToHistory(command);
    }
  }

  /// Get next command without removing it
  AnimationCommand? peek() {
    if (_commands.isEmpty) return null;
    return _commands.first;
  }

  /// Get and remove next command
  AnimationCommand? next() {
    if (_commands.isEmpty) return null;
    return _commands.removeAt(0);
  }

  /// Get next command by type
  AnimationCommand? nextByType(String type) {
    final index = _commands.indexWhere((cmd) => cmd.type == type);
    if (index == -1) return null;
    return _commands.removeAt(index);
  }

  /// Get next command by priority
  AnimationCommand? nextByPriority() {
    if (_commands.isEmpty) return null;
    
    // Find command with highest priority (lowest number)
    int highestPriorityIndex = 0;
    int highestPriority = _commands[0].priority;
    
    for (int i = 1; i < _commands.length; i++) {
      if (_commands[i].priority < highestPriority) {
        highestPriority = _commands[i].priority;
        highestPriorityIndex = i;
      }
    }
    
    return _commands.removeAt(highestPriorityIndex);
  }

  /// Remove command by ID
  bool removeCommand(String commandId) {
    final index = _commands.indexWhere((cmd) => cmd.id == commandId);
    if (index == -1) return false;
    _commands.removeAt(index);
    return true;
  }

  /// Remove commands by type
  int removeCommandsByType(String type) {
    int removedCount = 0;
    _commands.removeWhere((cmd) {
      if (cmd.type == type) {
        removedCount++;
        return true;
      }
      return false;
    });
    return removedCount;
  }

  /// Clear all commands
  void clear() {
    _commands.clear();
  }

  /// Clear history
  void clearHistory() {
    _history.clear();
  }

  /// Undo last command (move from history back to queue)
  bool undo() {
    if (_history.isEmpty) return false;
    
    final lastCommand = _history.removeLast();
    _commands.add(lastCommand);
    return true;
  }

  /// Redo command (move from queue back to history)
  bool redo() {
    if (_commands.isEmpty) return false;
    
    final command = _commands.removeLast();
    _history.add(command);
    return true;
  }

  /// Get commands by type
  List<AnimationCommand> getCommandsByType(String type) {
    return _commands.where((cmd) => cmd.type == type).toList();
  }

  /// Get commands by priority
  List<AnimationCommand> getCommandsByPriority(int priority) {
    return _commands.where((cmd) => cmd.priority == priority).toList();
  }

  /// Check if command exists by ID
  bool hasCommand(String commandId) {
    return _commands.any((cmd) => cmd.id == commandId);
  }

  /// Check if command exists by type
  bool hasCommandType(String type) {
    return _commands.any((cmd) => cmd.type == type);
  }

  /// Get command by ID
  AnimationCommand? getCommand(String commandId) {
    try {
      return _commands.firstWhere((cmd) => cmd.id == commandId);
    } catch (e) {
      return null;
    }
  }

  /// Get command index by ID
  int getCommandIndex(String commandId) {
    return _commands.indexWhere((cmd) => cmd.id == commandId);
  }

  /// Move command to different position
  bool moveCommand(String commandId, int newIndex) {
    final currentIndex = getCommandIndex(commandId);
    if (currentIndex == -1 || newIndex < 0 || newIndex >= _commands.length) {
      return false;
    }
    
    final command = _commands.removeAt(currentIndex);
    _commands.insert(newIndex, command);
    return true;
  }

  /// Move command to front
  bool moveToFront(String commandId) {
    return moveCommand(commandId, 0);
  }

  /// Move command to back
  bool moveToBack(String commandId) {
    return moveCommand(commandId, _commands.length - 1);
  }

  /// Get queue statistics
  Map<String, dynamic> getStatistics() {
    final typeCounts = <String, int>{};
    final priorityCounts = <int, int>{};
    
    for (final command in _commands) {
      typeCounts[command.type] = (typeCounts[command.type] ?? 0) + 1;
      priorityCounts[command.priority] = (priorityCounts[command.priority] ?? 0) + 1;
    }
    
    return {
      'totalCommands': _commands.length,
      'totalHistory': _history.length,
      'typeCounts': typeCounts,
      'priorityCounts': priorityCounts,
      'canUndo': canUndo,
      'canRedo': canRedo,
    };
  }

  /// Filter commands by condition
  List<AnimationCommand> filterCommands(bool Function(AnimationCommand) condition) {
    return _commands.where(condition).toList();
  }

  /// Sort commands by priority
  void sortByPriority() {
    _commands.sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// Sort commands by timestamp
  void sortByTimestamp() {
    _commands.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Sort commands by type
  void sortByType() {
    _commands.sort((a, b) => a.type.compareTo(b.type));
  }

  /// Get commands as batch
  List<AnimationCommand> getBatch(int count) {
    if (count <= 0) return [];
    if (count >= _commands.length) return List.from(_commands);
    
    final batch = <AnimationCommand>[];
    for (int i = 0; i < count; i++) {
      batch.add(_commands[i]);
    }
    return batch;
  }

  /// Process batch of commands
  List<AnimationCommand> processBatch(int count) {
    final batch = getBatch(count);
    for (final command in batch) {
      _commands.remove(command);
    }
    return batch;
  }

  /// Add to history
  void _addToHistory(AnimationCommand command) {
    _history.add(command);
    
    // Keep history size manageable
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
  }

  /// Get queue summary
  String getSummary() {
    final stats = getStatistics();
    return 'Queue: ${stats['totalCommands']} commands, History: ${stats['totalHistory']} commands';
  }

  @override
  String toString() {
    return 'AnimationQueue(size: $size, history: $historySize)';
  }
}
