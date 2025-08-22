import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Numeric input property widget
class NumericProperty extends PropertyWidget {
  final double value;
  final Function(double) onChanged;
  final double? minValue;
  final double? maxValue;
  final int decimalPlaces;

  const NumericProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.onChanged,
    this.minValue,
    this.maxValue,
    this.decimalPlaces = 2,
  });

  @override
  Widget buildPropertyContent() {
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
            onChanged(doubleValue);
          }
        },
      ),
    );
  }
}
