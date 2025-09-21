import '../enums/project_type.dart';

class Project {
  final String id;
  final String companyName;
  final String companyLogo;
  final String companyLocation;
  final String projectName;
  final String projectDescription;
  final ProjectType projectType;
  final String projectHashtags;
  final String? mediaMainRectangle;
  final String mediaSecondRectangle;
  final String companyTeamAndObjectivesParagraph1;
  final String companyTeamAndObjectivesParagraph2;
  final String companyTeamAndObjectivesParagraph3;
  final String companyTeamAndObjectivesMedia;
  final String requestOrProblemParagraph1;
  final String requestOrProblemParagraph2;
  final String requestOrProblemParagraph3;
  final String requestOrProblemMedia;
  final String solutionParagraph1;
  final String solutionParagraph2;
  final String solutionParagraph3;
  final String solutionMedia;

  const Project({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.companyLocation,
    required this.projectName,
    required this.projectDescription,
    required this.projectType,
    required this.projectHashtags,
    this.mediaMainRectangle,
    required this.mediaSecondRectangle,
    required this.companyTeamAndObjectivesParagraph1,
    required this.companyTeamAndObjectivesParagraph2,
    required this.companyTeamAndObjectivesParagraph3,
    required this.companyTeamAndObjectivesMedia,
    required this.requestOrProblemParagraph1,
    required this.requestOrProblemParagraph2,
    required this.requestOrProblemParagraph3,
    required this.requestOrProblemMedia,
    required this.solutionParagraph1,
    required this.solutionParagraph2,
    required this.solutionParagraph3,
    required this.solutionMedia,
  });

  /// Create a copy of this project with updated values
  Project copyWith({
    String? id,
    String? companyName,
    String? companyLogo,
    String? companyLocation,
    String? projectName,
    String? projectDescription,
    ProjectType? projectType,
    String? projectHashtags,
    String? mediaMainRectangle,
    String? mediaSecondRectangle,
    String? companyTeamAndObjectivesParagraph1,
    String? companyTeamAndObjectivesParagraph2,
    String? companyTeamAndObjectivesParagraph3,
    String? companyTeamAndObjectivesMedia,
    String? requestOrProblemParagraph1,
    String? requestOrProblemParagraph2,
    String? requestOrProblemParagraph3,
    String? requestOrProblemMedia,
    String? solutionParagraph1,
    String? solutionParagraph2,
    String? solutionParagraph3,
    String? solutionMedia,
  }) {
    return Project(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyLogo: companyLogo ?? this.companyLogo,
      companyLocation: companyLocation ?? this.companyLocation,
      projectName: projectName ?? this.projectName,
      projectDescription: projectDescription ?? this.projectDescription,
      projectType: projectType ?? this.projectType,
      projectHashtags: projectHashtags ?? this.projectHashtags,
      mediaMainRectangle: mediaMainRectangle ?? this.mediaMainRectangle,
      mediaSecondRectangle: mediaSecondRectangle ?? this.mediaSecondRectangle,
      companyTeamAndObjectivesParagraph1:
          companyTeamAndObjectivesParagraph1 ??
          this.companyTeamAndObjectivesParagraph1,
      companyTeamAndObjectivesParagraph2:
          companyTeamAndObjectivesParagraph2 ??
          this.companyTeamAndObjectivesParagraph2,
      companyTeamAndObjectivesParagraph3:
          companyTeamAndObjectivesParagraph3 ??
          this.companyTeamAndObjectivesParagraph3,
      companyTeamAndObjectivesMedia:
          companyTeamAndObjectivesMedia ?? this.companyTeamAndObjectivesMedia,
      requestOrProblemParagraph1:
          requestOrProblemParagraph1 ?? this.requestOrProblemParagraph1,
      requestOrProblemParagraph2:
          requestOrProblemParagraph2 ?? this.requestOrProblemParagraph2,
      requestOrProblemParagraph3:
          requestOrProblemParagraph3 ?? this.requestOrProblemParagraph3,
      requestOrProblemMedia:
          requestOrProblemMedia ?? this.requestOrProblemMedia,
      solutionParagraph1: solutionParagraph1 ?? this.solutionParagraph1,
      solutionParagraph2: solutionParagraph2 ?? this.solutionParagraph2,
      solutionParagraph3: solutionParagraph3 ?? this.solutionParagraph3,
      solutionMedia: solutionMedia ?? this.solutionMedia,
    );
  }

