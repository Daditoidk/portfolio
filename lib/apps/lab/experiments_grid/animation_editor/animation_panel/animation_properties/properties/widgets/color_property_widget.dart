import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_property_widget.dart';
import '../../providers/animation_properties_providers.dart';
import '../../../styles/styles.dart';

/// Color property widget with Riverpod integration
class ColorPropertyWidget extends PropertyWidget {
  final Color defaultValue;

  const ColorPropertyWidget({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    required this.defaultValue,
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
            notifier.getTypedProperty<Color>(propertyName) ?? defaultValue;

        return Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: value,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                propertyName,
                style: AnimationPanelStyles.label.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final newColor = await showDialog<Color>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Select Color for $propertyName'),
                    content: const SingleChildScrollView(child: ColorPicker()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(value),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );

                if (newColor != null) {
                  notifier.updateProperty(propertyName, newColor);
                }
              },
              icon: const Icon(Icons.color_lens),
              tooltip: 'Change Color',
            ),
          ],
        );
      },
    );
  }
}

/// Simple color picker widget
class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.white,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }).toList(),
    );
  }
}
