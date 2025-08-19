import 'package:flutter/material.dart';
import 'dart:math';
import 'text_animation_registry.dart';

/// Strategy for language change animations
enum LanguageChangeStrategy {
  cascadeTopToBottom, // Line by line from top to bottom
  readingWave, // Horizontal reading-like animation
  blockCascade, // Multiple lines at once (faster)
  instant, // No animation
  fadeInOut, // Simple fade
}

/// Type of scramble effect
enum ScrambleType {
  random, // Random characters
  morphing, // Morphing letters
  mixed, // Combination of both
}

/// Settings for language change animation
class LanguageChangeSettings {
  final LanguageChangeStrategy strategy;
  final ScrambleType scrambleType;
  final Duration duration;
  final Duration delayBetweenLines;
  final Duration delayBetweenBlocks;
  final int blockSize; // Number of lines per block
  final bool skipAnimation; // For accessibility

  const LanguageChangeSettings({
    this.strategy = LanguageChangeStrategy.readingWave,
    this.scrambleType = ScrambleType.mixed,
    this.duration = const Duration(milliseconds: 2000),
    this.delayBetweenLines = const Duration(milliseconds: 200),
    this.delayBetweenBlocks = const Duration(milliseconds: 100),
    this.blockSize = 3,
    this.skipAnimation = false,
  });

  const LanguageChangeSettings.fast({
    this.strategy = LanguageChangeStrategy.blockCascade,
    this.scrambleType = ScrambleType.random,
    this.duration = const Duration(milliseconds: 800),
    this.delayBetweenLines = const Duration(milliseconds: 100),
    this.delayBetweenBlocks = const Duration(milliseconds: 50),
    this.blockSize = 5,
    this.skipAnimation = false,
  });

  const LanguageChangeSettings.slow({
    this.strategy = LanguageChangeStrategy.readingWave,
    this.scrambleType = ScrambleType.morphing,
    this.duration = const Duration(milliseconds: 3000),
    this.delayBetweenLines = const Duration(milliseconds: 300),
    this.delayBetweenBlocks = const Duration(milliseconds: 150),
    this.blockSize = 2,
    this.skipAnimation = false,
  });
}

/// Global animation controller for language changes
class LanguageChangeAnimationController {
  static final LanguageChangeAnimationController _instance =
      LanguageChangeAnimationController._internal();

  factory LanguageChangeAnimationController() => _instance;

  LanguageChangeAnimationController._internal();

  bool _isAnimating = false;
  bool _skipAnimations = false;

  bool get isAnimating => _isAnimating;
  bool get skipAnimations => _skipAnimations;

  /// Set skip animations (called from accessibility menu)
  void setSkipAnimations(bool skip) {
    _skipAnimations = skip;
  }

  /// Start language change animation
  Future<void> animateLanguageChange({
    required BuildContext context,
    required LanguageChangeSettings settings,
    required VoidCallback onComplete,
  }) async {
    if (_skipAnimations || settings.skipAnimation) {
      onComplete();
      return;
    }

    _isAnimating = true;

    try {
      switch (settings.strategy) {
        case LanguageChangeStrategy.cascadeTopToBottom:
          await _cascadeTopToBottom(context, settings);
          break;
        case LanguageChangeStrategy.readingWave:
          await _readingWave(context, settings);
          break;
        case LanguageChangeStrategy.blockCascade:
          await _blockCascade(context, settings);
          break;
        case LanguageChangeStrategy.instant:
          // No animation
          break;
        case LanguageChangeStrategy.fadeInOut:
          await _fadeInOut(context, settings);
          break;
      }
    } finally {
      _isAnimating = false;
      onComplete();
    }
  }

  /// Cascade animation: line by line from top to bottom
  Future<void> _cascadeTopToBottom(
    BuildContext context,
    LanguageChangeSettings settings,
  ) async {
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    if (elements.isEmpty) return;

    // Get all line indices
    final lineIndices = registry.getLineIndices();

    // Animate each line sequentially
    for (int lineIndex in lineIndices) {
      final lineElements = registry.getElementsByLine(lineIndex);

      // Start scramble animation for all elements in this line
      for (final element in lineElements) {
        _startScrambleAnimation(element, settings);
      }

      // Wait for scramble to complete
      await Future.delayed(settings.delayBetweenLines);

      // Change text to new language for all elements in this line
      for (final element in lineElements) {
        _changeTextToNewLanguage(element, context);
      }

      // Wait before starting next line
      await Future.delayed(settings.delayBetweenLines);
    }
  }

  /// Reading wave animation: horizontal reading-like effect
  Future<void> _readingWave(
    BuildContext context,
    LanguageChangeSettings settings,
  ) async {
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    if (elements.isEmpty) return;

    final lineIndices = registry.getLineIndices();

    // Animate each line with reading wave effect
    for (int lineIndex in lineIndices) {
      final lineElements = registry.getElementsByLine(lineIndex);

      // Start scramble animation for this line
      for (final element in lineElements) {
        _startScrambleAnimation(element, settings);
      }

      // Wait for scramble to complete
      await Future.delayed(settings.delayBetweenLines);

      // Change text to new language for this line
      for (final element in lineElements) {
        _changeTextToNewLanguage(element, context);
      }

      // Start next line while previous line is changing
      if (lineIndex < lineIndices.length - 1) {
        final nextLineElements = registry.getElementsByLine(
          lineIndices[lineIndex + 1],
        );
        for (final element in nextLineElements) {
          _startScrambleAnimation(element, settings);
        }
      }

      await Future.delayed(settings.delayBetweenLines);
    }
  }

