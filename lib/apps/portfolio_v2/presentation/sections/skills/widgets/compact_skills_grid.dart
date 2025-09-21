import 'package:flutter/material.dart';

import '../../../../data/models/skill.dart';
import '../../../../data/repositories/skill_repository.dart';
import 'skill_grid_tile.dart';

class CompactSkillsGrid extends StatelessWidget {
  CompactSkillsGrid({super.key});

  final SkillRepository _repository = SkillRepository();

  List<Skill> _loadSkills() {
    if (_repository.skillCount == 0) {
      _repository.initializeWithSampleData();
    }
    return _repository.getAllSkills().where((item) => item.name != 'Flutter & Dart').toList();
  }

  @override
  Widget build(BuildContext context) {
    final skills = _loadSkills();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return SkillGridTile(skill: skill);
      },
    );
  }
}
