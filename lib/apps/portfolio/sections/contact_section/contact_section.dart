import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/version_info.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';

class ContactSection extends StatelessWidget {
  final Function(String)? onSectionTap; // Add this parameter

  const ContactSection({
    super.key,
    this.onSectionTap, // Add this parameter
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: 'contact-section', // Will be localized dynamically
          type: PageStructureType.section,
          level: 1,
          sectionId: "contact",
        ),
        PageStructureItem(
          label: 'contact-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "contact-title",
        ),
        PageStructureItem(
          label: 'contact-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "contact-description",
        ),
        PageStructureItem(
          label: 'contact-info', // Will be localized dynamically
          type: PageStructureType.form,
          level: 3,
          sectionId: "contact-info",
        ),
        PageStructureItem(
          label: 'social-links', // Will be localized dynamically
          type: PageStructureType.navigation,
          level: 3,
          sectionId: "social-links",
        ),
      ],
      onSectionTap: onSectionTap, // Pass the navigation callback
      currentLocale: Localizations.localeOf(context), // Pass the current locale
      child: Semantics(
        label: SemanticLabels.contactSection,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: AppTheme.contactBackground,
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isMobile ? 40 : 0),
              AccessibleText(
                l10n.contactTitle,
                semanticsLabel: SemanticLabels.sectionTitle,
                baseFontSize: theme.textTheme.headlineMedium?.fontSize ?? 24,
                fontWeight: theme.textTheme.headlineMedium?.fontWeight,
                languageCode: Localizations.localeOf(context).languageCode,
              ),
              const SizedBox(height: 30),
              AccessibleText(
                l10n.contactSubtitle,
                semanticsLabel: SemanticLabels.sectionDescription,
                baseFontSize: theme.textTheme.bodyLarge?.fontSize ?? 16,
                textAlign: TextAlign.center,
                languageCode: Localizations.localeOf(context).languageCode,
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.contactInformation,
                child: Wrap(
                  spacing: isMobile ? 20 : 30,
                  runSpacing: isMobile ? 20 : 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildContactItem(
                      context,
                      Icons.email,
                      l10n.contactEmail,
                      isMobile,
                    ),
                    _buildContactItem(
                      context,
                      Icons.phone,
                      l10n.contactPhone,
                      isMobile,
                    ),
                    _buildContactItem(
                      context,
                      Icons.location_on,
                      l10n.contactLocation,
                      isMobile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.socialMediaLinks,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      context,
                      'assets/icons/github.png',
                      theme.colorScheme.primary,
                      'GitHub',
                      'https://github.com/Daditoidk',
                      isMobile,
                    ),
                    SizedBox(width: isMobile ? 15 : 20),
                    _buildSocialButton(
                      context,
                      'assets/icons/linkedin.png',
                      theme.colorScheme.primary,
                      'LinkedIn',
                      'https://www.linkedin.com/in/csantacruza/',
                      isMobile,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Version and last update info - only show on desktop
              if (!isMobile) VersionInfo(isMobile: false),
              SizedBox(height: isMobile ? 40 : 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String text,
    bool isMobile,
  ) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Contact information',
      child: Column(
        children: [
          Semantics(
            label: 'Contact icon',
            child: Icon(
              icon,
              size: isMobile ? 25 : 30,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 10),
          Semantics(
            label: 'Contact details',
            child: AccessibleText(
              text,
              baseFontSize: isMobile
                  ? 12
                  : theme.textTheme.bodySmall?.fontSize ?? 12,
              textAlign: TextAlign.center,
              languageCode: Localizations.localeOf(context).languageCode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    dynamic icon, // Can be IconData or String (image path)
    Color color,
    String platform,
    String url,
    bool isMobile,
  ) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$platform profile',
      hint: 'Double tap to visit $platform profile',
      button: true,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isHovered = false;
          
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isMobile ? 45 : 50,
                height: isMobile ? 45 : 50,
                decoration: BoxDecoration(
                  color: isHovered 
                      ? theme.colorScheme.primary.withValues(alpha: 0.8)
                      : theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(isMobile ? 22.5 : 25),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: isHovered ? 0.5 : 0.3),
                      blurRadius: isHovered ? 12 : 8,
                      offset: Offset(0, isHovered ? 4 : 2),
                    ),
                  ],
                ),
                child: icon is IconData
                    ? Icon(
                        icon,
                        color: theme.colorScheme.onPrimary,
                        size: isMobile ? 20 : 24,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          icon as String,
                          width: isMobile ? 16 : 20,
                          height: isMobile ? 16 : 20,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
