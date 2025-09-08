import 'package:flutter/material.dart';

import '../../../../data/models/skill.dart';
import '../../../shared/components/skill_chip.dart';
import '../../../theme/portfolio_theme.dart';

class DetailedSkillRectangle extends StatelessWidget {
  final Skill skill;
  const DetailedSkillRectangle({required this.skill, super.key});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 323,
    //   height: 515,
    //   decoration: BoxDecoration(
    //     color: PortfolioTheme.bgColor,
    //     borderRadius: BorderRadius.circular(10),
    //     border: Border.all(color: PortfolioTheme.borderColor, width: 1),
    //   ),
    // );
    return Container(
      width: 323,
      height: MediaQuery.of(context).size.height * 0.67,
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
      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${skill.yearOfExperience}Y',
                style: PortfolioTheme.manropeBold16,
              ),
              Text(
                skill.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PortfolioTheme.manropeRegular16,
              ),
              if (skill.activelyBeingUsed)
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: PortfolioTheme.orangeColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                skill.image,
                errorBuilder: (context, error, stackTrace) =>
                    ColoredBox(color: PortfolioTheme.grayColor),
              ),
            ),
          ),
          buildCategories(),
        ],
      ),
    );
  }

  Widget buildCategories() {
    List<Widget> categories = [];
    List<String> categoriesNames = [];
    skill.details.forEach((key, value) {
      if (categoriesNames.contains(key)) {
        return;
      }
      categoriesNames.add(key);
      categories.add(
        Column(
          crossAxisAlignment: categoriesNames.length % 2 == 0
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Category title
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                key,
                style: PortfolioTheme.manropeSemibold15.copyWith(
                  color: PortfolioTheme.whiteColor,
                ),
              ),
            ),
            // Technology chips - only one Wrap per category
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: value.map((item) => SkillChip(text: item)).toList(),
            ),
          ],
        ),
      );
    });
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10),
        children: categories,
      ),
    );
  }
}
