import '../enums/project_type.dart';

class Project {
  final String companyName;
  final String companyLogo;
  final String companyLocation;
  final String projectName;
  final String projectDescription;
  final ProjectType projectType;
  final String projectHashtags;
  final String? mediaMainRectangle;
  final String mediaSecondRectangle;
  final String projectDetailInfo;
  final String projectDetailMedia1;
  final String projectDetailMedia2;

  const Project({
    required this.companyName,
    required this.companyLogo,
    required this.companyLocation,
    required this.projectName,
    required this.projectDescription,
    required this.projectType,
    required this.projectHashtags,
    this.mediaMainRectangle,
    required this.mediaSecondRectangle,
    required this.projectDetailInfo,
    required this.projectDetailMedia1,
    required this.projectDetailMedia2,
  });

  /// Create a copy of this project with updated values
  Project copyWith({
    String? companyName,
    String? companyLogo,
    String? companyLocation,
    String? projectName,
    String? projectDescription,
    ProjectType? projectType,
    String? projectHashtags,
    String? mediaMainRectangle,
    String? mediaSecondRectangle,
    String? projectDetailInfo,
    String? projectDetailMedia1,
    String? projectDetailMedia2,
  }) {
    return Project(
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      companyLocation: companyLocation ?? this.companyLocation,
      projectName: projectName ?? this.projectName,
      projectDescription: projectDescription ?? this.projectDescription,
      projectType: projectType ?? this.projectType,
      projectHashtags: projectHashtags ?? this.projectHashtags,
      mediaMainRectangle: mediaMainRectangle ?? this.mediaMainRectangle,
      mediaSecondRectangle: mediaSecondRectangle ?? this.mediaSecondRectangle,
      projectDetailInfo: projectDetailInfo ?? this.projectDetailInfo,
      projectDetailMedia1: projectDetailMedia1 ?? this.projectDetailMedia1,
      projectDetailMedia2: projectDetailMedia2 ?? this.projectDetailMedia2,
    );
  }

  /// Convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companyLogo': companyLogo,
      'companyLocation': companyLocation,
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectType': projectType.name,
      'projectHashtags': projectHashtags,
      'mediaMainRectangle': mediaMainRectangle,
      'mediaSecondRectangle': mediaSecondRectangle,
      'projectDetailInfo': projectDetailInfo,
      'projectDetailMedia1': projectDetailMedia1,
      'projectDetailMedia2': projectDetailMedia2,
    };
  }

  /// Create Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      companyName: json['companyName'] as String,
      companyLogo: json['companyLogo'] as String,
      companyLocation: json['companyLocation'] as String,
      projectName: json['projectName'] as String,
      projectDescription: json['projectDescription'] as String,
      projectType: ProjectType.values.firstWhere(
        (type) => type.name == json['projectType'],
        orElse: () => ProjectType.projectOverview,
      ),
      projectHashtags: json['projectHashtags'] as String,
      mediaMainRectangle: json['mediaMainRectangle'] as String?,
      mediaSecondRectangle: json['mediaSecondRectangle'] as String,
      projectDetailInfo: json['projectDetailInfo'] as String,
      projectDetailMedia1: json['projectDetailMedia1'] as String,
      projectDetailMedia2: json['projectDetailMedia2'] as String,
    );
  }

  /// Get hashtags as a list
  List<String> getHashtagsList() {
    return projectHashtags
        .split(' ')
        .where((tag) => tag.isNotEmpty)
        .map((tag) => tag.startsWith('#') ? tag : '#$tag')
        .toList();
  }

  /// Check if project has a specific hashtag
  bool hasHashtag(String hashtag) {
    final normalizedHashtag = hashtag.startsWith('#') ? hashtag : '#$hashtag';
    return getHashtagsList().any(
      (tag) => tag.toLowerCase() == normalizedHashtag.toLowerCase(),
    );
  }

  /// Get all media URLs as a list
  List<String> getAllMedia() {
    final mediaList = <String>[];

    if (mediaMainRectangle != null) {
      mediaList.add(mediaMainRectangle!);
    }

    mediaList.addAll([
      mediaSecondRectangle,
      projectDetailMedia1,
      projectDetailMedia2,
    ]);

    return mediaList;
  }

  /// Check if project has main media
  bool get hasMainMedia => mediaMainRectangle != null;

  /// Get project display title (company + project name)
  String get displayTitle => '$companyName - $projectName';

  /// Get project short description (first 100 characters)
  String get shortDescription {
    if (projectDescription.length <= 100) {
      return projectDescription;
    }
    return '${projectDescription.substring(0, 100)}...';
  }

  /// Get project type display name
  String get projectTypeDisplayName => projectType.displayName;

  /// Check if this is a live demo project
  bool get isLiveDemo => projectType.isDemo;

  /// Check if this is a project overview
  bool get isProjectOverview => projectType.isOverview;

  /// Check if this is a prototype project
  bool get isPrototype => projectType.isPrototype;

  /// Check if this is an open source project
  bool get isOpenSource => projectType.isOpenSource;

  /// Check if this is a personal project
  bool get isPersonal => projectType.isPersonal;

  /// Check if this is an enterprise project
  bool get isEnterprise => projectType.isEnterprise;

  /// Get project category
  ProjectCategory get category => projectType.category;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project &&
        other.companyName == companyName &&
        other.companyLogo == companyLogo &&
        other.companyLocation == companyLocation &&
        other.projectName == projectName &&
        other.projectDescription == projectDescription &&
        other.projectType == projectType &&
        other.projectHashtags == projectHashtags &&
        other.mediaMainRectangle == mediaMainRectangle &&
        other.mediaSecondRectangle == mediaSecondRectangle &&
        other.projectDetailInfo == projectDetailInfo &&
        other.projectDetailMedia1 == projectDetailMedia1 &&
        other.projectDetailMedia2 == projectDetailMedia2;
  }

  @override
  int get hashCode {
    return Object.hash(
      companyName,
      companyLogo,
      companyLocation,
      projectName,
      projectDescription,
      projectType,
      projectHashtags,
      mediaMainRectangle,
      mediaSecondRectangle,
      projectDetailInfo,
      projectDetailMedia1,
      projectDetailMedia2,
    );
  }

  @override
  String toString() {
    return 'Project(companyName: $companyName, projectName: $projectName, projectType: $projectType, projectHashtags: $projectHashtags)';
  }
}
