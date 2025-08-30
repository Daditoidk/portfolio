import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/styles.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Numeric input property widget with Riverpod integration
class NumericPropertyWidget extends PropertyWidget {
  final double defaultValue;
  final double? minValue;
  final double? maxValue;
  final int decimalPlaces;

  const NumericPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    this.defaultValue = 0.0,
    this.minValue,
    this.maxValue,
    this.decimalPlaces = 2,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch the specific property value from Riverpod
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);
        final value =
            properties.getProperty<double>(propertyName) ?? defaultValue;

        return Container(
          height: 36, // Standardized height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            initialValue: value.toStringAsFixed(decimalPlaces),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AnimationPanelStyles.numberValue.copyWith(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: InputBorder.none,
            ),
            onChanged: (text) {
              final doubleValue = double.tryParse(text);
              if (doubleValue != null) {
                // Update the new provider
                notifier.updateProperty(propertyName, doubleValue);
              }
            },
          ),
        );
      },
    );
  }
}
