import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Semantics(
      label: SemanticLabels.contactSection,
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
                  l10n.contactTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                label: SemanticLabels.sectionDescription,
                child: Text(
                  l10n.contactSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Semantics(
                label: SemanticLabels.contactInformation,
                child: Wrap(
                  spacing: isMobile ? 20 : 30,
                  runSpacing: isMobile ? 20 : 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildContactItem(Icons.email, l10n.contactEmail),
                    _buildContactItem(Icons.phone, l10n.contactPhone),
                    _buildContactItem(Icons.location_on, l10n.contactLocation),
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
                      Icons.facebook,
                      Colors.blue.shade600,
                      'Facebook',
                    ),
                    SizedBox(width: isMobile ? 15 : 20),
                    _buildSocialButton(
                      Icons.link,
                      Colors.blue.shade600,
                      'LinkedIn',
                    ),
                    SizedBox(width: isMobile ? 15 : 20),
                    _buildSocialButton(
                      Icons.code,
                      Colors.blue.shade600,
                      'GitHub',
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

  Widget _buildContactItem(IconData icon, String text) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Semantics(
          label: 'Contact information',
          child: Column(
            children: [
              Semantics(
                label: 'Contact icon',
                child: Icon(
                  icon,
                  size: isMobile ? 25 : 30,
                  color: AppTheme.primaryIcon,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 10),
              Semantics(
                label: 'Contact details',
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: isMobile ? 12 : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String platform) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return Semantics(
          label: '$platform profile',
          hint: 'Double tap to visit $platform profile',
          button: true,
          child: Container(
            width: isMobile ? 45 : 50,
            height: isMobile ? 45 : 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryButton,
              borderRadius: BorderRadius.circular(isMobile ? 22.5 : 25),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryButtonText,
              size: isMobile ? 20 : 24,
            ),
          ),
        );
      },
    );
  }
}
