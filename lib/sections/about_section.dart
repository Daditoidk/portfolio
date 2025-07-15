import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../helpers/responsive.dart';
import '../theme/app_theme.dart'; // Added import for AppTheme

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
    // final theme = Theme.of(context); // unused, removed
    
    return Semantics(
      label: SemanticLabels.aboutSection,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: isMobile ? 40 : 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: SemanticLabels.sectionTitle,
              child: Text(
                l10n.aboutTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 30),
            Semantics(
              label: SemanticLabels.sectionDescription,
              child: Text(
                l10n.aboutSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildSkillsGrid(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(BuildContext context, bool isMobile) {
    final l10n = AppLocalizations.of(context)!;
    final skills = l10n.aboutSkills.split(',');
    
    // Alternate navy and light blue for chip backgrounds
    return Wrap(
      spacing: isMobile ? 12 : 24,
      runSpacing: isMobile ? 12 : 24,
      alignment: WrapAlignment.center,
      children: List.generate(skills.length, (i) {
        final skill = skills[i].trim();
        final isEven = i % 2 == 0;
        final bgColor = isEven ? AppTheme.navy : AppTheme.blue;
        final textColor = isEven ? Colors.white : AppTheme.navy;
        return Chip(
          label: Text(skill),
          backgroundColor: bgColor,
          labelStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? 12 : 14,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 16,
            vertical: isMobile ? 4 : 8,
          ),
        );
      }),
    );
  }
}
