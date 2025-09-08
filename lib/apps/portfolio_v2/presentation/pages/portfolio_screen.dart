import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sections/header/header_section.dart';
import '../sections/about/about_section.dart';
import '../sections/skills/skills_section.dart';
import '../sections/projects/project_item.dart';
import '../sections/contact/contact_section.dart';
import '../shared/components/custom_nav_bar_portfolio_v2.dart';
import '../theme/portfolio_theme.dart';
import '../../data/providers/project_providers.dart';
import '../../../../core/l10n/app_localizations.dart';

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
    return Scaffold(
      backgroundColor: PortfolioTheme.bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                const HeaderSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      const AboutSection(),
                      SkillsSection(),
                      ...projects.map(
                        (project) => ProjectItem(project: project),
                      ),
                      const ContactSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...fixedItems(),
        ],
      ),
    );
  }

  List<Widget> fixedItems() {
    return [
      topLeftCornerText(),
      // topCenterNavBar(),
      topRightCornerText(),
      bottomRightAccesibilityButton(),
    ];
  }

  Widget topLeftCornerText() {
    return Positioned(
      top: 20,
      left: horizontalPadding,
      child: Text(
        'Bring ideas to life \nsince 2021 --',
        style: PortfolioTheme.manropeRegular16,
      ),
    );
  }

  Widget topCenterNavBar() {
    return const Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(child: CustomNavBarPortfolioV2()),
    );
  }

  Widget topRightCornerText() {
    return Positioned(
      top: 20,
      right: horizontalPadding,
      child: Text(
        'Portfolio\n   -- Vol 2',
        style: PortfolioTheme.manropeRegular16,
      ),
    );
  }

  Widget bottomRightAccesibilityButton() {
    return Positioned(
      bottom: 20,
      right: horizontalPadding,
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
    );
  }
}
