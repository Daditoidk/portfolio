import '../constants/skill_colors.dart';

class Skill {
  final String name;
  final int yearOfExperience;
  final String image;
  final bool activelyBeingUsed;
  final Map<String, List<String>> details;
  final SkillColorSet colorSet;

  const Skill({
    required this.name,
    required this.yearOfExperience,
    required this.image,
    required this.activelyBeingUsed,
    required this.details,
    required this.colorSet,
  });

  /// Create a copy of this skill with updated values
  Skill copyWith({
    String? name,
    int? yearOfExperience,
    String? image,
    bool? activelyBeingUsed,
    Map<String, List<String>>? details,
    SkillColorSet? colorSet,
  }) {
    return Skill(
      name: name ?? this.name,
      yearOfExperience: yearOfExperience ?? this.yearOfExperience,
      image: image ?? this.image,
      activelyBeingUsed: activelyBeingUsed ?? this.activelyBeingUsed,
      details: details ?? this.details,
      colorSet: colorSet ?? this.colorSet,
    );
  }

  /// Convert Skill to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'yearOfExperience': yearOfExperience,
      'image': image,
      'activelyBeingUsed': activelyBeingUsed,
      'details': details,
      'colorSet': colorSet.toJson(),
    };
  }

  /// Create Skill from JSON
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      yearOfExperience: json['yearOfExperience'] as int,
      image: json['image'] as String,
      activelyBeingUsed: json['activelyBeingUsed'] as bool,
      details: Map<String, List<String>>.from(
        (json['details'] as Map).map(
          (key, value) =>
              MapEntry(key as String, List<String>.from(value as List)),
        ),
      ),
      colorSet: SkillColorSet.fromJson(
        json['colorSet'] as Map<String, dynamic>,
      ),
    );
  }

  /// Get all technologies from all categories
  List<String> getAllTechnologies() {
    return details.values.expand((technologies) => technologies).toList();
  }

  /// Get technologies for a specific category
  List<String> getTechnologiesForCategory(String category) {
    return details[category] ?? [];
  }

  /// Get all category names
  List<String> getCategories() {
    return details.keys.toList();
  }

  /// Check if skill has a specific technology
  bool hasTechnology(String technology) {
    return getAllTechnologies().any(
      (tech) => tech.toLowerCase() == technology.toLowerCase(),
    );
  }

  /// Check if skill has a specific category
  bool hasCategory(String category) {
    return details.containsKey(category);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Skill &&
        other.name == name &&
        other.yearOfExperience == yearOfExperience &&
        other.image == image &&
        other.activelyBeingUsed == activelyBeingUsed &&
        other.colorSet == colorSet &&
        _mapEquals(other.details, details);
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      yearOfExperience,
      image,
      activelyBeingUsed,
      colorSet,
      details,
    );
  }

  @override
  String toString() {
    return 'Skill(name: $name, yearOfExperience: $yearOfExperience, image: $image, activelyBeingUsed: $activelyBeingUsed, colorSet: $colorSet, details: $details)';
  }

  /// Helper method to compare maps
  bool _mapEquals(
    Map<String, List<String>> map1,
    Map<String, List<String>> map2,
  ) {
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      if (!_listEquals(map1[key]!, map2[key]!)) return false;
    }

    return true;
  }

  /// Helper method to compare lists
  bool _listEquals(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }
}
