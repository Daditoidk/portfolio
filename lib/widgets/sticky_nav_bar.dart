import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';
import 'hamburger_menu.dart';

class StickyNavBar extends StatelessWidget {
  final Function(String) onSectionTap;
  final String currentSection;
  final bool isVisible;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const StickyNavBar({
    super.key,
    required this.onSectionTap,
    required this.currentSection,
    required this.isVisible,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return Semantics(
      label: SemanticLabels.navigationMenu,
      hint: SemanticLabels.useToNavigate,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          height: 60,
          color: _getStickyNavColor(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: 10,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate if navigation items would fit
                final navItems = [
                  _buildNavItem(l10n.navHome, 0),
                  _buildNavItem(l10n.navAbout, 1),
                  _buildNavItem(l10n.navProjects, 2),
                  _buildNavItem(l10n.navLab, 3),
                  _buildNavItem(l10n.navContact, 4),
                ];

                // Estimate total width needed for navigation items
                final estimatedNavWidth =
                    navItems.length * 80.0; // Approximate width per item
                final availableWidth =
                    constraints.maxWidth - 100; // Leave space for title

                final shouldShowHamburger = estimatedNavWidth > availableWidth;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      label: SemanticLabels.portfolioTitle,
                      child: Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontSize: isMobile ? 16 : null),
                      ),
                    ),
                    shouldShowHamburger
                        ? HamburgerMenu(
                          onSectionTap: onSectionTap,
                          currentSection: currentSection,
                          currentLocale: currentLocale,
                          onLocaleChanged: onLocaleChanged,
                        )
                        : Semantics(
                          label: SemanticLabels.navigationLinks,
                          child: Row(children: navItems),
                        ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, int sectionIndex) {
    final sections = ['home', 'about', 'projects', 'lab', 'contact'];
    final sectionId = sections[sectionIndex];
    final isActive = currentSection == sectionId;

    return Builder(
      builder:
          (context) => Semantics(
            label: title,
            hint:
                isActive
                    ? SemanticLabels.doubleTapToStay
                    : '${SemanticLabels.doubleTapToNavigate} $title ${SemanticLabels.navigateToSection}',
            value:
                isActive ? SemanticLabels.current : SemanticLabels.notCurrent,
            button: true,
            selected: isActive,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () => onSectionTap(sectionId),
                child: SizedBox(
                  height: 32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w500,
                          color:
                              currentSection == 'projects'
                                  ? (isActive ? AppTheme.navy : Colors.white)
                                  : currentSection == 'lab'
                                  ? (isActive ? AppTheme.navy : AppTheme.blue)
                                  : currentSection == 'contact'
                                  ? (isActive ? Colors.white : Colors.white70)
                                  : (isActive
                                      ? AppTheme.navActive
                                      : AppTheme.navInactive),
                        ),
                      ),
                      const SizedBox(height: 0),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: isActive ? 18 : 0,
                        decoration: BoxDecoration(
                          color:
                              currentSection == 'lab' && isActive
                                  ? AppTheme.darkRed
                                  : currentSection == 'contact' && isActive
                                  ? AppTheme.navy
                                  : AppTheme.navIndicator,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Color _getStickyNavColor() {
    switch (currentSection) {
      case 'home':
        return AppTheme.stickyNavHeader;
      case 'about':
        return AppTheme.stickyNavAbout;
      case 'projects':
        return AppTheme.stickyNavProjects;
      case 'lab':
        return AppTheme.stickyNavLab;
      case 'contact':
        return AppTheme.stickyNavContact;
      default:
        return AppTheme.stickyNavHeader;
    }
  }
}
