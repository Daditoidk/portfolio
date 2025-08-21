import 'package:flutter/material.dart';
import 'text_animation_registry.dart';
import 'language_change_animation.dart';

/// Viewport-aware animation system for language changes
class ViewportAnimationSystem {
  static final ViewportAnimationSystem _instance =
      ViewportAnimationSystem._internal();
  factory ViewportAnimationSystem() => _instance;
  ViewportAnimationSystem._internal();

  // Configuration
  double _viewportBuffer = 100.0; // Extra lines above/below viewport
  Duration _baseAnimationDuration = const Duration(milliseconds: 800);
  Duration _delayBetweenLines = const Duration(milliseconds: 150);
  Duration _delayBetweenBlocks = const Duration(milliseconds: 300);

  // Animation state
  bool _isAnimating = false;
  final Map<String, dynamic> _activeAnimations = {};

  /// Set viewport buffer (extra lines to animate)
  void setViewportBuffer(double buffer) {
    _viewportBuffer = buffer;
  }

  /// Set base animation duration
  void setBaseAnimationDuration(Duration duration) {
    _baseAnimationDuration = duration;
  }

  /// Set delay between lines
  void setDelayBetweenLines(Duration delay) {
    _delayBetweenLines = delay;
  }

  /// Set delay between blocks
  void setDelayBetweenBlocks(Duration delay) {
    _delayBetweenBlocks = delay;
  }

  /// Get visible lines in current viewport
  List<int> getVisibleLinesInViewport(
    ScrollController scrollController,
    double viewportHeight,
    double appBarHeight,
  ) {
    if (!scrollController.hasClients) return [];

    final scrollOffset = scrollController.offset;
    final viewportTop = scrollOffset;
    final viewportBottom = scrollOffset + viewportHeight - appBarHeight;

    // Get all lines from registry
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    if (elements.isEmpty) return [];

    // Get unique line indices
    final lineIndices = registry.getLineIndices();

    // Filter lines that are visible in viewport (with buffer)
    final visibleLines = <int>[];

    for (final lineIndex in lineIndices) {
      final lineElements = registry.getElementsByLine(lineIndex);
      if (lineElements.isNotEmpty) {
        // Calculate line position (average Y of all elements in line)
        final avgY =
            lineElements.map((e) => e.yPosition).reduce((a, b) => a + b) /
            lineElements.length;

        // Check if line is in viewport (with buffer)
        if (avgY >= viewportTop - _viewportBuffer &&
            avgY <= viewportBottom + _viewportBuffer) {
          visibleLines.add(lineIndex);
        }
      }
    }

    return visibleLines;
  }

  /// Get visible blocks in current viewport
  List<int> getVisibleBlocksInViewport(
    ScrollController scrollController,
    double viewportHeight,
    double appBarHeight,
  ) {
    final visibleLines = getVisibleLinesInViewport(
      scrollController,
      viewportHeight,
      appBarHeight,
    );

    if (visibleLines.isEmpty) return [];

    // Get unique block indices from visible lines
    final registry = TextAnimationRegistry();
    final visibleBlockIndices = <int>{};

    for (final lineIndex in visibleLines) {
      final lineElements = registry.getElementsByLine(lineIndex);
      for (final element in lineElements) {
        visibleBlockIndices.add(element.blockIndex);
      }
    }

    return visibleBlockIndices.toList()..sort();
  }

