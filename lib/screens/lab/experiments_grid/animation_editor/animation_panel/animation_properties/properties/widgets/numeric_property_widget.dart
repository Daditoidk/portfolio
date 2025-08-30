import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';
import '../../../styles/styles.dart';

/// Numeric property widget with Riverpod integration
class NumericPropertyWidget extends PropertyWidget {
  final double min;
  final double max;
  final double defaultValue;
  final double step;
  @override
  final String? unit;

  const NumericPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.min,
    required this.max,
    required this.defaultValue,
    this.step = 0.1,
    this.unit,
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
            notifier.getTypedProperty<double>(propertyName) ?? defaultValue;

        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: value.toStringAsFixed(2),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: defaultValue.toStringAsFixed(2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (newValue) {
                  final doubleValue = double.tryParse(newValue);
                  if (doubleValue != null &&
                      doubleValue >= min &&
                      doubleValue <= max) {
                    notifier.updateProperty(propertyName, doubleValue);
                  }
                },
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 8),
              Text(
                unit!,
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
