import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/widgets/accessible_pause_animations.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessiblePauseAnimations', () {
    testWidgets('should return child when pause animations is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessiblePauseAnimations(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should apply animation pausing when enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessiblePauseAnimations(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });
  });

  group('AccessibleAnimatedContainer', () {
    testWidgets(
      'should show AnimatedContainer when pause animations is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accessibilitySettingsProvider.overrideWith(
                (ref) => AccessibilitySettingsNotifier()
                  ..state = const AccessibilitySettings(pauseAnimations: false),
              ),
            ],
            child: const MaterialApp(
              home: AccessibleAnimatedContainer(child: Text('Test Text')),
            ),
          ),
        );

        expect(find.text('Test Text'), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsOneWidget);
      },
    );

    testWidgets('should show Container when pause animations is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleAnimatedContainer(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNothing);
    });
  });

  group('AccessibleAnimatedOpacity', () {
    testWidgets(
      'should show AnimatedOpacity when pause animations is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accessibilitySettingsProvider.overrideWith(
                (ref) => AccessibilitySettingsNotifier()
                  ..state = const AccessibilitySettings(pauseAnimations: false),
              ),
            ],
            child: const MaterialApp(
              home: AccessibleAnimatedOpacity(
                opacity: 0.5,
                child: Text('Test Text'),
              ),
            ),
          ),
        );

        expect(find.text('Test Text'), findsOneWidget);
        expect(find.byType(AnimatedOpacity), findsOneWidget);
      },
    );

    testWidgets('should show Opacity when pause animations is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleAnimatedOpacity(
              opacity: 0.5,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(AnimatedOpacity), findsNothing);
    });
  });

  group('AccessibleAnimatedSwitcher', () {
    testWidgets(
      'should show AnimatedSwitcher when pause animations is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accessibilitySettingsProvider.overrideWith(
                (ref) => AccessibilitySettingsNotifier()
                  ..state = const AccessibilitySettings(pauseAnimations: false),
              ),
            ],
            child: const MaterialApp(
              home: AccessibleAnimatedSwitcher(child: Text('Test Text')),
            ),
          ),
        );

        expect(find.text('Test Text'), findsOneWidget);
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
      },
    );

    testWidgets('should show child directly when pause animations is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleAnimatedSwitcher(child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(AnimatedSwitcher), findsNothing);
    });
  });

  group('AccessibleHero', () {
    testWidgets('should show Hero when pause animations is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHero(tag: 'test-hero', child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
    });

    testWidgets('should show child directly when pause animations is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(pauseAnimations: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHero(tag: 'test-hero', child: Text('Test Text')),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
      expect(find.byType(Hero), findsNothing);
    });
  });
}