  /// Animate language change with viewport awareness
  Future<void> animateLanguageChangeViewportAware({
    required BuildContext context,
    required ScrollController scrollController,
    required double viewportHeight,
    required double appBarHeight,
    required VoidCallback onComplete,
    LanguageChangeStrategy strategy = LanguageChangeStrategy.cascadeTopToBottom,
    Duration? customDuration,
    double? customViewportBuffer,
  }) async {
    if (_isAnimating) {
      print('⚠️ Animation already in progress, skipping...');
      return;
    }

    _isAnimating = true;
    final duration = customDuration ?? _baseAnimationDuration;
    final buffer = customViewportBuffer ?? _viewportBuffer;

    try {
      print('🎬 Starting viewport-aware language change animation...');
      print(
        '📱 Viewport: ${viewportHeight.toStringAsFixed(1)}px, Buffer: ${buffer.toStringAsFixed(1)}px',
      );

      // Get visible lines and blocks
      final visibleLines = getVisibleLinesInViewport(
        scrollController,
        viewportHeight,
        appBarHeight,
      );
      final visibleBlocks = getVisibleBlocksInViewport(
        scrollController,
        viewportHeight,
        appBarHeight,
      );

      print('👁️ Visible lines: $visibleLines (${visibleLines.length} total)');
      print(
        '📦 Visible blocks: $visibleBlocks (${visibleBlocks.length} total)',
      );

      if (visibleLines.isEmpty) {
        print('⚠️ No visible lines found, skipping animation');
        onComplete();
        return;
      }

      // Execute animation based on strategy
      switch (strategy) {
        case LanguageChangeStrategy.cascadeTopToBottom:
          await _cascadeTopToBottomViewport(
            context,
            visibleLines,
            visibleBlocks,
            duration,
            buffer,
          );
          break;
        case LanguageChangeStrategy.readingWave:
          await _readingWaveViewport(
            context,
            visibleLines,
            visibleBlocks,
            duration,
            buffer,
          );
          break;
        case LanguageChangeStrategy.blockCascade:
          await _blockCascadeViewport(
            context,
            visibleLines,
            visibleBlocks,
            duration,
            buffer,
          );
          break;
        case LanguageChangeStrategy.fadeInOut:
          await _fadeInOutViewport(
            context,
            visibleLines,
            visibleBlocks,
            duration,
            buffer,
          );
          break;
        case LanguageChangeStrategy.instant:
          // No animation
          break;
      }

      print('✅ Viewport animation completed successfully!');
    } catch (e) {
      print('❌ Error during viewport animation: $e');
    } finally {
      _isAnimating = false;
      onComplete();
    }
  }

  /// Cascade animation: top to bottom, viewport-aware
  Future<void> _cascadeTopToBottomViewport(
    BuildContext context,
    List<int> visibleLines,
    List<int> visibleBlocks,
    Duration duration,
    double buffer,
  ) async {
    print('🌊 Starting cascade top-to-bottom (viewport-aware)...');

    final registry = TextAnimationRegistry();

    // Sort lines by Y position (top to bottom)
    visibleLines.sort();

    for (int i = 0; i < visibleLines.length; i++) {
      final lineIndex = visibleLines[i];
      final lineElements = registry.getElementsByLine(lineIndex);

      if (lineElements.isNotEmpty) {
        print(
          '   📍 Animating line $lineIndex (${lineElements.length} elements)',
        );

        // Start scramble animation for all elements in this line
        for (final element in lineElements) {
          _startScrambleAnimation(element, duration);
        }

        // Wait for scramble to complete
        await Future.delayed(duration ~/ 2);

        // Change text to new language for all elements in this line
        for (final element in lineElements) {
          _changeTextToNewLanguage(element, context);
        }

        // Wait before starting next line (unless it's the last line)
        if (i < visibleLines.length - 1) {
          await Future.delayed(_delayBetweenLines);
        }
      }
    }
  }

  /// Reading wave animation: viewport-aware
  Future<void> _readingWaveViewport(
    BuildContext context,
    List<int> visibleLines,
    List<int> visibleBlocks,
    Duration duration,
    double buffer,
  ) async {
    print('🌊 Starting reading wave (viewport-aware)...');

    final registry = TextAnimationRegistry();

    // Sort lines by Y position
    visibleLines.sort();

    for (int i = 0; i < visibleLines.length; i++) {
      final lineIndex = visibleLines[i];
      final lineElements = registry.getElementsByLine(lineIndex);

      if (lineElements.isNotEmpty) {
        print(
          '   📍 Reading wave line $lineIndex (${lineElements.length} elements)',
        );

        // Start scramble animation for this line
        for (final element in lineElements) {
          _startScrambleAnimation(element, duration);
        }

        // Wait for scramble to complete
        await Future.delayed(duration ~/ 2);

        // Change text to new language for this line
        for (final element in lineElements) {
          _changeTextToNewLanguage(element, context);
        }

        // Start next line while previous line is changing (if available)
        if (i < visibleLines.length - 1) {
          final nextLineIndex = visibleLines[i + 1];
          final nextLineElements = registry.getElementsByLine(nextLineIndex);

          for (final element in nextLineElements) {
            _startScrambleAnimation(element, duration);
          }
        }

        await Future.delayed(_delayBetweenLines);
      }
    }
  }

