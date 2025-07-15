import 'package:flutter/material.dart';
import 'package:portfolio_web/widgets/hamburger_menu.dart';
import '../theme/app_theme.dart';
import '../constants/semantic_labels.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../helpers/responsive.dart';

class HeaderSection extends StatelessWidget {
  final Function(String) onSectionTap;
  final String currentSection;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const HeaderSection({
    super.key,
    required this.onSectionTap,
    required this.currentSection,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: (context) => _buildContent(context, isMobile: true),
      desktop: (context) => _buildContent(context, isMobile: false),
      tablet: (context) => _buildContent(context, isMobile: false),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isMobile}) {
    final loc = AppLocalizations.of(context)!;

    return Semantics(
      label: SemanticLabels.headerSection,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: AppTheme.cream,
        child: Column(
          children: [
            _buildNavigationBar(context, loc),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final isLandscape =
                      screenHeight < 500; // Landscape mode detection

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isMobile && !isLandscape ? 20 : 0),
                      Semantics(
                        label: SemanticLabels.profilePicture,
                        child: CircleAvatar(
                          radius: isLandscape ? 40 : (isMobile ? 60 : 80),
                          backgroundColor: AppTheme.avatarBackground,
                          child: Icon(
                            Icons.person,
                            size: isLandscape ? 40 : (isMobile ? 60 : 80),
                            color: AppTheme.avatarIcon,
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 15 : 30),
                      Semantics(
                        label: SemanticLabels.name,
                        child: Text(
                          loc.headerName,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontSize: isLandscape ? 24 : (isMobile ? 36 : null),
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 5 : 10),
                      Semantics(
                        label: SemanticLabels.professionalTitle,
                        child: Text(
                          loc.headerTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.secondaryIcon,
                            fontSize: isLandscape ? 14 : (isMobile ? 18 : null),
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 10 : 20),
                      Semantics(
                        label: SemanticLabels.professionalDescription,
                        child: Text(
                          loc.headerSubtitle,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontSize: isLandscape ? 12 : (isMobile ? 16 : null),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isMobile && !isLandscape ? 40 : 0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, AppLocalizations loc) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Semantics(
      label: SemanticLabels.mainNavigation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 40,
          vertical: isMobile ? 15 : 20,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate if navigation items would fit
            final navItems = [
              _buildNavItem(context, loc.navHome, 0),
              _buildNavItem(context, loc.navAbout, 1),
              _buildNavItem(context, loc.navProjects, 2),
              _buildNavItem(context, loc.navLab, 3),
              _buildNavItem(context, loc.navContact, 4),
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
                Flexible(
                  child: Semantics(
                    label: SemanticLabels.portfolioTitle,
                    child: Text(
                      loc.appTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: isMobile ? 18 : null),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                shouldShowHamburger
                    ? HamburgerMenu(
                      onSectionTap: onSectionTap,
                      currentSection: currentSection,
                      currentLocale: currentLocale,
                      onLocaleChanged: onLocaleChanged,
                    )
                    : Flexible(
                      child: Semantics(
                        label: SemanticLabels.navigationMenu,
                        child: Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.end,
                          children: navItems,
                        ),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, int sectionIndex) {
    final sections = ['home', 'about', 'projects', 'lab', 'contact'];
    final sectionId = sections[sectionIndex];
    final isActive = currentSection == sectionId;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Builder(
      builder:
          (context) => Semantics(
            label: title,
            hint: isActive ? 'Current section' : 'Navigate to $title section',
            value: isActive ? 'Current' : 'Not current',
            button: true,
            selected: isActive,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 8),
              child: InkWell(
                onTap: () => onSectionTap(sectionId),
                child: SizedBox(
                  height: isMobile ? 28 : 32,
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
                              isActive
                                  ? AppTheme.navActive
                                  : AppTheme.navInactive,
                          fontSize: isMobile ? 11 : null,
                        ),
                      ),
                      const SizedBox(height: 0),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 3,
                        width: isActive ? (isMobile ? 20 : 30) : 0,
                        decoration: BoxDecoration(
                          color: AppTheme.navIndicator,
                          borderRadius: BorderRadius.circular(2),
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
}
