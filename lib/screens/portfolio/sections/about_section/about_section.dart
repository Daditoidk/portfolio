import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/helpers/responsive.dart';

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
              label: SemanticLabels.aboutDescription,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 600,
                ),
                child: Text(
                  l10n.aboutDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: SemanticLabels.sectionDescription,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 600,
                ),
                child: Text(
                  l10n.aboutSubtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
