import 'package:flutter/material.dart';
import 'dart:convert';


/// Configuration-driven text ordering system
class TextOrderConfig {
  final List<TextSection> sections;
  final List<TextLine> lines;
  final Map<String, String> l10nKeyToText;

  const TextOrderConfig({
    required this.sections,
    required this.lines,
    required this.l10nKeyToText,
  });

  /// Create default configuration based on your current layout
  factory TextOrderConfig.defaultConfig() {
    return const TextOrderConfig(
      sections: [
        TextSection(
          name: 'Navigation',
          lineIds: ['line_0'],
          lineOrders: [0],
          color: Colors.blue,
          order: 0,
        ),
        TextSection(
          name: 'Header',
          lineIds: ['line_1', 'line_2', 'line_3'],
          lineOrders: [1, 2, 3],
          color: Colors.green,
          order: 1,
        ),
        TextSection(
          name: 'About',
          lineIds: ['line_4', 'line_5', 'line_6'],
          lineOrders: [4, 5, 6],
          color: Colors.orange,
          order: 2,
        ),
        TextSection(
          name: 'Skills',
          lineIds: [
            'line_7',
            'line_8',
            'line_9',
            'line_10',
            'line_11',
            'line_12',
            'line_13',
            'line_14',
            'line_15',
            'line_16',
            'line_17',
            'line_18',
          ],
          lineOrders: [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
          color: Colors.purple,
          order: 3,
        ),
        TextSection(
          name: 'Resume',
          lineIds: ['line_19', 'line_20', 'line_21', 'line_22'],
          lineOrders: [19, 20, 21, 22],
          color: Colors.red,
          order: 4,
        ),
        TextSection(
          name: 'Projects',
          lineIds: ['line_23', 'line_24', 'line_25', 'line_26', 'line_27'],
          lineOrders: [23, 24, 25, 26, 27],
          color: Colors.teal,
          order: 5,
        ),
        TextSection(
          name: 'Contact',
          lineIds: ['line_28', 'line_29', 'line_30'],
          lineOrders: [28, 29, 30],
          color: Colors.indigo,
          order: 6,
        ),
        TextSection(
          name: 'Footer',
          lineIds: ['line_31', 'line_32'],
          lineOrders: [31, 32],
          color: Colors.grey,
          order: 7,
        ),
      ],
      lines: [
        // Line 0: Navigation
        TextLine(
          order: 0,
          l10nKeys: [
            'appTitle',
            'navHome',
            'navAbout',
            'skillsTitle',
            'resumeSectionTitle',
            'navProjects',
            'navContact',
          ],
          height: 60.0,
          yPosition: 0.0,
        ),
        // Line 1: Header Name
        TextLine(
          order: 1,
          l10nKeys: ['headerName'],
          height: 60.0,
          yPosition: 60.0,
        ),
        // Line 2: Header Title
        TextLine(
          order: 2,
          l10nKeys: ['headerTitle'],
          height: 60.0,
          yPosition: 120.0,
        ),
        // Line 3: Header Subtitle
        TextLine(
          order: 3,
          l10nKeys: ['headerSubtitle'],
          height: 60.0,
          yPosition: 180.0,
        ),
        // Line 4: About Title
        TextLine(
          order: 4,
          l10nKeys: ['aboutTitle'],
          height: 60.0,
          yPosition: 240.0,
        ),
        // Line 5: About Description
        TextLine(
          order: 5,
          l10nKeys: ['aboutDescription'],
          height: 80.0,
          yPosition: 300.0,
        ),
        // Line 6: About Subtitle
        TextLine(
          order: 6,
          l10nKeys: ['aboutSubtitle'],
          height: 60.0,
          yPosition: 380.0,
        ),
        // Line 7: Skills Title
        TextLine(
          order: 7,
          l10nKeys: ['skillsTitle'],
          height: 60.0,
          yPosition: 440.0,
        ),
        // Line 8: Skills Subtitle
        TextLine(
          order: 8,
          l10nKeys: ['skillsSubtitle'],
          height: 60.0,
          yPosition: 500.0,
        ),
        // Line 9: Programming Languages Category
        TextLine(
          order: 9,
          l10nKeys: ['skillsLanguages'],
          height: 60.0,
          yPosition: 560.0,
        ),
        // Line 10: Programming Language Skills
        TextLine(
          order: 10,
          l10nKeys: [
            'skillFlutter',
            'skillDart',
            'skillKotlin',
            'skillKotlinMultiplatform',
            'skillSwift',
            'skillFlutterWeb',
          ],
          height: 80.0,
          yPosition: 620.0,
        ),
        // Line 11: Design & Animation Category
        TextLine(
          order: 11,
          l10nKeys: ['skillsDesign'],
          height: 60.0,
          yPosition: 700.0,
        ),
        // Line 12: Design Skills
        TextLine(
          order: 12,
          l10nKeys: ['skillRive', 'skillFigma', 'skillAdobeXD'],
          height: 60.0,
          yPosition: 760.0,
        ),
        // Line 13: Editors & Tools Category
        TextLine(
          order: 13,
          l10nKeys: ['skillsEditors'],
          height: 60.0,
          yPosition: 820.0,
        ),
        // Line 14: Editor Skills
        TextLine(
          order: 14,
          l10nKeys: [
            'skillAndroidStudio',
            'skillVSCode',
            'skillCursor',
            'skillGit',
          ],
          height: 80.0,
          yPosition: 880.0,
        ),
        // Line 15: DevOps Category
        TextLine(
          order: 15,
          l10nKeys: ['skillsDevOps'],
          height: 60.0,
          yPosition: 960.0,
        ),
        // Line 16: DevOps Skills
        TextLine(
          order: 16,
          l10nKeys: ['skillCodeMagic', 'skillGithubActions'],
          height: 60.0,
          yPosition: 1020.0,
        ),
        // Line 17: Project Management Category
        TextLine(
          order: 17,
          l10nKeys: ['projectManagement'],
          height: 60.0,
          yPosition: 1080.0,
        ),
        // Line 18: Project Management Skills
        TextLine(
          order: 18,
          l10nKeys: ['skillScrum', 'skillAgile', 'skillKanban'],
          height: 60.0,
          yPosition: 1140.0,
        ),
        // Line 19: Resume Title
        TextLine(
          order: 19,
          l10nKeys: ['resumeSectionTitle'],
          height: 60.0,
          yPosition: 1200.0,
        ),
        // Line 20: Resume Description
        TextLine(
          order: 20,
          l10nKeys: ['resumeSectionDescription'],
          height: 80.0,
          yPosition: 1260.0,
        ),
        // Line 21: Resume Download Button
        TextLine(
          order: 21,
          l10nKeys: ['resumeDownload'],
          height: 60.0,
          yPosition: 1340.0,
        ),
        // Line 22: Resume Last Updated
        TextLine(
          order: 22,
          l10nKeys: ['resumeLastUpdated'],
          height: 60.0,
          yPosition: 1400.0,
        ),
        // Line 23: Projects Title
        TextLine(
          order: 23,
          l10nKeys: ['projectsTitle'],
          height: 60.0,
          yPosition: 1460.0,
        ),
        // Line 24: Projects Subtitle
        TextLine(
          order: 24,
          l10nKeys: ['projectsSubtitle'],
          height: 60.0,
          yPosition: 1520.0,
        ),
        // Line 25: Project Title (Brain4Goals)
        TextLine(
          order: 25,
          l10nKeys: ['projectB4S'],
          height: 60.0,
          yPosition: 1580.0,
        ),
        // Line 26: Project Description
        TextLine(
          order: 26,
          l10nKeys: ['projectEcommerceDescription'],
          height: 80.0,
          yPosition: 1660.0,
        ),
        // Line 27: Demo text and Know More (counted as one line)
        TextLine(
          order: 27,
          l10nKeys: ['projectKnowMore'],
          height: 60.0,
          yPosition: 1740.0,
        ),
        // Line 28: Contact Title
        TextLine(
          order: 28,
          l10nKeys: ['contactTitle'],
          height: 60.0,
          yPosition: 1800.0,
        ),
        // Line 29: Contact Subtitle
        TextLine(
          order: 29,
          l10nKeys: ['contactSubtitle'],
          height: 60.0,
          yPosition: 1860.0,
        ),
        // Line 30: Contact Information
        TextLine(
          order: 30,
          l10nKeys: ['contactEmail', 'contactPhone', 'contactLocation'],
          height: 80.0,
          yPosition: 1920.0,
        ),
        // Line 31: Last Update
        TextLine(
          order: 31,
          l10nKeys: ['createdBy'],
          height: 60.0,
          yPosition: 2000.0,
        ),
        // Line 32: Version (dynamic value)
        TextLine(
          order: 32,
          l10nKeys: ['version'],
          height: 60.0,
          yPosition: 2060.0,
        ),
      ],
      l10nKeyToText: {
        'appTitle': 'Portfolio',
        'navHome': 'Inicio',
        'navAbout': 'Sobre Mí',
        'skillsTitle': 'Habilidades y Tecnologías',
        'resumeSectionTitle': 'Currículum',
        'navProjects': 'Proyectos',
        'navContact': 'Contacto',
        'headerName': 'Camilo Santacruz Abadiano',
        'headerTitle': 'Desarrollador Móvil',
        'headerSubtitle': 'Creando experiencias móviles hermosas',
        'aboutTitle': 'Sobre Mí',
        'aboutDescription':
            'Soy una persona curiosa apasionada por la tecnología...',
        'aboutSubtitle':
            'Un entusiasta de la tecnología que cree en el aprendizaje continuo...',
        'skillsSubtitle': 'Mi experiencia y herramientas con la que trabajo',
        'skillsLanguages': 'Lenguajes de Programación',
        'skillFlutter': 'Flutter & Dart',
        'skillDart': 'Dart',
        'skillKotlin': 'Kotlin',
        'skillKotlinMultiplatform': 'Kotlin Multiplatform',
        'skillSwift': 'Swift',
        'skillFlutterWeb': 'Flutter Web',
        'skillsDesign': 'Diseño y Animación',
        'skillRive': 'Rive',
        'skillFigma': 'Figma',
        'skillAdobeXD': 'Adobe XD',
        'skillsEditors': 'Editores y Herramientas',
        'skillAndroidStudio': 'Android Studio',
        'skillVSCode': 'Visual Studio Code',
        'skillCursor': 'Cursor',
        'skillGit': 'Git',
        'skillsDevOps': 'DevOps y CI/CD',
        'skillCodeMagic': 'CodeMagic',
        'skillGithubActions': 'Github Actions',
        'projectManagement': 'Gestión de Proyectos',
        'skillScrum': 'Scrum',
        'skillAgile': 'Agile',
        'skillKanban': 'Kanban',
        'resumeSectionDescription':
            'Descarga mi currículum actualizado. Si quieres saber más sobre mi experiencia, ¡este es el lugar!',
        'resumeDownload': 'Descargar',
        'resumeLastUpdated': 'Última actualización: ...',
        'projectsTitle': 'Mis Proyectos',
        'projectsSubtitle': 'Una selección de mis proyectos recientes.',
        'projectB4S': 'Brain4Goals App',
        'projectEcommerceDescription':
            'A comprehensive sports management app...',
        'projectKnowMore': 'Saber Más',
        'contactTitle': 'Ponte en Contacto',
        'contactSubtitle': 'Trabajemos juntos en tu próximo proyecto',
        'contactEmail': 'kamiomg00@gmail.com',
        'contactPhone': '+57 3025298355',
        'contactLocation': 'Funza, Cundinamarca, Colombia',
        'createdBy': 'Last Update: Local build',
        'version': 'v1.0.11',
      },
    );
  }

  /// Apply this configuration to the text animation registry
  /// Note: This functionality is temporarily disabled during refactor
  void applyToRegistry() {
    // TODO: Implement with new animation system
    print('Registry application temporarily disabled');
  }

  /// Get line index for a specific l10n key
  int? getLineIndex(String l10nKey) {
    for (final line in lines) {
      if (line.l10nKeys.contains(l10nKey)) {
        return line.order;
      }
    }
    return null;
  }

  /// Get section for a specific line
  TextSection? getSectionForLine(int lineIndex) {
    // This method needs to be updated to work with line IDs
    // For now, return null as we're transitioning to line IDs
    return null;
  }

  /// Get all l10n keys for a specific line
  List<String> getL10nKeysForLine(int lineIndex) {
    for (final line in lines) {
      if (line.order == lineIndex) {
        return line.l10nKeys;
      }
    }
    return [];
  }

  /// Export to JSON
  Map<String, dynamic> toJson() => {
    'sections': sections.map((s) => s.toJson()).toList(),
    'lines': lines.map((l) => l.toJson()).toList(),
    'l10nKeyToText': l10nKeyToText,
  };

  /// Import from JSON
  factory TextOrderConfig.fromJson(Map<String, dynamic> json) =>
      TextOrderConfig(
        sections: (json['sections'] as List)
            .map((s) => TextSection.fromJson(s))
            .toList(),
        lines: (json['lines'] as List)
            .map((l) => TextLine.fromJson(l))
            .toList(),
        l10nKeyToText: Map<String, String>.from(json['l10nKeyToText']),
      );
}

class TextSection {
  final String name;
  final List<String> lineIds; // Use line IDs instead of startLine/endLine
  final List<int> lineOrders; // Add line orders for better import/export
  final Color color;
  final int order; // Dynamic order based on Y position

