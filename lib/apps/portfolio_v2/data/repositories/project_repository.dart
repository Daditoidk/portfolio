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
              project.combinedDetailText.toLowerCase().contains(lowercaseQuery),
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
        id: 'brain4goals-app',
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
        companyTeamAndObjectivesParagraph1:
            'Brain4Goals helps youth football academies align athletes, coaches, and families around shared performance objectives.',
        companyTeamAndObjectivesParagraph2:
            'I partnered with product, design, and data teams to deliver a Flutter experience that works seamlessly on iOS and Android.',
        companyTeamAndObjectivesParagraph3:
            'Our objective was to give players one place to track progress, receive coaching insights, and stay motivated throughout the season.',
        companyTeamAndObjectivesMedia: '',
        requestOrProblemParagraph1:
            'The academy relied on spreadsheets and disconnected tools, making it hard to see trends in player wellness or performance.',
        requestOrProblemParagraph2:
            'Stakeholders needed a secure way to centralise evaluations, weekly check-ins, and AI-driven recommendations.',
        requestOrProblemParagraph3:
            'The existing process created silos between coaches and support staff, slowing down interventions for the players who needed them most.',
        requestOrProblemMedia: '',
        solutionParagraph1:
            'We built a cross-platform Flutter app with personalised dashboards, progress visualisations, and structured evaluations.',
        solutionParagraph2:
            'AI-driven insights surface focus areas for each athlete while Scrum ceremonies kept the delivery cadence predictable.',
        solutionParagraph3:
            'Deep testing and a scalable architecture mean new clubs can onboard quickly without sacrificing data quality.',
        solutionMedia: '',
      ),
    );

    // Kinpos Corporation Project
    addProject(
      Project(
        id: 'kinpos-corporation-refactoring',
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
        companyTeamAndObjectivesParagraph1:
            'Kinpos needed a unified platform to support enterprise retailers with both POS and MPOS experiences.',
        companyTeamAndObjectivesParagraph2:
            'Our distributed team included Flutter engineers, Kotlin specialists, QA, and product stakeholders across the Americas.',
        companyTeamAndObjectivesParagraph3:
            'The shared objective: reduce maintenance overhead while delivering a consistent interface to every franchise partner.',
        companyTeamAndObjectivesMedia: '',
        requestOrProblemParagraph1:
            'Legacy native apps were expensive to update and introduced feature drift between markets.',
        requestOrProblemParagraph2:
            'Merchants needed faster rollouts, but fragmented codebases made regression risk unmanageable.',
        requestOrProblemParagraph3:
            'Offline support, fiscal integrations, and hardware compatibility all had to co-exist in one roadmap.',
        requestOrProblemMedia:
            'assets/portfolio/projects/kinpos/detail_media1.png',
        solutionParagraph1:
            'We migrated the suite to Flutter with Kotlin Multiplatform for shared business logic and custom plugins for peripherals.',
        solutionParagraph2:
            'Centralising UI and state management with BLoC gave us deterministic behaviour across every storefront.',
        solutionParagraph3:
            'Automation, CI/CD, and strong observability cut release times by 66% and simplified onboarding for new clients.',
        solutionMedia: 'assets/portfolio/projects/kinpos/detail_media2.png',
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
