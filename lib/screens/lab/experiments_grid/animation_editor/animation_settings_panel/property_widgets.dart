import 'package:flutter/material.dart';
import 'animation_panel_styles.dart';

/// Base class for all property widgets
abstract class PropertyWidget extends StatelessWidget {
  final String propertyName;
  final String? description;
  final bool required;
  final String? unit; // Added unit support

  const PropertyWidget({
    super.key,
    required this.propertyName,
    this.description,
    this.required = false,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Name Section: Property name(units) + 5px padding + info icon, right-aligned
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Right-aligned
            children: [
              // Property name with units
              Text(
                unit != null ? '$propertyName($unit)' : propertyName,
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (required)
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
                )
              else
                const SizedBox(
                  width: 16,
                ), // Placeholder for consistent alignment
            ],
          ),
        ),

        const SizedBox(width: 16), // 16px spacing between row items
        // Value Section: depends on property type
        Expanded(flex: 3, child: buildPropertyContent()),
      ],
    );
  }

  Widget buildPropertyContent();
}

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
