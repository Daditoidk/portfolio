import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'skill_item.dart';
import 'skill_chip.dart';
import 'expanded_sub_technologies.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';

class SkillCategory extends StatelessWidget {
  final String categoryTitle;
  final List<SkillItem> skills;
  final String? expandedSkill;
  final Function(String?) onSkillTap;
  final AppLocalizations l10n;

  const SkillCategory({
    super.key,
    required this.categoryTitle,
    required this.skills,
    required this.expandedSkill,
    required this.onSkillTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Skill category: $categoryTitle",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            categoryTitle,
            baseFontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              final isExpanded = expandedSkill == skill.name;
              return Semantics(
                label: "Skill: ${skill.name}",
                hint: skill.hasSubTechnologies
                    ? "Tap to expand and see sub-technologies"
                    : "Skill information",
                child: SkillChip(
                  skill: skill,
                  isExpanded: isExpanded,
                  onTap: skill.hasSubTechnologies
                      ? () => onSkillTap(isExpanded ? null : skill.name)
                      : null,
                  l10n: l10n,
                ),
              );
            }).toList(),
          ),
          // Show expanded sub-technologies if any skill in this category is expanded
          ...skills
              .where(
                (skill) =>
                    expandedSkill == skill.name && skill.hasSubTechnologies,
              )
              .map(
                (skill) => ExpandedSubTechnologies(skill: skill, l10n: l10n),
              ),
        ],
      ),
    );
  }
}
