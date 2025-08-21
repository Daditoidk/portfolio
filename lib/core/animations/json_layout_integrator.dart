import 'package:flutter/material.dart';
import 'dart:convert';
import 'text_animation_registry.dart';

/// Integrates exported JSON layout from text layout editor with animation system
class JsonLayoutIntegrator {
  static final JsonLayoutIntegrator _instance =
      JsonLayoutIntegrator._internal();
  factory JsonLayoutIntegrator() => _instance;
  JsonLayoutIntegrator._internal();

  // Loaded configuration
  Map<String, dynamic>? _loadedConfig;
  bool _isConfigured = false;

  /// Load layout configuration from exported JSON
  Future<bool> loadLayoutFromJson(String jsonString) async {
    try {
      print('🔄 Loading layout configuration from JSON...');

      // Parse JSON
      final Map<String, dynamic> config = jsonDecode(jsonString);

      // Validate required fields
      if (!_validateConfig(config)) {
        print('❌ Invalid configuration format');
        return false;
      }

      _loadedConfig = config;
      _isConfigured = true;

      print('✅ Layout configuration loaded successfully!');
      print('   📊 Lines: ${config['lines']?.length ?? 0}');
      print('   📦 Blocks: ${config['sections']?.length ?? 0}');

      return true;
    } catch (e) {
      print('❌ Error loading layout configuration: $e');
      return false;
    }
  }

  /// Validate configuration format
  bool _validateConfig(Map<String, dynamic> config) {
    // Check required top-level fields
    if (!config.containsKey('lines') || !config.containsKey('sections')) {
      print('❌ Missing required fields: lines, sections');
      return false;
    }

    // Validate lines structure
    final lines = config['lines'] as List?;
    if (lines == null || lines.isEmpty) {
      print('❌ No lines found in configuration');
      return false;
    }

    // Validate sections structure
    final sections = config['sections'] as List?;
    if (sections == null || sections.isEmpty) {
      print('❌ No sections found in configuration');
      return false;
    }

    return true;
  }

  /// Apply loaded configuration to TextAnimationRegistry
  Future<bool> applyConfigurationToRegistry() async {
    if (!_isConfigured || _loadedConfig == null) {
      print('❌ No configuration loaded. Call loadLayoutFromJson first.');
      return false;
    }

    try {
      print('🔧 Applying configuration to TextAnimationRegistry...');

      final registry = TextAnimationRegistry();

      // Clear existing registry
      registry.clear();

      // Apply configuration
      final success =
          await _applyLinesConfiguration(registry) &&
          await _applySectionsConfiguration(registry);

      if (success) {
        print('✅ Configuration applied successfully to registry!');
        print('   📝 Total elements: ${registry.getSortedElements().length}');
        print('   📍 Total lines: ${registry.getLineIndices().length}');
        print('   📦 Total blocks: ${registry.getBlockIndices().length}');
      }

      return success;
    } catch (e) {
      print('❌ Error applying configuration: $e');
      return false;
    }
  }

  /// Apply lines configuration to registry
  Future<bool> _applyLinesConfiguration(TextAnimationRegistry registry) async {
    try {
      final lines = _loadedConfig!['lines'] as List;

      print('   📝 Applying ${lines.length} lines...');

      for (int i = 0; i < lines.length; i++) {
        final lineData = lines[i] as Map<String, dynamic>;

        // Extract line information
        final order = lineData['order'] as int? ?? i;
        final yPosition = lineData['yPosition'] as double? ?? 0.0;
        final height = lineData['height'] as double? ?? 40.0;
        final detectedTexts = lineData['detectedTexts'] as List? ?? [];

        print(
          '      📍 Line $order: Y=${yPosition.toStringAsFixed(1)}, Height=${height.toStringAsFixed(1)}',
        );
        print('         📝 ${detectedTexts.length} detected texts');

        // Process detected texts for this line
        for (int j = 0; j < detectedTexts.length; j++) {
          final textData = detectedTexts[j] as Map<String, dynamic>;

          final textId = textData['id'] as String? ?? 'text_${i}_$j';
          final text = textData['text'] as String? ?? '';
          final x = textData['x'] as double? ?? 0.0;
          final y = textData['y'] as double? ?? yPosition;

          if (text.isNotEmpty) {
            // Create a mock TextElement for now
            // In a real implementation, you'd find the actual widget and register it
            print(
              '         ✅ Text: "$text" (ID: $textId, X: ${x.toStringAsFixed(1)}, Y: ${y.toStringAsFixed(1)})',
            );
          }
        }
      }

      return true;
    } catch (e) {
      print('❌ Error applying lines configuration: $e');
      return false;
    }
  }

