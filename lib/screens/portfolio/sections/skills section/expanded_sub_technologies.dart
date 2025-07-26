import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'skill_item.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandedSubTechnologies extends ConsumerWidget {
  final SkillItem skill;
  final AppLocalizations l10n;

  const ExpandedSubTechnologies({
    super.key,
    required this.skill,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            '${skill.name} Technologies',
            baseFontSize:
                Theme.of(context).textTheme.titleSmall?.fontSize ?? 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue[700],
          ),
          const SizedBox(height: 12),
          ...skill.subTechnologies!.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccessibleText(
                  entry.key,
                  baseFontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      entry.value.map((tech) {
                    return ClickableCursor(
                      child: AccessibleTooltip(
                        message: '$tech - Sub-technology of ${skill.name}',
                        baseFontSize: 11,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[300]!),
                          ),
                          child: AccessibleText(
                            tech,
                            baseFontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}
