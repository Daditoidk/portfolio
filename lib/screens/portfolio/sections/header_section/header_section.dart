import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../widgets/portfolio_nav_bar.dart';

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

    return Semantics(
      label: SemanticLabels.headerSection,
      child: Container(
        width: double.infinity,
        height: screenHeight,
        color: AppTheme.cream,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavigationBar(context, loc),
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape =
                        screenHeight < 500; // Landscape mode detection
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: isMobile && !isLandscape ? 20 : 0),
                        Semantics(
                          label: SemanticLabels.profilePicture,
                          child: CircleAvatar(
                            radius: isLandscape ? 40 : (isMobile ? 60 : 80),
                            backgroundColor: AppTheme.avatarBackground,
                            backgroundImage: const AssetImage(
                              'assets/bgs/avatar.jpg',
                            ),
                            child: null,
                          ),
                        ),
                        SizedBox(height: isLandscape ? 15 : 30),
                        Semantics(
                          label: SemanticLabels.name,
                          child: Text(
                            loc.headerName,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.copyWith(
                              fontSize:
                                  isLandscape ? 24 : (isMobile ? 36 : null),
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
                              fontSize:
                                  isLandscape ? 14 : (isMobile ? 18 : null),
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
                              fontSize:
                                  isLandscape ? 12 : (isMobile ? 16 : null),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, AppLocalizations loc) {
    return PortfolioNavBar(
      onSectionTap: onSectionTap,
      currentSection: currentSection,
      currentLocale: currentLocale,
      onLocaleChanged: onLocaleChanged,
      isSticky: false,
      isVisible: true,
    );
  }
}
