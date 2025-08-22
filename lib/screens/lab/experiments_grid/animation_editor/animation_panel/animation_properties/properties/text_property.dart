import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Text input property widget
class TextProperty extends PropertyWidget {
  final String value;
  final Function(String) onChanged;
  final String? placeholder;
  final int maxLines;

  const TextProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.maxLines = 1,
  });

  @override
  Widget buildPropertyContent() {
    return Container(
      height: maxLines == 1 ? 36 : null, // Standardized height for single line
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        initialValue: value,
        maxLines: maxLines,
        style: AnimationPanelStyles.label.copyWith(
          color: Colors.grey.shade700,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: AnimationPanelStyles.label.copyWith(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
