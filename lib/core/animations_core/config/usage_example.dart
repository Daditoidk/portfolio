// Example of how to use the AnimationConfigManager in your property panel
// This file shows the pattern for updating and accessing config values

import 'animation_config_manager.dart';

/// Example: How to update config when user changes a property
class PropertyPanelExample {
  void onLoopPropertyChanged(bool newValue) {
    // Update the singleton config manager
    final configManager = AnimationConfigManager();
    configManager.setValue('Loop', newValue);

    // Now ALL classes using the config manager will get the updated value
    print('Loop property updated to: $newValue');
  }

  void onSpeedPropertyChanged(double newValue) {
    final configManager = AnimationConfigManager();
    configManager.setValue('Speed', newValue);
    print('Speed property updated to: $newValue');
  }

  void onMultiplePropertiesChanged(Map<String, dynamic> newValues) {
    final configManager = AnimationConfigManager();
    configManager.updateConfig(newValues);
    print('Multiple properties updated: $newValues');
  }
}

/// Example: How to listen to config changes
class ConfigListenerExample {
  void startListening() {
    final configManager = AnimationConfigManager();

    // Listen to all config changes
    configManager.addListener((updatedConfig) {
      print('Config changed: $updatedConfig');

      // React to specific changes
      if (updatedConfig['Loop'] == true) {
        print('Loop was enabled!');
      }
    });
  }

  void stopListening() {
    final configManager = AnimationConfigManager();
    // You would store the listener function reference to remove it later
    // configManager.removeListener(yourListenerFunction);
  }
}

/// Example: How to get current config values
class ConfigReaderExample {
  void readCurrentConfig() {
    final configManager = AnimationConfigManager();

    // Get specific values
    final loopValue = configManager.getValue<bool>('Loop');
    final speedValue = configManager.getValue<double>('Speed');

    // Get entire config (copy)
    final fullConfig = configManager.config;

    print('Current Loop: $loopValue');
    print('Current Speed: $speedValue');
    print('Full Config: $fullConfig');
  }
}

/// Example: How to initialize config with defaults
class ConfigInitializerExample {
  void initializeConfig() {
    final configManager = AnimationConfigManager();

    // Set initial values
    configManager.updateConfig({
      'Loop': false,
      'Speed': 1.0,
      'duration': 1000,
      'Direction': 'Left to Right',
      'Scramble Intensity': 0.5,
    });

    print('Config initialized with defaults');
  }
}
