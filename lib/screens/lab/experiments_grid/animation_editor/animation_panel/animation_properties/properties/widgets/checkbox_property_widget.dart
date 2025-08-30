import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Checkbox property widget with Riverpod integration
class CheckboxPropertyWidget extends PropertyWidget {
  final bool defaultValue;

  const CheckboxPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    this.defaultValue = false,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);

        final value =
            properties.getProperty<bool>(propertyName) ?? defaultValue;

        return Checkbox(
          value: value,
          onChanged: (newValue) {
            if (newValue != null) {
              notifier.updateProperty(propertyName, newValue);
            }
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }
}
