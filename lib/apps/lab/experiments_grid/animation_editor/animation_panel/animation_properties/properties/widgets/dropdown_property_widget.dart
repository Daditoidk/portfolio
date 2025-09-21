import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Dropdown property widget with Riverpod integration
class DropdownPropertyWidget extends PropertyWidget {
  final String defaultValue;
  final List<String> options;

  const DropdownPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.defaultValue,
    required this.options,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch the state to rebuild when it changes
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);

        // Use the new typed property access method from the provider
        final value =
            notifier.getTypedProperty<String>(propertyName) ?? defaultValue;

        return DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              notifier.updateProperty(propertyName, newValue);
            }
          },
        );
      },
    );
  }
}
