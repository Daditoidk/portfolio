

/// Main configuration for the animation editor
class AnimationEditorConfig {
  /// Available animation types
  static const List<String> availableAnimationTypes = [
    'text_scramble',
    'fade_in',
    'slide_in',
    'scale_in',
    'bounce_in',
  ];

  /// Get configuration for a specific animation type
  static Map<String, dynamic> getAnimationConfig(String animationType) {
    switch (animationType) {
      case 'text_scramble':
        return {
          'name': 'Text Scramble',
          'type': 'text_scramble',
          'category': 'Text Animations',
          'description': 'Scramble text characters with customizable settings',
          'properties': [
            {
              'name': 'speed',
              'type': 'double',
              'label': 'Animation Speed',
              'default': 1.0,
              'min': 0.1,
              'max': 5.0,
              'step': 0.1,
            },
            {
              'name': 'delay',
              'type': 'double',
              'label': 'Delay Between Characters',
              'default': 0.1,
              'min': 0.0,
              'max': 1.0,
              'step': 0.01,
            },
            {
              'name': 'loop',
              'type': 'bool',
              'label': 'Loop Animation',
              'default': false,
            },
            {
              'name': 'reverse',
              'type': 'bool',
              'label': 'Reverse Animation',
              'default': false,
            },
            {
              'name': 'scrambleCharacters',
              'type': 'string',
              'label': 'Scramble Characters',
              'default': r'!@#$%^&*()',
            },
            {
              'name': 'scrambleIterations',
              'type': 'int',
              'label': 'Scramble Iterations',
              'default': 10,
              'min': 1,
              'max': 50,
              'step': 1,
            },
            {
              'name': 'maintainCase',
              'type': 'bool',
              'label': 'Maintain Case',
              'default': true,
            },
          ],
        };
      case 'fade_in':
        return {
          'name': 'Fade In',
          'type': 'fade_in',
          'category': 'Basic Animations',
          'description': 'Fade in animation with opacity transition',
          'properties': [
            {
              'name': 'duration',
              'type': 'double',
              'label': 'Duration (seconds)',
              'default': 0.8,
              'min': 0.1,
              'max': 5.0,
              'step': 0.1,
            },
            {
              'name': 'curve',
              'type': 'dropdown',
              'label': 'Animation Curve',
              'default': 'easeInOut',
              'options': [
                'easeInOut',
                'easeIn',
                'easeOut',
                'fastOutSlowIn',
                'bounceIn',
                'bounceOut',
                'elasticIn',
                'elasticOut',
              ],
            },
          ],
        };
      case 'slide_in':
        return {
          'name': 'Slide In',
          'type': 'slide_in',
          'category': 'Basic Animations',
          'description': 'Slide in animation from specified direction',
          'properties': [
            {
              'name': 'direction',
              'type': 'dropdown',
              'label': 'Slide Direction',
              'default': 'left',
              'options': ['left', 'right', 'top', 'bottom'],
            },
            {
              'name': 'distance',
              'type': 'double',
              'label': 'Slide Distance',
              'default': 100.0,
              'min': 10.0,
              'max': 500.0,
              'step': 10.0,
            },
            {
              'name': 'duration',
              'type': 'double',
              'label': 'Duration (seconds)',
              'default': 0.8,
              'min': 0.1,
              'max': 5.0,
              'step': 0.1,
            },
          ],
        };
      case 'scale_in':
        return {
          'name': 'Scale In',
          'type': 'scale_in',
          'category': 'Basic Animations',
          'description': 'Scale in animation with size transition',
          'properties': [
            {
              'name': 'startScale',
              'type': 'double',
              'label': 'Start Scale',
              'default': 0.0,
              'min': 0.0,
              'max': 2.0,
              'step': 0.1,
            },
            {
              'name': 'endScale',
              'type': 'double',
              'label': 'End Scale',
              'default': 1.0,
              'min': 0.1,
              'max': 3.0,
              'step': 0.1,
            },
            {
              'name': 'duration',
              'type': 'double',
              'label': 'Duration (seconds)',
              'default': 0.8,
              'min': 0.1,
              'max': 5.0,
              'step': 0.1,
            },
          ],
        };
      case 'bounce_in':
        return {
          'name': 'Bounce In',
          'type': 'bounce_in',
          'category': 'Basic Animations',
          'description': 'Bounce in animation with elastic effect',
          'properties': [
            {
              'name': 'duration',
              'type': 'double',
              'label': 'Duration (seconds)',
              'default': 1.2,
              'min': 0.5,
              'max': 3.0,
              'step': 0.1,
            },
            {
              'name': 'bounceIntensity',
              'type': 'double',
              'label': 'Bounce Intensity',
              'default': 0.8,
              'min': 0.1,
              'max': 2.0,
              'step': 0.1,
            },
          ],
        };
      default:
        return {};
    }
  }

  /// Get all animation categories
  static List<String> getAnimationCategories() {
    final categories = <String>{};
    for (final type in availableAnimationTypes) {
      final config = getAnimationConfig(type);
      if (config.containsKey('category')) {
        categories.add(config['category'] as String);
      }
    }
    return categories.toList()..sort();
  }

  /// Get animations by category
  static Map<String, List<String>> getAnimationsByCategory() {
    final result = <String, List<String>>{};
    for (final type in availableAnimationTypes) {
      final config = getAnimationConfig(type);
      if (config.containsKey('category')) {
        final category = config['category'] as String;
        result.putIfAbsent(category, () => []).add(type);
      }
    }
    return result;
  }
}
