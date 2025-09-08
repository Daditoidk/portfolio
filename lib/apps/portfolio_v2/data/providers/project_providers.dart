import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/project_repository.dart';
import '../models/project.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Provider for ProjectRepository instance
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final repository = ProjectRepository();
  // Initialize with default data
  repository.initializeWithDefaultData();
  return repository;
});

/// Provider for all projects
final projectsProvider = Provider<List<Project>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAllProjects();
});

/// Provider for projects with localized data
final localizedProjectsProvider =
    Provider.family<List<Project>, AppLocalizations>((ref, l10n) {
      final repository = ref.watch(projectRepositoryProvider);
      repository.initializeWithLocalizedData(l10n);
      return repository.getAllProjects();
    });
