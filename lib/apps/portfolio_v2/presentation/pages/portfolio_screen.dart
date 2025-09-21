import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_web/core/accessibility/menu/accessibility_menu.dart';
import 'package:portfolio_web/core/accessibility/menu/accessibility_menu_content.dart';

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
import '../providers/accessibility_providers.dart';

class PortfolioV2Screen extends ConsumerWidget {
  const PortfolioV2Screen({super.key});

  static const double horizontalPadding = 31;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(accessibilityLocaleProvider);

    return Localizations.override(
      context: context,
      locale: currentLocale,
      child: Builder(
        builder: (localeContext) {
          final l10n = AppLocalizations.of(localeContext);
          final projects = l10n != null
              ? ref.watch(localizedProjectsProvider(l10n))
              : ref.watch(projectsProvider);
          final scrollController = ref.watch(scrollControllerProvider);
          final sectionKeys = ref.watch(sectionKeysProvider);
          final sectionScrollService = ref.watch(sectionScrollServiceProvider);
          final screenSize = MediaQuery.of(localeContext).size;
          final isStackedHeader = screenSize.width < 1024;
          final topLeftHeaderBackground = isStackedHeader
              ? PortfolioTheme.grayColor
              : PortfolioTheme.bgColor;
          const topRightHeaderBackground = PortfolioTheme.grayColor;

          scrollController.addListener(() {
            final current =
                sectionScrollService.getCurrentSection(localeContext);
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
                            KeyedSubtree(
                              key: sectionKeys['about'],
                              child: const AboutSection(),
                            ),
                            KeyedSubtree(
                              key: sectionKeys['skills'],
                              child: SkillsSection(),
                            ),
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
                ...fixedItems(
                  ref,
                  topLeftHeaderBackground,
                  topRightHeaderBackground,
                ),
                accessibilityMenuPanel(localeContext, ref),
              ],
            ),
          );
        },
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
    final locale = ref.watch(accessibilityLocaleProvider);
    return Positioned(
      bottom: 20,
      right: horizontalPadding,
      child: RevealOnScroll(
        scrollController: ref.watch(scrollControllerProvider),
        from: RevealFrom.right,
        fadeDuration: Duration(milliseconds: 1200),
        staggerDelay: Duration(milliseconds: 1200),
        child: AccessibilityMenu(
          languageCode: locale.languageCode,
          onLanguageChanged: (lang) {
            ref.read(accessibilityLocaleProvider.notifier).state = Locale(lang);
          },
          onPressed: () {
            final controller =
                ref.read(isAccessibilityMenuOpenProvider.notifier);
            controller.state = !controller.state;
          },
        ),
      ),
    );
  }

  Widget accessibilityMenuPanel(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isAccessibilityMenuOpenProvider);
    final locale = ref.watch(accessibilityLocaleProvider);
    final menuWidth = (MediaQuery.of(context).size.width * 0.9)
        .clamp(0, 340)
        .toDouble();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      top: 0,
      bottom: 0,
      right: isOpen ? 0 : -menuWidth,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: Material(
          color: Colors.grey.shade100,
          child: SizedBox(
            width: menuWidth,
            height: MediaQuery.of(context).size.height,
            child: AccessibilityMenuContent(
              languageCode: locale.languageCode,
              onLanguageChanged: (lang) {
                ref.read(accessibilityLocaleProvider.notifier).state =
                    Locale(lang);
              },
              onClose: () {
                ref.read(isAccessibilityMenuOpenProvider.notifier).state =
                    false;
              },
              onPageStructureOpen: () {
                ref.read(isAccessibilityMenuOpenProvider.notifier).state =
                    false;
              },
            ),
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
