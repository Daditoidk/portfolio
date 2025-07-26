import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

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
      expect(find.byType(MouseRegion), findsAtLeast(1));
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
      expect(find.byType(MouseRegion), findsAtLeast(1));
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
      expect(find.byType(MouseRegion), findsAtLeast(1));
    });

    testWidgets('should respect showCustomCursor parameter', (
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
              showCustomCursor: false,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeast(1));
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
      expect(find.byType(MouseRegion), findsAtLeast(1));
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
      expect(find.byType(MouseRegion), findsAtLeast(1));
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should handle onPressed callback', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: MaterialApp(
            home: AccessibleButton(
              onPressed: () => pressed = true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      expect(pressed, isTrue);
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
            home: Scaffold(body: AccessibleLink(child: Text('Test Link'))),
          ),
        ),
      );

      expect(find.text('Test Link'), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeast(1));
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
            home: Scaffold(body: AccessibleLink(child: Text('Test Link'))),
          ),
        ),
      );

      expect(find.text('Test Link'), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeast(1));
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle onTap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(customCursor: true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AccessibleLink(
                onTap: () => tapped = true,
                child: const Text('Test Link'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Link'));
      expect(tapped, isTrue);
    });
  });

  group('AccessibleTextLink', () {
    testWidgets('should render text with link styling', (
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
            home: Scaffold(
              body: AccessibleTextLink(text: 'Test Link Text', onTap: null),
            ),
          ),
        ),
      );

      expect(find.text('Test Link Text'), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeast(1));
      expect(find.byType(InkWell), findsOneWidget);
    });
  });

  group('AccessibleIconButton', () {
    testWidgets('should render icon button with custom cursor', (
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
            home: AccessibleIconButton(child: Icon(Icons.home)),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byType(MouseRegion), findsAtLeast(1));
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
