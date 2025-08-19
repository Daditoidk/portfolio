import 'package:flutter/material.dart';

/// Represents a text element on the page
class TextElement {
  final String text;
  final String? id;
  final GlobalKey key;
  double yPosition; // Made mutable for position updates
  int lineIndex; // Made mutable for manual override
  int blockIndex; // Made mutable for manual override
  final bool isVisible;
  final int? manualLineIndex; // Manual override for line
  final int? manualBlockIndex; // Manual override for block

  TextElement({
    required this.text,
    this.id,
    required this.key,
    required this.yPosition,
    required this.lineIndex,
    required this.blockIndex,
    this.isVisible = true,
    this.manualLineIndex,
    this.manualBlockIndex,
  });

  @override
  String toString() {
    return 'TextElement(text: "$text", yPosition: $yPosition, lineIndex: $lineIndex, blockIndex: $blockIndex)';
  }
}

/// Global registry for tracking text elements on the page
class TextAnimationRegistry {
  static final TextAnimationRegistry _instance =
      TextAnimationRegistry._internal();
  factory TextAnimationRegistry() => _instance;
  TextAnimationRegistry._internal();

  final Map<String, TextElement> _textElements = {};
  final List<TextElement> _sortedElements = [];
  bool _isDirty = true;

  // Configurable thresholds
  double _lineThreshold = 30.0; // Increased from 20.0
  int _blockSize = 5; // Increased from 3
  bool _useManualOverrides = true;

  /// Set the line threshold for automatic line detection
  void setLineThreshold(double threshold) {
    _lineThreshold = threshold;
    _isDirty = true;
  }

  /// Set the block size for automatic block detection
  void setBlockSize(int size) {
    _blockSize = size;
    _isDirty = true;
  }

  /// Enable/disable manual overrides
  void setUseManualOverrides(bool use) {
    _useManualOverrides = use;
    _isDirty = true;
  }

  /// Register a text element
  void registerText({
    required BuildContext context,
    required String text,
    String? id,
    GlobalKey? key,
    int? manualLineIndex,
    int? manualBlockIndex,
  }) {
    final elementKey = key ?? GlobalKey();
    final elementId = id ?? '${text.hashCode}_${elementKey.hashCode}';

    // Get the position of the text element
    final position = _getTextPosition(context, elementKey);

    final element = TextElement(
      text: text,
      id: id,
      key: elementKey,
      yPosition: position.dy,
      lineIndex: 0, // Will be calculated later
      blockIndex: 0, // Will be calculated later
      manualLineIndex: manualLineIndex,
      manualBlockIndex: manualBlockIndex,
    );

    _textElements[elementId] = element;
    _isDirty = true;
  }

  /// Unregister a text element
  void unregisterText(String id) {
    _textElements.remove(id);
    _isDirty = true;
  }

