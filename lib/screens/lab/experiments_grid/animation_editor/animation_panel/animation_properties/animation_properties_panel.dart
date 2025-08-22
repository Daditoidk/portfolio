import 'package:flutter/material.dart';
import 'animation_property_config.dart';
import '../styles/styles.dart';

/// Widget for the animation properties panel (renamed from settings panel)
class AnimationPropertiesPanel extends StatefulWidget {
  final String? selectedAnimation;
  final Function(String) onAnimationChanged;
  final Function(Map<String, dynamic>) onSettingsChanged;
  final Map<String, dynamic> currentSettings;

  const AnimationPropertiesPanel({
    super.key,
    required this.selectedAnimation,
    required this.onAnimationChanged,
    required this.onSettingsChanged,
    required this.currentSettings,
  });

  @override
  State<AnimationPropertiesPanel> createState() =>
      _AnimationPropertiesPanelState();
}

class _AnimationPropertiesPanelState extends State<AnimationPropertiesPanel> {
  // Dynamic settings map based on selected animation
  final Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    // Load current settings from widget
    _settings.addAll(widget.currentSettings);

    // Initialize with default values for the selected animation
    if (widget.selectedAnimation != null) {
      final config = AnimationPropertyConfigs.getConfig(
        widget.selectedAnimation!,
      );
      if (config != null) {
        for (final property in config.properties) {
          if (!_settings.containsKey(property.name)) {
            _settings[property.name] = property.defaultValue;
          }
        }
      }
    }
  }

  void _updateSettings() {
    widget.onSettingsChanged(_settings);
  }

  void _onPropertyChanged(String propertyName, dynamic value) {
    setState(() {
      print(
        'Property changed: $propertyName = $value (type: ${value.runtimeType})',
      );

      // Handle special case for text order import validation
      if (propertyName == 'Text Order Data' && value is Map) {
        // Check if this is a validation response or direct JSON data
        if (value.containsKey('validationStatus')) {
          // This is a validation response
          final validationStatus = value['validationStatus'] as bool?;
          final data = value['data'];

          print(
            'Text Order Import - Property: $propertyName, Validation: $validationStatus, Data: ${data != null ? 'Valid' : 'Invalid'}',
          );

          if (validationStatus == true && data != null) {
            _settings[propertyName] = data;
            _settings['_textOrderValid'] = true;
            print('Text Order Valid: true');
          } else {
            _settings['_textOrderValid'] = false;
            print('Text Order Valid: false');
          }
        } else {
          // This is direct JSON data (the actual import)
          print('Text Order Data received directly: ${value.keys}');
          _settings[propertyName] = value;
          _settings['_textOrderValid'] = true;
          print('Text Order Valid: true (direct JSON data)');
        }
      } else {
        _settings[propertyName] = value;
      }

      _updateSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedAnimation == null) {
      return _buildNoAnimationSelected();
    }

    final config = AnimationPropertyConfigs.getConfig(
      widget.selectedAnimation!,
    );
    if (config == null) {
      return _buildNoConfigFound();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animation Properties Header
        _buildPropertiesHeader(),

        const SizedBox(height: 16),

        // Dynamic Properties based on animation configuration
        ...config.properties
            .where((property) {
              // Hide Text Order Preview if text order is not valid
              if (property.name == 'Text Order Preview') {
                final isValid = _settings['_textOrderValid'] == true;
                print('Text Order Preview visibility check: $isValid');
                return isValid;
              }
              return true;
            })
            .map((property) {
              final propertyValue = property.name == 'Text Order Preview'
                  ? _settings['Text Order Data']
                  : _settings[property.name];

              print(
                'Creating property widget: ${property.name} with value: ${propertyValue != null ? propertyValue.runtimeType : 'null'}',
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PropertyWidgetFactory.createPropertyWidget(
                  property,
                  propertyValue,
                  (value) => _onPropertyChanged(property.name, value),
                ),
              );
            }),
      ],
    );
  }

  Widget _buildNoAnimationSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.animation, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Select an animation to configure properties',
            style: AnimationPanelStyles.subheading.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoConfigFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.orange.shade400),
          const SizedBox(height: 16),
          Text(
            'No configuration found for this animation',
            style: AnimationPanelStyles.subheading.copyWith(
              color: Colors.orange.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesHeader() {
    return Row(
      children: [
        Icon(Icons.settings, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          'Animation Properties',
          style: AnimationPanelStyles.subheading.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