  /// Block cascade: viewport-aware
  Future<void> _blockCascadeViewport(
    BuildContext context,
    List<int> visibleLines,
    List<int> visibleBlocks,
    Duration duration,
    double buffer,
  ) async {
    print('📦 Starting block cascade (viewport-aware)...');

    final registry = TextAnimationRegistry();

    // Sort blocks by Y position
    visibleBlocks.sort();

    for (int i = 0; i < visibleBlocks.length; i++) {
      final blockIndex = visibleBlocks[i];
      final blockElements = registry.getElementsByBlock(blockIndex);

      if (blockElements.isNotEmpty) {
        print(
          '   📦 Animating block $blockIndex (${blockElements.length} elements)',
        );

        // Start scramble animation for all elements in this block
        for (final element in blockElements) {
          _startScrambleAnimation(element, duration);
        }

        // Wait for scramble to complete
        await Future.delayed(duration ~/ 2);

        // Change text to new language for all elements in this block
        for (final element in blockElements) {
          _changeTextToNewLanguage(element, context);
        }

        // Wait before starting next block (unless it's the last block)
        if (i < visibleBlocks.length - 1) {
          await Future.delayed(_delayBetweenBlocks);
        }
      }
    }
  }

  /// Fade in/out: viewport-aware
  Future<void> _fadeInOutViewport(
    BuildContext context,
    List<int> visibleLines,
    List<int> visibleBlocks,
    Duration duration,
    double buffer,
  ) async {
    print('✨ Starting fade in/out (viewport-aware)...');

    final registry = TextAnimationRegistry();
    final allVisibleElements = <TextElement>[];

    // Collect all elements from visible lines
    for (final lineIndex in visibleLines) {
      final lineElements = registry.getElementsByLine(lineIndex);
      allVisibleElements.addAll(lineElements);
    }

    if (allVisibleElements.isNotEmpty) {
      print('   ✨ Fading ${allVisibleElements.length} visible elements');

      // Fade out all visible elements
      for (final element in allVisibleElements) {
        _fadeOutElement(element);
      }

      await Future.delayed(duration ~/ 2);

      // Change text to new language
      for (final element in allVisibleElements) {
        _changeTextToNewLanguage(element, context);
      }

      // Fade in all visible elements
      for (final element in allVisibleElements) {
        _fadeInElement(element);
      }

      await Future.delayed(duration ~/ 2);
    }
  }

  /// Start scramble animation for a text element
  void _startScrambleAnimation(TextElement element, Duration duration) {
    print('   🔀 Starting scramble for: "${element.text}"');

    // For now, we'll just log the animation start
    // In a real implementation, you would create an AnimationController
    // and manage the actual animation state

    // Store animation state
    _activeAnimations[element.id ?? element.text] = null; // Placeholder

    print('   ✅ Scramble animation started for: "${element.text}"');
  }

  /// Change text to new language
  void _changeTextToNewLanguage(TextElement element, BuildContext context) {
    print('   🌍 Changing language for: "${element.text}"');

    // This would change the actual text content
    // Implementation depends on your localization system

    // For now, we'll just print the action
    // In a real implementation, you would:
    // 1. Get the new text from your localization system
    // 2. Update the widget that contains this text
    // 3. Trigger a rebuild
  }

  /// Fade out element
  void _fadeOutElement(TextElement element) {
    print('   📉 Fading out: "${element.text}"');
    // Implement fade out animation
  }

  /// Fade in element
  void _fadeInElement(TextElement element) {
    print('   📈 Fading in: "${element.text}"');
    // Implement fade in animation
  }

  /// Check if animation is in progress
  bool get isAnimating => _isAnimating;

  /// Stop all active animations
  void stopAllAnimations() {
    print('🛑 Stopping all active animations...');

    // Clear all active animations
    _activeAnimations.clear();
    _isAnimating = false;
  }

  /// Dispose all resources
  void dispose() {
    stopAllAnimations();
  }
}

// LanguageChangeStrategy is defined in language_change_animation.dart
