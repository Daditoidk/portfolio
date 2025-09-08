import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Text property widget with Riverpod integration
class TextPropertyWidget extends PropertyWidget {
  final String defaultValue;
  final String? hintText;

  const TextPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.defaultValue,
    this.hintText,
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

        return TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            hintText: hintText ?? defaultValue,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          onChanged: (newValue) {
            notifier.updateProperty(propertyName, newValue);
          },
        );
      },
    );
  }
}
