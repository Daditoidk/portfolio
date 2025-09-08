import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';

class ResumeSection extends StatelessWidget {
  final Function(String)? onSectionTap; // Add this parameter

  const ResumeSection({
    super.key,
    this.onSectionTap, // Add this parameter
  });

  static const String resumeAsset =
      'assets/Camilo Santacruz Abadiano resume.pdf';
  static const String lastUpdated = '2025-07-21';

  void _downloadResume(BuildContext context) async {
    if (kIsWeb) {
      final url = resumeAsset;
      html.AnchorElement(href: url)
        ..setAttribute('download', 'Camilo Santacruz Abadiano resume.pdf')
        ..click();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download only supported on web for now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: 'resume-section', // Will be localized dynamically
          type: PageStructureType.section,
          level: 1,
          sectionId: "resume",
        ),
        PageStructureItem(
          label: 'resume-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "resume-title",
        ),
        PageStructureItem(
          label: 'resume-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "resume-description",
        ),
        PageStructureItem(
          label: 'download-resume', // Will be localized dynamically
          type: PageStructureType.button,
          level: 2,
          sectionId: "download-resume",
        ),
        PageStructureItem(
          label: 'last-updated', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "last-updated",
        ),
      ],
      onSectionTap: onSectionTap, // Pass the navigation callback
      currentLocale: Localizations.localeOf(context), // Pass the current locale
      child: AccessibleHighContrast(
        backgroundColor: Colors.grey[100]!,
        foregroundColor: Colors.black,
        child: AccessiblePauseAnimations(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: screenHeight * 0.5),
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: isMobile ? 40 : 80,
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: "Resume section title",
                        child: AccessibleText(
                          l10n.resumeSectionTitle,
                          baseFontSize:
                              Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize ??
                              24,
                          fontWeight: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.fontWeight,
                          languageCode: Localizations.localeOf(
                            context,
                          ).languageCode,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: "Resume section description",
                        child: AccessibleText(
                          l10n.resumeSectionDescription,
                          baseFontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize ??
                              16,
                          color: Colors.grey[600],
                          textAlign: TextAlign.center,
                          languageCode: Localizations.localeOf(
                            context,
                          ).languageCode,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Semantics(
                        label: "Download resume button",
                        hint: "Tap to download the resume PDF file",
                        button: true,
                        child: AccessibleCustomCursor(
                          child: AccessibleTooltip(
                            message: "Download resume as PDF file",
                            child: AccessibleButton(
                              onPressed: () => _downloadResume(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 25,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: AccessibleText(
                                  l10n.resumeDownload.toUpperCase(),
                                  baseFontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  languageCode: Localizations.localeOf(context).languageCode,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Semantics(
                    label: "Resume last updated information",
                    child: AccessibleText(
                      l10n.resumeLastUpdated(lastUpdated),
                      baseFontSize:
                          Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
                      color: Colors.grey[600],
                      languageCode: Localizations.localeOf(context).languageCode,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
