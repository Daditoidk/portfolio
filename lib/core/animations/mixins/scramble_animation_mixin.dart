import 'dart:math' as math;

import '../text/text_scramble_config.dart';
import '../text_order/text_order_data.dart';
import '../widgets/animated_text_widget.dart';

/// Mixin that provides scramble animation functionality
mixin ScrambleAnimationMixin<T extends AnimatedTextWidget>
    on AnimatedTextWidgetState<T> {
  /// Random generator for scramble characters
  static final math.Random _random = math.Random();

  /// Cache for scrambled characters to avoid regeneration
  final Map<String, String> _scrambleCache = {};

  /// Current scramble iteration for each character
  final Map<int, int> _charIterations = {};

  /// Scramble configuration
  TextScrambleConfig get scrambleConfig {
    if (widget.config is TextScrambleConfig) {
      return widget.config as TextScrambleConfig;
    }
    throw StateError('ScrambleAnimationMixin requires TextScrambleConfig');
  }

  /// Get scramble characters to use
  String get scrambleCharacters => scrambleConfig.scrambleCharacters;

  /// Get number of scramble iterations
  int get scrambleIterations => scrambleConfig.scrambleIterations;

  /// Whether to maintain character case
  bool get maintainCase => scrambleConfig.maintainCase;

  /// Animation mode
  AnimationMode get animationMode => scrambleConfig.mode;

  /// Animation timing mode
  AnimationTimingMode get timingMode => scrambleConfig.timing;

  /// Animation direction
  AnimationDirection get direction => scrambleConfig.direction;

  /// Generate a scrambled version of the input text
  String generateScrambledText(String originalText, double progress) {
    if (originalText.isEmpty) return originalText;

    final chars = originalText.split('');
    final scrambledChars = <String>[];

    for (int i = 0; i < chars.length; i++) {
      final char = chars[i];

      if (_shouldScrambleCharacter(i, progress, chars.length)) {
        scrambledChars.add(_getScrambledCharacter(char, i));
      } else {
        scrambledChars.add(char);
      }
    }

    return scrambledChars.join('');
  }

  /// Determine if a character should be scrambled at the current progress
  bool _shouldScrambleCharacter(int index, double progress, int totalLength) {
    switch (timingMode) {
      case AnimationTimingMode.simultaneous:
        return _shouldScrambleSimultaneous(index, progress);
      case AnimationTimingMode.cascade:
        return _shouldScrambleSequential(index, progress, totalLength);
      case AnimationTimingMode.wave:
        return _shouldScrambleStaggered(index, progress, totalLength);
      case AnimationTimingMode.random:
        return _shouldScrambleSimultaneous(index, progress);
      case AnimationTimingMode.custom:
        return _shouldScrambleSimultaneous(index, progress);
    }
  }

  /// Check scramble for simultaneous timing
  bool _shouldScrambleSimultaneous(int index, double progress) {
    final iteration = (progress * scrambleIterations).floor();
    _charIterations[index] = iteration;

    // Character is scrambled if we haven't reached the final iteration
    // and we're in an "active" iteration (even numbers scramble, odd numbers show original)
    return iteration < scrambleIterations && iteration % 2 == 0;
  }

  /// Check scramble for sequential timing
  bool _shouldScrambleSequential(int index, double progress, int totalLength) {
    final adjustedIndex = direction == AnimationDirection.rightToLeft
        ? totalLength - 1 - index
        : index;

    final charProgress = (progress * totalLength) - adjustedIndex;
    final charIteration = (charProgress * scrambleIterations).floor();

    _charIterations[index] = charIteration;

    return charIteration >= 0 &&
        charIteration < scrambleIterations &&
        charIteration % 2 == 0;
  }

  /// Check scramble for staggered timing
  bool _shouldScrambleStaggered(int index, double progress, int totalLength) {
    final staggerDelay = 0.1; // 10% delay between characters
    final adjustedIndex = direction == AnimationDirection.rightToLeft
        ? totalLength - 1 - index
        : index;

    final charStartProgress = adjustedIndex * staggerDelay / totalLength;
    final charProgress = math.max(0.0, progress - charStartProgress);
    final normalizedProgress = charProgress / (1.0 - charStartProgress);

    final charIteration = (normalizedProgress * scrambleIterations).floor();
    _charIterations[index] = charIteration;

    return charProgress > 0 &&
        charIteration < scrambleIterations &&
        charIteration % 2 == 0;
  }

  /// Get a scrambled character for the given original character
  String _getScrambledCharacter(String originalChar, int index) {
    // Don't scramble whitespace
    if (originalChar.trim().isEmpty) {
      return originalChar;
    }

    // Use cache key based on character and iteration
    final iteration = _charIterations[index] ?? 0;
    final cacheKey = '${originalChar}_${index}_$iteration';

    if (_scrambleCache.containsKey(cacheKey)) {
      return _scrambleCache[cacheKey]!;
    }

    // Generate new scrambled character
    String scrambledChar =
        scrambleCharacters[_random.nextInt(scrambleCharacters.length)];

    // Maintain case if required
    if (maintainCase && originalChar.isNotEmpty) {
      if (originalChar == originalChar.toUpperCase()) {
        scrambledChar = scrambledChar.toUpperCase();
      } else {
        scrambledChar = scrambledChar.toLowerCase();
      }
    }

    // Cache the result
    _scrambleCache[cacheKey] = scrambledChar;

    return scrambledChar;
  }

  /// Generate scrambled text based on text order data
  String generateScrambledTextFromOrder(
    String originalText,
    double progress,
    TextOrderData textOrderData,
  ) {
    if (textOrderData.sections.isEmpty) {
      return generateScrambledText(originalText, progress);
    }

    final chars = originalText.split('');
    final scrambledChars = List<String>.from(chars);

    // Get animation sequence based on mode
    final sequences = _getAnimationSequences(textOrderData);

    for (int seqIndex = 0; seqIndex < sequences.length; seqIndex++) {
      final sequence = sequences[seqIndex];
      final sequenceProgress = _getSequenceProgress(
        seqIndex,
        sequences.length,
        progress,
      );

      for (final textId in sequence) {
        final charIndex = _getCharacterIndexFromTextId(
          textId,
          originalText,
          textOrderData,
        );

        if (charIndex >= 0 && charIndex < chars.length) {
          if (_shouldScrambleCharacter(
            charIndex,
            sequenceProgress,
            chars.length,
          )) {
            scrambledChars[charIndex] = _getScrambledCharacter(
              chars[charIndex],
              charIndex,
            );
          }
        }
      }
    }

    return scrambledChars.join('');
  }

  /// Get animation sequences based on mode
  List<List<String>> _getAnimationSequences(TextOrderData textOrderData) {
    switch (animationMode) {
      case AnimationMode.line:
        return textOrderData.sections
            .expand((section) => section.lines)
            .map((line) => line.textIds)
            .toList();

      case AnimationMode.block:
        return textOrderData.sections
            .map((section) => section.allTextIds)
            .toList();

      case AnimationMode.random:
        return textOrderData.allTextIds.map((textId) => [textId]).toList();

      case AnimationMode.custom:
        // Use custom sequence from config
        final customSequence = scrambleConfig.getAnimationSequence();
        return customSequence.isNotEmpty ? [customSequence] : [];
    }
  }

  /// Get progress for a specific sequence
  double _getSequenceProgress(
    int sequenceIndex,
    int totalSequences,
    double overallProgress,
  ) {
    switch (timingMode) {
      case AnimationTimingMode.simultaneous:
        return overallProgress;

      case AnimationTimingMode.cascade:
        final sequenceProgress =
            (overallProgress * totalSequences) - sequenceIndex;
        return sequenceProgress.clamp(0.0, 1.0);

      case AnimationTimingMode.wave:
        final staggerDelay = 0.1;
        final sequenceStartProgress =
            sequenceIndex * staggerDelay / totalSequences;
        final adjustedProgress = math.max(
          0.0,
          overallProgress - sequenceStartProgress,
        );
        final normalizedProgress =
            adjustedProgress / (1.0 - sequenceStartProgress);
        return normalizedProgress.clamp(0.0, 1.0);

      case AnimationTimingMode.random:
        return overallProgress;

      case AnimationTimingMode.custom:
        return overallProgress;
    }
  }

  /// Get character index from text ID
  int _getCharacterIndexFromTextId(
    String textId,
    String originalText,
    TextOrderData textOrderData,
  ) {
    // This is a simplified mapping
    // In a real implementation, you'd have a proper mapping between text IDs and character positions
    final textElement = textOrderData.getTextElementById(textId);
    if (textElement == null) return -1;

    // Find the text element's position in the original text
    final elementText = textElement.text;
    final index = originalText.indexOf(elementText);

    return index;
  }

  /// Clear scramble cache
  void clearScrambleCache() {
    _scrambleCache.clear();
    _charIterations.clear();
  }

  /// Get scramble statistics
  Map<String, dynamic> getScrambleStats(String originalText, double progress) {
    final totalChars = originalText.length;
    int scrambledCount = 0;
    int revealedCount = 0;

    for (int i = 0; i < totalChars; i++) {
      if (_shouldScrambleCharacter(i, progress, totalChars)) {
        scrambledCount++;
      } else {
        revealedCount++;
      }
    }

    return {
      'totalCharacters': totalChars,
      'scrambledCharacters': scrambledCount,
      'revealedCharacters': revealedCount,
      'scrambleRatio': totalChars > 0 ? scrambledCount / totalChars : 0.0,
      'revealRatio': totalChars > 0 ? revealedCount / totalChars : 0.0,
      'currentIteration': (progress * scrambleIterations).floor(),
      'totalIterations': scrambleIterations,
      'cacheSize': _scrambleCache.length,
    };
  }

  /// Create a custom scramble effect
  String createCustomScrambleEffect(
    String originalText,
    double progress, {
    String? customScrambleChars,
    int? customIterations,
    bool? customMaintainCase,
  }) {
    // TODO: Implement custom scramble effect with parameter overrides
    final result = generateScrambledText(originalText, progress);
    return result;
  }

  /// Animate text reveal with scramble effect
  String animateTextReveal(
    String originalText,
    double progress, {
    bool revealFromLeft = true,
    double scrambleIntensity = 1.0,
  }) {
    final chars = originalText.split('');
    final result = <String>[];

    for (int i = 0; i < chars.length; i++) {
      final charProgress = revealFromLeft
          ? (progress * chars.length) - i
          : (progress * chars.length) - (chars.length - 1 - i);

      if (charProgress >= 1.0) {
        // Character is fully revealed
        result.add(chars[i]);
      } else if (charProgress > 0.0) {
        // Character is in scramble phase
        final scrambleProgress = charProgress * scrambleIntensity;
        if (_shouldScrambleCharacter(i, scrambleProgress, chars.length)) {
          result.add(_getScrambledCharacter(chars[i], i));
        } else {
          result.add(chars[i]);
        }
      } else {
        // Character hasn't started animating yet
        result.add(' '); // or keep original character
      }
    }

    return result.join('');
  }

  /// Create typewriter effect with scramble
  String createTypewriterScrambleEffect(
    String originalText,
    double progress, {
    double scrambleDuration =
        0.3, // 30% of time spent scrambling each character
  }) {
    final chars = originalText.split('');
    final result = <String>[];

    for (int i = 0; i < chars.length; i++) {
      final charStartProgress = i / chars.length;
      final charEndProgress = (i + 1) / chars.length;

      if (progress < charStartProgress) {
        // Character hasn't started yet
        break;
      } else if (progress >= charEndProgress) {
        // Character is fully revealed
        result.add(chars[i]);
      } else {
        // Character is in progress
        final charProgress =
            (progress - charStartProgress) /
            (charEndProgress - charStartProgress);

        if (charProgress < scrambleDuration) {
          // Still scrambling
          final scrambleProgress = charProgress / scrambleDuration;
          if (_shouldScrambleCharacter(i, scrambleProgress, chars.length)) {
            result.add(_getScrambledCharacter(chars[i], i));
          } else {
            result.add(chars[i]);
          }
        } else {
          // Revealed
          result.add(chars[i]);
        }
      }
    }

    return result.join('');
  }

  @override
  void dispose() {
    clearScrambleCache();
    super.dispose();
  }
}
