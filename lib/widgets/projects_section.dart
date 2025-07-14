import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Semantics(
      label: SemanticLabels.projectsSection,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          color: AppTheme.projectsBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isMobile ? 40 : 0),
              Semantics(
                label: SemanticLabels.sectionTitle,
                child: Text(
                  l10n.projectsTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.projectList,
                child: Wrap(
                  spacing: isMobile ? 15 : 20,
                  runSpacing: isMobile ? 15 : 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildProjectCard(
                      l10n.projectEcommerceTitle,
                      l10n.projectEcommerceDescription,
                      Icons.shopping_cart,
                    ),
                    _buildProjectCard(
                      l10n.projectTaskManagerTitle,
                      l10n.projectTaskManagerDescription,
                      Icons.task_alt,
                    ),
                    _buildProjectCard(
                      l10n.projectWeatherTitle,
                      l10n.projectWeatherDescription,
                      Icons.wb_sunny,
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 40 : 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, IconData icon) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Semantics(
          label: '${SemanticLabels.project}: $title',
          hint: SemanticLabels.viewProjectDetails,
          button: true,
          child: Container(
            width: isMobile ? screenWidth * 0.85 : 300,
            padding: EdgeInsets.all(isMobile ? 15 : 20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: SemanticLabels.projectIcon,
                  child: Icon(
                    icon,
                    size: isMobile ? 30 : 40,
                    color: AppTheme.primaryIcon,
                  ),
                ),
                SizedBox(height: isMobile ? 10 : 15),
                Semantics(
                  label: 'Project title',
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: isMobile ? 16 : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Semantics(
                  label: 'Project description',
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.4,
                      fontSize: isMobile ? 13 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
