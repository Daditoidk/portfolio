import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Text property widget with Riverpod integration
class TextPropertyWidget extends PropertyWidget {
  final String defaultValue;
  final String? placeholder;
  final TextInputType? keyboardType;

  const TextPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.defaultValue,
    this.placeholder,
    this.keyboardType,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);

        final value =
            properties.getProperty<String>(propertyName) ?? defaultValue;

        return TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            isDense: true,
            hintText: placeholder,
          ),
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: (newValue) {
            notifier.updateProperty(propertyName, newValue);
          },
        );
      },
    );
  }
}
