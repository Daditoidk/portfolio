import 'package:flutter/material.dart';

import '../../../../data/models/skill.dart';
import '../../../shared/components/skill_chip.dart';
import '../../../theme/portfolio_theme.dart';

class DetailedSkillRectangle extends StatelessWidget {
  final Skill skill;
  final double? width;
  final double? height;
  final bool enableScroll;

  const DetailedSkillRectangle({
    required this.skill,
    this.width,
    this.height,
    this.enableScroll = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 323.0;

    return Container(
      width: cardWidth,
      constraints: BoxConstraints(minHeight: 480, maxWidth: cardWidth),
      height: height,
      decoration: BoxDecoration(
        color: skill.colorSet.mainColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: skill.colorSet.borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: skill.colorSet.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: _DetailedSkillContent(skill: skill, enableScroll: enableScroll),
    );
  }
}

class _DetailedSkillContent extends StatelessWidget {
  final Skill skill;
  final bool enableScroll;

  const _DetailedSkillContent({
    required this.skill,
    required this.enableScroll,
  });

  @override
  Widget build(BuildContext context) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${skill.yearOfExperience}Y', style: PortfolioTheme.manropeBold16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              skill.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: PortfolioTheme.manropeRegular16,
            ),
          ),
        ),
        if (skill.activelyBeingUsed)
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              color: PortfolioTheme.orangeColor,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(width: 10, height: 10),
      ],
    );

    final avatar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: Image.asset(
          skill.image,
          errorBuilder: (context, error, stackTrace) =>
              const ColoredBox(color: PortfolioTheme.grayColor),
        ),
      ),
    );

    final categoriesColumn = _buildCategories();

    final Widget categoriesWidget = enableScroll
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 8),
              child: categoriesColumn,
            ),
          )
        : categoriesColumn;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, avatar, categoriesWidget],
    );
  }

  Widget _buildCategories() {
    final categories = <Widget>[];
    final seen = <String>{};

    skill.details.forEach((key, value) {
      if (!seen.add(key)) return;

      categories.add(
        Column(
          crossAxisAlignment: seen.length.isEven
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                key,
                style: PortfolioTheme.manropeSemibold15.copyWith(
                  color: PortfolioTheme.whiteColor,
                  fontSize: 13,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: value.map((item) => SkillChip(text: item)).toList(),
            ),
          ],
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [...categories, const SizedBox(height: 12)],
    );
  }
}
