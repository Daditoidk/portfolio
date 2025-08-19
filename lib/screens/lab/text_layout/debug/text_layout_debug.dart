import 'package:flutter/material.dart';
import '../editor/text_layout_editor.dart';

/// Debug widget to access the text layout editor
class TextLayoutDebug extends StatelessWidget {
  const TextLayoutDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: Colors.orange.shade600, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Text Layout Debug',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Debug and testing tools for the text layout system. '
              'Access the visual editor and test layout configurations.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TextLayoutEditor(),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Layout Editor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeatureItem('Visual Editor', 'Drag-and-drop line management'),
        _buildFeatureItem('Real-time Preview', 'Live portfolio rendering'),
        _buildFeatureItem('Configuration Export', 'Save/load layout settings'),
        _buildFeatureItem('Line Management', 'Create, move, and resize lines'),
        _buildFeatureItem('Section Organization', 'Group lines into sections'),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
