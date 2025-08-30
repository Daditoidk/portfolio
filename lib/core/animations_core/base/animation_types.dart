/// Types of text animations available
enum TextAnimationType {
  /// Text appears character by character with scramble effect
  text_scramble,

  /// Text fades in/out smoothly
  text_fade_in,

  /// Text slides in from different directions
  text_slide,

  /// Text types out character by character
  text_typewriter,

  /// Text waves into view with wave effect
  text_wave,

  /// No animation, just static text
  none,
}

/// Types of transition animations available
enum TransitionAnimationType {
  /// Elements fade in from right
  transition_fade_right,

  /// Flashlight effect reveals content
  transition_flashlight,

  /// Elements slide up into view
  transition_slide_up,

  /// Elements zoom in from center
  transition_zoom_in,

  /// No transition
  none,
}

/// Types of effect animations available
enum EffectAnimationType {
  /// Particle effects
  effect_particles,

  /// Glitch effects
  effect_glitch,

  /// Morphing effects
  effect_morph,

  /// No effects
  none,
}

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/// Convert string ID to TextAnimationType enum
TextAnimationType? stringToTextAnimationType(String? id) {
  if (id == null) return null;

  switch (id) {
    case 'text_scramble':
      return TextAnimationType.text_scramble;
    case 'text_fade_in':
      return TextAnimationType.text_fade_in;
    case 'text_slide':
      return TextAnimationType.text_slide;
    case 'text_typewriter':
      return TextAnimationType.text_typewriter;
    case 'text_wave':
      return TextAnimationType.text_wave;
    default:
      return null;
  }
}

/// Convert TextAnimationType enum to string ID
String? textAnimationTypeToString(TextAnimationType? type) {
  if (type == null) return null;

  switch (type) {
    case TextAnimationType.text_scramble:
      return 'text_scramble';
    case TextAnimationType.text_fade_in:
      return 'text_fade_in';
    case TextAnimationType.text_slide:
      return 'text_slide';
    case TextAnimationType.text_typewriter:
      return 'text_typewriter';
    case TextAnimationType.text_wave:
      return 'text_wave';
    case TextAnimationType.none:
      return null;
  }
}

/// Convert string ID to TransitionAnimationType enum
TransitionAnimationType? stringToTransitionAnimationType(String? id) {
  if (id == null) return null;

  switch (id) {
    case 'transition_fade_right':
      return TransitionAnimationType.transition_fade_right;
    case 'transition_flashlight':
      return TransitionAnimationType.transition_flashlight;
    case 'transition_slide_up':
      return TransitionAnimationType.transition_slide_up;
    case 'transition_zoom_in':
      return TransitionAnimationType.transition_zoom_in;
    default:
      return null;
  }
}

/// Convert TransitionAnimationType enum to string ID
String? transitionAnimationTypeToString(TransitionAnimationType? type) {
  if (type == null) return null;

  switch (type) {
    case TransitionAnimationType.transition_fade_right:
      return 'transition_fade_right';
    case TransitionAnimationType.transition_flashlight:
      return 'transition_flashlight';
    case TransitionAnimationType.transition_slide_up:
      return 'transition_slide_up';
    case TransitionAnimationType.transition_zoom_in:
      return 'transition_zoom_in';
    case TransitionAnimationType.none:
      return null;
  }
}
