import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Dropdown property widget with Riverpod integration
class DropdownPropertyWidget extends PropertyWidget {
  final List<String> options;
  final String defaultValue;

  const DropdownPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.options,
    required this.defaultValue,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);

        final value = properties.getProperty<String>(propertyName) ?? defaultValue;

        return DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: (newValue) {
            if (newValue != null) {
              notifier.updateProperty(propertyName, newValue);
            }
          },
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        );
      },
    );
  }
}
