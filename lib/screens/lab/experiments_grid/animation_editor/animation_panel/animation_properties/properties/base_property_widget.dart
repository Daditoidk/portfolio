import 'package:flutter/material.dart';
import '../../styles/styles.dart';

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