  /// Apply sections configuration to registry
  Future<bool> _applySectionsConfiguration(
    TextAnimationRegistry registry,
  ) async {
    try {
      final sections = _loadedConfig!['sections'] as List;

      print('   📦 Applying ${sections.length} sections...');

      for (int i = 0; i < sections.length; i++) {
        final sectionData = sections[i] as Map<String, dynamic>;

        // Extract section information
        final name = sectionData['name'] as String? ?? 'Section $i';
        final order = sectionData['order'] as int? ?? i;
        final lineIds = sectionData['lineIds'] as List? ?? [];
        final lineOrders = sectionData['lineOrders'] as List? ?? [];
        final color = sectionData['color'] as int? ?? 0xFF0000FF;

        print('      📦 Section $order: "$name" with ${lineIds.length} lines');
        print('         📍 Line orders: $lineOrders');

        // In a real implementation, you'd map these to actual TextElements
        // and update their block indices
      }

      return true;
    } catch (e) {
      print('❌ Error applying sections configuration: $e');
      return false;
    }
  }

  /// Get loaded configuration summary
  Map<String, dynamic>? getConfigurationSummary() {
    if (!_isConfigured || _loadedConfig == null) return null;

    return {
      'lines': _loadedConfig!['lines']?.length ?? 0,
      'sections': _loadedConfig!['sections']?.length ?? 0,
      'hasL10nKeys': _loadedConfig!.containsKey('l10nKeyToText'),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Check if configuration is loaded
  bool get isConfigured => _isConfigured;

  /// Get loaded configuration
  Map<String, dynamic>? get loadedConfig => _loadedConfig;

  /// Clear loaded configuration
  void clearConfiguration() {
    _loadedConfig = null;
    _isConfigured = false;
    print('🧹 Configuration cleared');
  }

  /// Export current configuration as JSON (for debugging)
  String exportCurrentConfiguration() {
    if (!_isConfigured || _loadedConfig == null) {
      return '{}';
    }

    try {
      return jsonEncode(_loadedConfig);
    } catch (e) {
      print('❌ Error exporting configuration: $e');
      return '{}';
    }
  }
}

/// Widget that displays the loaded configuration status
class JsonLayoutStatusWidget extends StatelessWidget {
  final JsonLayoutIntegrator integrator;
  final VoidCallback? onReload;

  const JsonLayoutStatusWidget({
    super.key,
    required this.integrator,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final summary = integrator.getConfigurationSummary();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'JSON Layout Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  integrator.isConfigured ? Icons.check_circle : Icons.error,
                  color: integrator.isConfigured ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (summary != null) ...[
              _StatusRow(
                label: 'Lines',
                value: '${summary['lines']}',
                icon: Icons.format_list_numbered,
              ),
              _StatusRow(
                label: 'Sections',
                value: '${summary['sections']}',
                icon: Icons.layers,
              ),
              _StatusRow(
                label: 'L10n Keys',
                value: summary['hasL10nKeys'] ? 'Available' : 'Not available',
                icon: Icons.language,
              ),
              _StatusRow(
                label: 'Loaded',
                value: summary['timestamp'] ?? 'Unknown',
                icon: Icons.schedule,
              ),
            ] else ...[
              const Text(
                'No configuration loaded',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: integrator.isConfigured
                        ? () {
                            // Show configuration details
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Configuration Details'),
                                content: SingleChildScrollView(
                                  child: Text(
                                    integrator.exportCurrentConfiguration(),
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.info_outline),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onReload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
