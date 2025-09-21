import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/scroll_providers.dart';
import '../../shared/widgets/reveal_from_animation.dart';
import '../../theme/portfolio_theme.dart';

class ContactSection extends ConsumerWidget {
  final ScrollController? controller;
  const ContactSection({super.key, this.controller});

  Future<void> _handleEmailTap(BuildContext context) async {
    const String email = 'kamiomg99@gmail.com';
    const String subject = '[Portfolio] Project Inquiry';
    const String body = '''
    Hi Camilo,
    
    I hope this email finds you well. I was just looking through your portfolio and was really impressed with your work on [mention a specific project or two]. I especially liked [mention a specific detail you liked].
    
    I'm working on a project called [Your Project Name] and I think your skills would be a great fit. It involves [briefly describe your project].
    
    I'd like to get an idea of your rates and see if you'd be interested in a potential collaboration. Would you have some time to chat next week?
    
    Thanks,
    
    [Your Name]
    [Your Contact Information]
    ''';

    try {
      final subjectEncoded = Uri.encodeComponent(subject);
      final bodyEncoded = Uri.encodeComponent(body);
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        // Manually build query to avoid '+' for spaces
        query: 'subject=$subjectEncoded&body=$bodyEncoded',
      );

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Mail compose already visible; nothing else to do.
        return;
      }
    } catch (error) {
      await Clipboard.setData(const ClipboardData(text: email));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo abrir el correo. Email copiado al portapapeles.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleExternalUrlTap(BuildContext context, String url) async {
    final trimmedUrl = url.trim();
    try {
      final uri = Uri.parse(trimmedUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Unable to launch $trimmedUrl');
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: trimmedUrl));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo abrir el enlace. URL copiada al portapapeles.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          RevealOnScroll(
            scrollController: controller ?? ref.watch(scrollControllerProvider),
            from: RevealFrom.center,
            fadeDuration: Duration(milliseconds: 1200),
            staggerDelay: Duration(milliseconds: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textWithGradient(),

                const SizedBox(height: 65),
                Text(
                  'Drop me an email',
                  style: PortfolioTheme.manropeRegular20,
                ),
                const SizedBox(height: 8),
                LinkText(
                  text: 'kamiomg99@gmail.com',
                  onTap: () async {
                    await _handleEmailTap(context);
                  },
                ),
              ],
            ),
          ),
          RevealOnScroll(
            scrollController: controller ?? ref.watch(scrollControllerProvider),
            from: RevealFrom.bottom,
            fadeDuration: Duration(milliseconds: 1500),
            staggerDelay: Duration(milliseconds: 1500),
            child: _FooterLinks(
              onGithubTap: () {
                _handleExternalUrlTap(context, 'https://github.com/Daditoidk');
              },
              onLinkedinTap: () {
                _handleExternalUrlTap(
                  context,
                  'https://www.linkedin.com/in/csantacruza/',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textWithGradient() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 420;
        final letterSpacing = isCompact ? 10.0 : 18.0;
        final baseStyle = PortfolioTheme.monotonRegular100.copyWith(
          fontSize: isCompact ? 48 : 100,
          letterSpacing: letterSpacing,
        );

        return FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Ready to ',
              style: baseStyle,
              children: [
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        PortfolioTheme.createGradient.createShader(bounds),
                    child: Text(
                      'create',
                      style: baseStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                TextSpan(text: '?', style: baseStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final VoidCallback onGithubTap;
  final VoidCallback onLinkedinTap;

  const _FooterLinks({required this.onGithubTap, required this.onLinkedinTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        if (isCompact) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '@2025',
                style: PortfolioTheme.manropeRegular16,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  LinkText(
                    text: 'GITHUB',
                    style: PortfolioTheme.manropeBold16,
                    onTap: onGithubTap,
                  ),
                  LinkText(
                    text: 'LINKEDIN',
                    style: PortfolioTheme.manropeBold16,
                    onTap: onLinkedinTap,
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('@2025', style: PortfolioTheme.manropeRegular16),
            LinkText(
              text: 'GITHUB',
              style: PortfolioTheme.manropeBold16,
              onTap: onGithubTap,
            ),
            LinkText(
              text: 'LINKEDIN',
              style: PortfolioTheme.manropeBold16,
              onTap: onLinkedinTap,
            ),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const LinkText({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: style ?? PortfolioTheme.manropeBold20),
      ),
    );
  }
}
