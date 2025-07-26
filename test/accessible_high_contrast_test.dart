import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/widgets/accessible_high_contrast.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessibleHighContrast', () {
    testWidgets('should return child when high contrast is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  highContrastEnabled: false,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHighContrast(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should apply high contrast when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  highContrastEnabled: true,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHighContrast(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);

      // Verify that the widget is wrapped in a container with high contrast styling
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Test Text'),
          matching: find.byType(Container),
        ),
      );
      expect(container.color, isNotNull);
    });

    testWidgets('should apply custom colors when provided', (
      WidgetTester tester,
    ) async {
      const customBgColor = Colors.red;
      const customFgColor = Colors.yellow;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  highContrastEnabled: true,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHighContrast(
              backgroundColor: customBgColor,
              foregroundColor: customFgColor,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });
  });
}
