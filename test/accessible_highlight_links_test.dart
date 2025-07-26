import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/widgets/accessible_highlight_links.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessibleHighlightLinks', () {
    testWidgets('should return child when highlight links is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(highlightLinks: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHighlightLinks(
              child: ElevatedButton(
                onPressed: null,
                child: Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should apply highlighting when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(highlightLinks: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHighlightLinks(
              child: ElevatedButton(
                onPressed: null,
                child: Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });
  });

  group('AccessibleInkWell', () {
    testWidgets('should show normal InkWell when highlight links is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(highlightLinks: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleInkWell(child: Text('Clickable Text')),
          ),
        ),
      );

      expect(find.text('Clickable Text'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should show highlighted InkWell when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(highlightLinks: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleInkWell(child: Text('Clickable Text')),
          ),
        ),
      );

      expect(find.text('Clickable Text'), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('AccessibleGestureDetector', () {
    testWidgets(
      'should show normal GestureDetector when highlight links is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accessibilitySettingsProvider.overrideWith(
                (ref) => AccessibilitySettingsNotifier()
                  ..state = const AccessibilitySettings(highlightLinks: false),
              ),
            ],
            child: const MaterialApp(
              home: AccessibleGestureDetector(child: Text('Clickable Text')),
            ),
          ),
        );

        expect(find.text('Clickable Text'), findsOneWidget);
        expect(find.byType(GestureDetector), findsOneWidget);
      },
    );

    testWidgets('should show highlighted GestureDetector when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(highlightLinks: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleGestureDetector(child: Text('Clickable Text')),
          ),
        ),
      );

      expect(find.text('Clickable Text'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
