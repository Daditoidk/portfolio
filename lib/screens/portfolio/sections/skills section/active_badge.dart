import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../widgets/accessibility floating button/widgets/accessible_text.dart';
import '../../../../widgets/accessibility floating button/widgets/accessible_tooltip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveBadge extends ConsumerWidget {
  final AppLocalizations l10n;

  const ActiveBadge({super.key, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccessibleTooltip(
      message: l10n.activeTooltip,
      baseFontSize: 12,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(8),
        ),
        child: AccessibleText(
          l10n.currentlyUsing,
          baseFontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
