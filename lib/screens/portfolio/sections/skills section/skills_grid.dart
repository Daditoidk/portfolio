import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'skill_item.dart';
import 'skill_category.dart';

class SkillsGrid extends StatefulWidget {
  const SkillsGrid({super.key});

  @override
  State<SkillsGrid> createState() => _SkillsGridState();
}

class _SkillsGridState extends State<SkillsGrid> {
  String? _expandedSkill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Programming Languages
        SkillCategory(
          categoryTitle: l10n.skillsLanguages,
          skills: [
            SkillItem(
              'Flutter & Dart',
              4,
              isCurrentlyUsing: true,
              hasSubTechnologies: true,
              subTechnologies: _getFlutterSubTechnologies(l10n),
            ),
            SkillItem(l10n.skillFlutterWeb, 1, isCurrentlyUsing: true),
            SkillItem(l10n.skillKotlin, 2),
            SkillItem(l10n.skillKotlinMultiplatform, 1),
            SkillItem(l10n.skillSwift, 1),
          ],
          expandedSkill: _expandedSkill,
          onSkillTap: (skillName) {
            setState(() {
              _expandedSkill = skillName;
            });
          },
          l10n: l10n,
        ),

        const SizedBox(height: 20),

        // Design & Animation
        SkillCategory(
          categoryTitle: l10n.skillsDesign,
          skills: [
            SkillItem(l10n.skillRive, 1, isCurrentlyUsing: true),
            SkillItem(l10n.skillFigma, 1),
            SkillItem(l10n.skillAdobeXD, 2),
          ],
          expandedSkill: _expandedSkill,
          onSkillTap: (skillName) {
            setState(() {
              _expandedSkill = skillName;
            });
          },
          l10n: l10n,
        ),

        const SizedBox(height: 20),

        // Editors & Tools
        SkillCategory(
          categoryTitle: l10n.skillsEditors,
          skills: [
            SkillItem(l10n.skillAndroidStudio, 4),
            SkillItem(l10n.skillVSCode, 2),
            SkillItem(l10n.skillCursor, 1, isCurrentlyUsing: true),
            SkillItem(l10n.skillGit, 6, isCurrentlyUsing: true),
          ],
          expandedSkill: _expandedSkill,
          onSkillTap: (skillName) {
            setState(() {
              _expandedSkill = skillName;
            });
          },
          l10n: l10n,
        ),

        const SizedBox(height: 20),

        // DevOps & CI/CD
        SkillCategory(
          categoryTitle: l10n.skillsDevOps,
          skills: [
            SkillItem(l10n.skillCodeMagic, 1, isCurrentlyUsing: true),
            SkillItem(l10n.skillGithubActions, 1),
          ],
          expandedSkill: _expandedSkill,
          onSkillTap: (skillName) {
            setState(() {
              _expandedSkill = skillName;
            });
          },
          l10n: l10n,
        ),

        const SizedBox(height: 20),

        // Project Management
        SkillCategory(
          categoryTitle: l10n.projectManagement,
          skills: [
            SkillItem(l10n.skillScrum, 3),
            SkillItem(l10n.skillAgile, 4),
            SkillItem(l10n.skillKanban, 1),
          ],
          expandedSkill: _expandedSkill,
          onSkillTap: (skillName) {
            setState(() {
              _expandedSkill = skillName;
            });
          },
          l10n: l10n,
        ),
      ],
    );
  }

  Map<String, List<String>> _getFlutterSubTechnologies(AppLocalizations l10n) {
    return {
      l10n.stateManagement: [
        l10n.skillRiverpod,
        l10n.skillProvider,
        l10n.skillGetX,
        l10n.skillBloc,
      ],
      l10n.codeGeneration: [l10n.skillHooks, l10n.skillFreezed],
      l10n.nativeIntegration: [l10n.skillPlatformChannels, l10n.skillRest],
      l10n.databases: [
        l10n.skillIsarDatabase,
        l10n.skillSqlLite,
        l10n.skillFirebase,
      ],
      l10n.analyticsMonitoring: [
        l10n.skillFirebaseAnalytics,
        l10n.skillFirebaseCrashlytics,
      ],
      l10n.developmentTools: [l10n.skillMason],
    };
  }
}
