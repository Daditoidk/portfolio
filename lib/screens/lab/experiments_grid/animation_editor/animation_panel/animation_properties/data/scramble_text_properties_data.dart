import 'base_animation_properties_data.dart';

/// Properties specific to scramble text animation
class ScrambleTextPropertiesData extends BaseAnimationPropertiesData {
  final double intensity;
  final String direction;

  const ScrambleTextPropertiesData({
    required super.loop,
    required super.speed,
    required this.intensity,
    required this.direction,
    super.previewText,
  });

  @override
  ScrambleTextPropertiesData copyWith({
    bool? loop,
    double? speed,
    String? previewText,
    double? intensity,
    String? direction,
  }) {
    return ScrambleTextPropertiesData(
      loop: loop ?? this.loop,
      speed: speed ?? this.speed,
      previewText: previewText ?? this.previewText,
      intensity: intensity ?? this.intensity,
      direction: direction ?? this.direction,
    );
  }

  @override
  String toString() {
    return 'ScrambleTextPropertiesData(loop: $loop, speed: $speed, intensity: $intensity, direction: $direction)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrambleTextPropertiesData &&
        super == other &&
        other.intensity == intensity &&
        other.direction == direction;
  }

  @override
  int get hashCode {
    return Object.hash(super.hashCode, intensity, direction);
  }

  @override
  T? getProperty<T>(String propertyName) {
    switch (propertyName.toLowerCase()) {
      case 'intensity':
        return intensity as T?;
      case 'direction':
        return direction as T?;
      default:
        return super.getProperty<T>(propertyName);
    }
  }

  @override
  BaseAnimationPropertiesData updateProperty(
    String propertyName,
    dynamic value,
  ) {
    switch (propertyName.toLowerCase()) {
      case 'intensity':
        return copyWith(intensity: value as double);
      case 'direction':
        return copyWith(direction: value as String);
      default:
        return this;
    }
  }

  static ScrambleTextPropertiesData defaultValues() {
    return const ScrambleTextPropertiesData(
      loop: false,
      speed: 1.0,
      intensity: 0.5,
      direction: 'Left to Right',
      previewText: 'Hello World',
    );
  }
}