  /// Get the position of a text element with retry mechanism
  Offset _getTextPosition(BuildContext context, GlobalKey key) {
    try {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        // Only return if we got a valid position
        if (position.dy > 0 || position.dy == 0) {
          return position;
        }
      }
    } catch (e) {
      // Handle error gracefully
    }
    return Offset.zero;
  }

  /// Update positions of all text elements
  void updatePositions() {
    for (final element in _textElements.values) {
      try {
        final renderBox =
            element.key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          element.yPosition = position.dy;
        }
      } catch (e) {
        // Handle error gracefully
      }
    }
    _isDirty = true;
  }

  /// Get all text elements sorted by position (top to bottom)
  List<TextElement> getSortedElements() {
    if (_isDirty) {
      _sortedElements.clear();
      _sortedElements.addAll(_textElements.values);

      // Filter out elements with invalid positions
      _sortedElements.removeWhere((element) => element.yPosition < 0);

      _sortedElements.sort((a, b) => a.yPosition.compareTo(b.yPosition));

      // Calculate line and block indices
      _calculateLineAndBlockIndices();
    }
    return _sortedElements;
  }

  /// Calculate line and block indices for all elements
  void _calculateLineAndBlockIndices() {
    if (_sortedElements.isEmpty) return;

    // If manual overrides are enabled, apply them
    if (_useManualOverrides) {
      setupManualOverrides();
      return;
    }

    // Improved automatic detection based on content and position
    _calculateAutomaticLineAndBlockIndices(_sortedElements);
  }

  /// Calculate automatic line and block indices with improved logic
  void _calculateAutomaticLineAndBlockIndices(List<TextElement> elements) {
    // Group elements by approximate Y position (within threshold)
    final yGroups = <double, List<TextElement>>{};

    for (final element in elements) {
      if (element.yPosition >= 0) {
        // Use a smaller threshold for more precise grouping
        final yGroup =
            (element.yPosition / _lineThreshold).round() * _lineThreshold;
        yGroups.putIfAbsent(yGroup, () => []).add(element);
      }
    }

    // Sort Y groups to maintain order
    final sortedYGroups = yGroups.keys.toList()..sort();

    // Assign line indices based on Y position groups
    for (int i = 0; i < sortedYGroups.length; i++) {
      final yGroup = sortedYGroups[i];
      final groupElements = yGroups[yGroup]!;

      for (final element in groupElements) {
        element.lineIndex = i;
      }
    }

    // Assign block indices based on content analysis
    _assignBlockIndicesByContent(elements);
  }

  /// Assign block indices based on content analysis
  void _assignBlockIndicesByContent(List<TextElement> elements) {
    // Define content patterns for each section
    final sectionPatterns = {
      0: [
        'portfolio',
        'home',
        'about',
        'skills',
        'resume',
        'projects',
        'contact',
        'nav',
      ],
      1: ['camilo', 'santacruz', 'abadiano', 'header'],
      2: ['about', 'curious', 'passionate', 'technology', 'enthusiast'],
      3: [
        'skills',
        'technologies',
        'programming',
        'languages',
        'flutter',
        'dart',
        'kotlin',
        'swift',
        'design',
        'animation',
        'rive',
        'figma',
        'adobe',
        'editors',
        'tools',
        'android studio',
        'visual studio',
        'cursor',
        'git',
        'devops',
        'ci/cd',
        'codemagic',
        'github actions',
        'project management',
        'scrum',
        'agile',
        'kanban',
      ],
      4: ['resume', 'download', 'curriculum', 'cv'],
      5: ['projects', 'recent', 'selection'],
      6: [
        'brain4goals',
        'ecommerce',
        'sports',
        'management',
        'app',
        'know more',
      ],
      7: [
        'contact',
        'touch',
        'email',
        'phone',
        'location',
        'colombia',
        'funza',
        'cundinamarca',
      ],
    };

    for (final element in elements) {
      final text = element.text.toLowerCase();
      int bestSection = 0;
      double bestScore = 0.0;

      // Calculate similarity score for each section
      for (final entry in sectionPatterns.entries) {
        final section = entry.key;
        final patterns = entry.value;

        double score = 0.0;
        for (final pattern in patterns) {
          if (text.contains(pattern)) {
            score += pattern.length; // Longer matches get higher scores
          }
        }

        if (score > bestScore) {
          bestScore = score;
          bestSection = section;
        }
      }

      // If no good match found, use position-based assignment
      if (bestScore == 0.0) {
        bestSection = _getSectionByPosition(element.yPosition);
      }

      element.blockIndex = bestSection;
    }
  }

  /// Get section by Y position as fallback
  int _getSectionByPosition(double yPosition) {
    if (yPosition < 0) return 0;

    // Define approximate Y ranges for each section
    // These values should be adjusted based on your actual layout
    if (yPosition < 100) return 0; // Navigation
    if (yPosition < 300) return 1; // Header
    if (yPosition < 500) return 2; // About
    if (yPosition < 1200) return 3; // Skills
    if (yPosition < 1400) return 4; // Resume
    if (yPosition < 1600) return 5; // Projects
    if (yPosition < 1800) return 6; // Project Details
    return 7; // Contact
  }

  /// Get text elements by line index
  List<TextElement> getElementsByLine(int lineIndex) {
    return getSortedElements()
        .where((element) => element.lineIndex == lineIndex)
        .toList();
  }

  /// Get text elements by block index
  List<TextElement> getElementsByBlock(int blockIndex) {
    return getSortedElements()
        .where((element) => element.blockIndex == blockIndex)
        .toList();
  }

  /// Get all line indices
  List<int> getLineIndices() {
    final elements = getSortedElements();
    return elements.map((e) => e.lineIndex).toSet().toList()..sort();
  }

  /// Get all block indices
  List<int> getBlockIndices() {
    final elements = getSortedElements();
    return elements.map((e) => e.blockIndex).toSet().toList()..sort();
  }

  /// Clear all registered text elements
  void clear() {
    _textElements.clear();
    _sortedElements.clear();
    _isDirty = true;
  }

  /// Set up manual overrides based on the correct line and section structure
  void setupManualOverrides() {
    // Define the correct line and section mappings using localization keys
    // This matches the user's specific organization
    final lineMappings = {
      // Line 0: Navigation
      'appTitle': 0, // Portfolio
      'navHome': 0, // Home
      'navAbout': 0, // About
      'skillsTitle': 0, // Skills & Technologies
      'resumeSectionTitle': 0, // Resume
      'navProjects': 0, // Projects
      'navContact': 0, // Contact
      // Line 1: Header Name
      'headerName': 1, // Camilo Santacruz Abadiano
      // Line 2: Header Title
      'headerTitle': 2, // Mobile Developer
      // Line 3: Header Subtitle
      'headerSubtitle': 3, // Creating beautiful mobile experiences
      // Line 4: About Title
      'aboutTitle': 4, // About Me
      // Line 5: About Description
      'aboutDescription':
          5, // I am a curious person passionate about technology...
      // Line 6: About Subtitle
      'aboutSubtitle':
          6, // A tech enthusiast who believes in continuous learning...
      // Line 7: Skills Title
      'skillsTitle': 7, // Skills & Technologies
      // Line 8: Skills Subtitle
      'skillsSubtitle': 8, // My technical expertise and tools I work with
      // Line 9: Programming Languages Category
      'skillsLanguages': 9, // Programming Languages
      // Line 10: Programming Language Skills
      'skillFlutter': 10,
      'skillDart': 10,
      'skillKotlin': 10,
      'skillKotlinMultiplatform': 10,
      'skillSwift': 10,
      'skillFlutterWeb': 10,

      // Line 11: Design & Animation Category
      'skillsDesign': 11, // Design & Animation
      // Line 12: Design Skills
      'skillRive': 12, 'skillFigma': 12, 'skillAdobeXD': 12,

      // Line 13: Editors & Tools Category
      'skillsEditors': 13, // Editors & Tools
      // Line 14: Editor Skills
      'skillAndroidStudio': 14,
      'skillVSCode': 14,
      'skillCursor': 14,
      'skillGit': 14,

      // Line 15: DevOps Category
      'skillsDevOps': 15, // DevOps & CI/CD
      // Line 16: DevOps Skills
      'skillCodeMagic': 16, 'skillGithubActions': 16,

      // Line 17: Project Management Category
      'projectManagement': 17, // Project Management
      // Line 18: Project Management Skills
      'skillScrum': 18, 'skillAgile': 18, 'skillKanban': 18,

      // Line 19: Resume Title
      'resumeSectionTitle': 19, // Resume
      // Line 20: Resume Description
      'resumeSectionDescription': 20, // Download my latest resume...
      // Line 21: Resume Download Button
      'resumeDownload': 21, // Download
      // Line 22: Resume Last Updated
      'resumeLastUpdated': 22, // Last updated: {date}
      // Line 23: Projects Title
      'projectsTitle': 23, // My Projects
      // Line 24: Projects Subtitle
      'projectsSubtitle': 24, // A selection of my recent projects
      // Line 25: Project Title (Brain4Goals)
      'projectB4S': 25, // Brain4Goals App
      // Line 26: Project Description
      'projectEcommerceDescription':
          26, // A comprehensive sports management app...
      // Line 27: Demo text and Know More (counted as one line)
      'projectKnowMore': 27, // Know More
      // Line 28: Contact Title
      'contactTitle': 28, // Get In Touch
      // Line 29: Contact Subtitle
      'contactSubtitle': 29, // Let's work together on your next project
      // Line 30: Contact Information
      'contactEmail': 30, 'contactPhone': 30, 'contactLocation': 30,

      // Line 31: Last Update
      'createdBy': 31, // Last update: Local build
      // Line 32: Version (dynamic value)
      'version': 32, // v1.0.11 (dynamic version from package_info)
    };

    // Define section mappings (blocks) using localization keys
    final sectionMappings = {
      // Section 0: Navigation
      'appTitle': 0,
      'navHome': 0,
      'navAbout': 0,
      'skillsTitle': 0,
      'resumeSectionTitle': 0,
      'navProjects': 0,
      'navContact': 0,

      // Section 1: Header
      'headerName': 1, 'headerTitle': 1, 'headerSubtitle': 1,

      // Section 2: About
      'aboutTitle': 2, 'aboutDescription': 2, 'aboutSubtitle': 2,

      // Section 3: Skills (all skills content)
      'skillsTitle': 3,
      'skillsSubtitle': 3,
      'skillsLanguages': 3,
      'skillFlutter': 3,
      'skillDart': 3,
      'skillKotlin': 3,
      'skillKotlinMultiplatform': 3,
      'skillSwift': 3,
      'skillFlutterWeb': 3,
      'skillsDesign': 3,
      'skillRive': 3,
      'skillFigma': 3,
      'skillAdobeXD': 3,
      'skillsEditors': 3,
      'skillAndroidStudio': 3,
      'skillVSCode': 3,
      'skillCursor': 3,
      'skillGit': 3,
      'skillsDevOps': 3,
      'skillCodeMagic': 3,
      'skillGithubActions': 3,
      'projectManagement': 3,
      'skillScrum': 3,
      'skillAgile': 3,
      'skillKanban': 3,

      // Section 4: Resume
      'resumeSectionTitle': 4,
      'resumeSectionDescription': 4,
      'resumeDownload': 4,
      'resumeLastUpdated': 4,

      // Section 5: Projects
      'projectsTitle': 5, 'projectsSubtitle': 5,

      // Section 6: Project Details
      'projectB4S': 6, 'projectEcommerceDescription': 6, 'projectKnowMore': 6,

      // Section 7: Contact
      'contactTitle': 7,
      'contactSubtitle': 7,
      'contactEmail': 7,
      'contactPhone': 7,
      'contactLocation': 7,
      'createdBy': 7,
      'version': 7, // Version info
    };

    // Apply manual overrides to existing elements
    for (final element in _textElements.values) {
      // Try to match by localization key
      String? matchedKey;

      // First, try to match by exact text content (for backward compatibility)
      for (final entry in lineMappings.entries) {
        final key = entry.key;
        // Check if the text matches any localization key's value
        if (element.text.toLowerCase().contains(key.toLowerCase()) ||
            key.toLowerCase().contains(element.text.toLowerCase())) {
          matchedKey = key;
          break;
        }
      }

      // If no match found, try to match by partial text content
      if (matchedKey == null) {
        for (final entry in lineMappings.entries) {
          final key = entry.key;
          // Check if the text contains parts of the key or vice versa
          final keyWords = key.toLowerCase().split(' ');
          final textWords = element.text.toLowerCase().split(' ');

          for (final keyWord in keyWords) {
            for (final textWord in textWords) {
              if (keyWord.contains(textWord) || textWord.contains(keyWord)) {
                if (keyWord.length > 2 && textWord.length > 2) {
                  // Avoid matching very short words
                  matchedKey = key;
                  break;
                }
              }
            }
            if (matchedKey != null) break;
          }
          if (matchedKey != null) break;
        }
      }

      if (matchedKey != null) {
        final lineIndex = lineMappings[matchedKey];
        final blockIndex = sectionMappings[matchedKey];

        if (lineIndex != null) {
          element.lineIndex = lineIndex;
        }
        if (blockIndex != null) {
          element.blockIndex = blockIndex;
        }
      }
    }

    // Handle missing skill tags by giving them the same line/section as adjacent text
    _handleMissingSkillTags();

    _isDirty = true;
  }

  /// Handle missing skill tags by assigning them the same line/section as adjacent text
  void _handleMissingSkillTags() {
    final elements = _textElements.values.toList();

    // Group elements by their Y position (within a small threshold)
    final yGroups = <double, List<TextElement>>{};
    for (final element in elements) {
      if (element.yPosition >= 0) {
        final yGroup =
            (element.yPosition / 10).round() * 10.0; // Group by 10px intervals
        yGroups.putIfAbsent(yGroup, () => []).add(element);
      }
    }

    // For each group, if there are elements with line assignments, assign the same to unassigned elements
    for (final group in yGroups.values) {
      final assignedElements = group.where((e) => e.lineIndex >= 0).toList();
      final unassignedElements = group.where((e) => e.lineIndex < 0).toList();

      if (assignedElements.isNotEmpty && unassignedElements.isNotEmpty) {
        // Use the most common line index in this group
        final lineCounts = <int, int>{};
        for (final element in assignedElements) {
          lineCounts[element.lineIndex] =
              (lineCounts[element.lineIndex] ?? 0) + 1;
        }

        final mostCommonLine = lineCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        // Assign the same line and section to unassigned elements
        for (final element in unassignedElements) {
          element.lineIndex = mostCommonLine;

          // Find the corresponding section
          final sectionCounts = <int, int>{};
          for (final assignedElement in assignedElements) {
            if (assignedElement.lineIndex == mostCommonLine) {
              sectionCounts[assignedElement.blockIndex] =
                  (sectionCounts[assignedElement.blockIndex] ?? 0) + 1;
            }
          }

          if (sectionCounts.isNotEmpty) {
            final mostCommonSection = sectionCounts.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;
            element.blockIndex = mostCommonSection;
          }
        }
      }
    }
  }

  /// Get debug information as structured data for table widgets
  Map<String, dynamic> getDebugData() {
    final elements = getSortedElements();
    final lines = getLineIndices();
    final blocks = getBlockIndices();

    // Prepare line table data
    final lineTableData = <Map<String, dynamic>>[];
    for (final line in lines) {
      final lineElements = getElementsByLine(line);
      final values = lineElements
          .map(
            (e) => {'text': e.text, 'key': _getLocalizationKeyForText(e.text)},
          )
          .toList();
      lineTableData.add({
        'line': line,
        'count': lineElements.length,
        'values': values,
      });
    }

    // Prepare section table data
    final sectionTableData = <Map<String, dynamic>>[];
    for (final block in blocks) {
      final blockElements = getElementsByBlock(block);
      final lineNumbers = blockElements.map((e) => e.lineIndex).toSet().toList()
        ..sort();
      sectionTableData.add({
        'section': block,
        'lineNumbers': lineNumbers,
        'count': blockElements.length,
      });
    }

    // Prepare detailed element list
    final detailedElements = <Map<String, dynamic>>[];
    for (int i = 0; i < elements.length; i++) {
      final element = elements[i];
      final manual = element.manualLineIndex != null
          ? ' (manual: L${element.manualLineIndex})'
          : '';
      detailedElements.add({
        'index': i + 1,
        'text': element.text,
        'key': _getLocalizationKeyForText(element.text),
        'yPosition': element.yPosition,
        'lineIndex': element.lineIndex,
        'blockIndex': element.blockIndex,
        'manual': manual,
      });
    }

    return {
      'summary': {
        'totalElements': elements.length,
        'validElements': elements.where((e) => e.yPosition >= 0).length,
        'lineThreshold': _lineThreshold,
        'blockSize': _blockSize,
        'useManualOverrides': _useManualOverrides,
      },
      'lineTable': lineTableData,
      'sectionTable': sectionTableData,
      'detailedElements': detailedElements,
    };
  }

  /// Try to find the localization key for a given text
  String _getLocalizationKeyForText(String text) {
    // This is a simplified approach - in a real implementation, you'd want to use the actual localization system
    // For now, we'll try to match based on common patterns

    final textLower = text.toLowerCase();

    // Navigation keys
    if (textLower.contains('portfolio') || textLower.contains('portafolio')) {
      return 'appTitle';
    }
    if (textLower.contains('home') || textLower.contains('inicio')) {
      return 'navHome';
    }
    if (textLower.contains('about') || textLower.contains('sobre')) {
      return 'navAbout';
    }
    if (textLower.contains('skills') || textLower.contains('habilidades')) {
      return 'skillsTitle';
    }
    if (textLower.contains('resume') || textLower.contains('curriculum')) {
      return 'resumeSectionTitle';
    }
    if (textLower.contains('projects') || textLower.contains('proyectos')) {
      return 'navProjects';
    }
    if (textLower.contains('contact') || textLower.contains('contacto')) {
      return 'navContact';
    }

    // Header keys
    if (textLower.contains('camilo') && textLower.contains('santacruz')) {
      return 'headerName';
    }
    if (textLower.contains('mobile developer') ||
        textLower.contains('desarrollador')) {
      return 'headerTitle';
    }
    if (textLower.contains('creating beautiful') ||
        textLower.contains('creando experiencias')) {
      return 'headerSubtitle';
    }

    // About keys
    if (textLower.contains('about me') || textLower.contains('sobre mí')) {
      return 'aboutTitle';
    }
    if (textLower.contains('curious person') ||
        textLower.contains('persona curiosa')) {
      return 'aboutDescription';
    }
    if (textLower.contains('tech enthusiast') ||
        textLower.contains('entusiasta')) {
      return 'aboutSubtitle';
    }

    // Skills keys
    if (textLower.contains('skills & technologies') ||
        textLower.contains('habilidades y tecnologías')) {
      return 'skillsTitle';
    }
    if (textLower.contains('technical expertise') ||
        textLower.contains('experiencia técnica')) {
      return 'skillsSubtitle';
    }
    if (textLower.contains('programming languages') ||
        textLower.contains('lenguajes de programación')) {
      return 'skillsLanguages';
    }
    if (textLower.contains('flutter')) return 'skillFlutter';
    if (textLower.contains('dart')) return 'skillDart';
    if (textLower.contains('kotlin')) return 'skillKotlin';
    if (textLower.contains('swift')) return 'skillSwift';
    if (textLower.contains('design & animation') ||
        textLower.contains('diseño y animación')) {
      return 'skillsDesign';
    }
    if (textLower.contains('rive')) return 'skillRive';
    if (textLower.contains('figma')) return 'skillFigma';
    if (textLower.contains('adobe xd')) return 'skillAdobeXD';
    if (textLower.contains('editors & tools') ||
        textLower.contains('editores y herramientas')) {
      return 'skillsEditors';
    }
    if (textLower.contains('android studio')) return 'skillAndroidStudio';
    if (textLower.contains('visual studio code')) return 'skillVSCode';
    if (textLower.contains('cursor')) return 'skillCursor';
    if (textLower.contains('git')) return 'skillGit';
    if (textLower.contains('devops') || textLower.contains('ci/cd')) {
      return 'skillsDevOps';
    }
    if (textLower.contains('codemagic')) return 'skillCodeMagic';
    if (textLower.contains('github actions')) return 'skillGithubActions';
    if (textLower.contains('project management') ||
        textLower.contains('gestión de proyectos')) {
      return 'projectManagement';
    }
    if (textLower.contains('scrum')) return 'skillScrum';
    if (textLower.contains('agile')) return 'skillAgile';
    if (textLower.contains('kanban')) return 'skillKanban';

    // Resume keys
    if (textLower.contains('resume') || textLower.contains('curriculum')) {
      return 'resumeSectionTitle';
    }
    if (textLower.contains('download my latest') ||
        textLower.contains('descarga mi curriculum')) {
      return 'resumeSectionDescription';
    }
    if (textLower.contains('download') || textLower.contains('descargar')) {
      return 'resumeDownload';
    }
    if (textLower.contains('last updated') ||
        textLower.contains('última actualización')) {
      return 'resumeLastUpdated';
    }

    // Projects keys
    if (textLower.contains('my projects') ||
        textLower.contains('mis proyectos')) {
      return 'projectsTitle';
    }
    if (textLower.contains('selection of my recent') ||
        textLower.contains('selección de mis proyectos')) {
      return 'projectsSubtitle';
    }
    if (textLower.contains('brain4goals')) return 'projectB4S';
    if (textLower.contains('comprehensive sports management')) {
      return 'projectEcommerceDescription';
    }
    if (textLower.contains('know more') || textLower.contains('saber más')) {
      return 'projectKnowMore';
    }

    // Contact keys
    if (textLower.contains('get in touch') ||
        textLower.contains('ponte en contacto')) {
      return 'contactTitle';
    }
    if (textLower.contains('work together') ||
        textLower.contains('trabajemos juntos')) {
      return 'contactSubtitle';
    }
    if (textLower.contains('kamiomg99@gmail.com')) return 'contactEmail';
    if (textLower.contains('+57 3025298355')) return 'contactPhone';
    if (textLower.contains('funza') ||
        textLower.contains('cundinamarca') ||
        textLower.contains('colombia')) {
      return 'contactLocation';
    }

    // Version keys (dynamic values)
    if (textLower.contains('last update') ||
        textLower.contains('última actualización')) {
      return 'createdBy';
    }
    if (textLower.startsWith('v') && textLower.contains('.')) return 'version';
    if (textLower.contains('local build')) return 'createdBy';

    return 'Unknown';
  }

  /// Get debug information as string (kept for backward compatibility)
  String getDebugInfo() {
    final debugData = getDebugData();
    final summary = debugData['summary'] as Map<String, dynamic>;
    final lineTable = debugData['lineTable'] as List<Map<String, dynamic>>;
    final sectionTable =
        debugData['sectionTable'] as List<Map<String, dynamic>>;
    final detailedElements =
        debugData['detailedElements'] as List<Map<String, dynamic>>;

    StringBuffer info = StringBuffer();
    info.writeln('TextAnimationRegistry Debug Info:');
    info.writeln('Total elements: ${summary['totalElements']}');
    info.writeln(
      'Valid elements (with positions): ${summary['validElements']}',
    );
    info.writeln('Line threshold: ${summary['lineThreshold']} px');
    info.writeln('Block size: ${summary['blockSize']}');
    info.writeln('Use manual overrides: ${summary['useManualOverrides']}');
    info.writeln('');

    // Table 1: Lines and their values
    info.writeln('=== TABLE 1: LINES AND VALUES ===');
    info.writeln('Line | Count | Values');
    info.writeln('-----|-------|-------');
    for (final lineData in lineTable) {
      final line = lineData['line'] as int;
      final count = lineData['count'] as int;
      final values = (lineData['values'] as List<Map<String, dynamic>>)
          .map((e) => '"${e['text']}" (Key: ${e['key']})')
          .join(', ');
      info.writeln(
        '${line.toString().padLeft(3)} | ${count.toString().padLeft(5)} | $values',
      );
    }

    info.writeln('');

    // Table 2: Sections and their line numbers
    info.writeln('=== TABLE 2: SECTIONS AND LINE NUMBERS ===');
    info.writeln('Section | Line Numbers | Count');
    info.writeln('--------|--------------|-------');
    for (final sectionData in sectionTable) {
      final section = sectionData['section'] as int;
      final lineNumbers = (sectionData['lineNumbers'] as List<int>).join(', ');
      final count = sectionData['count'] as int;
      info.writeln(
        '${section.toString().padLeft(6)} | ${lineNumbers.padLeft(12)} | ${count.toString().padLeft(5)}',
      );
    }

    info.writeln('');
    info.writeln('=== DETAILED ELEMENT LIST ===');
    info.writeln('All elements sorted by Y position:');
    for (final elementData in detailedElements) {
      final index = elementData['index'] as int;
      final text = elementData['text'] as String;
      final key = elementData['key'] as String;
      final yPosition = elementData['yPosition'] as double;
      final lineIndex = elementData['lineIndex'] as int;
      final blockIndex = elementData['blockIndex'] as int;
      final manual = elementData['manual'] as String;
      info.writeln(
        '  $index. "$text" (Key: $key, Y: ${yPosition.toStringAsFixed(1)}, L:$lineIndex, B:$blockIndex)$manual',
      );
    }

    return info.toString();
  }
}

