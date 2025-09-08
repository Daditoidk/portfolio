import '../models/skill.dart';
import '../constants/skill_colors.dart';

/// Repository for managing Skill data
/// This is where you create, read, update, and delete Skill objects
class SkillRepository {
  // In a real app, this would connect to a database, API, or local storage
  // For now, we'll use in-memory storage as an example
  final List<Skill> _skills = [];

  /// Get all skills
  List<Skill> getAllSkills() {
    return List.unmodifiable(_skills);
  }

  /// Get skills that are actively being used
  List<Skill> getActiveSkills() {
    return _skills.where((skill) => skill.activelyBeingUsed).toList();
  }

  /// Get skills by experience level (minimum years)
  List<Skill> getSkillsByExperience(int minYears) {
    return _skills
        .where((skill) => skill.yearOfExperience >= minYears)
        .toList();
  }

  /// Get skills by category
  List<Skill> getSkillsByCategory(String category) {
    return _skills.where((skill) => skill.hasCategory(category)).toList();
  }

  /// Get skills that contain a specific technology
  List<Skill> getSkillsByTechnology(String technology) {
    return _skills.where((skill) => skill.hasTechnology(technology)).toList();
  }

  /// Get a skill by name
  Skill? getSkillByName(String name) {
    try {
      return _skills.firstWhere(
        (skill) => skill.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Add a new skill
  void addSkill(Skill skill) {
    // Check if skill already exists
    final existingSkill = getSkillByName(skill.name);
    if (existingSkill != null) {
      throw Exception('Skill with name "${skill.name}" already exists');
    }

    _skills.add(skill);
  }

  /// Update an existing skill
  void updateSkill(String skillName, Skill updatedSkill) {
    final index = _skills.indexWhere(
      (skill) => skill.name.toLowerCase() == skillName.toLowerCase(),
    );

    if (index == -1) {
      throw Exception('Skill with name "$skillName" not found');
    }

    _skills[index] = updatedSkill;
  }

  /// Delete a skill by name
  void deleteSkill(String skillName) {
    final index = _skills.indexWhere(
      (skill) => skill.name.toLowerCase() == skillName.toLowerCase(),
    );

    if (index == -1) {
      throw Exception('Skill with name "$skillName" not found');
    }

    _skills.removeAt(index);
  }

  /// Clear all skills
  void clearAllSkills() {
    _skills.clear();
  }

  /// Get total number of skills
  int get skillCount => _skills.length;

  /// Get all unique categories across all skills
  List<String> getAllCategories() {
    final categories = <String>{};
    for (final skill in _skills) {
      categories.addAll(skill.getCategories());
    }
    return categories.toList()..sort();
  }

  /// Get all unique technologies across all skills
  List<String> getAllTechnologies() {
    final technologies = <String>{};
    for (final skill in _skills) {
      technologies.addAll(skill.getAllTechnologies());
    }
    return technologies.toList()..sort();
  }

  /// Search skills by name (case-insensitive)
  List<Skill> searchSkills(String query) {
    if (query.isEmpty) return getAllSkills();

    return _skills
        .where(
          (skill) => skill.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Get skills sorted by experience (descending)
  List<Skill> getSkillsSortedByExperience() {
    final sortedSkills = List<Skill>.from(_skills);
    sortedSkills.sort(
      (a, b) => b.yearOfExperience.compareTo(a.yearOfExperience),
    );
    return sortedSkills;
  }

  /// Get skills sorted by name (ascending)
  List<Skill> getSkillsSortedByName() {
    final sortedSkills = List<Skill>.from(_skills);
    sortedSkills.sort((a, b) => a.name.compareTo(b.name));
    return sortedSkills;
  }

  /// Initialize with real skills data
  void initializeWithSampleData() {
    clearAllSkills();

    // Programming Languages
    addSkill(
      Skill(
        name: 'Flutter & Dart',
        yearOfExperience: 4,
        image: 'assets/portfolio/skills/icons/flutter.png',
        activelyBeingUsed: true,
        details: {
          'State Management': ['Riverpod', 'Provider', 'GetX', 'Bloc'],
          'Code Generation & Tools': ['Hooks', 'Freezed', 'Mason'],
          'Native Integration': ['Platform Channels', 'REST'],
          'Databases': ['Isar Database', 'SQLite', 'Firebase'],
          'Analytics & Monitoring': [
            'Firebase Analytics',
            'Firebase Crashlytics',
          ],
          'Testing': [
            'TDD',
            'Unit Testing',
            'Widget Testing',
            'Integration Testing',
          ],
          'Architecture': ['Clean Architecture', 'MVVM'],
        },
        colorSet: SkillColors.blue,
      ),
    );

    addSkill(
      Skill(
        name: 'Kotlin',
        yearOfExperience: 2,
        image: 'assets/portfolio/skills/icons/kotlin.png',
        activelyBeingUsed: false,
        details: {
          'Android Development': ['Kotlin', 'Android SDK'],
          'Mobile Development': ['Native Android Apps'],
        },
        colorSet: SkillColors.blue,
      ),
    );

    addSkill(
      Skill(
        name: 'Kotlin Multiplatform',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/kotlin-multiplatform.png',
        activelyBeingUsed: false,
        details: {
          'Cross-platform': ['Kotlin Multiplatform', 'Shared Code'],
          'Mobile Development': ['iOS', 'Android'],
        },
        colorSet: SkillColors.blue,
      ),
    );

    addSkill(
      Skill(
        name: 'Swift',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/swift.png',
        activelyBeingUsed: false,
        details: {
          'iOS Development': ['Swift', 'iOS SDK'],
          'Mobile Development': ['Native iOS Apps'],
        },
        colorSet: SkillColors.blue,
      ),
    );

    // Design & Animation
    addSkill(
      Skill(
        name: 'Rive',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/rive2.png',
        activelyBeingUsed: true,
        details: {
          'Animation': ['Rive', 'Interactive Animations'],
          'Design Tools': ['Real-time Animation'],
        },
        colorSet: SkillColors.green,
      ),
    );

    addSkill(
      Skill(
        name: 'Figma',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/figma.png',
        activelyBeingUsed: true,
        details: {
          'Design': ['Figma', 'UI/UX Design'],
          'Collaboration': ['Design Systems', 'Prototyping'],
        },
        colorSet: SkillColors.green,
      ),
    );

    addSkill(
      Skill(
        name: 'DaVinci Resolve',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/davinci2.png',
        activelyBeingUsed: true,
        details: {
          'Video Editing': ['DaVinci Resolve', 'Professional Video Editing'],
          'Color Grading': ['Color Correction', 'Color Grading'],
          'Post Production': ['Video Effects', 'Audio Post'],
        },
        colorSet: SkillColors.green,
      ),
    );

    // Editors & Tools
    addSkill(
      Skill(
        name: 'Android Studio',
        yearOfExperience: 4,
        image: 'assets/portfolio/skills/icons/android-studio.png',
        activelyBeingUsed: false,
        details: {
          'IDE': ['Android Studio', 'Development Environment'],
          'Mobile Development': ['Android Development'],
        },
        colorSet: SkillColors.gray,
      ),
    );

    addSkill(
      Skill(
        name: 'Visual Studio Code',
        yearOfExperience: 2,
        image: 'assets/portfolio/skills/icons/vscode.png',
        activelyBeingUsed: false,
        details: {
          'IDE': ['Visual Studio Code', 'Code Editor'],
          'Development': ['Multi-language Support'],
        },
        colorSet: SkillColors.gray,
      ),
    );

    addSkill(
      Skill(
        name: 'Cursor',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/cursor.png',
        activelyBeingUsed: true,
        details: {
          'IDE': ['Cursor', 'AI-powered Editor'],
          'Development': ['AI Code Assistant'],
        },
        colorSet: SkillColors.purple,
      ),
    );

    addSkill(
      Skill(
        name: 'Git',
        yearOfExperience: 6,
        image: 'assets/portfolio/skills/icons/github.png',
        activelyBeingUsed: true,
        details: {
          'Version Control': ['Git', 'Source Control'],
          'Collaboration': ['Branching', 'Merging'],
        },
        colorSet: SkillColors.gray,
      ),
    );

    // DevOps & CI/CD
    addSkill(
      Skill(
        name: 'CodeMagic',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/code-magic.png',
        activelyBeingUsed: true,
        details: {
          'CI/CD': ['CodeMagic', 'Continuous Integration'],
          'Mobile DevOps': ['Flutter CI/CD', 'App Distribution'],
        },
        colorSet: SkillColors.purple,
      ),
    );

    addSkill(
      Skill(
        name: 'GitHub Actions',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/github-actions.png',
        activelyBeingUsed: false,
        details: {
          'CI/CD': ['GitHub Actions', 'Automated Workflows'],
          'DevOps': ['Continuous Integration'],
        },
        colorSet: SkillColors.gray,
      ),
    );

    // Project Management
    addSkill(
      Skill(
        name: 'Scrum',
        yearOfExperience: 3,
        image: 'assets/portfolio/skills/icons/scrum3.png',
        activelyBeingUsed: true,
        details: {
          'Project Management': ['Scrum', 'Agile Framework'],
          'Team Collaboration': ['Sprints', 'Stand-ups'],
        },
        colorSet: SkillColors.yellow,
      ),
    );

    addSkill(
      Skill(
        name: 'Agile',
        yearOfExperience: 4,
        image: 'assets/portfolio/skills/icons/agile3.png',
        activelyBeingUsed: true,
        details: {
          'Project Management': ['Agile', 'Iterative Development'],
          'Methodology': ['Flexible Planning', 'Customer Collaboration'],
        },
        colorSet: SkillColors.yellow,
      ),
    );

    addSkill(
      Skill(
        name: 'Kanban',
        yearOfExperience: 1,
        image: 'assets/portfolio/skills/icons/kanban2.png',
        activelyBeingUsed: false,
        details: {
          'Project Management': ['Kanban', 'Visual Workflow'],
          'Task Management': ['Work in Progress', 'Flow Management'],
        },
        colorSet: SkillColors.yellow,
      ),
    );
  }
}
