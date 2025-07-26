import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/widgets/accessibility floating button/widgets/accessible_hide_images.dart';
import 'package:portfolio_web/widgets/accessibility floating button/core/accessibility_settings.dart';

void main() {
  group('AccessibleHideImages', () {
    testWidgets('should return child when hide images is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHideImages(
              child: Image(image: AssetImage('test.png')),
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should show placeholder when hide images is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHideImages(
              child: Image(image: AssetImage('test.png')),
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text('Image hidden for accessibility'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should show custom alt text when provided', (
      WidgetTester tester,
    ) async {
      const altText = 'Custom alt text for image';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHideImages(
              altText: altText,
              child: Image(image: AssetImage('test.png')),
            ),
          ),
        ),
      );

      expect(find.text(altText), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should show custom placeholder when provided', (
      WidgetTester tester,
    ) async {
      const placeholderText = 'Custom placeholder';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleHideImages(
              placeholder: Text(placeholderText),
              child: Image(image: AssetImage('test.png')),
            ),
          ),
        ),
      );

      expect(find.text(placeholderText), findsOneWidget);
      expect(find.text('Image hidden for accessibility'), findsNothing);
    });
  });

  group('AccessibleImage', () {
    testWidgets('should show image when hide images is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: false),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleImage(imagePath: 'test.png'),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should show alt text when hide images is enabled', (
      WidgetTester tester,
    ) async {
      const altText = 'Test image description';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilitySettingsProvider.overrideWith(
              (ref) =>
                  AccessibilitySettingsNotifier()
                    ..state = const AccessibilitySettings(hideImages: true),
            ),
          ],
          child: const MaterialApp(
            home: AccessibleImage(imagePath: 'test.png', altText: altText),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text(altText), findsOneWidget);
    });
  });
}