/// Widget that automatically registers text for animation
class AnimatedText extends StatelessWidget {
  final String text;
  final String? id;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;
  final int? manualLineIndex; // Manual override for line
  final int? manualBlockIndex; // Manual override for block

  const AnimatedText(
    this.text, {
    super.key,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.manualLineIndex,
    this.manualBlockIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Register this text element for animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TextAnimationRegistry().registerText(
        context: context,
        text: text,
        id: id,
        key: key as GlobalKey?,
        manualLineIndex: manualLineIndex,
        manualBlockIndex: manualBlockIndex,
      );
    });

    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

/// Widget that automatically registers text for animation with custom key
class AnimatedTextWithKey extends StatelessWidget {
  final String text;
  final String? id;
  final GlobalKey textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final StrutStyle? strutStyle;
  final int? manualLineIndex; // Manual override for line
  final int? manualBlockIndex; // Manual override for block

  const AnimatedTextWithKey(
    this.text, {
    super.key,
    required this.textKey,
    this.id,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.textScaleFactor,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.manualLineIndex,
    this.manualBlockIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Register this text element for animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TextAnimationRegistry().registerText(
        context: context,
        text: text,
        id: id,
        key: textKey,
        manualLineIndex: manualLineIndex,
        manualBlockIndex: manualBlockIndex,
      );
    });

