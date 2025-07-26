import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/helpers/responsive.dart';
import 'skills_grid.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';

class SkillsSectionScreen extends StatelessWidget {
  final Function(String)? onSectionTap; // Add this parameter

  const SkillsSectionScreen({
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

    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: 'skills-section', // Will be localized dynamically
          type: PageStructureType.section,
          level: 1,
          sectionId: "skills",
        ),
        PageStructureItem(
          label: 'skills-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "skills-title",
        ),
        PageStructureItem(
          label: 'skills-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "skills-description",
        ),
        PageStructureItem(
          label: 'programming-languages', // Will be localized dynamically
          type: PageStructureType.section,
          level: 3,
          sectionId: "programming-languages",
        ),
        PageStructureItem(
          label: 'design-animation', // Will be localized dynamically
          type: PageStructureType.section,
          level: 3,
          sectionId: "design-animation",
        ),
        PageStructureItem(
          label: 'editors-tools', // Will be localized dynamically
          type: PageStructureType.section,
          level: 3,
          sectionId: "editors-tools",
        ),
        PageStructureItem(
          label: 'devops-cicd', // Will be localized dynamically
          type: PageStructureType.section,
          level: 3,
          sectionId: "devops-cicd",
        ),
        PageStructureItem(
          label: 'project-management', // Will be localized dynamically
          type: PageStructureType.section,
          level: 3,
          sectionId: "project-management",
        ),
      ],
      onSectionTap: onSectionTap, // Pass the navigation callback
      currentLocale: Localizations.localeOf(context), // Pass the current locale
      child: AccessibleHighContrast(
        backgroundColor: Colors.grey[50]!,
        foregroundColor: Colors.black,
        child: AccessiblePauseAnimations(
          child: Semantics(
            label: SemanticLabels.skillsAndTechnologies,
            child: Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 80,
                vertical: isMobile ? 40 : 80,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: SemanticLabels.sectionTitle,
                      child: AccessibleText(
                        l10n.skillsTitle,
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
                    const SizedBox(height: 16),
                    Semantics(
                      label: SemanticLabels.sectionDescription,
                      child: AccessibleText(
                        l10n.skillsSubtitle,
                        baseFontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize ??
                            16,
                        color: Colors.grey[600],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 800,
                      ),
                      child: const SkillsGrid(),
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
}
