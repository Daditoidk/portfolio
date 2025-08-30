import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/styles.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';

/// Color picker property widget with Riverpod integration
class ColorPropertyWidget extends PropertyWidget {
  final Color defaultValue;
  final List<Color>? predefinedColors;

  const ColorPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    this.defaultValue = Colors.white,
    this.predefinedColors,
  });

  @override
  Widget buildPropertyContent() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch the specific property value from Riverpod
        final properties = ref.watch(animationPropertiesProvider);
        final notifier = ref.read(animationPropertiesProvider.notifier);
        final value =
            properties.getProperty<Color>(propertyName) ?? defaultValue;

        return Row(
          children: [
            // Color preview
            GestureDetector(
              onTap: () {
                // TODO: Implement color picker dialog
                // For now, cycle through predefined colors
                if (predefinedColors != null && predefinedColors!.isNotEmpty) {
                  final currentIndex = predefinedColors!.indexOf(value);
                  final nextIndex =
                      (currentIndex + 1) % predefinedColors!.length;
                  // Update the new provider
                  notifier.updateProperty(
                    propertyName,
                    predefinedColors![nextIndex],
                  );
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
      },
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