    return Text(
      text,
      key: textKey,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

/// A table widget to display text animation registry debug information
class TextAnimationRegistryTable extends StatelessWidget {
  final Map<String, dynamic> debugData;

  const TextAnimationRegistryTable({super.key, required this.debugData});

  @override
  Widget build(BuildContext context) {
    final summary = debugData['summary'] as Map<String, dynamic>;
    final lineTable = debugData['lineTable'] as List<Map<String, dynamic>>;
    final sectionTable =
        debugData['sectionTable'] as List<Map<String, dynamic>>;
    final detailedElements =
        debugData['detailedElements'] as List<Map<String, dynamic>>;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Summary information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TextAnimationRegistry Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _SummaryItem(
                      label: 'Total Elements',
                      value: '${summary['totalElements']}',
                    ),
                    _SummaryItem(
                      label: 'Valid Elements',
                      value: '${summary['validElements']}',
                    ),
                    _SummaryItem(
                      label: 'Line Threshold',
                      value: '${summary['lineThreshold']}px',
                    ),
                    _SummaryItem(
                      label: 'Block Size',
                      value: '${summary['blockSize']}',
                    ),
                    _SummaryItem(
                      label: 'Manual Overrides',
                      value: summary['useManualOverrides']
                          ? 'Enabled'
                          : 'Disabled',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab bar
          TabBar(
            tabs: const [
              Tab(text: 'Lines & Values'),
              Tab(text: 'Sections & Lines'),
              Tab(text: 'Detailed Elements'),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _LinesTable(lineTable: lineTable),
                _SectionsTable(sectionTable: sectionTable),
                _DetailedElementsTable(detailedElements: detailedElements),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _LinesTable extends StatelessWidget {
  final List<Map<String, dynamic>> lineTable;

  const _LinesTable({required this.lineTable});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Line')),
          DataColumn(label: Text('Count')),
          DataColumn(label: Text('Values')),
        ],
        rows: lineTable.map((lineData) {
          final line = lineData['line'] as int;
          final count = lineData['count'] as int;
          final values = lineData['values'] as List<Map<String, dynamic>>;

          return DataRow(
            cells: [
              DataCell(Text('$line')),
              DataCell(Text('$count')),
              DataCell(
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    values
                        .map((v) => '"${v['text']}" (Key: ${v['key']})')
                        .join(', '),
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SectionsTable extends StatelessWidget {
  final List<Map<String, dynamic>> sectionTable;

  const _SectionsTable({required this.sectionTable});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Section')),
          DataColumn(label: Text('Line Numbers')),
          DataColumn(label: Text('Count')),
        ],
        rows: sectionTable.map((sectionData) {
          final section = sectionData['section'] as int;
          final lineNumbers = sectionData['lineNumbers'] as List<int>;
          final count = sectionData['count'] as int;

          return DataRow(
            cells: [
              DataCell(Text('$section')),
              DataCell(Text(lineNumbers.join(', '))),
              DataCell(Text('$count')),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailedElementsTable extends StatelessWidget {
  final List<Map<String, dynamic>> detailedElements;

  const _DetailedElementsTable({required this.detailedElements});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Text')),
          DataColumn(label: Text('Key')),
          DataColumn(label: Text('Y Pos')),
          DataColumn(label: Text('Line')),
          DataColumn(label: Text('Block')),
          DataColumn(label: Text('Manual')),
        ],
        rows: detailedElements.map((elementData) {
          final index = elementData['index'] as int;
          final text = elementData['text'] as String;
          final key = elementData['key'] as String;
          final yPosition = elementData['yPosition'] as double;
          final lineIndex = elementData['lineIndex'] as int;
          final blockIndex = elementData['blockIndex'] as int;
          final manual = elementData['manual'] as String;

          return DataRow(
            cells: [
              DataCell(Text('$index')),
              DataCell(
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              DataCell(
                Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    key,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              DataCell(
                Text(yPosition >= 0 ? yPosition.toStringAsFixed(1) : 'N/A'),
              ),
              DataCell(Text('$lineIndex')),
              DataCell(Text('$blockIndex')),
              DataCell(Text(manual.isEmpty ? '-' : manual)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
