import 'scramble_text_properties_data.dart';
import '../constants/property_names.dart';

/// Base class for all animation properties
abstract class BaseAnimationPropertiesData {
  final bool loop;
  final double speed;
  final String previewText;

  const BaseAnimationPropertiesData({
    required this.loop,
    required this.speed,
    this.previewText = "Hello World!",
  });

  /// Create from map
  static BaseAnimationPropertiesData fromMap(Map<String, dynamic> map) {
    // This is abstract - subclasses should override
    throw UnimplementedError('Subclasses must implement fromMap');
  }

  /// Copy with method for immutable updates
  BaseAnimationPropertiesData copyWith({
    bool? loop,
    double? speed,
    String? previewText,
  }) {
    // This is abstract - subclasses should override
    throw UnimplementedError('Subclasses must implement copyWith');
  }

  /// Get default values for all properties
  static BaseAnimationPropertiesData defaultValues() {
    // Return a default scramble instance
    return const ScrambleTextPropertiesData(
      loop: false,
      speed: 1.0,
      intensity: 0.5,
      direction: 'Left to Right',
      previewText: 'Hello World',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseAnimationPropertiesData &&
        other.loop == loop &&
        other.speed == speed;
  }

  @override
  int get hashCode {
    return Object.hash(loop, speed);
  }

  /// Get a property value by name
  T? getProperty<T>(String propertyName) {
    final normalizedName = propertyName.toLowerCase();
    switch (normalizedName) {
      case PropertyNames.loop:
        return loop as T?;
      case PropertyNames.speed:
        return speed as T?;
      case PropertyNames.previewText:
        return previewText as T?;
      default:
        return null;
    }
  }

  /// Update a specific property and return new instance
  BaseAnimationPropertiesData updateProperty(
    String propertyName,
    dynamic value,
  ) {
    final normalizedName = propertyName.toLowerCase();
    switch (normalizedName) {
      case PropertyNames.loop:
        return copyWith(loop: value as bool);
      case PropertyNames.speed:
        return copyWith(speed: value as double);
      case PropertyNames.previewText:
        return copyWith(previewText: value as String);
      default:
        return this;
    }
  }
}
