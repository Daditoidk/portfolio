import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/helpers/responsive.dart';
import 'skills_grid.dart';

class SkillsSectionScreen extends StatelessWidget {
  const SkillsSectionScreen({super.key});

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

    return Semantics(
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
                child: Text(
                  l10n.skillsTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: SemanticLabels.sectionDescription,
                child: Text(
                  l10n.skillsSubtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
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
    );
  }
}
