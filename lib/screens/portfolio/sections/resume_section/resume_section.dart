import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import '../../../../core/l10n/app_localizations.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

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
    return Container(
      width: double.infinity,
      height: screenHeight * 0.5,
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
                Text(
                  l10n.resumeSectionTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.resumeSectionDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _downloadResume(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.resumeDownload.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              l10n.resumeLastUpdated(lastUpdated),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
