/// Enum representing different types of projects
enum ProjectType {
  /// Live demo projects - working applications that can be demonstrated
  liveDemo('Live Demo'),

  /// Project overview - detailed case studies of completed projects
  projectOverview('Project Overview'),

  /// Prototype - early-stage or experimental projects
  prototype('Prototype'),

  /// Open source - publicly available projects
  openSource('Open Source'),

  /// Personal - personal side projects
  personal('Personal'),

  /// Enterprise - large-scale business applications
  enterprise('Enterprise'),

  /// Mobile app - mobile application projects
  mobileApp('Mobile App'),

  /// Web app - web application projects
  webApp('Web App'),

  /// Desktop app - desktop application projects
  desktopApp('Desktop App'),

  /// Full stack - full-stack development projects
  fullStack('Full Stack');

  const ProjectType(this.displayName);

  /// The display name for the project type
  final String displayName;

  /// Get project type by display name
  static ProjectType? fromDisplayName(String displayName) {
    for (final type in ProjectType.values) {
      if (type.displayName == displayName) {
        return type;
      }
    }
    return null;
  }

  /// Get all display names
  static List<String> getAllDisplayNames() {
    return ProjectType.values.map((type) => type.displayName).toList();
  }

  /// Check if this is a demo-type project
  bool get isDemo => this == ProjectType.liveDemo;

  /// Check if this is an overview-type project
  bool get isOverview => this == ProjectType.projectOverview;

  /// Check if this is a prototype project
  bool get isPrototype => this == ProjectType.prototype;

  /// Check if this is an open source project
  bool get isOpenSource => this == ProjectType.openSource;

  /// Check if this is a personal project
  bool get isPersonal => this == ProjectType.personal;

  /// Check if this is an enterprise project
  bool get isEnterprise => this == ProjectType.enterprise;

  /// Check if this is a mobile project
  bool get isMobile => this == ProjectType.mobileApp;

  /// Check if this is a web project
  bool get isWeb => this == ProjectType.webApp;

  /// Check if this is a desktop project
  bool get isDesktop => this == ProjectType.desktopApp;

  /// Check if this is a full-stack project
  bool get isFullStack => this == ProjectType.fullStack;

  /// Get category of the project type
  ProjectCategory get category {
    switch (this) {
      case ProjectType.liveDemo:
      case ProjectType.projectOverview:
        return ProjectCategory.showcase;
      case ProjectType.prototype:
      case ProjectType.personal:
        return ProjectCategory.experimental;
      case ProjectType.openSource:
        return ProjectCategory.community;
      case ProjectType.enterprise:
      case ProjectType.mobileApp:
      case ProjectType.webApp:
      case ProjectType.desktopApp:
      case ProjectType.fullStack:
        return ProjectCategory.professional;
    }
  }

  @override
  String toString() => displayName;
}

/// Categories for grouping project types
enum ProjectCategory {
  /// Showcase projects - for demonstrating skills and capabilities
  showcase('Showcase'),

  /// Experimental projects - prototypes and personal experiments
  experimental('Experimental'),

  /// Community projects - open source contributions
  community('Community'),

  /// Professional projects - enterprise and business applications
  professional('Professional');

  const ProjectCategory(this.displayName);

  /// The display name for the project category
  final String displayName;

  /// Get all project types in this category
  List<ProjectType> get projectTypes {
    return ProjectType.values.where((type) => type.category == this).toList();
  }

  @override
  String toString() => displayName;
}
