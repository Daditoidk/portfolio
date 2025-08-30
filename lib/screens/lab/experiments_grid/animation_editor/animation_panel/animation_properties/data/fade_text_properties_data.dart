import 'base_animation_properties_data.dart';

/// Properties specific to fade text animation
class FadeTextPropertiesData extends BaseAnimationPropertiesData {
  final double duration;
  final String fadeType;

  const FadeTextPropertiesData({
    required super.loop,
    required super.speed,
    required this.duration,
    required this.fadeType,
    super.previewText,
  });

  @override
  FadeTextPropertiesData copyWith({
    bool? loop,
    double? speed,
    double? duration,
    String? fadeType,
    String? previewText,
  }) {
    return FadeTextPropertiesData(
      loop: loop ?? this.loop,
      speed: speed ?? this.speed,
      duration: duration ?? this.duration,
      fadeType: fadeType ?? this.fadeType,
      previewText: previewText ?? this.previewText,
    );
  }

  @override
  String toString() {
    return 'FadeTextPropertiesData(loop: $loop, speed: $speed, duration: $duration, fadeType: $fadeType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FadeTextPropertiesData &&
        super == other &&
        other.duration == duration &&
        other.fadeType == fadeType;
  }

  @override
  int get hashCode {
    return Object.hash(super.hashCode, duration, fadeType);
  }

  @override
  T? getProperty<T>(String propertyName) {
    switch (propertyName.toLowerCase()) {
      case 'duration':
        return duration as T?;
      case 'fadetype':
        return fadeType as T?;
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
      case 'duration':
        return copyWith(duration: value as double);
      case 'fadetype':
        return copyWith(fadeType: value as String);
      default:
        return this;
    }
  }

  static FadeTextPropertiesData defaultValues() {
    return const FadeTextPropertiesData(
      loop: false,
      speed: 1.0,
      duration: 2.0,
      fadeType: 'Fade In',
      previewText: 'Hello World',
    );
  }
}
