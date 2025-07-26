import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/navigation/route_names.dart';
import '../core/accessibility/accessibility_floating_button.dart';

class LabIconButton extends StatelessWidget {
  const LabIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AccessibleCustomCursor(
      child: AccessibleTooltip(
        message: 'Go to Lab',
        child: IconButton(
          icon: Icon(Icons.science, color: AppTheme.navy, size: 24),
          onPressed: () {
            context.go(RouteNames.lab);
          },
        ),
      ),
    );
  }
}
