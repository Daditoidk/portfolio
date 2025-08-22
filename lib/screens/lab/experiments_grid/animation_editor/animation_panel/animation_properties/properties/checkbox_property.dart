import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Checkbox property widget (special layout)
class CheckboxProperty extends PropertyWidget {
  final bool value;
  final Function(bool) onChanged;

  const CheckboxProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Special layout for checkbox: [Empty Space] [Checkbox + Property name + 5px + info icon]
    return Row(
      children: [
        // Empty Space (same proportion as name section in other properties)
        const Expanded(flex: 2, child: SizedBox.shrink()),

        const SizedBox(width: 16), // 16px spacing between row items
        // Value Section: Checkbox + Property name + 5px + info icon
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (newValue) {
                  onChanged(newValue ?? false);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Text(
                propertyName,
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (this.required)
                Text(
                  ' *',
                  style: AnimationPanelStyles.label.copyWith(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: 5), // 5px padding
              if (description != null)
                Tooltip(
                  message: description!,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPropertyContent() {
    // Not used for checkbox as we override build()
    return const SizedBox.shrink();
  }
}
