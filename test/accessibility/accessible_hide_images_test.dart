import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

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
          child: MaterialApp(
            home: AccessibleHideImages(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Icon(Icons.image),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image), findsOneWidget);
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
          child: MaterialApp(
            home: AccessibleHideImages(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Icon(Icons.image),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image), findsNothing);
      expect(find.text('Image hidden'), findsOneWidget);
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
          child: MaterialApp(
            home: AccessibleHideImages(
              altText: altText,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Icon(Icons.image),
              ),
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
          child: MaterialApp(
            home: AccessibleHideImages(
              placeholder: Text(placeholderText),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Icon(Icons.image),
              ),
            ),
          ),
        ),
      );

      expect(find.text(placeholderText), findsOneWidget);
      expect(find.text('Image hidden'), findsNothing);
    });

    testWidgets('should handle CircleAvatar correctly', (
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
          child: MaterialApp(
            home: AccessibleHideImages(
              altText: 'Profile picture',
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.text('Profile picture'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
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
          child: MaterialApp(
            home: AccessibleImage(imagePath: 'assets/bgs/avatar.jpg'),
          ),
        ),
      );

      // The image widget should be present even if the asset doesn't exist
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
          child: MaterialApp(
            home: AccessibleImage(
              imagePath: 'assets/bgs/avatar.jpg',
              altText: altText,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text(altText), findsOneWidget);
    });

    testWidgets('should respect showAltText parameter', (
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
          child: MaterialApp(
            home: AccessibleImage(
              imagePath: 'assets/bgs/avatar.jpg',
              altText: 'Test description',
              showAltText: false,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
      expect(find.text('Test description'), findsNothing);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });
  });
}
