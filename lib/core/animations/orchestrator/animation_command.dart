/// Base class for all animation commands
abstract class AnimationCommand {
  final String id;
  final String type;
  final DateTime timestamp;
  final Map<String, dynamic> parameters;

  const AnimationCommand({
    required this.id,
    required this.type,
    required this.timestamp,
    this.parameters = const {},
  });

  /// Execute the command
  Future<void> execute();

  /// Check if command can be executed
  bool canExecute();

  /// Get command description
  String get description;

  /// Get command priority (lower = higher priority)
  int get priority => 0;

  /// Check if command is reversible
  bool get isReversible => false;

  /// Create reverse command if possible
  AnimationCommand? get reverseCommand => null;

  @override
  String toString() {
    return 'AnimationCommand(id: $id, type: $type, timestamp: $timestamp)';
  }
}

/// Command to start an animation
class StartAnimationCommand extends AnimationCommand {
  final String animationId;
  final Map<String, dynamic> config;

  StartAnimationCommand({
    required super.id,
    required this.animationId,
    required this.config,
    super.parameters,
  }) : super(type: 'start_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Start animation: $animationId';

  @override
  bool get isReversible => true;

  @override
  AnimationCommand? get reverseCommand =>
      StopAnimationCommand(id: '${id}_reverse', animationId: animationId);
}

/// Command to stop an animation
class StopAnimationCommand extends AnimationCommand {
  final String animationId;

  StopAnimationCommand({
    required super.id,
    required this.animationId,
    super.parameters,
  }) : super(type: 'stop_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Stop animation: $animationId';

  @override
  bool get isReversible => true;

  @override
  AnimationCommand? get reverseCommand => StartAnimationCommand(
    id: '${id}_reverse',
    animationId: animationId,
    config: parameters['originalConfig'] ?? {},
  );
}

/// Command to pause an animation
class PauseAnimationCommand extends AnimationCommand {
  final String animationId;

  PauseAnimationCommand({
    required super.id,
    required this.animationId,
    super.parameters,
  }) : super(type: 'pause_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Pause animation: $animationId';

  @override
  bool get isReversible => true;

  @override
  AnimationCommand? get reverseCommand =>
      ResumeAnimationCommand(id: '${id}_reverse', animationId: animationId);
}

/// Command to resume an animation
class ResumeAnimationCommand extends AnimationCommand {
  final String animationId;

  ResumeAnimationCommand({
    required super.id,
    required this.animationId,
    super.parameters,
  }) : super(type: 'resume_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Resume animation: $animationId';

  @override
  bool get isReversible => true;

  @override
  AnimationCommand? get reverseCommand =>
      PauseAnimationCommand(id: '${id}_reverse', animationId: animationId);
}

/// Command to reset an animation
class ResetAnimationCommand extends AnimationCommand {
  final String animationId;

  ResetAnimationCommand({
    required super.id,
    required this.animationId,
    super.parameters,
  }) : super(type: 'reset_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Reset animation: $animationId';

  @override
  bool get isReversible => false;
}

/// Command to update animation configuration
class UpdateAnimationConfigCommand extends AnimationCommand {
  final String animationId;
  final Map<String, dynamic> newConfig;
  final Map<String, dynamic>? previousConfig;

  UpdateAnimationConfigCommand({
    required super.id,
    required this.animationId,
    required this.newConfig,
    this.previousConfig,
    super.parameters,
  }) : super(type: 'update_config', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Update config for animation: $animationId';

  @override
  bool get isReversible => previousConfig != null;

  @override
  AnimationCommand? get reverseCommand => previousConfig != null
      ? UpdateAnimationConfigCommand(
          id: '${id}_reverse',
          animationId: animationId,
          newConfig: previousConfig!,
          previousConfig: newConfig,
        )
      : null;
}

/// Command to load text order data
class LoadTextOrderDataCommand extends AnimationCommand {
  final Map<String, dynamic> textOrderData;

  LoadTextOrderDataCommand({
    required super.id,
    required this.textOrderData,
    super.parameters,
  }) : super(type: 'load_text_order', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Load text order data';

  @override
  bool get isReversible => false;
}

/// Command to export animation
class ExportAnimationCommand extends AnimationCommand {
  final String animationId;
  final String exportFormat;
  final String? exportPath;

  ExportAnimationCommand({
    required super.id,
    required this.animationId,
    required this.exportFormat,
    this.exportPath,
    super.parameters,
  }) : super(type: 'export_animation', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => true;

  @override
  String get description => 'Export animation: $animationId to $exportFormat';

  @override
  bool get isReversible => false;
}

/// Command to batch multiple commands
class BatchCommand extends AnimationCommand {
  final List<AnimationCommand> commands;

  BatchCommand({required super.id, required this.commands, super.parameters})
    : super(type: 'batch', timestamp: DateTime.now());

  @override
  Future<void> execute() async {
    // Implementation will be handled by the orchestrator
  }

  @override
  bool canExecute() => commands.isNotEmpty;

  @override
  String get description => 'Execute ${commands.length} commands in batch';

  @override
  int get priority => commands.fold<int>(
    0,
    (min, cmd) => cmd.priority < min ? cmd.priority : min,
  );

  @override
  bool get isReversible => commands.every((cmd) => cmd.isReversible);

  @override
  AnimationCommand? get reverseCommand {
    if (!isReversible) return null;

    final reverseCommands = commands
        .map((cmd) => cmd.reverseCommand)
        .where((cmd) => cmd != null)
        .cast<AnimationCommand>()
        .toList();

    if (reverseCommands.isEmpty) return null;

    return BatchCommand(
      id: '${id}_reverse',
      commands: reverseCommands.reversed.toList(),
    );
  }
}
