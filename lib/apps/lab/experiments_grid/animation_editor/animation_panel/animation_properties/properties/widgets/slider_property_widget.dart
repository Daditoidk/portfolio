import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';
import '../../../styles/styles.dart';

/// Slider property widget with Riverpod integration
class SliderPropertyWidget extends PropertyWidget {
  final double min;
  final double max;
  final double defaultValue;
  final int divisions;
  @override
  final String? unit;

  const SliderPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.min,
    required this.max,
    required this.defaultValue,
    this.divisions = 100,
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
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (newValue) {
                  notifier.updateProperty(propertyName, newValue);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                value.toStringAsFixed(2),
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
