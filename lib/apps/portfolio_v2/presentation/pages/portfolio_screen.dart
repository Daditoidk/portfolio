import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sections/header/header_section.dart';
import '../sections/about/about_section.dart';
import '../sections/skills/skills_section.dart';
import '../sections/projects/project_item.dart';
import '../sections/contact/contact_section.dart';
import '../shared/widgets/reveal_from_animation.dart';
import '../theme/portfolio_theme.dart';
import '../../data/providers/project_providers.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/scroll_providers.dart';

class PortfolioV2Screen extends ConsumerWidget {
  const PortfolioV2Screen({super.key});

  static const double horizontalPadding = 31;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get localized projects
    final l10n = AppLocalizations.of(context);
    final projects = l10n != null
        ? ref.watch(localizedProjectsProvider(l10n))
        : ref.watch(projectsProvider);
    final scrollController = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);
    final sectionScrollService = ref.watch(sectionScrollServiceProvider);
    final screenSize = MediaQuery.of(context).size;
    final isStackedHeader = screenSize.width < 1024;
    final topLeftHeaderBackground = isStackedHeader
        ? PortfolioTheme.grayColor
        : PortfolioTheme.bgColor;
    const topRightHeaderBackground = PortfolioTheme.grayColor;

    // Listen to scroll updates to update current section for nav highlighting
    scrollController.addListener(() {
      final current = sectionScrollService.getCurrentSection(context);
      final prev = ref.read(currentSectionProvider);
      if (current != prev) {
        ref.read(currentSectionProvider.notifier).state = current;
      }
    });

    return Scaffold(
      backgroundColor: PortfolioTheme.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Home section
                KeyedSubtree(
                  key: sectionKeys['home'],
                  child: const HeaderSection(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      // About section
                      KeyedSubtree(
                        key: sectionKeys['about'],
                        child: const AboutSection(),
                      ),
                      // Skills section
                      KeyedSubtree(
                        key: sectionKeys['skills'],
                        child: SkillsSection(),
                      ),
                      // Projects section wrapper (list remains inside)
                      KeyedSubtree(
                        key: sectionKeys['projects'],
                        child: Column(
                          children: [
                            ...projects.map(
                              (project) => ProjectItem(project: project),
                            ),
                          ],
                        ),
                      ),
                      // Contact section
                      KeyedSubtree(
                        key: sectionKeys['contact'],
                        child: const ContactSection(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...fixedItems(ref, topLeftHeaderBackground, topRightHeaderBackground),
        ],
      ),
    );
  }

  List<Widget> fixedItems(
    WidgetRef ref,
    Color topLeftHeaderBackground,
    Color topRightHeaderBackground,
  ) {
    return [
      topLeftCornerText(ref, topLeftHeaderBackground),
      topRightCornerText(ref, topRightHeaderBackground),
      bottomRightAccesibilityButton(ref),
    ];
  }

  Widget topLeftCornerText(WidgetRef ref, Color headerBackgroundColor) {
    final isInHeader = ref.watch(currentSectionProvider) == 'home';
    final textColor = isInHeader
        ? _foregroundForBackground(headerBackgroundColor)
        : PortfolioTheme.whiteColor;

    return Positioned(
      top: 20,
      left: horizontalPadding,
      child: RevealOnScroll(
        scrollController: ref.watch(scrollControllerProvider),
        from: RevealFrom.left,
        fadeDuration: Duration(milliseconds: 1200),
        staggerDelay: Duration(milliseconds: 1200),
        child: Text(
          'Bring ideas to life \nsince 2021 --',
          style: PortfolioTheme.manropeRegular16.copyWith(color: textColor),
        ),
      ),
    );
  }

  Widget topRightCornerText(WidgetRef ref, Color headerBackgroundColor) {
    final currentSection = ref.watch(currentSectionProvider);
    final isInHeader = currentSection == 'home';
    final textColor = isInHeader
        ? _foregroundForBackground(headerBackgroundColor)
        : PortfolioTheme.whiteColor;

    return Positioned(
      top: 20,
      right: horizontalPadding,
      child: RevealOnScroll(
        scrollController: ref.watch(scrollControllerProvider),
        from: RevealFrom.right,
        fadeDuration: Duration(milliseconds: 1200),
        staggerDelay: Duration(milliseconds: 1200),
        child: Text(
          'Portfolio\n   -- Vol 2',
          style: PortfolioTheme.manropeRegular16.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget bottomRightAccesibilityButton(WidgetRef ref) {
    return Positioned(
      bottom: 20,
      right: horizontalPadding,
      child: RevealOnScroll(
        scrollController: ref.watch(scrollControllerProvider),
        from: RevealFrom.right,
        fadeDuration: Duration(milliseconds: 1200),
        staggerDelay: Duration(milliseconds: 1200),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: PortfolioTheme.orangeColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: PortfolioTheme.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.accessibility,
            color: PortfolioTheme.whiteColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Color _foregroundForBackground(Color background) {
    final brightness = ThemeData.estimateBrightnessForColor(background);
    return brightness == Brightness.dark
        ? PortfolioTheme.whiteColor
        : PortfolioTheme.bgColor;
  }
}
