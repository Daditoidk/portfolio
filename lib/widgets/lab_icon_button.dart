import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/navigation/route_names.dart';

class LabIconButton extends StatelessWidget {
  const LabIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Go to Lab',
      icon: Icon(Icons.science, color: AppTheme.navy, size: 24),
      onPressed: () {
        context.go(RouteNames.lab);
      },
    );
  }
}
