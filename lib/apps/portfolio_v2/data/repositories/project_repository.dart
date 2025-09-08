import '../models/project.dart';
import '../enums/project_type.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Repository for managing Project data
/// This is where you create, read, update, and delete Project objects
class ProjectRepository {
  // In a real app, this would connect to a database, API, or local storage
  // For now, we'll use in-memory storage as an example
  final List<Project> _projects = [];

  /// Get all projects
  List<Project> getAllProjects() {
    return List.unmodifiable(_projects);
  }

  /// Get projects by company name
  List<Project> getProjectsByCompany(String companyName) {
    return _projects
        .where(
          (project) =>
              project.companyName.toLowerCase() == companyName.toLowerCase(),
        )
        .toList();
  }

  /// Get projects by type
  List<Project> getProjectsByType(ProjectType projectType) {
    return _projects
        .where((project) => project.projectType == projectType)
        .toList();
  }

  /// Get projects by type display name
  List<Project> getProjectsByTypeName(String projectTypeName) {
    final projectType = ProjectType.fromDisplayName(projectTypeName);
    if (projectType == null) return [];
    return getProjectsByType(projectType);
  }

  /// Get projects by hashtag
  List<Project> getProjectsByHashtag(String hashtag) {
    return _projects.where((project) => project.hasHashtag(hashtag)).toList();
  }

  /// Get projects by location
  List<Project> getProjectsByLocation(String location) {
    return _projects
        .where(
          (project) => project.companyLocation.toLowerCase().contains(
            location.toLowerCase(),
          ),
        )
        .toList();
  }

