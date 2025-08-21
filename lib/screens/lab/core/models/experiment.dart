import 'package:flutter/material.dart';

/// Type of experiment
enum ExperimentType {
  tool, // Development tools
  editor, // Visual editors
  animation, // Animation systems
  widget, // UI widgets
  brick, // Code bricks/templates
  exception, // Exception handlers
  ai, // AI experiments
  other, // Other experiments
}

/// Status of the experiment
enum ExperimentStatus {
  active, // Currently working
  beta, // In development
  deprecated, // No longer maintained
  planned, // Planned for future
}

/// Represents an experiment in the lab
class Experiment {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final Color? accentColor;
  final List<String> tags;
  final ExperimentType type;
  final ExperimentStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? author;
  final String? version;
  final bool isPublic;
  final Map<String, dynamic> metadata;

  const Experiment({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.accentColor,
    required this.tags,
    required this.type,
    this.status = ExperimentStatus.active,
    required this.createdAt,
    this.updatedAt,
    this.author,
    this.version,
    this.isPublic = true,
    this.metadata = const {},
  });

  /// Create a copy with updated fields
  Experiment copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    Color? accentColor,
    List<String>? tags,
    ExperimentType? type,
    ExperimentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    String? version,
    bool? isPublic,
    Map<String, dynamic>? metadata,
  }) {
    return Experiment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      accentColor: accentColor ?? this.accentColor,
      tags: tags ?? this.tags,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      version: version ?? this.version,
      isPublic: isPublic ?? this.isPublic,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get display color based on type
  Color get displayColor {
    if (accentColor != null) return accentColor!;

    switch (type) {
      case ExperimentType.tool:
        return Colors.blue.shade600;
      case ExperimentType.editor:
        return Colors.green.shade600;
      case ExperimentType.animation:
        return Colors.purple.shade600;
      case ExperimentType.widget:
        return Colors.orange.shade600;
      case ExperimentType.brick:
        return Colors.teal.shade600;
      case ExperimentType.exception:
        return Colors.red.shade600;
      case ExperimentType.ai:
        return Colors.indigo.shade600;
      case ExperimentType.other:
        return Colors.grey.shade600;
    }
  }

  /// Get status color
  Color get statusColor {
    switch (status) {
      case ExperimentStatus.active:
        return Colors.green;
      case ExperimentStatus.beta:
        return Colors.orange;
      case ExperimentStatus.deprecated:
        return Colors.red;
      case ExperimentStatus.planned:
        return Colors.blue;
    }
  }

  /// Get status text
  String get statusText {
    switch (status) {
      case ExperimentStatus.active:
        return 'Active';
      case ExperimentStatus.beta:
        return 'Beta';
      case ExperimentStatus.deprecated:
        return 'Deprecated';
      case ExperimentStatus.planned:
        return 'Planned';
    }
  }

  /// Get type text
  String get typeText {
    switch (type) {
      case ExperimentType.tool:
        return 'Tool';
      case ExperimentType.editor:
        return 'Editor';
      case ExperimentType.animation:
        return 'Animation';
      case ExperimentType.widget:
        return 'Widget';
      case ExperimentType.brick:
        return 'Brick';
      case ExperimentType.exception:
        return 'Exception';
      case ExperimentType.ai:
        return 'AI';
      case ExperimentType.other:
        return 'Other';
    }
  }

  /// Check if experiment matches search query
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery) ||
        tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
        typeText.toLowerCase().contains(lowerQuery);
  }

  /// Check if experiment matches filter
  bool matchesFilter({
    List<ExperimentType>? types,
    List<ExperimentStatus>? statuses,
    List<String>? tagFilters,
  }) {
    if (types != null && !types.contains(type)) return false;
    if (statuses != null && !statuses.contains(status)) return false;
    if (tagFilters != null && !tagFilters.any((tag) => tags.contains(tag))) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'Experiment(id: $id, title: $title, type: $type, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Experiment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
