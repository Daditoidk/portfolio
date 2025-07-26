import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../widgets/accessibility floating button/accessibility_floating_button.dart';

class AboutSection extends ConsumerWidget {
  final Function(String)? onSectionTap; // Add this parameter

  const AboutSection({
    super.key,
    this.onSectionTap, // Add this parameter
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      mobile: (context) => _buildContent(context, ref, isMobile: true),
      desktop: (context) => _buildContent(context, ref, isMobile: false),
      tablet: (context) => _buildContent(context, ref, isMobile: false),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref, {
    required bool isMobile,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: 'about-section', // Will be localized dynamically
          type: PageStructureType.section,
          level: 1,
          sectionId: "about",
        ),
        PageStructureItem(
          label: 'about-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "about-title",
        ),
        PageStructureItem(
          label: 'about-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "about-description",
        ),
        PageStructureItem(
          label: 'about-subtitle', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "about-subtitle",
        ),
      ],
      onSectionTap: onSectionTap, // Pass the navigation callback
      currentLocale: Localizations.localeOf(context), // Pass the current locale
      child: AccessibleHighContrast(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: AccessiblePauseAnimations(
          child: Semantics(
            label: SemanticLabels.aboutSection,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 32,
                vertical: isMobile ? 40 : 80,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: SemanticLabels.sectionTitle,
                    child: AccessibleText(
                      l10n.aboutTitle,
                      baseFontSize:
                          Theme.of(
                            context,
                          ).textTheme.headlineMedium?.fontSize ??
                          24,
                      fontWeight: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.fontWeight,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Semantics(
                    label: SemanticLabels.aboutDescription,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 600,
                      ),
                      child: AccessibleText(
                        l10n.aboutDescription,
                        baseFontSize: isMobile ? 14 : 16,
                        textAlign: TextAlign.center,
                        maxLines: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    label: SemanticLabels.sectionDescription,
                    child: AccessibleText(
                      l10n.aboutSubtitle,
                      baseFontSize: isMobile ? 12 : 14,
                      color: Colors.grey[600],
                      textAlign: TextAlign.center,
                      maxLines: 3,
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