  const TextSection({
    required this.name,
    required this.lineIds,
    required this.lineOrders,
    required this.color,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'lineIds': lineIds,
    'lineOrders': lineOrders,
    'color': color.value,
    'order': order,
  };

  factory TextSection.fromJson(Map<String, dynamic> json) => TextSection(
    name: json['name'],
    lineIds: List<String>.from(json['lineIds']),
    lineOrders: json['lineOrders'] != null
        ? List<int>.from(json['lineOrders'])
        : [], // Fallback for backward compatibility
    color: Color(json['color']),
    order: json['order'] ?? 0,
  );
}

class TextLine {
  final int order;
  final List<String> l10nKeys;
  final double height;
  final double yPosition;
  final List<Map<String, dynamic>> detectedTexts;

  const TextLine({
    required this.order,
    required this.l10nKeys,
    required this.height,
    required this.yPosition,
    this.detectedTexts = const [],
  });

  Map<String, dynamic> toJson() => {
    'order': order,
    'l10nKeys': l10nKeys,
    'height': height,
    'yPosition': yPosition,
    'detectedTexts': detectedTexts,
  };

  factory TextLine.fromJson(Map<String, dynamic> json) => TextLine(
    order: json['order'],
    l10nKeys: List<String>.from(json['l10nKeys']),
    height: json['height'].toDouble(),
    yPosition: json['yPosition']?.toDouble() ?? 0.0,
    detectedTexts: json['detectedTexts'] != null
        ? List<Map<String, dynamic>>.from(json['detectedTexts'])
        : [],
  );

