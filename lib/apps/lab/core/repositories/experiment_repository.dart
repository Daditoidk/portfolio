import 'package:flutter/material.dart';
import '../models/experiment.dart';

/// Repository for managing experiments in the lab
class ExperimentRepository {
  static final ExperimentRepository _instance =
      ExperimentRepository._internal();
  factory ExperimentRepository() => _instance;
  ExperimentRepository._internal();

  // List of all experiments
  final List<Experiment> _experiments = [
    // Text Order Visualizer
    Experiment(
      id: 'text_order_visualizer',
      title: 'Text Order Visualizer',
      description:
          'Visual tool for organizing and ordering text elements across web pages into lines and blocks. Perfect for structuring content layout.',
      tags: ['visualizer', 'text', 'order', 'layout', 'structure', 'web'],
      type: ExperimentType.editor,
      status: ExperimentStatus.active,
      // accentColor: const Color(0xFFfcf866), // Yellow for editor
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 15),
      author: 'Camilo Santacruz',
      version: '1.0.0',
      metadata: {
        'features': [
          'drag_and_drop',
          'block_management',
          'json_export',
          'text_detection',
          'visual_ordering',
        ],
        'complexity': 'medium',
        'category': 'development_tool',
      },
    ),

    // Animation Editor (placeholder for now)
    Experiment(
      id: 'animation_editor',
      title: 'Animation Editor',
      description:
          'Comprehensive animation system for language changes, viewport-aware animations, and performance monitoring.',
      tags: ['animation', 'language', 'viewport', 'performance', 'system'],
      type: ExperimentType.animation,
      status: ExperimentStatus.beta,
      // accentColor: const Color(0xFF7ef7fc), // Cyan for animation
      createdAt: DateTime(2024, 1, 10),
      updatedAt: DateTime(2024, 1, 15),
      author: 'Camilo Santacruz',
      version: '0.9.0',
      metadata: {
        'features': [
          'viewport_aware',
          'language_change',
          'performance_monitor',
          'json_integration',
        ],
        'complexity': 'high',
        'category': 'animation_system',
      },
    ),

    // DIY Inbox Cleaner (2025 Edition)
    Experiment(
      id: 'diy_inbox_cleaner',
      title: 'DIY Inbox Cleaner (2025 Edition)',
      description:
          'A modern Flutter mobile application that empowers users to take full control of their Gmail inbox with AI-powered categorization and secure, on-device processing.',
      tags: [
        'flutter',
        'gmail',
        'ai',
        'privacy',
        'mobile',
        'automation',
        'security',
      ],
      type: ExperimentType.tool,
      status: ExperimentStatus.planned,
      accentColor: const Color(0xFF4CAF50), // Green for Gmail/email
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
      author: 'Camilo Santacruz',
      version: '0.0.1',
      metadata: {
        'features': [
          'gmail_api_integration',
          'oauth_2_0_authentication',
          'ai_categorization',
          'bulk_operations',
          'offline_first',
          'secure_storage',
          'push_notifications',
        ],
        'complexity': 'high',
        'category': 'mobile_app',
        'target_platform': 'mobile',
        'api_integration': 'gmail_api',
        'ai_features': true,
        'security_level': 'high',
      },
    ),
  ];

  /// Get all experiments
  List<Experiment> getAllExperiments() {
    return List.unmodifiable(_experiments);
  }

  /// Get experiments by type
  List<Experiment> getExperimentsByType(ExperimentType type) {
    return _experiments.where((exp) => exp.type == type).toList();
  }

  /// Get experiments by status
  List<Experiment> getExperimentsByStatus(ExperimentStatus status) {
    return _experiments.where((exp) => exp.status == status).toList();
  }

  /// Get experiments by tag
  List<Experiment> getExperimentsByTag(String tag) {
    return _experiments.where((exp) => exp.tags.contains(tag)).toList();
  }

  /// Search experiments
  List<Experiment> searchExperiments(String query) {
    if (query.isEmpty) return getAllExperiments();
    return _experiments.where((exp) => exp.matchesSearch(query)).toList();
  }

  /// Filter experiments
  List<Experiment> filterExperiments({
    List<ExperimentType>? types,
    List<ExperimentStatus>? statuses,
    List<String>? tagFilters,
  }) {
    return _experiments
        .where(
          (exp) => exp.matchesFilter(
            types: types,
            statuses: statuses,
            tagFilters: tagFilters,
          ),
        )
        .toList();
  }

  /// Get experiment by ID
  Experiment? getExperimentById(String id) {
    try {
      return _experiments.firstWhere((exp) => exp.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new experiment
  void addExperiment(Experiment experiment) {
    _experiments.add(experiment);
  }

  /// Update existing experiment
  bool updateExperiment(Experiment experiment) {
    final index = _experiments.indexWhere((exp) => exp.id == experiment.id);
    if (index != -1) {
      _experiments[index] = experiment;
      return true;
    }
    return false;
  }

  /// Remove experiment
  bool removeExperiment(String id) {
    final index = _experiments.indexWhere((exp) => exp.id == id);
    if (index != -1) {
      _experiments.removeAt(index);
      return true;
    }
    return false;
  }

  /// Get experiment statistics
  Map<String, dynamic> getStatistics() {
    final total = _experiments.length;
    final byType = <ExperimentType, int>{};
    final byStatus = <ExperimentStatus, int>{};
    final allTags = <String>{};

    for (final exp in _experiments) {
      byType[exp.type] = (byType[exp.type] ?? 0) + 1;
      byStatus[exp.status] = (byStatus[exp.status] ?? 0) + 1;
      allTags.addAll(exp.tags);
    }

    return {
      'total': total,
      'byType': byType,
      'byStatus': byStatus,
      'uniqueTags': allTags.length,
      'tags': allTags.toList()..sort(),
    };
  }

  /// Get all available tags
  List<String> getAllTags() {
    final tags = <String>{};
    for (final exp in _experiments) {
      tags.addAll(exp.tags);
    }
    return tags.toList()..sort();
  }

  /// Get all available types
  List<ExperimentType> getAllTypes() {
    return ExperimentType.values.toList();
  }

  /// Get all available statuses
  List<ExperimentStatus> getAllStatuses() {
    return ExperimentStatus.values.toList();
  }
}
