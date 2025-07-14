import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';

class LabSection extends StatelessWidget {
  const LabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Semantics(
      label: SemanticLabels.labSection,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          color: AppTheme.labBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isMobile ? 40 : 0),
              Semantics(
                label: SemanticLabels.sectionTitle,
                child: Text(
                  l10n.labTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                label: SemanticLabels.sectionDescription,
                child: Text(
                  l10n.labSubtitle,
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.experimentalProjects,
                child: Wrap(
                  spacing: isMobile ? 15 : 20,
                  runSpacing: isMobile ? 15 : 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLabCard(
                      l10n.labAIChatTitle,
                      l10n.labAIChatDescription,
                      Icons.smart_toy,
                      Colors.purple.shade100,
                    ),
                    _buildLabCard(
                      l10n.labARTitle,
                      l10n.labARDescription,
                      Icons.view_in_ar,
                      Colors.green.shade100,
                    ),
                    _buildLabCard(
                      l10n.labVoiceTitle,
                      l10n.labVoiceDescription,
                      Icons.mic,
                      Colors.orange.shade100,
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

  Widget _buildLabCard(
    String title,
    String description,
    IconData icon,
    Color bgColor,
  ) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Semantics(
          label: '${SemanticLabels.experimentalProject}: $title',
          hint: SemanticLabels.viewExperimentalProjectDetails,
          button: true,
          child: Container(
            width: isMobile ? screenWidth * 0.85 : 280,
            padding: EdgeInsets.all(isMobile ? 15 : 20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: SemanticLabels.projectIcon,
                  child: Icon(
                    icon,
                    size: isMobile ? 30 : 40,
                    color: Colors.blue.shade600,
                  ),
                ),
                SizedBox(height: isMobile ? 10 : 15),
                Semantics(
                  label: '${SemanticLabels.project} title',
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: '${SemanticLabels.project} description',
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 10),
                Semantics(
                  label: '${SemanticLabels.experimentalProject} badge',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.experimentalBadge,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
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
