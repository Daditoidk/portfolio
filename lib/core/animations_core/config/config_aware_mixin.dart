import 'animation_config_manager.dart';

/// Mixin that provides easy access to the singleton config manager
/// Any class using this mixin can easily access the latest config values
mixin ConfigAwareMixin {
  /// Get the singleton config manager instance
  AnimationConfigManager get configManager => AnimationConfigManager();

  /// Get current config (returns a copy to prevent external modification)
  Map<String, dynamic> get currentConfig => configManager.config;

  /// Get a specific config value with type safety
  T? getConfigValue<T>(String key) => configManager.getValue<T>(key);

  /// Get a specific config value with default fallback
  T getConfigValueOrDefault<T>(String key, T defaultValue) {
    final value = configManager.getValue<T>(key);
    return value ?? defaultValue;
  }

  /// Check if a config value exists
  bool hasConfigValue(String key) => configManager.hasValue(key);

  /// Get config for specific animation type
  Map<String, dynamic> getConfigForType(String animationType) {
    return configManager.getConfigForType(animationType);
  }

  /// Listen to config changes
  void listenToConfigChanges(Function(Map<String, dynamic>) listener) {
    configManager.addListener(listener);
  }

  /// Stop listening to config changes
  void stopListeningToConfigChanges(Function(Map<String, dynamic>) listener) {
    configManager.removeListener(listener);
  }

  /// Debug: Print current config
  void debugPrintConfig() {
    print('ConfigAwareMixin: Current config: $currentConfig');
  }
}
