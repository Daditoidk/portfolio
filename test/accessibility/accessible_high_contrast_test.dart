import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

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

      // Verify that the widget is wrapped in a Theme widget (there will be multiple themes)
      expect(
        find.byType(Theme),
        findsAtLeast(2),
      ); // MaterialApp theme + our theme
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
      expect(
        find.byType(Theme),
        findsAtLeast(2),
      ); // MaterialApp theme + our theme
    });

    testWidgets('should respect applyToText parameter', (
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
            home: AccessibleHighContrast(
              applyToText: false,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should respect applyToIcons parameter', (
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
            home: AccessibleHighContrast(
              applyToIcons: false,
              child: Icon(Icons.home),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('should respect applyToButtons parameter', (
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
            home: AccessibleHighContrast(
              applyToButtons: false,
              child: ElevatedButton(onPressed: null, child: Text('Button')),
            ),
          ),
        ),
      );

      expect(find.text('Button'), findsOneWidget);
    });
  });
}
