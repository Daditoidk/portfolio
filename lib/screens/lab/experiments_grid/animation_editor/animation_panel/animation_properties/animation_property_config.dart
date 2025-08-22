import 'package:flutter/material.dart' hide ColorProperty;
import 'properties/index.dart';

/// Configuration for animation properties
class AnimationPropertyConfig {
  final String animationId;
  final List<PropertyConfig> properties;

  const AnimationPropertyConfig({
    required this.animationId,
    required this.properties,
  });
}

/// Configuration for a single property
class PropertyConfig {
  final String name;
  final PropertyType type;
  final dynamic defaultValue;
  final Map<String, dynamic>? options;
  final String? description;
  final bool required;

  const PropertyConfig({
    required this.name,
    required this.type,
    required this.defaultValue,
    this.options,
    this.description,
    this.required = false,
  });
}

/// Types of properties
enum PropertyType {
  dropdown,
  numeric,
  slider,
  checkbox,
  text,
  color,
  textOrderImport,
  textOrderPreview,
  exportType,
  preview,
  custom,
}

/// Factory class to create property widgets
class PropertyWidgetFactory {
  static Widget createPropertyWidget(
    PropertyConfig config,
    dynamic currentValue,
    Function(dynamic) onChanged,
  ) {
    switch (config.type) {
      case PropertyType.dropdown:
        return DropdownProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          unit: config.options?['unit'] as String?,
          value: (currentValue as String?) ?? config.defaultValue as String,
          options: (config.options?['options'] as List<String>?) ?? [],
          onChanged: onChanged,
          placeholder: config.options?['placeholder'] as String?,
        );

      case PropertyType.numeric:
        return NumericProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          unit: config.options?['unit'] as String?,
          value: (currentValue as double?) ?? config.defaultValue as double,
          onChanged: onChanged,
          minValue: config.options?['min'],
          maxValue: config.options?['max'],
          decimalPlaces: config.options?['decimalPlaces'] ?? 2,
        );

      case PropertyType.slider:
        return SliderProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          unit: config.options?['unit'] as String?,
          value: (currentValue as double?) ?? config.defaultValue as double,
          onChanged: onChanged,
          minValue: config.options?['min'],
          maxValue: config.options?['max'],
          decimalPlaces: config.options?['decimalPlaces'] ?? 1,
        );

      case PropertyType.checkbox:
        return CheckboxProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          value: (currentValue as bool?) ?? config.defaultValue as bool,
          onChanged: onChanged,
        );

      case PropertyType.text:
        return TextProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          unit: config.options?['unit'] as String?,
          value: (currentValue as String?) ?? config.defaultValue as String,
          onChanged: onChanged,
          placeholder: config.options?['placeholder'] as String?,
          maxLines: config.options?['maxLines'] ?? 1,
        );

      case PropertyType.color:
        return ColorProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          unit: config.options?['unit'] as String?,
          value: (currentValue as Color?) ?? config.defaultValue as Color,
          onChanged: onChanged,
          predefinedColors: config.options?['colors'] as List<Color>?,
        );

      case PropertyType.textOrderImport:
        return TextOrderImportProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          value: currentValue,
          onChanged: onChanged,
          onValidationChanged: (isValid) {
            print(
              'PropertyWidgetFactory - TextOrderImport validation: $isValid',
            );
            // We need to pass the actual parsed JSON data, not currentValue
            // The data will be passed through the onChanged callback from the import widget
            if (isValid) {
              // The import widget will call onChanged with the parsed data
              // We just need to signal that validation passed
              onChanged({'validationStatus': isValid, 'data': null});
            } else {
              onChanged({'validationStatus': isValid, 'data': null});
            }
          },
        );

      case PropertyType.textOrderPreview:
        return TextOrderPreviewProperty(
          propertyName: config.name,
          description: config.description,
          required: config.required,
          value: currentValue,
          onChanged: onChanged,
        );

      case PropertyType.exportType:
        // TODO: Implement ExportTypeProperty
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Export Type: ${currentValue ?? config.defaultValue}',
            style: TextStyle(fontSize: 12),
          ),
        );

      case PropertyType.preview:
        return Container();
      case PropertyType.custom:
        // Return the text scramble preview widget
        return Container();
    }
  }
}

/// Predefined animation property configurations
class AnimationPropertyConfigs {
  static const Map<String, AnimationPropertyConfig> configs = {
    // Text Animations
    'text_scramble': AnimationPropertyConfig(
      animationId: 'text_scramble',
      properties: [
        PropertyConfig(
          name: 'Direction',
          type: PropertyType.dropdown,
          defaultValue: 'Left to Right',
          options: {
            'options': [
              'Left to Right',
              'Right to Left',
              'Top to Bottom',
              'Bottom to Top',
            ],
          },
          description: 'Direction of the scramble effect',
        ),
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.slider,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
          description: 'Animation speed multiplier',
        ),
        PropertyConfig(
          name: 'Scramble Intensity',
          type: PropertyType.slider,
          defaultValue: 0.5,
          options: {'min': 0.1, 'max': 1.0, 'decimalPlaces': 2},
          description: 'How much the text scrambles',
        ),
        PropertyConfig(
          name: 'Loop',
          type: PropertyType.checkbox,
          defaultValue: false,
          description: 'Repeat the animation indefinitely',
        ),
        PropertyConfig(
          name: 'Animation Preview',
          type: PropertyType.preview,
          defaultValue: null,
          description: 'Live preview of current animation settings',
        ),
        PropertyConfig(
          name: 'Text Order Data',
          type: PropertyType.textOrderImport,
          defaultValue: null,
          description: 'Import text order data for complex animations',
        ),

        PropertyConfig(
          name: 'Text Order Preview',
          type: PropertyType.textOrderPreview,
          defaultValue: null,
          description: 'Preview of imported text order data',
        ),

        // PropertyConfig(
        //   name: 'Export Type',
        //   type: PropertyType.exportType,
        //   defaultValue: 'JSON',
        //   options: {
        //     'exportTypes': ['JSON', 'Dart Code', 'CSV', 'XML'],
        //   },
        //   description: 'Format for exporting the animation',
        // ),
      ],
    ),