  /// Convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'companyLocation': companyLocation,
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectType': projectType.name,
      'projectHashtags': projectHashtags,
      'mediaMainRectangle': mediaMainRectangle,
      'mediaSecondRectangle': mediaSecondRectangle,
      'companyTeamAndObjectivesParagraph1': companyTeamAndObjectivesParagraph1,
      'companyTeamAndObjectivesParagraph2': companyTeamAndObjectivesParagraph2,
      'companyTeamAndObjectivesParagraph3': companyTeamAndObjectivesParagraph3,
      'companyTeamAndObjectivesMedia': companyTeamAndObjectivesMedia,
      'requestOrProblemParagraph1': requestOrProblemParagraph1,
      'requestOrProblemParagraph2': requestOrProblemParagraph2,
      'requestOrProblemParagraph3': requestOrProblemParagraph3,
      'requestOrProblemMedia': requestOrProblemMedia,
      'solutionParagraph1': solutionParagraph1,
      'solutionParagraph2': solutionParagraph2,
      'solutionParagraph3': solutionParagraph3,
      'solutionMedia': solutionMedia,
    };
  }

  /// Create Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
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
      companyTeamAndObjectivesParagraph1:
          json['companyTeamAndObjectivesParagraph1'] as String,
      companyTeamAndObjectivesParagraph2:
          json['companyTeamAndObjectivesParagraph2'] as String,
      companyTeamAndObjectivesParagraph3:
          json['companyTeamAndObjectivesParagraph3'] as String,
      companyTeamAndObjectivesMedia:
          json['companyTeamAndObjectivesMedia'] as String,
      requestOrProblemParagraph1: json['requestOrProblemParagraph1'] as String,
      requestOrProblemParagraph2: json['requestOrProblemParagraph2'] as String,
      requestOrProblemParagraph3: json['requestOrProblemParagraph3'] as String,
      requestOrProblemMedia: json['requestOrProblemMedia'] as String,
      solutionParagraph1: json['solutionParagraph1'] as String,
      solutionParagraph2: json['solutionParagraph2'] as String,
      solutionParagraph3: json['solutionParagraph3'] as String,
      solutionMedia: json['solutionMedia'] as String,
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

    void addIfNotEmpty(String value) {
      if (value.isNotEmpty) {
        mediaList.add(value);
      }
    }

    addIfNotEmpty(mediaSecondRectangle);
    addIfNotEmpty(companyTeamAndObjectivesMedia);
    addIfNotEmpty(requestOrProblemMedia);
    addIfNotEmpty(solutionMedia);

    return mediaList;
  }

  /// Company, team & objectives paragraphs concatenated
  List<String> get companyTeamAndObjectivesParagraphs => [
    companyTeamAndObjectivesParagraph1,
    companyTeamAndObjectivesParagraph2,
    companyTeamAndObjectivesParagraph3,
  ].where((paragraph) => paragraph.trim().isNotEmpty).toList();

  /// Request/problem paragraphs concatenated
  List<String> get requestOrProblemParagraphs => [
    requestOrProblemParagraph1,
    requestOrProblemParagraph2,
    requestOrProblemParagraph3,
  ].where((paragraph) => paragraph.trim().isNotEmpty).toList();

  /// Solution paragraphs concatenated
  List<String> get solutionParagraphs => [
    solutionParagraph1,
    solutionParagraph2,
    solutionParagraph3,
  ].where((paragraph) => paragraph.trim().isNotEmpty).toList();

  /// Combine all detail paragraphs for searches or summaries
  String get combinedDetailText => [
    ...companyTeamAndObjectivesParagraphs,
    ...requestOrProblemParagraphs,
    ...solutionParagraphs,
  ].join('\n\n');

  /// Check if project has main media
  bool get hasMainMedia => mediaMainRectangle != null;

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
        other.id == id &&
        other.companyName == companyName &&
        other.companyLogo == companyLogo &&
        other.companyLocation == companyLocation &&
        other.projectName == projectName &&
        other.projectDescription == projectDescription &&
        other.projectType == projectType &&
        other.projectHashtags == projectHashtags &&
        other.mediaMainRectangle == mediaMainRectangle &&
        other.mediaSecondRectangle == mediaSecondRectangle &&
        other.companyTeamAndObjectivesParagraph1 ==
            companyTeamAndObjectivesParagraph1 &&
        other.companyTeamAndObjectivesParagraph2 ==
            companyTeamAndObjectivesParagraph2 &&
        other.companyTeamAndObjectivesParagraph3 ==
            companyTeamAndObjectivesParagraph3 &&
        other.companyTeamAndObjectivesMedia == companyTeamAndObjectivesMedia &&
        other.requestOrProblemParagraph1 == requestOrProblemParagraph1 &&
        other.requestOrProblemParagraph2 == requestOrProblemParagraph2 &&
        other.requestOrProblemParagraph3 == requestOrProblemParagraph3 &&
        other.requestOrProblemMedia == requestOrProblemMedia &&
        other.solutionParagraph1 == solutionParagraph1 &&
        other.solutionParagraph2 == solutionParagraph2 &&
        other.solutionParagraph3 == solutionParagraph3 &&
        other.solutionMedia == solutionMedia;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      companyName,
      companyLogo,
      companyLocation,
      projectName,
      projectDescription,
      projectType,
      projectHashtags,
      mediaMainRectangle,
      mediaSecondRectangle,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, companyName: $companyName, projectName: $projectName, projectType: $projectType, projectHashtags: $projectHashtags)';
  }
}
