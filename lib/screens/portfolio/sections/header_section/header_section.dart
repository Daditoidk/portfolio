import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../widgets/portfolio_nav_bar.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenHeight < 500; // Landscape mode detection

    return AccessiblePageStructure(
      structureItems: [
        // Header as both heading and landmark
        PageStructureItem(
          label: 'header-section', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 1,
          sectionId: "home",
        ),
        PageStructureItem(
          label: 'header-section', // Will be localized dynamically
          type: PageStructureType.navigation, // Add as navigation landmark
          level: 1,
          sectionId: "home",
        ),
        PageStructureItem(
          label: 'navigation-menu', // Will be localized dynamically
          type: PageStructureType.navigation,
          level: 2,
          sectionId: "navigation",
        ),
        PageStructureItem(
          label: 'profile-picture', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "profile",
        ),
        PageStructureItem(
          label: 'name-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "name",
        ),
        PageStructureItem(
          label: 'professional-title', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "title",
        ),
        PageStructureItem(
          label: 'professional-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "description",
        ),
      ],
      onSectionTap: onSectionTap, // Pass the navigation callback
      currentLocale: currentLocale, // Pass the current locale
      child: AccessibleHighContrast(
        backgroundColor: AppTheme.cream,
        foregroundColor: AppTheme.navy,
        child: AccessiblePauseAnimations(
          child: Semantics(
            label: SemanticLabels.headerSection,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              color: AppTheme.cream,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main content area centered
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isMobile && !isLandscape ? 20 : 0),
                      Semantics(
                        label: SemanticLabels.profilePicture,
                        child: AccessibleHideImages(
                          altText:
                              "Profile picture of Camilo Santacruz Abadiano",
                          child: CircleAvatar(
                            radius: isLandscape ? 40 : (isMobile ? 60 : 80),
                            backgroundColor: AppTheme.avatarBackground,
                            backgroundImage: const AssetImage(
                              'assets/bgs/avatar.jpg',
                            ),
                            child: null,
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 15 : 30),
                      AccessibleText(
                        loc.headerName,
                        semanticsLabel: SemanticLabels.name,
                        baseFontSize: isLandscape ? 24 : (isMobile ? 36 : null),
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        languageCode: currentLocale.languageCode,
                      ),
                      SizedBox(height: isLandscape ? 5 : 10),
                      AccessibleText(
                        loc.headerTitle,
                        semanticsLabel: SemanticLabels.professionalTitle,
                        baseFontSize: isLandscape ? 14 : (isMobile ? 18 : null),
                        fontWeight: FontWeight.w500,
                        color: AppTheme.secondaryIcon,
                        languageCode: currentLocale.languageCode,
                      ),
                      SizedBox(height: isLandscape ? 10 : 20),
                      AccessibleText(
                        loc.headerSubtitle,
                        semanticsLabel: SemanticLabels.professionalDescription,
                        baseFontSize: isLandscape
                            ? 12
                            : (isMobile
                                  ? 16
                                  : Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.fontSize ??
                                        16),
                        textAlign: TextAlign.center,
                        languageCode: currentLocale.languageCode,
                      ),
                      SizedBox(height: isMobile && !isLandscape ? 40 : 0),
                    ],
                  ),
                  // Navigation bar positioned at the top
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildNavigationBar(context, loc),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, AppLocalizations loc) {
    return AccessibleHighlightLinks(
      highlightColor: AppTheme.navActive,
      child: PortfolioNavBar(
        onSectionTap: onSectionTap,
        currentSection: currentSection,
        currentLocale: currentLocale,
        onLocaleChanged: onLocaleChanged,
        isSticky: false,
        isVisible: true,
      ),
    );
  }
}
