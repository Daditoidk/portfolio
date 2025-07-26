import 'package:flutter/material.dart';
import '../core/l10n/app_localizations.dart';
import '../core/constants/semantic_labels.dart';
import '../core/theme/app_theme.dart';
import 'hamburger_menu.dart';
import 'lab_icon_button.dart';
import '../core/accessibility/accessibility_floating_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PortfolioNavBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    // final isDesktop = screenWidth >= 1024;
    final settings = ref.watch(accessibilitySettingsProvider);

    if (isSticky && !isVisible) {
      return const SizedBox.shrink();
    }
    return Semantics(
      label: SemanticLabels.navigationMenu,
      hint: SemanticLabels.useToNavigate,
      child: AccessibleAnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSticky && !isVisible ? 0.0 : 1.0,
        child: Container(
          height: _calculateNavHeight(settings),
          color: isSticky ? _getStickyNavColor() : Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 40,
              vertical: isMobile ? 10 : 10,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {


                return Row(
                  children: [
                    // Left: Title
                    Semantics(
                      label: SemanticLabels.portfolioTitle,
                      child: AccessibleText(
                        l10n.appTitle,
                        baseFontSize: (isMobile
                            ? 16
                            : (Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.fontSize ??
                                      20) +
                                  5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Middle: Nav items or Hamburger
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, navConstraints) {
                          // Create a test row to measure the actual width needed
                          final testNavItems = [
                            _buildNavItem(l10n.navHome, 0, settings),
                            _buildNavItem(l10n.navAbout, 1, settings),
                            _buildNavItem(l10n.skillsTitle, 2, settings),
                            _buildNavItem(l10n.resumeSectionTitle, 3, settings),
                            _buildNavItem(l10n.navProjects, 4, settings),
                            _buildNavItem(l10n.navContact, 5, settings),
                          ];

                          // Always show hamburger on mobile/tablet
                          if (isMobile || isTablet) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: AccessibleCustomCursor(
                                child: HamburgerMenu(
                                  onSectionTap: onSectionTap,
                                  currentSection: currentSection,
                                  currentLocale: currentLocale,
                                  onLocaleChanged: onLocaleChanged,
                                ),
                              ),
                            );
                          }

                          // For desktop, measure if nav items fit
                          return _buildResponsiveNavItems(
                            context,
                            testNavItems,
                            navConstraints.maxWidth,
                            settings,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right: Lab icon
                    AccessibleCustomCursor(child: LabIconButton()),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateNavHeight(AccessibilitySettings settings) {
    // Base height plus additional height for increased line height
    final baseHeight = 60.0;
    // Calculate height increase based on line height multiplier
    // Line height goes from 1.2 to 2.0 (4 levels: 0,1,2,3)
    final lineHeightMultiplier = 1.2 + settings.lineHeightLevel * 0.2;
    final baseTextHeight = 16.0; // Base text height
    final increasedTextHeight = baseTextHeight * lineHeightMultiplier;
    final heightIncrease =
        (increasedTextHeight - baseTextHeight) * 2; // Double for padding
    return baseHeight + heightIncrease;
  }

  Widget _buildResponsiveNavItems(
    BuildContext context,
    List<Widget> navItems,
    double availableWidth,
    AccessibilitySettings settings,
  ) {
    // Calculate actual text widths for more accurate measurement
    final navTitles = [
      'Home',
      'About',
      'Skills',
      'Resume',
      'Projects',
      'Contact',
    ];

    double totalNavWidth = 0;
    for (int i = 0; i < navTitles.length; i++) {
      final title = navTitles[i];
      final textStyle = AccessibilityTextStyle.fromSettings(
        settings,
        baseFontSize: 12, // Base font size for nav items
        fontWeight: FontWeight.w500,
        applyPortfolioOnlyFeatures: true,
      );

      // Measure actual text width
      final textSpan = TextSpan(text: title, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );
      textPainter.layout();

      // Add padding and spacing
      final itemWidth = textPainter.width + 32; // 16px padding on each side
      totalNavWidth += itemWidth;
    }

    // Account for title, spacing, and lab icon with buffer
    final reservedWidth = 260.0; // Increased buffer for safety
    final availableNavWidth = availableWidth - reservedWidth;

    // Show hamburger menu if nav items would overflow
    if (totalNavWidth > availableNavWidth) {
      return Align(
        alignment: Alignment.centerRight,
        child: AccessibleCustomCursor(
          child: HamburgerMenu(
            onSectionTap: onSectionTap,
            currentSection: currentSection,
            currentLocale: currentLocale,
            onLocaleChanged: onLocaleChanged,
          ),
        ),
      );
    } else {
      return Semantics(
        label: SemanticLabels.navigationLinks,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: navItems,
        ),
      );
    }
  }

  Widget _buildNavItem(
    String title,
    int sectionIndex,
    AccessibilitySettings settings,
  ) {
    final sections = [
      'home',
      'about',
      'skills',
      'resume',
      'projects',
      'contact',
    ];
    final sectionId = sections[sectionIndex];
    // Adjust active state: if currentSection is 'resume', highlight Resume nav item
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
        child: AccessibleCustomCursor(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AccessibleInkWell(
              onTap: () => onSectionTap(sectionId),
              highlightColor: AppTheme.navActive.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                // Use flexible height instead of fixed SizedBox
                constraints: BoxConstraints(
                  minHeight: 32,
                  maxHeight:
                      32 +
                      (settings.lineHeightLevel *
                          6.0), // Dynamic height based on line height
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AccessibleText(
                      title,
                      baseFontSize:
                          Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: _getTextColor(isActive),
                    ),
                    const SizedBox(height: 0),
                    AccessibleAnimatedContainer(
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
      case 'skills':
        return AppTheme.stickyNavAbout; // Use same color as about for now
      case 'projects':
        return AppTheme.stickyNavProjects;
      case 'contact':
        return AppTheme.stickyNavContact;
      default:
        return AppTheme.stickyNavHeader;
    }
  }
}
