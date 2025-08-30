import 'package:flutter/foundation.dart';

/// Singleton manager for animation configuration
/// Ensures all classes have access to the latest, consistent config values
class AnimationConfigManager {
  static final AnimationConfigManager _instance =
      AnimationConfigManager._internal();
  factory AnimationConfigManager() => _instance;
  AnimationConfigManager._internal();

  /// Current animation configuration
  final Map<String, dynamic> _config = <String, dynamic>{};

  /// Listeners for config changes
  final List<Function(Map<String, dynamic>)> _listeners = [];

  /// Get current config (returns a copy to prevent external modification)
  Map<String, dynamic> get config => Map<String, dynamic>.from(_config);

  /// Get a specific config value
  T? getValue<T>(String key) {
    return _config[key] as T?;
  }

  /// Set a specific config value
  void setValue<T>(String key, T value) {
    debugPrint('AnimationConfigManager: Setting $key = $value');
    _config[key] = value;
    _notifyListeners();
  }

  /// Update multiple config values at once
  void updateConfig(Map<String, dynamic> newConfig) {
    debugPrint('AnimationConfigManager: Updating config with $newConfig');
    _config.addAll(newConfig);
    _notifyListeners();
  }

  /// Replace entire config
  void replaceConfig(Map<String, dynamic> newConfig) {
    debugPrint(
      'AnimationConfigManager: Replacing entire config with $newConfig',
    );
    _config.clear();
    _config.addAll(newConfig);
    _notifyListeners();
  }

  /// Reset config to default values
  void resetToDefaults() {
    debugPrint('AnimationConfigManager: Resetting to defaults');
    _config.clear();
    _config.addAll(_getDefaultConfig());
    _notifyListeners();
  }

  /// Get default configuration
  Map<String, dynamic> _getDefaultConfig() {
    return {
      'duration': 1000,
      'Speed': 1.0,
      'delay': 0,
      'Loop': false,
      'Direction': 'Left to Right',
      'Scramble Intensity': 0.5,
    };
  }

  /// Add listener for config changes
  void addListener(Function(Map<String, dynamic>) listener) {
    _listeners.add(listener);
  }

  /// Remove listener
  void removeListener(Function(Map<String, dynamic>) listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners of config changes
  void _notifyListeners() {
    final currentConfig = config; // Send copy to listeners
    for (final listener in _listeners) {
      try {
        listener(currentConfig);
      } catch (e) {
        debugPrint('AnimationConfigManager: Error notifying listener: $e');
      }
    }
  }

  /// Get config for specific animation type
  Map<String, dynamic> getConfigForType(String animationType) {
    final baseConfig = config;
    // Add type-specific defaults if needed
    switch (animationType.toLowerCase()) {
      case 'scramble':
        baseConfig['Scramble Intensity'] ??= 0.5;
        break;
      case 'fade':
        baseConfig['Fade Duration'] ??= 500;
        break;
      case 'slide':
        baseConfig['Slide Distance'] ??= 50.0;
        break;
    }
    return baseConfig;
  }

  /// Check if a specific config value is set
  bool hasValue(String key) => _config.containsKey(key);

  /// Get all config keys
  Set<String> get keys => _config.keys.toSet();

  /// Get config as string for debugging
  @override
  String toString() {
    return 'AnimationConfigManager(config: $_config)';
  }
}
