import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Slider property widget for numeric values with slider + input field
class SliderProperty extends PropertyWidget {
  final double value;
  final double? minValue;
  final double? maxValue;
  final int decimalPlaces;
  final ValueChanged<double> onChanged;

  const SliderProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    this.minValue,
    this.maxValue,
    this.decimalPlaces = 1,
    required this.onChanged,
  });

  @override
  Widget buildPropertyContent() {
    final min = minValue ?? 0.0;
    final max = maxValue ?? 100.0;

    // Create controller with current value
    final controller = TextEditingController(
      text: value.toStringAsFixed(decimalPlaces),
    );

    return Row(
      children: [
        // Slider with fixed width and horizontal padding
        Container(
          width: 160,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Builder(
            builder: (context) => SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue.shade600,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.blue.shade600,
                overlayColor: Colors.blue.shade200.withValues(alpha: 0.3),
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8.0,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 16.0,
                ),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: ((max - min) / (max - min) * 100).round(),
                onChanged: (newValue) {
                  controller.text = newValue.toStringAsFixed(decimalPlaces);
                  onChanged(newValue);
                },
              ),
            ),
          ),
        ),

        SizedBox(
          width: 50,
          height: 25,
          child: TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: AnimationPanelStyles.numberValue.copyWith(
              color: Colors.grey.shade700,
              fontSize: 10,
              height: 2.5,
            ),
            decoration: InputDecoration.collapsed(
              hintText: '0.0',
              constraints: BoxConstraints.expand(height: 25, width: 50),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            maxLines: 1,
            onChanged: (text) {
              final doubleValue = double.tryParse(text);
              if (doubleValue != null) {
                onChanged(doubleValue.clamp(min, max));
              }
            },
          ),
        ),
      ],
    );
  }
}
