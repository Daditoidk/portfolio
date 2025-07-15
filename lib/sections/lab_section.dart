import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../helpers/responsive.dart';
import '../theme/app_theme.dart';

class LabSection extends StatelessWidget {
  const LabSection({super.key});

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
    
    return Semantics(
      label: SemanticLabels.labSection,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: AppTheme.labBackground,
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
              child: Text(l10n.labTitle, style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: 30),
            Semantics(
              label: SemanticLabels.sectionDescription,
              child: Text(
                l10n.labSubtitle,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildLabItems(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildLabItems(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final labs = List.generate(7, (index) => 'Lab ${index + 1}');
    // Show all 7 items in all views
    return Wrap(
      spacing: isMobile ? 12 : 24,
      runSpacing: isMobile ? 12 : 24,
      alignment: WrapAlignment.center,
      children: List.generate(
        labs.length,
        (index) => Container(
          width: isMobile ? 140 : 200,
          height: isMobile ? 100 : 140,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            labs[index],
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 14 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
