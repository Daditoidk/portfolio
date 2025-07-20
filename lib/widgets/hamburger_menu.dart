import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/l10n/app_localizations.dart';
import '../core/constants/semantic_labels.dart';
import '../core/theme/app_theme.dart';
import 'version_info.dart';

class HamburgerMenu extends StatelessWidget {
  final Function(String) onSectionTap;
  final String currentSection;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const HamburgerMenu({
    super.key,
    required this.onSectionTap,
    required this.currentSection,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: SemanticLabels.navigationMenu,
      hint: 'Open navigation menu',
      button: true,
      child: IconButton(
        onPressed: () => _showMobileMenu(context, l10n),
        icon: const Icon(Icons.menu),
        color: AppTheme.navActive,
        iconSize: 28,
      ),
    );
  }

  void _showMobileMenu(BuildContext context, AppLocalizations l10n) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close menu',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            _buildBlurredBackground(context, animation),
            _buildSideDrawer(context, animation, l10n),
          ],
        );
      },
    );
  }

  Widget _buildBlurredBackground(
    BuildContext context,
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildSideDrawer(
    BuildContext context,
    Animation<double> animation,
    AppLocalizations l10n,
  ) {
    final sections = [
      {'id': 'home', 'title': l10n.navHome},
      {'id': 'about', 'title': l10n.navAbout},
      {'id': 'projects', 'title': l10n.navProjects},
      {'id': 'contact', 'title': l10n.navContact},
    ];
    final languages = [
      {'locale': const Locale('en'), 'title': 'English', 'flag': '🇺🇸'},
      {'locale': const Locale('es'), 'title': 'Español', 'flag': '🇪🇸'},
      {'locale': const Locale('ja'), 'title': '日本語', 'flag': '🇯🇵'},
    ];
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: Material(
          color: Colors.grey.shade200,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(-2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with close button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menu',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.navActive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: AppTheme.navActive,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Navigation items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    children: [
                      // Navigation sections
                      ...sections
                          .map(
                            (section) => _buildMobileNavItem(
                              context,
                              section['title']!,
                              section['id']!,
                            ),
                      ),
                      // Divider before language options
                      const Divider(height: 1, thickness: 1),
                      const Divider(height: 32, thickness: 1),
                      // Language options header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 0,
                        ),
                        child: Text(
                          'Language',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppTheme.navInactive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Language options
                      ...languages
                          .map(
                            (language) => _buildLanguageItem(
                              context,
                              language['title'] as String,
                              language['flag'] as String,
                              language['locale'] as Locale,
                            ),
                      ),
                      if (isMobile) const VersionInfo(isMobile: true),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(
    BuildContext context,
    String title,
    String sectionId,
  ) {
    final isActive = currentSection == sectionId;

    return Semantics(
      label: title,
      hint: isActive ? 'Current section' : 'Navigate to $title section',
      value: isActive ? 'Current' : 'Not current',
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onSectionTap(sectionId);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            color:
                isActive
                    ? AppTheme.cream : Color(0xFFF5F5F5),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getSectionIcon(sectionId),
                color: isActive ? AppTheme.navActive : AppTheme.navInactive,
                size: 24,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppTheme.navActive : AppTheme.navInactive,
                  ),
                ),
              ),
              if (isActive)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.navIndicator,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    String title,
    String flag,
    Locale locale,
  ) {
    final isActive = currentLocale == locale;

    return Semantics(
      label: title,
      hint: isActive ? 'Current language' : 'Change to $title',
      value: isActive ? 'Current' : 'Not current',
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onLocaleChanged(locale);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            color:
                isActive
                    ? AppTheme.cream : Color(0xFFF5F5F5),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? AppTheme.navActive : AppTheme.navInactive,
                  ),
                ),
              ),
              if (isActive)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.navIndicator,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSectionIcon(String sectionId) {
    switch (sectionId) {
      case 'home':
        return Icons.home;
      case 'about':
        return Icons.person;
      case 'projects':
        return Icons.work;
      case 'contact':
        return Icons.contact_mail;
      default:
        return Icons.circle;
    }
  }
}
