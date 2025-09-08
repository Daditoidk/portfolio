import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../apps/lab/experiments_grid/animation_editor/animation_panel/animation_properties/data/index.dart';

mixin SimpleScrambleMixin {
  // Cache for scramble info only (no longer need scrambled text cache)
  final Map<String, Map<int, bool>> _scrambleInfoCache = {};

  /// Builds a text widget with scramble animation effect
  Widget buildScrambleText({
    required String beforeText,
    required ScrambleTextPropertiesData config,
    required AnimationController timeline,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? afterText,
  }) {
    final scrambleIntensity = config.intensity;
    final random = Random();

    return AnimatedBuilder(
      animation: timeline,
      builder: (context, child) {
        final progress = timeline.value;

        // If animation is complete (progress = 1.0), show the final text
        if (progress >= 1.0) {
          final finalText = afterText ?? beforeText;
          return Text(
            finalText,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        // Detect animation type for ongoing animation
        if (beforeText == afterText || afterText == null) {
          // ANIMATION TYPE 1: Same text scramble
          return _buildSameTextScrambleAnimation(
            text: beforeText,
            progress: progress,
            scrambleIntensity: scrambleIntensity,
            speed: config.speed,
            random: random,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        } else {
          // ANIMATION TYPE 2: Text transformation
          return _buildTextTransformationAnimation(
            beforeText: beforeText,
            afterText: afterText,
            progress: progress,
            speed: config.speed,
            random: random,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }
      },
    );
  }

  /// ANIMATION TYPE 1: Same text scramble animation
  Widget _buildSameTextScrambleAnimation({
    required String text,
    required double progress,
    required double scrambleIntensity,
    required double speed,
    required Random random,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final cacheKey = '${text}_$scrambleIntensity';

    // Get or create scramble info (only once)
    if (!_scrambleInfoCache.containsKey(cacheKey)) {
      _scrambleInfoCache[cacheKey] = decideScrambleCharacters(
        text: text,
        intensity: scrambleIntensity,
        random: random,
      );
    }

    final scrambleInfo = _scrambleInfoCache[cacheKey]!;

    // Build display text based on progress
    String displayText = '';
    for (int i = 0; i < text.length; i++) {
      if (scrambleInfo[i] == true) {
        // This character should be scrambled
        if (progress < 0.5) {
          // First half: generate NEW random characters based on scramble rate
          displayText += _getScrambledCharacterWithRate(
            progress: progress,
            characterIndex: i,
            speed: speed,
            random: random,
          );
        } else {
          // Second half: gradually reveal original character
          double revealProgress = (progress - 0.5) * 2; // 0.0 to 1.0
          if (revealProgress > (i / text.length)) {
            // Time to reveal this character
            displayText += text[i];
          } else {
            // Still scrambling - generate new random character based on rate
            displayText += _getScrambledCharacterWithRate(
              progress: progress,
              characterIndex: i,
              speed: speed,
              random: random,
            );
          }
        }
      } else {
        // Never scrambled
        displayText += text[i];
      }
    }

    return Text(
      displayText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// ANIMATION TYPE 2: Text transformation animation
  Widget _buildTextTransformationAnimation({
    required String beforeText,
    required String afterText,
    required double progress,
    required double speed,
    required Random random,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    // All characters scramble, then reveal after text
    String displayText = '';

    if (progress <= 0.0) {
      final finalText = beforeText;
      return Text(
        finalText,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    if (progress >= 1.0) {
      final finalText = afterText;
      return Text(
        finalText,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    if (progress < 0.5) {
      // First half: all characters are scrambled randomly with rate control
      for (int i = 0; i < beforeText.length; i++) {
        displayText += _getScrambledCharacterWithRate(
          progress: progress,
          characterIndex: i,
          speed: speed,
          random: random,
        );
      }
    } else {
      // Second half: gradually reveal after text
      double revealProgress = (progress - 0.5) * 2; // 0.0 to 1.0
      int charsToReveal = (afterText.length * revealProgress).round();

      for (int i = 0; i < afterText.length; i++) {
        if (i < charsToReveal) {
          // Reveal after text character
          displayText += afterText[i];
        } else {
          // Still scrambling - generate new random character based on rate
          displayText += _getScrambledCharacterWithRate(
            progress: progress,
            characterIndex: i,
            speed: speed,
            random: random,
          );
        }
      }
    }

    return Text(
      displayText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Returns a list of characters (String) to use for the scramble effect,
  /// including English, Spanish, and Japanese characters.
  List<String> scrambleCharacters() {
    // English letters (upper and lower), numbers, common symbols
    const english =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+[]{};:\'",.<>?/\\|`~';
    // Spanish-specific characters
    const spanish = 'áéíóúüñÁÉÍÓÚÜÑ¿¡';
    // Japanese Hiragana, Katakana, and a few Kanji (for effect)
    const japanese =
        'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン日月火水木金土';

    // Combine all characters into a single list of single-character strings
    return (english + spanish + japanese).split('');
  }

  /// Decides which characters should be scrambled based on intensity
  Map<int, bool> decideScrambleCharacters({
    required String text,
    required double intensity,
    required Random random,
  }) {
    final totalChars = text.length;
    final scrambleMap = <int, bool>{};

    // If intensity is 0, no characters scramble
    if (intensity <= 0.0) {
      for (int i = 0; i < totalChars; i++) {
        scrambleMap[i] = false;
      }
      return scrambleMap;
    }

    // If intensity is 1, all characters scramble
    if (intensity >= 1.0) {
      for (int i = 0; i < totalChars; i++) {
        scrambleMap[i] = true;
      }
      return scrambleMap;
    }

    // For values between 0 and 1, calculate how many characters should scramble
    final charsToScramble = (totalChars * intensity).round();

    // Initialize all characters as not scrambling
    for (int i = 0; i < totalChars; i++) {
      scrambleMap[i] = false;
    }

    // Randomly select characters to scramble
    int scrambledCount = 0;
    while (scrambledCount < charsToScramble) {
      final randomIndex = random.nextInt(totalChars);
      if (!scrambleMap[randomIndex]!) {
        scrambleMap[randomIndex] = true;
        scrambledCount++;
      }
    }

    return scrambleMap;
  }

  /// Gets a scrambled character with rate control for natural visual effect
  String _getScrambledCharacterWithRate({
    required double progress,
    required int characterIndex,
    required double speed,
    required Random random,
  }) {
    // Use speed to control how fast characters change
    // Higher speed = faster character changes, Lower speed = slower changes
    double speedMultiplier = speed.clamp(0.5, 2.0); // Limit speed range

    // Calculate when this character should change based on speed
    // Higher speed means more frequent changes
    double changeFrequency = speedMultiplier * 40; // Base frequency multiplier
    double changeThreshold = (progress * changeFrequency) % 1.0;

    // Add character offset so characters don't all change at the same time
    double characterOffset = (characterIndex * 0.15) % 1.0;

    // Change character if threshold is met
    if (changeThreshold > characterOffset) {
      return scrambleCharacters()[random.nextInt(scrambleCharacters().length)];
    } else {
      // Return a consistent character for this frame to avoid flickering
      // Use a deterministic but varied seed based on progress, index, and speed
      int seed = ((progress * 1000) + characterIndex + (speed * 100)).round();
      Random seededRandom = Random(seed);
      return scrambleCharacters()[seededRandom.nextInt(
        scrambleCharacters().length,
      )];
    }
  }
}
