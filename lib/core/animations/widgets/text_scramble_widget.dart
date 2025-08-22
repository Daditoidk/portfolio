import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../screens/lab/experiments_grid/animation_editor/animation_panel/toExport/text_scramble_config.dart';
import '../text_order/text_order_data.dart';
import 'animated_text_widget.dart';

/// Widget for text scramble animation
class TextScrambleWidget extends AnimatedTextWidget {
  /// Text scramble specific configuration
  final TextScrambleConfig scrambleConfig;

  const TextScrambleWidget({
    super.key,
    required super.animationId,
    required super.text,
    required this.scrambleConfig,
    super.textOrderData,
    super.style,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.autoStart,
    super.onAnimationStart,
    super.onAnimationComplete,
    super.onAnimationError,
    super.onProgressUpdate,
  }) : super(config: scrambleConfig);

  @override
  ConsumerState<TextScrambleWidget> createState() => _TextScrambleWidgetState();
}

class _TextScrambleWidgetState
    extends AnimatedTextWidgetState<TextScrambleWidget>
    with AnimationListener<TextScrambleWidget> {
  /// Current scrambled text
  String _currentScrambledText = '';

  /// Original text characters
  List<String> _originalChars = [];

  /// Random generator for scramble characters
  final math.Random _random = math.Random();

  /// Animation sequences based on text order data
  final List<List<String>> _animationSequences = [];

  /// Scramble characters to use
  late String _scrambleChars;

  /// Number of scramble iterations per character
  late int _scrambleIterations;

  /// Whether to maintain character case
  late bool _maintainCase;

  @override
  void initializeAnimationSpecific() {
    super.initializeAnimationSpecific();

    // Initialize scramble configuration
    _scrambleChars = widget.scrambleConfig.scrambleCharacters;
    _scrambleIterations = widget.scrambleConfig.scrambleIterations;
    _maintainCase = widget.scrambleConfig.maintainCase;

    // Initialize text data
    _initializeTextData();

    // Setup animation sequences
    _setupAnimationSequences();

    // Initialize scrambled text
    _updateScrambledText();
  }

  /// Initialize text data
  void _initializeTextData() {
    _originalChars = widget.text.split('');
    _currentScrambledText = widget.text;
  }

  /// Setup animation sequences based on configuration
  void _setupAnimationSequences() {
    _animationSequences.clear();

    if (widget.textOrderData != null) {
      // Use text order data to create sequences
      _setupSequencesFromTextOrderData();
    } else {
      // Use default sequence based on animation mode
      _setupDefaultSequences();
    }
  }

  /// Setup sequences from text order data
  void _setupSequencesFromTextOrderData() {
    final textOrderData = widget.textOrderData!;

    switch (widget.scrambleConfig.mode) {
      case AnimationMode.line:
        _setupLineSequences(textOrderData);
        break;
      case AnimationMode.block:
        _setupBlockSequences(textOrderData);
        break;
      case AnimationMode.random:
        _setupCharacterSequences(textOrderData);
        break;
      case AnimationMode.custom:
        _setupCustomSequences(textOrderData);
        break;
    }
  }

  /// Setup line-based sequences
  void _setupLineSequences(TextOrderData textOrderData) {
    for (final section in textOrderData.sections) {
      for (final line in section.lines) {
        final lineTextIds = line.textIds;
        _animationSequences.add(lineTextIds);
      }
    }
  }

  /// Setup block-based sequences
  void _setupBlockSequences(TextOrderData textOrderData) {
    for (final section in textOrderData.sections) {
      final sectionTextIds = section.allTextIds;
      _animationSequences.add(sectionTextIds);
    }
  }

  /// Setup character-based sequences
  void _setupCharacterSequences(TextOrderData textOrderData) {
    final allTextIds = textOrderData.allTextIds;
    for (final textId in allTextIds) {
      _animationSequences.add([textId]);
    }
  }

  /// Setup custom sequences
  void _setupCustomSequences(TextOrderData textOrderData) {
    // Use the animation sequence from config if available
    final customSequence = widget.scrambleConfig.getAnimationSequence();
    if (customSequence.isNotEmpty) {
      _animationSequences.add(customSequence);
    } else {
      // Fallback to character mode
      _setupCharacterSequences(textOrderData);
    }
  }

  /// Setup default sequences when no text order data is available
  void _setupDefaultSequences() {
    switch (widget.scrambleConfig.mode) {
      case AnimationMode.line:
        // Treat entire text as one line
        final charIndices = List.generate(
          _originalChars.length,
          (index) => index.toString(),
        );
        _animationSequences.add(charIndices);
        break;
      case AnimationMode.random:
        // Each character is its own sequence
        for (int i = 0; i < _originalChars.length; i++) {
          _animationSequences.add([i.toString()]);
        }
        break;
      case AnimationMode.custom:
        // Group by words
        final words = widget.text.split(' ');
        int charIndex = 0;
        for (final word in words) {
          final wordIndices = <String>[];
          for (int i = 0; i < word.length; i++) {
            wordIndices.add(charIndex.toString());
            charIndex++;
          }
          if (word != words.last) {
            charIndex++; // Skip space
          }
          _animationSequences.add(wordIndices);
        }
        break;
      default:
        // Default to character mode
        for (int i = 0; i < _originalChars.length; i++) {
          _animationSequences.add([i.toString()]);
        }
    }
  }

  // Animation update is handled by the base class and AnimatedBuilder

  /// Update scrambled text based on current animation progress
  void _updateScrambledText() {
    final progress = animationController.value;
    final chars = List<String>.from(_originalChars);

    // Calculate which sequences should be active
    final totalSequences = _animationSequences.length;
    if (totalSequences == 0) {
      _currentScrambledText = widget.text;
      return;
    }

    switch (widget.scrambleConfig.timing) {
      case AnimationTimingMode.simultaneous:
        _updateSimultaneousScramble(chars, progress);
        break;
      case AnimationTimingMode.cascade:
        _updateSequentialScramble(chars, progress);
        break;
      case AnimationTimingMode.wave:
        _updateStaggeredScramble(chars, progress);
        break;
      case AnimationTimingMode.random:
        _updateSimultaneousScramble(chars, progress);
        break;
      case AnimationTimingMode.custom:
        _updateSimultaneousScramble(chars, progress);
        break;
    }

    _currentScrambledText = chars.join('');
  }

  /// Update scramble with simultaneous timing
  void _updateSimultaneousScramble(List<String> chars, double progress) {
    for (int i = 0; i < chars.length; i++) {
      if (_shouldScrambleChar(i, progress)) {
        chars[i] = _getScrambledChar(_originalChars[i]);
      }
    }
  }

  /// Update scramble with sequential timing
  void _updateSequentialScramble(List<String> chars, double progress) {
    final totalSequences = _animationSequences.length;
    final sequenceProgress = progress * totalSequences;
    final currentSequence = sequenceProgress.floor().clamp(
      0,
      totalSequences - 1,
    );
    final sequenceLocalProgress = sequenceProgress - currentSequence;

    // Scramble current sequence
    if (currentSequence < _animationSequences.length) {
      final sequence = _animationSequences[currentSequence];
      for (final textId in sequence) {
        final charIndex = int.tryParse(textId) ?? 0;
        if (charIndex < chars.length) {
          if (_shouldScrambleChar(charIndex, sequenceLocalProgress)) {
            chars[charIndex] = _getScrambledChar(_originalChars[charIndex]);
          }
        }
      }
    }
  }

  /// Update scramble with staggered timing
  void _updateStaggeredScramble(List<String> chars, double progress) {
    final staggerDelay = 0.1; // 10% stagger between sequences

    for (int seqIndex = 0; seqIndex < _animationSequences.length; seqIndex++) {
      final sequence = _animationSequences[seqIndex];
      final sequenceStartProgress = seqIndex * staggerDelay;
      final sequenceEndProgress =
          sequenceStartProgress + (1.0 - (seqIndex * staggerDelay));

      if (progress >= sequenceStartProgress &&
          progress <= sequenceEndProgress) {
        final localProgress =
            (progress - sequenceStartProgress) /
            (sequenceEndProgress - sequenceStartProgress);

        for (final textId in sequence) {
          final charIndex = int.tryParse(textId) ?? 0;
          if (charIndex < chars.length) {
            if (_shouldScrambleChar(charIndex, localProgress)) {
              chars[charIndex] = _getScrambledChar(_originalChars[charIndex]);
            }
          }
        }
      }
    }
  }

  /// Determine if a character should be scrambled at current progress
  bool _shouldScrambleChar(int charIndex, double progress) {
    if (progress >= 1.0) return false; // Animation complete

    final phase = (progress * _scrambleIterations).floor();
    final shouldScramble = phase < _scrambleIterations && phase % 2 == 0;

    return shouldScramble;
  }

  /// Get a scrambled character
  String _getScrambledChar(String originalChar) {
    if (originalChar.trim().isEmpty) return originalChar; // Keep spaces

    String scrambledChar =
        _scrambleChars[_random.nextInt(_scrambleChars.length)];

    if (_maintainCase && originalChar.isNotEmpty) {
      if (originalChar == originalChar.toUpperCase()) {
        scrambledChar = scrambledChar.toUpperCase();
      } else {
        scrambledChar = scrambledChar.toLowerCase();
      }
    }

    return scrambledChar;
  }

  @override
  Widget buildAnimatedWidget(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Text(
          _currentScrambledText,
          style: getCurrentTextStyle(context),
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      },
    );
  }

  @override
  String getCurrentText() {
    return _currentScrambledText;
  }

  /// Get scramble-specific animation value
  double getScrambleValue(String property, {double defaultValue = 0.0}) {
    return getAnimationValue(property, defaultValue: defaultValue);
  }

  /// Get current scramble iteration
  int getCurrentScrambleIteration() {
    return (progress * _scrambleIterations).floor();
  }

  /// Get scramble completion ratio
  double getScrambleCompletionRatio() {
    if (_scrambleIterations == 0) return 1.0;
    return getCurrentScrambleIteration() / _scrambleIterations;
  }

  /// Check if character is currently being scrambled
  bool isCharacterScrambled(int index) {
    if (index >= _originalChars.length) return false;
    return _shouldScrambleChar(index, progress);
  }

  /// Get the number of characters currently being scrambled
  int getScrambledCharacterCount() {
    int count = 0;
    for (int i = 0; i < _originalChars.length; i++) {
      if (isCharacterScrambled(i)) count++;
    }
    return count;
  }

  /// Get animation statistics
  Map<String, dynamic> getAnimationStats() {
    return {
      'progress': progress,
      'currentIteration': getCurrentScrambleIteration(),
      'totalIterations': _scrambleIterations,
      'scrambledCharCount': getScrambledCharacterCount(),
      'totalCharCount': _originalChars.length,
      'completionRatio': getScrambleCompletionRatio(),
      'currentSequence': 0, // TODO: Implement sequence tracking
      'totalSequences': _animationSequences.length,
      'isAnimating': isAnimating,
    };
  }
}
