import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/navigation/route_names.dart';
import '../widgets/language_switcher.dart';

class MainSelectionScreen extends StatefulWidget {
  const MainSelectionScreen({super.key});

  @override
  State<MainSelectionScreen> createState() => _MainSelectionScreenState();
}

class _MainSelectionScreenState extends State<MainSelectionScreen> {
  Locale _currentLocale = const Locale('en');

  void _onLocaleChanged(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: _currentLocale,
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;

          return Semantics(
            label: l10n.a11y_mainSelectionScreen,
            hint: l10n.a11y_mainSelectionScreenHint,
            child: Scaffold(
              backgroundColor: AppTheme.navy,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Title
                    Semantics(
                      label: l10n.mainSelectionWelcome,
                      header: true,
                      child: Text(
                        l10n.mainSelectionWelcome,
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      label: l10n.mainSelectionSubtitle,
                      child: Text(
                        l10n.mainSelectionSubtitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 80),
                    // Navigation Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildNavigationButton(
                              context: context,
                              title: l10n.mainSelectionPortfolioTitle,
                              subtitle: l10n.mainSelectionPortfolioSubtitle,
                              icon: Icons.work,
                              accessibilityLabel:
                                  l10n.a11y_mainSelectionPortfolioButton,
                              accessibilityHint:
                                  l10n.a11y_mainSelectionPortfolioButtonHint,
                              onTap: () {
                                context.go(RouteNames.portfolio);
                              },
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: _buildNavigationButton(
                              context: context,
                              title: l10n.mainSelectionLabTitle,
                              subtitle: l10n.mainSelectionLabSubtitle,
                              icon: Icons.science,
                              accessibilityLabel:
                                  l10n.a11y_mainSelectionLabButton,
                              accessibilityHint:
                                  l10n.a11y_mainSelectionLabButtonHint,
                              onTap: () {
                                context.go(RouteNames.lab);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Language Switcher at bottom
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: LanguageSwitcher(
                        currentLocale: _currentLocale,
                        onLocaleChanged: _onLocaleChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String accessibilityLabel,
    required String accessibilityHint,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: accessibilityLabel,
      hint: accessibilityHint,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Icon
                Semantics(
                  label: accessibilityLabel,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.navy.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: AppTheme.navy, size: 28),
                  ),
                ),
                const SizedBox(width: 20),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: title,
                        header: true,
                        child: Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Semantics(
                        label: subtitle,
                        child: Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Semantics(
                  label: accessibilityHint,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.navy,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