    'text_fade_in': AnimationPropertyConfig(
      animationId: 'text_fade_in',
      properties: [
        PropertyConfig(
          name: 'Direction',
          type: PropertyType.dropdown,
          defaultValue: 'Left to Right',
          options: {
            'options': [
              'Left to Right',
              'Right to Left',
              'Top to Bottom',
              'Bottom to Top',
            ],
          },
        ),
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.slider,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
        ),
        PropertyConfig(
          name: 'Delay',
          type: PropertyType.slider,
          defaultValue: 0.0,
          options: {'min': 0.0, 'max': 5.0, 'decimalPlaces': 1, 'unit': 's'},
        ),
        PropertyConfig(
          name: 'Reverse',
          type: PropertyType.checkbox,
          defaultValue: false,
        ),
      ],
    ),

    'text_typewriter': AnimationPropertyConfig(
      animationId: 'text_typewriter',
      properties: [
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.slider,
          defaultValue: 0.1,
          options: {'min': 0.05, 'max': 0.5, 'decimalPlaces': 2, 'unit': 's'},
          description: 'Delay between each character',
        ),
        PropertyConfig(
          name: 'Sound Effect',
          type: PropertyType.checkbox,
          defaultValue: false,
          description: 'Play typewriter sound',
        ),
        PropertyConfig(
          name: 'Cursor Blink',
          type: PropertyType.checkbox,
          defaultValue: true,
        ),
      ],
    ),

    // Transition Animations
    'transition_fade_right': AnimationPropertyConfig(
      animationId: 'transition_fade_right',
      properties: [
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.numeric,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
        ),
        PropertyConfig(
          name: 'Distance',
          type: PropertyType.numeric,
          defaultValue: 100.0,
          options: {
            'min': 50.0,
            'max': 300.0,
            'decimalPlaces': 0,
            'unit': 'px',
          },
        ),
        PropertyConfig(
          name: 'Easing',
          type: PropertyType.dropdown,
          defaultValue: 'Ease In Out',
          options: {
            'options': [
              'Ease In Out',
              'Ease In',
              'Ease Out',
              'Linear',
              'Bounce',
            ],
          },
        ),
      ],
    ),

    'transition_flashlight': AnimationPropertyConfig(
      animationId: 'transition_flashlight',
      properties: [
        PropertyConfig(
          name: 'Intensity',
          type: PropertyType.numeric,
          defaultValue: 0.8,
          options: {'min': 0.1, 'max': 1.0, 'decimalPlaces': 2},
        ),
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.numeric,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
        ),
        PropertyConfig(
          name: 'Color',
          type: PropertyType.color,
          defaultValue: Colors.white,
          options: {
            'colors': [Colors.white, Colors.yellow, Colors.orange, Colors.red],
          },
        ),
      ],
    ),

    // Image Animations
    'image_reveal': AnimationPropertyConfig(
      animationId: 'image_reveal',
      properties: [
        PropertyConfig(
          name: 'Direction',
          type: PropertyType.dropdown,
          defaultValue: 'Left to Right',
          options: {
            'options': [
              'Left to Right',
              'Right to Left',
              'Top to Bottom',
              'Bottom to Top',
            ],
          },
        ),
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.numeric,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
        ),
        PropertyConfig(
          name: 'Reveal Type',
          type: PropertyType.dropdown,
          defaultValue: 'Linear',
          options: {
            'options': ['Linear', 'Radial', 'Diagonal', 'Random'],
          },
        ),
      ],
    ),

    // Effect Animations
    'effect_bounce': AnimationPropertyConfig(
      animationId: 'effect_bounce',
      properties: [
        PropertyConfig(
          name: 'Intensity',
          type: PropertyType.numeric,
          defaultValue: 0.5,
          options: {'min': 0.1, 'max': 1.0, 'decimalPlaces': 2},
        ),
        PropertyConfig(
          name: 'Speed',
          type: PropertyType.numeric,
          defaultValue: 1.0,
          options: {'min': 0.1, 'max': 3.0, 'decimalPlaces': 1, 'unit': 'x'},
        ),
        PropertyConfig(
          name: 'Bounce Count',
          type: PropertyType.numeric,
          defaultValue: 3,
          options: {'min': 1, 'max': 10, 'decimalPlaces': 0},
        ),
      ],
    ),
  };

  /// Get configuration for a specific animation
  static AnimationPropertyConfig? getConfig(String animationId) {
    return configs[animationId];
  }

  /// Get all available animation IDs
  static List<String> getAvailableAnimationIds() {
    return configs.keys.toList();
  }
}