  /// Block cascade: multiple lines at once
  Future<void> _blockCascade(
    BuildContext context,
    LanguageChangeSettings settings,
  ) async {
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    if (elements.isEmpty) return;

    final blockIndices = registry.getBlockIndices();

    // Animate each block (multiple lines at once)
    for (int blockIndex in blockIndices) {
      final blockElements = registry.getElementsByBlock(blockIndex);

      // Start scramble animation for all elements in this block
      for (final element in blockElements) {
        _startScrambleAnimation(element, settings);
      }

      // Wait for scramble to complete
      await Future.delayed(settings.delayBetweenBlocks);

      // Change text to new language for all elements in this block
      for (final element in blockElements) {
        _changeTextToNewLanguage(element, context);
      }

      // Wait before starting next block
      await Future.delayed(settings.delayBetweenBlocks);
    }
  }

  /// Simple fade in/out
  Future<void> _fadeInOut(
    BuildContext context,
    LanguageChangeSettings settings,
  ) async {
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    if (elements.isEmpty) return;

    // Fade out all elements
    for (final element in elements) {
      _fadeOutElement(element);
    }

    await Future.delayed(settings.duration ~/ 2);

    // Change text to new language
    for (final element in elements) {
      _changeTextToNewLanguage(element, context);
    }

    // Fade in all elements
    for (final element in elements) {
      _fadeInElement(element);
    }

    await Future.delayed(settings.duration ~/ 2);
  }

  /// Start scramble animation for a text element
  void _startScrambleAnimation(
    TextElement element,
    LanguageChangeSettings settings,
  ) {
    // This would trigger the scramble effect on the specific text element
    // The actual implementation depends on how you want to handle the scramble effect

    // For now, we'll use a simple approach with a custom widget
    // In a real implementation, you might want to use a Stream or callback system

    print('Starting scramble animation for: "${element.text}"');

    // You could emit an event or use a callback to notify the UI
    // that this element should start scrambling
  }

  /// Change text to new language
  void _changeTextToNewLanguage(TextElement element, BuildContext context) {
    // This would change the actual text content
    // You'll need to implement this based on your localization system

    print('Changing text to new language: "${element.text}"');

    // Example implementation:
    // 1. Get the new text from your localization system
    // 2. Update the widget that contains this text
    // 3. Trigger a rebuild

    // For now, we'll just print the action
  }

  /// Fade out element
  void _fadeOutElement(TextElement element) {
    print('Fading out: "${element.text}"');
    // Implement fade out animation
  }

  /// Fade in element
  void _fadeInElement(TextElement element) {
    print('Fading in: "${element.text}"');
    // Implement fade in animation
  }
}

/// Scramble text widget for individual text elements
class ScrambleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final ScrambleType scrambleType;
  final bool isAnimating;

  const ScrambleText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.scrambleType = ScrambleType.mixed,
    this.isAnimating = false,
  });

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _displayText = '';
  final Random _random = Random();

  // Characters for different languages
  static const String _englishChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static const String _spanishChars =
      'ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz0123456789áéíóúüÁÉÍÓÚÜ';
  static const String _japaneseChars =
      'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789';

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation.addListener(() {
      if (widget.isAnimating) {
        _updateScrambleText();
      }
    });
  }

  @override
  void didUpdateWidget(ScrambleText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.forward();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.reverse();
      _displayText = widget.text;
    }

    if (widget.text != oldWidget.text && !widget.isAnimating) {
      _displayText = widget.text;
    }
  }

  void _updateScrambleText() {
    if (!mounted) return;

    setState(() {
      _displayText = _generateScrambleText(widget.text);
    });
  }

  String _generateScrambleText(String originalText) {
    if (originalText.isEmpty) return '';

    String chars;
    switch (widget.scrambleType) {
      case ScrambleType.random:
        chars = _englishChars + _spanishChars + _japaneseChars;
        break;
      case ScrambleType.morphing:
        // Use characters similar to the original
        chars = _getSimilarChars(originalText);
        break;
      case ScrambleType.mixed:
        chars = _englishChars + _spanishChars + _japaneseChars;
        break;
    }

    return originalText
        .split('')
        .map((char) {
          if (char == ' ') return ' ';
          return chars[_random.nextInt(chars.length)];
        })
        .join('');
  }

  String _getSimilarChars(String text) {
    // Return characters similar to the text being scrambled
    if (text.contains(RegExp(r'[あ-んア-ン]'))) {
      return _japaneseChars;
    } else if (text.contains(RegExp(r'[áéíóúüÁÉÍÓÚÜñÑ]'))) {
      return _spanishChars;
    } else {
      return _englishChars;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayText, style: widget.style, textAlign: widget.textAlign);
  }
}
