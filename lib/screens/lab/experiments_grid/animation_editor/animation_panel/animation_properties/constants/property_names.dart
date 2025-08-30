/// Constants for animation property names to prevent typos and ensure consistency
class PropertyNames {
  // Common properties (base class) - lowercase to match data file switch cases
  static const String speed = 'speed';
  static const String loop = 'loop';
  static const String previewText = 'previewtext';

  // Scramble text properties - lowercase to match data file switch cases
  static const String scrambleIntensity = 'intensity';
  static const String direction = 'direction';

  // Fade text properties - lowercase to match data file switch cases
  static const String fadeDuration = 'duration';
  static const String fadeType = 'fadetype';

  // Slide text properties - lowercase to match data file switch cases
  static const String slideDistance = 'distance';
  static const String easing = 'easing';

  // Prevent instantiation
  PropertyNames._();
}
