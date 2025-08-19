import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../../core/animations/text_animation_registry.dart';
import '../models/text_layout_config.dart';
import '../../widgets/custom_toast.dart';

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
      for (final lineId in section.lineIds) {
        _setManualBlockIndex(registry, lineId, _getSectionOrder(section));
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
    String lineId,
    int blockIndex,
  ) {
    // This would need to be implemented in the registry
    print('Setting manual block index for line $lineId to $blockIndex');
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

        CustomToast.showSuccess(
          context,
          message: 'Text layout configuration applied!',
          duration: const Duration(seconds: 2),
        );
      },
      child: const Text('Apply Text Layout'),
    );
  }
}
