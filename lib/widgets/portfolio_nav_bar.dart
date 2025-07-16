import 'package:flutter/material.dart';
import '../core/l10n/app_localizations.dart';
import '../core/constants/semantic_labels.dart';
import '../core/theme/app_theme.dart';
import 'hamburger_menu.dart';
import 'lab_icon_button.dart';

class PortfolioNavBar extends StatelessWidget {
  final Function(String) onSectionTap;
  final String currentSection;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;
  final bool isSticky;
  final bool isVisible;

  const PortfolioNavBar({
    super.key,
    required this.onSectionTap,
    required this.currentSection,
    required this.currentLocale,
    required this.onLocaleChanged,
    this.isSticky = false,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isSticky && !isVisible) {
      return const SizedBox.shrink();
    }
    return Semantics(
      label: SemanticLabels.navigationMenu,
      hint: SemanticLabels.useToNavigate,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSticky && !isVisible ? 0.0 : 1.0,
        child: Container(
          height: 60,
          color: isSticky ? _getStickyNavColor() : Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 40,
              vertical: isMobile ? 10 : 10,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final navItems = [
                  _buildNavItem(l10n.navHome, 0),
                  _buildNavItem(l10n.navAbout, 1),
                  _buildNavItem(l10n.navProjects, 2),
                  _buildNavItem(l10n.navContact, 3),
                ];
                final estimatedNavWidth = navItems.length * 80.0;
                final availableWidth = constraints.maxWidth - 100;
                final shouldShowHamburger =
                    estimatedNavWidth > availableWidth || isMobile;

                return Row(
                  children: [
                    // Left: Title
                    Semantics(
                      label: SemanticLabels.portfolioTitle,
                      child: Text(
                        l10n.appTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontSize:
                              (isMobile
                                  ? 16
                                  : (Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.fontSize ??
                                          20) +
                                      5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Middle: Nav items or Hamburger
                    Expanded(
                      child:
                          shouldShowHamburger
                              ? Align(
                                alignment: Alignment.centerRight,
                                child: HamburgerMenu(
                                  onSectionTap: onSectionTap,
                                  currentSection: currentSection,
                                  currentLocale: currentLocale,
                                  onLocaleChanged: onLocaleChanged,
                                ),
                              )
                              : Semantics(
                                label: SemanticLabels.navigationLinks,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: navItems,
                                ),
                              ),
                    ),
                    const SizedBox(width: 16),
                    // Right: Lab icon
                    LabIconButton(),
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
    final sections = ['home', 'about', 'projects', 'contact'];
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
                          color: _getTextColor(isActive),
                        ),
                      ),
                      const SizedBox(height: 0),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: isActive ? 18 : 0,
                        decoration: BoxDecoration(
                          color: _getUnderlineColor(isActive),
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

  Color _getTextColor(bool isActive) {
    if (!isSticky) {
      return isActive ? AppTheme.navActive : AppTheme.navInactive;
    }

    switch (currentSection) {
      case 'projects':
        return isActive ? AppTheme.navy : Colors.white.withValues(alpha: 0.8);
      case 'contact':
        return isActive ? Colors.white : Colors.white.withValues(alpha: 0.8);
      default:
        return isActive ? AppTheme.navActive : AppTheme.navInactive;
    }
  }

  Color _getUnderlineColor(bool isActive) {
    if (!isActive) return Colors.transparent;

    if (isSticky && currentSection == 'contact') {
      return AppTheme.cream;
    }

    return AppTheme.navIndicator;
  }

  Color _getStickyNavColor() {
    switch (currentSection) {
      case 'home':
        return AppTheme.stickyNavHeader;
      case 'about':
        return AppTheme.stickyNavAbout;
      case 'projects':
        return AppTheme.stickyNavProjects;
      case 'contact':
        return AppTheme.stickyNavContact;
      default:
        return AppTheme.stickyNavHeader;
    }
  }
}
