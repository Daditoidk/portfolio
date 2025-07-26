import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../widgets/accessibility floating button/widgets/accessible_text.dart';
import '../../../../widgets/accessibility floating button/widgets/accessible_tooltip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExperienceBadge extends ConsumerWidget {
  final int years;
  final AppLocalizations l10n;

  const ExperienceBadge({super.key, required this.years, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color badgeColor;
    Color textColor;

    if (years == 1) {
      // Bronze for 1 year or less
      badgeColor = const Color(0xFFCD7F32);
      textColor = Colors.white;
    } else if (years <= 3) {
      // Silver for 2-3 years
      badgeColor = const Color(0xFFC0C0C0);
      textColor = Colors.black87;
    } else {
      // Gold for 4+ years
      badgeColor = const Color(0xFFFFD700);
      textColor = Colors.black87;
    }

    final tooltipMessage = years == 1
        ? l10n.experienceTooltipOneYear
        : l10n.experienceTooltipYears(years.toString());

    return AccessibleTooltip(
      message: tooltipMessage,
      baseFontSize: 12,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: AccessibleText(
          '$years',
          baseFontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
