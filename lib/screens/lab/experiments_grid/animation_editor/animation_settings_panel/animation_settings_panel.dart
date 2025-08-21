import 'package:flutter/material.dart';
import 'animation_panel_styles.dart';
import 'animation_property_config.dart';

class AnimationSettingsPanel extends StatefulWidget {
  final String? selectedAnimation;
  final Function(String) onAnimationChanged;
  final Function(Map<String, dynamic>) onSettingsChanged;
  final Map<String, dynamic> currentSettings;

  const AnimationSettingsPanel({
    super.key,
    required this.selectedAnimation,
    required this.onAnimationChanged,
    required this.onSettingsChanged,
    required this.currentSettings,
  });

  @override
  State<AnimationSettingsPanel> createState() => _AnimationSettingsPanelState();
}

class _AnimationSettingsPanelState extends State<AnimationSettingsPanel> {
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
      _settings[propertyName] = value;
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
        // Animation Settings Header
        _buildSettingsHeader(),

        const SizedBox(height: 16),

        // Dynamic Properties based on animation configuration
        ...config.properties.map(
          (property) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PropertyWidgetFactory.createPropertyWidget(
              property,
              _settings[property.name],
              (value) => _onPropertyChanged(property.name, value),
            ),
          ),
        ),
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
            'Select an animation to configure settings',
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

  Widget _buildSettingsHeader() {
    return Row(
      children: [
        Icon(Icons.settings, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          'Animation Settings',
          style: AnimationPanelStyles.subheading.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
