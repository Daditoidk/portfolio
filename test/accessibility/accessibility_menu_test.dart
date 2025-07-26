import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_web/core/accessibility/accessibility_floating_button.dart';

void main() {
  group('AccessibilityMenu', () {
    testWidgets('should render accessibility button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: Scaffold(body: AccessibilityMenu(languageCode: 'en')),
          ),
        ),
      );

      expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenu(
                languageCode: 'en',
                onPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.accessibility_new));
      expect(pressed, isTrue);
    });

    testWidgets('should show tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: Scaffold(body: AccessibilityMenu(languageCode: 'en')),
          ),
        ),
      );

      // The tooltip should be present in the widget tree
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('should respect menu alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: Scaffold(
              body: AccessibilityMenu(
                languageCode: 'en',
                menuAlignment: AlignmentDirectional.bottomStart,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
    });
  });

  group('AccessibilityMenuContent', () {
    testWidgets('should render menu title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Accessibility Menu'), findsOneWidget);
    });

    testWidgets('should render close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should call onClose when close button is tapped', (
      WidgetTester tester,
    ) async {
      bool closed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () => closed = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, isTrue);
    });

    testWidgets('should render language switcher', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Language'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('should render reset button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Reset All Accessibility Settings'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should render accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      // Check for some key accessibility features
      expect(find.text('Bigger Text'), findsOneWidget);
      expect(find.text('Text Spacing'), findsOneWidget);
      expect(find.text('Dyslexia Friendly'), findsOneWidget);
      expect(find.text('Hide Images'), findsOneWidget);
      expect(find.text('Highlight links'), findsOneWidget);
      expect(find.text('Pause Animations'), findsOneWidget);
      expect(find.text('Cursor'), findsOneWidget);
      expect(find.text('Tooltips'), findsOneWidget);
      expect(find.text('Page Structure'), findsOneWidget);
    });

    testWidgets('should render sliders for multi-level features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(
        find.byType(Slider),
        findsAtLeast(3),
      ); // Font size, letter spacing, line height
    });

    testWidgets('should render switches for toggle features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'en',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsAtLeast(6)); // Multiple toggle features
    });

    testWidgets('should support Spanish language', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'es',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Menú De Accesibilidad'), findsOneWidget);
      expect(find.text('Texto más grande'), findsOneWidget);
      expect(find.text('Apto para dislexia'), findsOneWidget);
    });

    testWidgets('should support Japanese language', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccessibilityMenuContent(
                languageCode: 'ja',
                onLanguageChanged: (code) {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('アクセシビリティメニュー'), findsOneWidget);
      expect(find.text('テキストを大きく'), findsOneWidget);
      expect(find.text('ディスレクシア対応'), findsOneWidget);
    });
  });
}
