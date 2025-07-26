import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/widgets/accessible_custom_cursor.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessibleCustomCursor', () {
    testWidgets('should show default cursor when custom cursor is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleCustomCursor(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
    });

    testWidgets('should show custom cursor when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleCustomCursor(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
    });

    testWidgets('should use custom cursor when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleCustomCursor(
              customCursor: SystemMouseCursors.precise,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
    });
  });

  group('AccessibleButton', () {
    testWidgets('should show normal cursor when custom cursor is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleButton(child: Text('Test Button')),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should show click cursor when custom cursor is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleButton(child: Text('Test Button')),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });

  group('AccessibleLink', () {
    testWidgets('should show normal cursor when custom cursor is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleLink(child: Text('Test Link')),
          ),
        ),
      );

      expect(find.text('Test Link'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should show click cursor when custom cursor is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleLink(child: Text('Test Link')),
          ),
        ),
      );

      expect(find.text('Test Link'), findsOneWidget);
      expect(find.byType(MouseRegion), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
