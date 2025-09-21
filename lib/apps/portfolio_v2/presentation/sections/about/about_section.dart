import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/scroll_providers.dart';
import '../../shared/components/text_button.dart';
import '../../shared/widgets/reveal_from_animation.dart';
import '../../theme/portfolio_theme.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  /// Get the last modification date of the CV PDF
  String _getCvLastModifiedDate() {
    // For web, we can't access file system directly
    // You can manually update this date when you update the CV
    return 'Updated: 16/08/2025';
  }

  /// Download the CV PDF
  Future<void> _downloadCv() async {
    try {
      // For web, we need to use the asset URL that will be served by Flutter
      const cvUrl =
          'assets/portfolio/about/Camilo%20Santacruz%20Abadiano%20resume%20Flutter%20Dev.pdf';
      final uri = Uri.parse(cvUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Alternative approach: try to trigger download
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_blank',
        );
      }
    } catch (e) {
      // Handle error - could show a snackbar or dialog
      print('Error downloading CV: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutText = """
I'm Camilo Santacruz Abadiano, a seasoned developer based in Bogotá, Colombia. Since graduating from the Universidad de los Andes and starting my career in 2016, I've had the privilege of working with a diverse range of clients across the United States and Spain. My experience has been a journey of continuous learning, tackling a variety of challenges to deliver high-quality digital solutions. Beyond my professional life, I’m constantly seeking new challenges and experiences, whether it's through physical disciplines like climbing and calisthenics, or exploring new creative outlets. I believe that a blend of technical expertise and creative passion is key to innovative problem-solving.

My interests extend well beyond the code I write. I’m an avid cook who loves a good cup of masala chai, and I'm currently diving into the world of video and image editing to expand my skills in media. Traveling has always been a significant part of my life—I've explored Spain, France, and Australia, and I hope to soon return to my home, Colombia, and visit Japan. In my free time, you'm often find me watching anime or getting lost in a good book, always with music setting the mood. With a working knowledge of Spanish, English, and basic Japanese, I'm excited by the possibilities that new technologies like AI offer for boosting creativity and connecting with people from all over the world.
""";

    final scrollController = ref.watch(scrollControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 600;
        final isStacked = width < 1024;
        final verticalPadding = isSmall ? 96.0 : 160.0;
        final textStyle = PortfolioTheme.manropeRegular16.copyWith(
          fontSize: isSmall ? 16 : 18,
          height: 1.6,
        );
        final textAlign = isStacked ? TextAlign.left : TextAlign.right;
        final textColumnAlignment = isStacked
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end;
        final buttonAlignment = isStacked
            ? Alignment.centerLeft
            : Alignment.centerLeft;
        final headingStyle = isSmall
            ? PortfolioTheme.monotonRegular48
            : PortfolioTheme.monotonRegular80;

        Widget buildDescription() {
          return Column(
            crossAxisAlignment: textColumnAlignment,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isStacked ? width : width * 0.55,
                ),
                child: Text(
                  aboutText,
                  style: textStyle,
                  textAlign: textAlign,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 24),
              Align(
                alignment: buttonAlignment,
                child: RevealOnScroll(
                  scrollController: scrollController,
                  from: RevealFrom.left,
                  fadeDuration: const Duration(milliseconds: 800),
                  staggerDelay: const Duration(milliseconds: 800),
                  child: Tooltip(
                    message: _getCvLastModifiedDate(),
                    child: CustomTextButton(
                      text: 'Get my CV',
                      onTap: _downloadCv,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        final headingWidget = RevealOnScroll(
          scrollController: scrollController,
          from: isStacked ? RevealFrom.top : RevealFrom.right,
          fadeDuration: const Duration(milliseconds: 600),
          staggerDelay: const Duration(milliseconds: 600),
          child: Text('About', style: headingStyle,
          ),
        );

        return Container(
          width: double.infinity,
          color: PortfolioTheme.bgColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: isStacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingWidget,
                    SizedBox(height: isSmall ? 24 : 48),
                    buildDescription(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: buildDescription()),
                    SizedBox(width: width * 0.2),
                    headingWidget,
                  ],
                ),
        );
      },
    );
  }
}
