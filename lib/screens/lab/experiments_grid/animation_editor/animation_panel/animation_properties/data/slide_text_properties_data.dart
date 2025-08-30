import 'base_animation_properties_data.dart';

/// Properties specific to slide text animation
class SlideTextPropertiesData extends BaseAnimationPropertiesData {
  final double distance;
  final String direction;
  final String easing;

  const SlideTextPropertiesData({
    required super.loop,
    required super.speed,
    required this.distance,
    required this.direction,
    required this.easing,
    super.previewText,
  });

  @override
  SlideTextPropertiesData copyWith({
    bool? loop,
    double? speed,
    double? distance,
    String? direction,
    String? easing,
    String? previewText,
  }) {
    return SlideTextPropertiesData(
      loop: loop ?? this.loop,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      direction: direction ?? this.direction,
      easing: easing ?? this.easing,
      previewText: previewText ?? this.previewText,
    );
  }

  @override
  String toString() {
    return 'SlideTextPropertiesData(loop: $loop, speed: $speed, distance: $distance, direction: $direction, easing: $easing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SlideTextPropertiesData &&
        super == other &&
        other.distance == distance &&
        other.direction == direction &&
        other.easing == easing;
  }

  @override
  int get hashCode {
    return Object.hash(super.hashCode, distance, direction, easing);
  }

  @override
  T? getProperty<T>(String propertyName) {
    switch (propertyName.toLowerCase()) {
      case 'distance':
        return distance as T?;
      case 'direction':
        return direction as T?;
      case 'easing':
        return easing as T?;
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
      case 'distance':
        return copyWith(distance: value as double);
      case 'direction':
        return copyWith(direction: value as String);
      case 'easing':
        return copyWith(easing: value as String);
      default:
        return this;
    }
  }

  static SlideTextPropertiesData defaultValues() {
    return const SlideTextPropertiesData(
      loop: false,
      speed: 1.0,
      distance: 50.0,
      direction: 'Left to Right',
      easing: 'Linear',
      previewText: 'Hello World',
    );
  }
}
