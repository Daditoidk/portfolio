import 'package:flutter/material.dart';
import 'dart:convert';

import '../models/text_order_config.dart';
import '../../../../widgets/custom_toast.dart';

/// Integration layer between Text Order Visualizer and text animation registry
/// Note: TextAnimationRegistry functionality has been removed during refactor
class TextOrderIntegration {
  static final TextOrderIntegration _instance =
      TextOrderIntegration._internal();
  factory TextOrderIntegration() => _instance;
  TextOrderIntegration._internal();

  /// Apply configuration to the text animation registry
  /// Note: This functionality is temporarily disabled
  void applyConfiguration(TextOrderConfig config) {
    // TODO: Implement with new animation system
    print('Configuration application temporarily disabled');
  }

  /// Get current configuration from registry
  /// Note: This functionality is temporarily disabled
  TextOrderConfig getCurrentConfiguration() {
    // Return default configuration for now
    return TextOrderConfig.defaultConfig();
  }

  /// Save configuration to shared preferences or file
  Future<void> saveConfiguration(TextOrderConfig config) async {
    final json = config.toJson();
    final jsonString = jsonEncode(json);

    // You can save this to SharedPreferences, file, or any storage
    print('Configuration saved: $jsonString');

    // Apply to registry
    applyConfiguration(config);
  }

  /// Load configuration from storage
  Future<TextOrderConfig?> loadConfiguration() async {
    // You can load from SharedPreferences, file, or any storage
    // For now, return default config
    return TextOrderConfig.defaultConfig();
  }
}

/// Widget to apply configuration in production
class TextOrderConfigurationWidget extends StatelessWidget {
  final TextOrderConfig config;
  final VoidCallback? onApplied;

  const TextOrderConfigurationWidget({
    super.key,
    required this.config,
    this.onApplied,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        TextOrderIntegration().applyConfiguration(config);
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
