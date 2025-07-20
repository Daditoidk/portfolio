import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

class ActiveBadge extends StatelessWidget {
  final AppLocalizations l10n;

  const ActiveBadge({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: l10n.activeTooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          l10n.currentlyUsing,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
