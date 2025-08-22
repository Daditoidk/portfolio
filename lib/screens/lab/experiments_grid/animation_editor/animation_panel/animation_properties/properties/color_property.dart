import 'package:flutter/material.dart';
import '../../styles/styles.dart';
import 'base_property_widget.dart';

/// Color picker property widget
class ColorProperty extends PropertyWidget {
  final Color value;
  final Function(Color) onChanged;
  final List<Color>? predefinedColors;

  const ColorProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.onChanged,
    this.predefinedColors,
  });

  @override
  Widget buildPropertyContent() {
    return Row(
      children: [
        // Color preview
        GestureDetector(
          onTap: () {
            // TODO: Implement color picker dialog
            // For now, cycle through predefined colors
            if (predefinedColors != null && predefinedColors!.isNotEmpty) {
              final currentIndex = predefinedColors!.indexOf(value);
              final nextIndex = (currentIndex + 1) % predefinedColors!.length;
              onChanged(predefinedColors![nextIndex]);
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: value,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(
              Icons.color_lens,
              color: _getContrastColor(value),
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Tap to cycle colors',
          style: AnimationPanelStyles.label.copyWith(
            color: Colors.grey.shade600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