  /// Create a copy of this TextLine with updated values
  TextLine copyWith({
    int? order,
    List<String>? l10nKeys,
    double? height,
    double? yPosition,
    List<Map<String, dynamic>>? detectedTexts,
  }) {
    return TextLine(
      order: order ?? this.order,
      l10nKeys: l10nKeys ?? this.l10nKeys,
      height: height ?? this.height,
      yPosition: yPosition ?? this.yPosition,
      detectedTexts: detectedTexts ?? this.detectedTexts,
    );
  }
}

/// Global configuration manager
class TextOrderConfigManager {
  static final TextOrderConfigManager _instance =
      TextOrderConfigManager._internal();
  factory TextOrderConfigManager() => _instance;
  TextOrderConfigManager._internal();

  TextOrderConfig _config = TextOrderConfig.defaultConfig();

  /// Get current configuration
  TextOrderConfig get config => _config;

  /// Update configuration
  void updateConfig(TextOrderConfig newConfig) {
    _config = newConfig;
    _config.applyToRegistry();
  }

  /// Load configuration from JSON string
  void loadFromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    _config = TextOrderConfig.fromJson(json);
    _config.applyToRegistry();
  }

  /// Export current configuration to JSON string
  String exportToJson() {
    return jsonEncode(_config.toJson());
  }

  /// Reset to default configuration
  void resetToDefault() {
    _config = TextOrderConfig.defaultConfig();
    _config.applyToRegistry();
  }
}
