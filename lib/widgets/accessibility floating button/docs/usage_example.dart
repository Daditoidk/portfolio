import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../accessibility_floating_button.dart';

/// Example usage of the Accessibility Floating Button component
class AccessibilityExample extends ConsumerWidget {
  const AccessibilityExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Accessibility Example',
      home: Scaffold(
        appBar: AppBar(title: const AccessibleText('Accessibility Example')),
        body: AccessiblePauseAnimations(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Example with high contrast
                AccessibleHighContrast(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccessibleText(
                          'High Contrast Section',
                          baseFontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8),
                        AccessibleText(
                          'This section will have high contrast applied when the setting is enabled.',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Example with image hiding
                AccessibleHideImages(
                  altText: 'A beautiful landscape image',
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Example with link highlighting
                AccessibleHighlightLinks(
                  child: Column(
                    children: [
                      AccessibleButton(
                        onPressed: () => debugPrint('Button pressed'),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: AccessibleText('Clickable Button'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AccessibleLink(
                        onTap: () => debugPrint('Link tapped'),
                        child: const AccessibleText(
                          'Clickable Link',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Example with custom cursor
                AccessibleCustomCursor(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const AccessibleText(
                      'Hover over this area to see custom cursor',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Example with tooltip
                AccessibleTooltip(
                  message: 'This is a helpful tooltip message',
                  child: const Icon(Icons.info, size: 24, color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: AccessibilityMenu(
          languageCode: 'en',
          onLanguageChanged: (code) => debugPrint('Language changed to $code'),
          onPressed: () => debugPrint('Accessibility menu opened'),
        ),
      ),
    );
  }
}
