import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';
import '../../../styles/styles.dart';

/// Checkbox property widget with Riverpod integration
class CheckboxPropertyWidget extends PropertyWidget {
  const CheckboxPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch the state to rebuild when it changes
        final provider = ref.watch(animationPropertiesProvider);
        final providerNotifier = ref.read(animationPropertiesProvider.notifier);

        // Use the new typed property access method from the provider
        final value = provider.getProperty<bool>(propertyName) ?? false;

        return Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (newValue) {
                if (newValue != null) {
                  providerNotifier.updateProperty(propertyName, newValue);
                }
              },
            ),
            Expanded(
              child: Text(
                propertyName,
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
