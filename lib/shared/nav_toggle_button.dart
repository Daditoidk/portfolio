import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/navigation/route_names.dart';

class NavToggleButton extends StatelessWidget {
  final bool goLab;

  const NavToggleButton({super.key, required this.goLab});

  @override
  Widget build(BuildContext context) {
    final icon = goLab ? Icons.science : Icons.work;
    final text = goLab ? 'Lab' : 'Portfolio';
    final route = goLab ? RouteNames.lab : RouteNames.portfolio;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          context.go(route);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppTheme.navy, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: AppTheme.navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
