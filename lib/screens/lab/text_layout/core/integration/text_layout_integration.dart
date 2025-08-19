import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../../core/animations/text_animation_registry.dart';
import '../models/text_layout_config.dart';

/// Integration layer between visual editor and text animation registry
class TextLayoutIntegration {
  static final TextLayoutIntegration _instance =
      TextLayoutIntegration._internal();
  factory TextLayoutIntegration() => _instance;
  TextLayoutIntegration._internal();

  /// Apply configuration to the text animation registry
  void applyConfiguration(TextLayoutConfig config) {
    final registry = TextAnimationRegistry();

    // Clear existing manual overrides
    registry.clear();

    // Apply line mappings to registry
    for (final line in config.lines) {
      for (final l10nKey in line.l10nKeys) {
        _setManualLineIndex(registry, l10nKey, line.order);
      }
    }

    // Apply section mappings to registry
    for (final section in config.sections) {
      for (int i = section.startLine; i <= section.endLine; i++) {
        _setManualBlockIndex(registry, i, _getSectionOrder(section));
      }
    }

    // Force registry to recalculate by calling a method that triggers recalculation
    registry.setUseManualOverrides(true);
  }

  /// Set manual line index for a specific l10n key
  void _setManualLineIndex(
    TextAnimationRegistry registry,
    String l10nKey,
    int lineIndex,
  ) {
    // This would need to be implemented in the registry
    // For now, we'll use the existing setupManualOverrides method
    print('Setting manual line index for $l10nKey to $lineIndex');
  }

  /// Set manual block index for a specific line
  void _setManualBlockIndex(
    TextAnimationRegistry registry,
    int lineIndex,
    int blockIndex,
  ) {
    // This would need to be implemented in the registry
    print('Setting manual block index for line $lineIndex to $blockIndex');
  }

  /// Get section order (for block index)
  int _getSectionOrder(TextSection section) {
    // You can customize this based on your needs
    // For now, using a simple mapping
    switch (section.name.toLowerCase()) {
      case 'navigation':
        return 0;
      case 'header':
        return 1;
      case 'about':
        return 2;
      case 'skills':
        return 3;
      case 'resume':
        return 4;
      case 'projects':
        return 5;
      case 'contact':
        return 6;
      case 'footer':
        return 7;
      default:
        return 0;
    }
  }

  /// Get current configuration from registry
  TextLayoutConfig getCurrentConfiguration() {
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    // Group by line index
    final lineGroups = <int, List<TextElement>>{};
    for (final element in elements) {
      lineGroups.putIfAbsent(element.lineIndex, () => []).add(element);
    }

    // Create lines
    final lines = <TextLine>[];
    for (int i = 0; i < 33; i++) {
      if (lineGroups.containsKey(i)) {
        final lineElements = lineGroups[i]!;
        lines.add(
          TextLine(
            order: i,
            l10nKeys: lineElements
                .map((e) => e.id ?? '')
                .where((id) => id.isNotEmpty)
                .toList(),
            height: 60.0,
            yPosition: i * 60.0,
          ),
        );
      } else {
        lines.add(
          TextLine(order: i, l10nKeys: [], height: 60.0, yPosition: i * 60.0),
        );
      }
    }

    // Create default sections
    final sections = [
      TextSection(
        name: 'Navigation',
        startLine: 0,
        endLine: 0,
        color: Colors.blue,
      ),
      TextSection(
        name: 'Header',
        startLine: 1,
        endLine: 3,
        color: Colors.green,
      ),
      TextSection(
        name: 'About',
        startLine: 4,
        endLine: 6,
        color: Colors.orange,
      ),
      TextSection(
        name: 'Skills',
        startLine: 7,
        endLine: 18,
        color: Colors.purple,
      ),
      TextSection(
        name: 'Resume',
        startLine: 19,
        endLine: 22,
        color: Colors.red,
      ),
      TextSection(
        name: 'Projects',
        startLine: 23,
        endLine: 27,
        color: Colors.teal,
      ),
      TextSection(
        name: 'Contact',
        startLine: 28,
        endLine: 30,
        color: Colors.indigo,
      ),
      TextSection(
        name: 'Footer',
        startLine: 31,
        endLine: 32,
        color: Colors.grey,
      ),
    ];

    return TextLayoutConfig(
      sections: sections,
      lines: lines,
      l10nKeyToText: _getL10nKeyToText(),
    );
  }

  /// Get l10n key to text mapping
  Map<String, String> _getL10nKeyToText() {
    // This should come from your actual localization system
    // For now, using the default mapping
    return TextLayoutConfig.defaultConfig().l10nKeyToText;
  }

  /// Save configuration to shared preferences or file
  Future<void> saveConfiguration(TextLayoutConfig config) async {
    final json = config.toJson();
    final jsonString = jsonEncode(json);

    // You can save this to SharedPreferences, file, or any storage
    print('Configuration saved: $jsonString');

    // Apply to registry
    applyConfiguration(config);
  }

  /// Load configuration from storage
  Future<TextLayoutConfig?> loadConfiguration() async {
    // You can load from SharedPreferences, file, or any storage
    // For now, return default config
    return TextLayoutConfig.defaultConfig();
  }
}

/// Widget to apply configuration in production
class TextLayoutConfigurationWidget extends StatelessWidget {
  final TextLayoutConfig config;
  final VoidCallback? onApplied;

  const TextLayoutConfigurationWidget({
    super.key,
    required this.config,
    this.onApplied,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        TextLayoutIntegration().applyConfiguration(config);
        onApplied?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text layout configuration applied!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: const Text('Apply Text Layout'),
    );
  }
}
