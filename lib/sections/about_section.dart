import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Semantics(
      label: SemanticLabels.aboutSection,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isMobile ? 40 : 0),
              Semantics(
                label: SemanticLabels.sectionTitle,
                child: Text(
                  l10n.aboutTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                label: SemanticLabels.aboutDescription,
                child: Text(
                  l10n.aboutDescription,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.skillsAndTechnologies,
                child: Wrap(
                  spacing: isMobile ? 15 : 20,
                  runSpacing: isMobile ? 15 : 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSkillCard(l10n.skillFlutter, Icons.mobile_friendly),
                    _buildSkillCard(l10n.skillDart, Icons.code),
                    _buildSkillCard(l10n.skillFirebase, Icons.cloud),
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

  Widget _buildSkillCard(String title, IconData icon) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Semantics(
          label: '$title ${SemanticLabels.skillsAndTechnologies.toLowerCase()}',
          child: Container(
            padding: EdgeInsets.all(isMobile ? 15 : 20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Column(
              children: [
                Semantics(
                  label: '$title ${SemanticLabels.projectIcon.toLowerCase()}',
                  child: Icon(
                    icon,
                    size: isMobile ? 30 : 40,
                    color: AppTheme.primaryIcon,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : null,
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
