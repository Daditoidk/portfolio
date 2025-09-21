import 'package:flutter/material.dart';

import '../../../../data/models/skill.dart';
import '../../../theme/portfolio_theme.dart';

class SkillGridTile extends StatelessWidget {
  final Skill skill;
  const SkillGridTile({required this.skill, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 28,
            child: Image.asset(
              skill.image,
              errorBuilder: (context, error, stackTrace) =>
                  ColoredBox(color: PortfolioTheme.grayColor),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              skill.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: PortfolioTheme.manropeRegular16,
            ),
          ),
        ],
      ),
    );
  }
}