  /// Get a project by name
  Project? getProjectByName(String projectName) {
    try {
      return _projects.firstWhere(
        (project) =>
            project.projectName.toLowerCase() == projectName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get a project by company and project name
  Project? getProjectByCompanyAndName(String companyName, String projectName) {
    try {
      return _projects.firstWhere(
        (project) =>
            project.companyName.toLowerCase() == companyName.toLowerCase() &&
            project.projectName.toLowerCase() == projectName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Add a new project
  void addProject(Project project) {
    // Check if project already exists
    final existingProject = getProjectByCompanyAndName(
      project.companyName,
      project.projectName,
    );

    if (existingProject != null) {
      throw Exception(
        'Project "${project.projectName}" at "${project.companyName}" already exists',
      );
    }

    _projects.add(project);
  }

  /// Update an existing project
  void updateProject(
    String companyName,
    String projectName,
    Project updatedProject,
  ) {
    final index = _projects.indexWhere(
      (project) =>
          project.companyName.toLowerCase() == companyName.toLowerCase() &&
          project.projectName.toLowerCase() == projectName.toLowerCase(),
    );

    if (index == -1) {
      throw Exception('Project "$projectName" at "$companyName" not found');
    }

    _projects[index] = updatedProject;
  }

  /// Delete a project by company and project name
  void deleteProject(String companyName, String projectName) {
    final index = _projects.indexWhere(
      (project) =>
          project.companyName.toLowerCase() == companyName.toLowerCase() &&
          project.projectName.toLowerCase() == projectName.toLowerCase(),
    );

    if (index == -1) {
      throw Exception('Project "$projectName" at "$companyName" not found');
    }

    _projects.removeAt(index);
  }

  /// Clear all projects
  void clearAllProjects() {
    _projects.clear();
  }

  /// Get total number of projects
  int get projectCount => _projects.length;

  /// Get all unique companies
  List<String> getAllCompanies() {
    final companies = <String>{};
    for (final project in _projects) {
      companies.add(project.companyName);
    }
    return companies.toList()..sort();
  }

  /// Get all unique project types
  List<ProjectType> getAllProjectTypes() {
    final types = <ProjectType>{};
    for (final project in _projects) {
      types.add(project.projectType);
    }
    return types.toList();
  }

  /// Get all unique project type display names
  List<String> getAllProjectTypeNames() {
    return getAllProjectTypes().map((type) => type.displayName).toList()
      ..sort();
  }

  /// Get all unique hashtags
  List<String> getAllHashtags() {
    final hashtags = <String>{};
    for (final project in _projects) {
      hashtags.addAll(project.getHashtagsList());
    }
    return hashtags.toList()..sort();
  }

  /// Get all unique locations
  List<String> getAllLocations() {
    final locations = <String>{};
    for (final project in _projects) {
      locations.add(project.companyLocation);
    }
    return locations.toList()..sort();
  }

  /// Search projects by name, description, or company (case-insensitive)
  List<Project> searchProjects(String query) {
    if (query.isEmpty) return getAllProjects();

    final lowercaseQuery = query.toLowerCase();
    return _projects
        .where(
          (project) =>
              project.projectName.toLowerCase().contains(lowercaseQuery) ||
              project.projectDescription.toLowerCase().contains(
                lowercaseQuery,
              ) ||
              project.companyName.toLowerCase().contains(lowercaseQuery) ||
              project.projectDetailInfo.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Get projects sorted by company name
  List<Project> getProjectsSortedByCompany() {
    final sortedProjects = List<Project>.from(_projects);
    sortedProjects.sort((a, b) => a.companyName.compareTo(b.companyName));
    return sortedProjects;
  }

  /// Get projects sorted by project name
  List<Project> getProjectsSortedByProjectName() {
    final sortedProjects = List<Project>.from(_projects);
    sortedProjects.sort((a, b) => a.projectName.compareTo(b.projectName));
    return sortedProjects;
  }

  /// Get projects sorted by type
  List<Project> getProjectsSortedByType() {
    final sortedProjects = List<Project>.from(_projects);
    sortedProjects.sort(
      (a, b) => a.projectType.displayName.compareTo(b.projectType.displayName),
    );
    return sortedProjects;
  }

  /// Get projects that have main media
  List<Project> getProjectsWithMainMedia() {
    return _projects.where((project) => project.hasMainMedia).toList();
  }

  /// Initialize with real projects data
  void initializeWithSampleData([AppLocalizations? l10n]) {
    clearAllProjects();

    // Brain4Goals Project
    addProject(
      Project(
        companyName: 'Brain 4 Goals',
        companyLogo: 'assets/portfolio/projects/b4s/logomark.png',
        companyLocation: 'Barcelona, España',
        projectName: 'Brain4Goals App',
        projectDescription:
            l10n?.projectBrain4GoalsDescription ??
            'I led the development of Brain4Goals, a cross-platform mobile app built with Flutter that helps young footballers track performance and mental wellness. The app provides personalised, AI-powered recommendations based on weekly evaluations. I collaborated with a team of designers and a backend developer, using Scrum methodology, to deliver this project.',
        projectType: ProjectType.liveDemo,
        projectHashtags:
            '#Flutter #iOS #Android #MobileDevelopment #Scrum #UX/UI #AI #SportsTech #Football #PlayerDevelopment #MentalWellness #PerformanceTracking #AppStore #PlayStore',
        mediaMainRectangle: null, // Will show demo instead
        mediaSecondRectangle:
            'assets/portfolio/projects/b4s/secondary_media.mov',
        projectDetailInfo:
            'Brain4Goals is a comprehensive mobile application designed to support young footballers in their development journey. The app combines performance tracking with mental wellness features, providing a holistic approach to player development.\n\nKey Features:\n• Cross-platform mobile app built with Flutter\n• AI-powered personalized recommendations\n• Weekly performance evaluations\n• Mental wellness tracking and support\n• Team collaboration tools\n• Scrum methodology implementation\n• Available on both App Store and Play Store\n\nTechnical Implementation:\n• Flutter framework for cross-platform development\n• AI integration for personalized recommendations\n• Real-time data synchronization\n• User-friendly interface with focus on UX/UI\n• Integration with backend services\n• Comprehensive testing and quality assurance\n\nThis project demonstrates expertise in mobile development, AI integration, team collaboration, and agile methodologies.',
        projectDetailMedia1: 'assets/projects/brain4goals_detail1.png',
        projectDetailMedia2: 'assets/projects/brain4goals_detail2.png',
      ),
    );

    // Kinpos Corporation Project
    addProject(
      Project(
        companyName: 'Kinpos Corporation',
        companyLogo: 'assets/portfolio/projects/kinpos/logomark.png',
        companyLocation: 'Miami, USA',
        projectName: 'POS and MPOS apps Migration to Flutter',
        projectDescription:
            l10n?.projectKinposDescription ??
            'I was part of the innovation team that migrated multiple MPOS and POS applications to a single, unified Flutter codebase. This new architecture leveraged Kotlin Multiplatform and Flutter plugins to consolidate over seven individual apps into one streamlined solution. The project achieved a 66% reduction in update time and a 30% reduction in new feature implementation by allowing changes to be made once and applied across all clients.',
        projectType: ProjectType.projectOverview,
        projectHashtags:
            '#FlutterDev #KotlinMultiplatform #CrossPlatform #POS #MPOS #MonolithicArchitecture #StateManagement #BLoC #FlutterPlugins #Migration #CodebaseUnification #MobileDevelopment #NativeInteroperability',
        mediaMainRectangle: 'assets/portfolio/projects/kinpos/main_media.mp4',
        mediaSecondRectangle:
            'assets/portfolio/projects/kinpos/secondary_media.png',
        projectDetailInfo:
            'This project involved a comprehensive migration strategy to consolidate multiple Point of Sale (POS) and Mobile Point of Sale (MPOS) applications into a unified Flutter-based solution. The migration addressed significant technical debt and operational inefficiencies in the existing system.\n\nProject Challenges:\n• Multiple legacy applications with different codebases\n• Inconsistent user experiences across platforms\n• High maintenance overhead for updates and new features\n• Complex business logic scattered across different apps\n• Native platform dependencies and integrations\n\nSolution Architecture:\n• Unified Flutter codebase for cross-platform consistency\n• Kotlin Multiplatform integration for shared business logic\n• Custom Flutter plugins for native functionality\n• BLoC state management for complex application state\n• Monolithic architecture for simplified deployment\n• Native interoperability for platform-specific features\n\nKey Achievements:\n• 66% reduction in update deployment time\n• 30% reduction in new feature implementation time\n• Consolidated 7+ individual applications into 1 solution\n• Improved code maintainability and consistency\n• Enhanced developer productivity and team collaboration\n• Reduced technical debt and operational complexity\n\nTechnical Implementation:\n• Flutter framework for cross-platform development\n• Kotlin Multiplatform for shared business logic\n• Custom Flutter plugins for native integrations\n• BLoC pattern for state management\n• Comprehensive testing and quality assurance\n• CI/CD pipeline optimization\n• Performance monitoring and analytics\n\nThis project demonstrates expertise in large-scale application migration, cross-platform development, architecture design, and team leadership in complex enterprise environments.',
        projectDetailMedia1:
            'assets/portfolio/projects/kinpos/detail_media1.png',
        projectDetailMedia2:
            'assets/portfolio/projects/kinpos/detail_media2.png',
      ),
    );
  }

  /// Initialize with localized data using BuildContext
  void initializeWithLocalizedData(AppLocalizations l10n) {
    initializeWithSampleData(l10n);
  }

  /// Initialize with default English data (fallback)
  void initializeWithDefaultData() {
    initializeWithSampleData();
  }
}
