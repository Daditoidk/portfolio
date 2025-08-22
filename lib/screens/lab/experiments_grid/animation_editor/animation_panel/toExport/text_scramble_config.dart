import '../../../../../../core/animations/base/animation_config.dart';

/// Animation modes for text
enum AnimationMode {
  line, // Animate by lines
  block, // Animate by blocks
  random, // Animate in random order
  custom, // Custom order
}

/// Animation directions for text
enum AnimationDirection {
  leftToRight, // LTR
  rightToLeft, // RTL
  topToBottom, // TTB
  bottomToTop, // BTT
  centerOut, // From center outward
  outsideIn, // From outside inward
}

/// Animation timing modes for text
enum AnimationTimingMode {
  simultaneous, // All texts at the same time
  cascade, // One after another
  wave, // Wave effect
  random, // Random timing
  custom, // Custom timing
}

/// Configuration for text scramble animation
class TextScrambleConfig extends AnimationConfig {
  final List<String> textIds;
  final Map<String, dynamic> textOrderData;
  final AnimationMode mode;
  final AnimationDirection direction;
  final AnimationTimingMode timing;
  final double speed;
  final double delay;
  final bool loop;
  final bool reverse;
  final String scrambleCharacters;
  final int scrambleIterations;
  final bool maintainCase;

  const TextScrambleConfig({
    required super.name,
    required super.type,
    required super.properties,
    required this.textIds,
    required this.textOrderData,
    required this.mode,
    required this.direction,
    required this.timing,
    required this.speed,
    required this.delay,
    required this.loop,
    required this.reverse,
    required this.scrambleCharacters,
    required this.scrambleIterations,
    required this.maintainCase,
  });

  /// Get animation sequence based on mode and direction
  List<String> getAnimationSequence() {
    switch (mode) {
      case AnimationMode.line:
        return _getLineSequence();
      case AnimationMode.block:
        return _getBlockSequence();
      case AnimationMode.random:
        return _getRandomSequence();
      case AnimationMode.custom:
        return _getCustomSequence();
    }
  }

  /// Validate text order data
  bool isTextOrderDataValid() {
    return textOrderData.containsKey('sections') &&
        textOrderData.containsKey('lines');
  }

  List<String> _getLineSequence() {
    final lines = textOrderData['lines'] as List<dynamic>? ?? [];
    final sequence = <String>[];

    for (final line in lines) {
      final detectedTexts = line['detectedTexts'] as List<dynamic>? ?? [];
      for (final text in detectedTexts) {
        final textId = text['id'] as String?;
        if (textId != null) {
          sequence.add(textId);
        }
      }
    }

    return sequence;
  }

  List<String> _getBlockSequence() {
    final sections = textOrderData['sections'] as List<dynamic>? ?? [];
    final sequence = <String>[];

    for (final section in sections) {
      final lineIds = section['lineIds'] as List<dynamic>? ?? [];
      for (final lineId in lineIds) {
        final lines = textOrderData['lines'] as List<dynamic>? ?? [];
        for (final line in lines) {
          if (line['id'] == lineId) {
            final detectedTexts = line['detectedTexts'] as List<dynamic>? ?? [];
            for (final text in detectedTexts) {
              final textId = text['id'] as String?;
              if (textId != null) {
                sequence.add(textId);
              }
            }
          }
        }
      }
    }

    return sequence;
  }

  List<String> _getRandomSequence() {
    final sequence = _getLineSequence();
    sequence.shuffle();
    return sequence;
  }

  List<String> _getCustomSequence() {
    final customOrder = properties['customOrder'] as List<dynamic>? ?? [];
    return customOrder.map((e) => e.toString()).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'properties': properties,
      'textIds': textIds,
      'textOrderData': textOrderData,
      'mode': mode.name,
      'direction': direction.name,
      'timing': timing.name,
      'speed': speed,
      'delay': delay,
      'loop': loop,
      'reverse': reverse,
      'scrambleCharacters': scrambleCharacters,
      'scrambleIterations': scrambleIterations,
      'maintainCase': maintainCase,
    };
  }

  @override
  bool isValid() {
    return name.isNotEmpty &&
        type.isNotEmpty &&
        textIds.isNotEmpty &&
        isTextOrderDataValid();
  }

  @override
  Map<String, dynamic> getDefaultProperties() {
    return {
      'speed': 1.0,
      'delay': 0.1,
      'loop': false,
      'reverse': false,
      'scrambleCharacters': r'!@#$%^&*()',
      'scrambleIterations': 10,
      'maintainCase': true,
    };
  }

  /// Create configuration from JSON
  factory TextScrambleConfig.fromJson(Map<String, dynamic> json) {
    return TextScrambleConfig(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      properties: json['properties'] ?? {},
      textIds: List<String>.from(json['textIds'] ?? []),
      textOrderData: json['textOrderData'] ?? {},
      mode: _parseAnimationMode(json['mode']),
      direction: _parseAnimationDirection(json['direction']),
      timing: _parseAnimationTiming(json['timing']),
      speed: json['speed']?.toDouble() ?? 1.0,
      delay: json['delay']?.toDouble() ?? 0.1,
      loop: json['loop'] ?? false,
      reverse: json['reverse'] ?? false,
      scrambleCharacters: json['scrambleCharacters'] ?? r'!@#$%^&*()',
      scrambleIterations: json['scrambleIterations'] ?? 10,
      maintainCase: json['maintainCase'] ?? true,
    );
  }

  static AnimationMode _parseAnimationMode(String? modeString) {
    switch (modeString) {
      case 'line':
        return AnimationMode.line;
      case 'block':
        return AnimationMode.block;
      case 'random':
        return AnimationMode.random;
      case 'custom':
        return AnimationMode.custom;
      default:
        return AnimationMode.line;
    }
  }

  static AnimationDirection _parseAnimationDirection(String? directionString) {
    switch (directionString) {
      case 'leftToRight':
        return AnimationDirection.leftToRight;
      case 'rightToLeft':
        return AnimationDirection.rightToLeft;
      case 'topToBottom':
        return AnimationDirection.topToBottom;
      case 'bottomToTop':
        return AnimationDirection.bottomToTop;
      case 'centerOut':
        return AnimationDirection.centerOut;
      case 'outsideIn':
        return AnimationDirection.outsideIn;
      default:
        return AnimationDirection.leftToRight;
    }
  }

  static AnimationTimingMode _parseAnimationTiming(String? timingString) {
    switch (timingString) {
      case 'simultaneous':
        return AnimationTimingMode.simultaneous;
      case 'cascade':
        return AnimationTimingMode.cascade;
      case 'wave':
        return AnimationTimingMode.wave;
      case 'random':
        return AnimationTimingMode.random;
      case 'custom':
        return AnimationTimingMode.custom;
      default:
        return AnimationTimingMode.simultaneous;
    }
  }
}
