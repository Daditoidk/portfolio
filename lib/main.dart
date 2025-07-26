import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/language_config.dart';
import 'core/accessibility/accessibility_floating_button.dart';

void main() {
  runApp(ProviderScope(child: PortfolioApp()));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalCursorManager(
      child: MaterialApp.router(
        title: 'Portfolio',
        theme: AppTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LanguageConfig.getAllLanguages()
            .map((lang) => lang.locale)
            .toList(),
        routerConfig: AppRouter.createRouter(),
      ),
    );
  }
}
