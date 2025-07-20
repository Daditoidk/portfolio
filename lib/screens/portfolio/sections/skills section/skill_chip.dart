import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'skill_item.dart';
import 'experience_badge.dart';
import 'active_badge.dart';

class SkillChip extends StatelessWidget {
  final SkillItem skill;
  final bool isExpanded;
  final VoidCallback? onTap;
  final AppLocalizations l10n;

  const SkillChip({
    super.key,
    required this.skill,
    required this.isExpanded,
    this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isExpanded ? Colors.blue[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? Colors.blue[400]! : Colors.blue[200]!,
            width: isExpanded ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              skill.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            ExperienceBadge(years: skill.years, l10n: l10n),
            if (skill.isCurrentlyUsing) ...[
              const SizedBox(width: 4),
              ActiveBadge(l10n: l10n),
            ],
            if (skill.hasSubTechnologies) ...[
              const SizedBox(width: 4),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.blue[600],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
