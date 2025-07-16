import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/semantic_labels.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/helpers/responsive.dart';
import '../../../widgets/portfolio_nav_bar.dart';

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
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
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
            ],
          ),
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
