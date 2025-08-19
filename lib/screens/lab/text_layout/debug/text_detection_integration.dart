import 'package:flutter/material.dart';

/// Integration widget for text detection system in the lab
class TextDetectionIntegration extends StatelessWidget {
  const TextDetectionIntegration({super.key});

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
                Icon(Icons.text_fields, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Text Detection System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Advanced text detection and classification system for portfolio text elements. '
              'Automatically detects, classifies, and organizes text based on content patterns and positioning.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showQuickDetection(context),
                  icon: const Icon(Icons.search),
                  label: const Text('Quick Detection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showInfo(context),
                  icon: const Icon(Icons.info),
                  label: const Text('Info'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFeatureList(),
          ],
        ),
      ),
    );
  }

  void _showQuickDetection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Detection'),
        content: const Text(
          'Text detection system is integrated with the text animation registry. '
          'Use the layout editor to configure text positioning and organization.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Detection System Info'),
        content: const Text(
          'This system automatically:\n\n'
          '• Detects text elements in the portfolio\n'
          '• Classifies them by content and position\n'
          '• Organizes them into logical sections\n'
          '• Provides confidence scores\n'
          '• Suggests optimal layouts\n\n'
          'Use the layout editor to fine-tune the automatic detection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeatureItem(
          'Automatic Detection',
          'AI-powered text element detection',
        ),
        _buildFeatureItem(
          'Smart Classification',
          'Content-based categorization',
        ),
        _buildFeatureItem('Position Analysis', 'Spatial relationship mapping'),
        _buildFeatureItem(
          'Confidence Scoring',
          'Reliability metrics for suggestions',
        ),
        _buildFeatureItem(
          'Layout Optimization',
          'Intelligent positioning recommendations',
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: Colors.blue.shade600, size: 16),
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
