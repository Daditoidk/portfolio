import 'package:flutter/material.dart';
import '../../../data/repositories/skill_repository.dart';
import '../../theme/portfolio_theme.dart';
import 'widgets/detailed_skill_rectangle.dart';
import 'widgets/skills_grid.dart';

class SkillsSection extends StatelessWidget {
  SkillsSection({super.key});

  final SkillRepository _skillRepository = SkillRepository();

  @override
  Widget build(BuildContext context) {
    // Initialize skills data if not already done
    if (_skillRepository.skillCount == 0) {
      _skillRepository.initializeWithSampleData();
    }
    Widget activelyBeingUsedLabel() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: PortfolioTheme.orangeColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10),
          Text('-', style: PortfolioTheme.manropeRegular16),
          SizedBox(width: 10),

          Text('Actively being used', style: PortfolioTheme.manropeRegular16),
        ],
      );
    }

    Widget yearsOfExperienceLabel() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('#Y', style: PortfolioTheme.manropeBold16),
          SizedBox(width: 10),

          Text('-', style: PortfolioTheme.manropeRegular16),
          SizedBox(width: 10),

          Text('Years of experience', style: PortfolioTheme.manropeRegular16),
        ],
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: PortfolioTheme.bgColor,
      padding: EdgeInsets.symmetric(vertical: 57),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailedSkillRectangle(
                skill:
                    _skillRepository.getSkillByName('Flutter & Dart') ??
                    _skillRepository.getAllSkills().first,
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [activelyBeingUsedLabel(), yearsOfExperienceLabel()],
              ),
            ],
          ),
          const SizedBox(width: 21),
          Expanded(child: SkillsGrid()),
        ],
      ),
    );
  }
}
