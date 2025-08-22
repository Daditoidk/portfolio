import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Dropdown property widget
class DropdownProperty extends PropertyWidget {
  final String value;
  final List<String> options;
  final Function(String) onChanged;
  final String? placeholder;

  const DropdownProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.options,
    required this.onChanged,
    this.placeholder,
  });

  @override
  Widget buildPropertyContent() {
    return Container(
      height: 36, // Standardized height
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isNotEmpty ? value : null,
          alignment: AlignmentDirectional.bottomStart,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          hint: placeholder != null
              ? Text(
                  placeholder!,
                  style: AnimationPanelStyles.dropdownOption.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                )
              : null,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: AnimationPanelStyles.dropdownOption.copyWith(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
