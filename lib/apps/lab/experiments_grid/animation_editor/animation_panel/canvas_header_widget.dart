import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget for the canvas header with back button and canvas dropdown
class CanvasHeaderWidget extends StatelessWidget {
  final String selectedCanvas;
  final List<Map<String, dynamic>> availableCanvases;
  final Function(String) onCanvasChanged;

  const CanvasHeaderWidget({
    super.key,
    required this.selectedCanvas,
    required this.availableCanvases,
    required this.onCanvasChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/lab'),
                icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                'Back to Lab',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Canvas dropdown
          Text(
            'Select Canvas',
            style: TextStyle(
              fontSize: 11, // Reduced from 14 to 11
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: selectedCanvas,
            isExpanded: true,
            underline: Container(),
            items: availableCanvases.map((canvas) {
              return DropdownMenuItem<String>(
                value: canvas['id'] as String,
                child: Row(
                  children: [
                    Icon(
                      canvas['icon'] as IconData,
                      size: 16,
                      color: canvas['color'] as Color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      canvas['name'] as String,
                      style: TextStyle(fontSize: 12), // Reduced font size
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onCanvasChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
