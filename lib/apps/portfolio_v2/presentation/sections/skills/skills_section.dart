import 'package:flutter/material.dart';

import '../../../data/repositories/skill_repository.dart';
import '../../theme/portfolio_theme.dart';
import 'fall_in_grid.dart';
import 'widgets/compact_skills_grid.dart';
import 'widgets/detailed_skill_rectangle.dart';

class SkillsSection extends StatelessWidget {
  SkillsSection({super.key});

  final SkillRepository _skillRepository = SkillRepository();

  @override
  Widget build(BuildContext context) {
    if (_skillRepository.skillCount == 0) {
      _skillRepository.initializeWithSampleData();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isSmall = maxWidth < 600;
        final isMedium = maxWidth >= 600 && maxWidth < 1024;

        final primarySkill =
            _skillRepository.getSkillByName('Flutter & Dart') ??
            _skillRepository.getAllSkills().first;

        final detailCard = DetailedSkillRectangle(
          skill: primarySkill,
          width: isSmall ? maxWidth : 323,
          height: null,
          enableScroll: isSmall,
        );

        final labels = _LegendLabels(isCompact: isSmall || isMedium);

        late final Widget content;
        final viewportHeight =
            MediaQuery.of(context).size.height +
            MediaQuery.of(context).size.height * 0.15;
        final gridMaxHeight = ((viewportHeight - (isSmall ? 160 : 220)).clamp(
          280.0,
          viewportHeight,
        )).toDouble();

        if (!isSmall && !isMedium) {
          content = _LargeLayout(
            detailCard: detailCard,
            labels: labels,
            gridMaxHeight: gridMaxHeight,
          );
        } else if (isMedium) {
          content = _MediumLayout(
            detailCard: detailCard,
            labels: labels,
            gridMaxHeight: gridMaxHeight,
          );
        } else {
          content = _SmallLayout(detailCard: detailCard, labels: labels);
        }

        return Container(
          width: double.infinity,
          color: PortfolioTheme.bgColor,
          padding: EdgeInsets.symmetric(
            vertical: isSmall ? 48 : 72,
            horizontal: isSmall ? 0 : 12,
          ),
          child: content,
        );
      },
    );
  }
}

class _LargeLayout extends StatelessWidget {
  const _LargeLayout({
    required this.detailCard,
    required this.labels,
    required this.gridMaxHeight,
  });

  final Widget detailCard;
  final Widget labels;
  final double gridMaxHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [detailCard, const SizedBox(height: 24), labels],
        ),
        const SizedBox(width: 32),
        Expanded(
          child: SizedBox(height: gridMaxHeight, child: const SkillsGrid()),
        ),
      ],
    );
  }
}

class _MediumLayout extends StatelessWidget {
  const _MediumLayout({
    required this.detailCard,
    required this.labels,
    required this.gridMaxHeight,
  });

  final Widget detailCard;
  final Widget labels;
  final double gridMaxHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [detailCard, const SizedBox(width: 24), labels],
        ),
        const SizedBox(height: 40),
        SizedBox(height: gridMaxHeight, child: const SkillsGrid()),
      ],
    );
  }
}

class _SmallLayout extends StatelessWidget {
  const _SmallLayout({required this.detailCard, required this.labels});

  final Widget detailCard;
  final Widget labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detailCard,
        const SizedBox(height: 20),
        labels,
        const SizedBox(height: 28),
        CompactSkillsGrid(),
      ],
    );
  }
}

class _LegendLabels extends StatelessWidget {
  const _LegendLabels({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    Widget activelyBeingUsedLabel() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              color: PortfolioTheme.orangeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text('-', style: PortfolioTheme.manropeRegular16),
          const SizedBox(width: 10),
          Text('Actively being used', style: PortfolioTheme.manropeRegular16),
        ],
      );
    }

    Widget yearsOfExperienceLabel() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('#Y', style: PortfolioTheme.manropeBold16),
          SizedBox(width: 10),
          Text('-', style: PortfolioTheme.manropeRegular16),
          SizedBox(width: 10),
          Text('Years of experience', style: PortfolioTheme.manropeRegular16),
        ],
      );
    }

    final labels = [
      activelyBeingUsedLabel(),
      const SizedBox(height: 10),
      yearsOfExperienceLabel(),
    ];

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: labels,
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: labels,
    );
  }
}
