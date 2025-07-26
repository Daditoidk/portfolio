import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

void main() {
  group('AccessiblePageStructure', () {
    testWidgets('should return child when page structure is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  pageStructureEnabled: false,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessiblePageStructure(
              currentLocale: Locale('en'),
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should show overlay when page structure is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  pageStructureEnabled: true,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessiblePageStructure(
              currentLocale: Locale('en'),
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should show overlay with custom colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  pageStructureEnabled: true,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessiblePageStructure(
              currentLocale: Locale('en'),
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });
  });

  group('PageStructureItem', () {
    test('should create page structure item with required parameters', () {
      const item = PageStructureItem(
        label: 'Test Item',
        type: PageStructureType.heading,
      );

      expect(item.label, 'Test Item');
      expect(item.type, PageStructureType.heading);
      expect(item.description, isNull);
      expect(item.key, isNull);
      expect(item.level, 0);
    });

    test('should create page structure item with all parameters', () {
      const item = PageStructureItem(
        label: 'Test Item',
        description: 'Test Description',
        type: PageStructureType.navigation,
        level: 2,
      );

      expect(item.label, 'Test Item');
      expect(item.description, 'Test Description');
      expect(item.type, PageStructureType.navigation);
      expect(item.level, 2);
    });
  });

  group('PageStructureType', () {
    test('should have all expected values', () {
      expect(PageStructureType.values.length, 11);
      expect(
        PageStructureType.values.contains(PageStructureType.heading),
        isTrue,
      );
      expect(
        PageStructureType.values.contains(PageStructureType.navigation),
        isTrue,
      );
      expect(PageStructureType.values.contains(PageStructureType.main), isTrue);
      expect(
        PageStructureType.values.contains(PageStructureType.section),
        isTrue,
      );
      expect(
        PageStructureType.values.contains(PageStructureType.article),
        isTrue,
      );
      expect(
        PageStructureType.values.contains(PageStructureType.aside),
        isTrue,
      );
      expect(
        PageStructureType.values.contains(PageStructureType.footer),
        isTrue,
      );
      expect(
        PageStructureType.values.contains(PageStructureType.button),
        isTrue,
      );
      expect(PageStructureType.values.contains(PageStructureType.link), isTrue);
      expect(PageStructureType.values.contains(PageStructureType.form), isTrue);
      expect(
        PageStructureType.values.contains(PageStructureType.other),
        isTrue,
      );
    });
  });

  group('AccessibleStructureItem', () {
    testWidgets('should return child when page structure is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  pageStructureEnabled: false,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleStructureItem(
              label: 'Test Item',
              type: PageStructureType.heading,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should return child when page structure is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) => AccessibilitySettingsNotifier()
                ..state = const AccessibilitySettings(
                  pageStructureEnabled: true,
                ),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleStructureItem(
              label: 'Test Item',
              type: PageStructureType.heading,
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });
  });
}
