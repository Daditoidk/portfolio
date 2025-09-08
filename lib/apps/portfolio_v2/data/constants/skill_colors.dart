import 'package:flutter/material.dart';

/// Color sets for skills with predefined main, border, and shadow colors
class SkillColors {
  // Private constructor to prevent instantiation
  SkillColors._();

  /// Blue color set
  static final SkillColorSet blue = SkillColorSet(
    name: 'blue',
    mainColor: const Color(0xFF3A444B),
    borderColor: const Color(0xFF505A60),
    shadowColor: const Color(
      0xFF000000,
    ).withValues(alpha: 0.1882), // 18.82% opacity
  );

  /// Green color set
  static final SkillColorSet green = SkillColorSet(
    name: 'green',
    mainColor: const Color(0xFF404540),
    borderColor: const Color(0xFF555A55),
    shadowColor: const Color(
      0xFF000000,
    ).withValues(alpha: 0.1882), // 12.55% opacity
  );

  /// Gray color set
  static final SkillColorSet gray = SkillColorSet(
    name: 'gray',
    mainColor: const Color(0xFF444444),
    borderColor: const Color(0xFF555555),
    shadowColor: const Color(
      0xFF000000,
    ).withValues(alpha: 0.251), // 25.1% opacity
  );

  /// Yellow color set
  static final SkillColorSet yellow = SkillColorSet(
    name: 'yellow',
    mainColor: const Color(0xFF4D4D44),
    borderColor: const Color(0xFF606055),
    shadowColor: const Color(
      0xFF000000,
    ).withValues(alpha: 0.1451), // 14.51% opacity
  );

  /// Purple color set
  static final SkillColorSet purple = SkillColorSet(
    name: 'purple',
    mainColor: const Color(0xFF3A3344),
    borderColor: const Color(0xFF554C60),
    shadowColor: const Color(
      0xFF000000,
    ).withValues(alpha: 0.1882), // 18.82% opacity
  );

  /// Get all available color sets
  static List<SkillColorSet> get all => [blue, green, gray, yellow, purple];

  /// Get color set by name
  static SkillColorSet? getByName(String name) {
    for (final colorSet in all) {
      if (colorSet.name == name.toLowerCase()) {
        return colorSet;
      }
    }
    return null;
  }

  /// Get random color set
  static SkillColorSet getRandom() {
    return all[DateTime.now().millisecond % all.length];
  }

  /// Get color set by index (0-4)
  static SkillColorSet getByIndex(int index) {
    if (index < 0 || index >= all.length) {
      throw ArgumentError('Index must be between 0 and ${all.length - 1}');
    }
    return all[index];
  }

  /// Get color set names
  static List<String> getNames() {
    return all.map((colorSet) => colorSet.name).toList();
  }

  /// Helper method to create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Helper method to create shadow colors with proper opacity
  static Color createShadowColor(Color baseColor, double opacityPercent) {
    return baseColor.withValues(alpha: opacityPercent / 100.0);
  }
}

/// Represents a complete color set for a skill
class SkillColorSet {
  final String name;
  final Color mainColor;
  final Color borderColor;
  final Color shadowColor;

  const SkillColorSet({
    required this.name,
    required this.mainColor,
    required this.borderColor,
    required this.shadowColor,
  });

  /// Create a copy with updated values
  SkillColorSet copyWith({
    String? name,
    Color? mainColor,
    Color? borderColor,
    Color? shadowColor,
  }) {
    return SkillColorSet(
      name: name ?? this.name,
      mainColor: mainColor ?? this.mainColor,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mainColor': mainColor.value,
      'borderColor': borderColor.value,
      'shadowColor': shadowColor.value,
    };
  }

  /// Create from JSON
  factory SkillColorSet.fromJson(Map<String, dynamic> json) {
    return SkillColorSet(
      name: json['name'] as String,
      mainColor: Color(json['mainColor'] as int),
      borderColor: Color(json['borderColor'] as int),
      shadowColor: Color(json['shadowColor'] as int),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillColorSet &&
        other.name == name &&
        other.mainColor == mainColor &&
        other.borderColor == borderColor &&
        other.shadowColor == shadowColor;
  }

  @override
  int get hashCode {
    return Object.hash(name, mainColor, borderColor, shadowColor);
  }

  @override
  String toString() {
    return 'SkillColorSet(name: $name, mainColor: $mainColor, borderColor: $borderColor, shadowColor: $shadowColor)';
  }
}
