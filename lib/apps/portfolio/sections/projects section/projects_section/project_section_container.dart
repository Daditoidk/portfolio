import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ProjectSectionContainer extends StatelessWidget {
  final bool isMobile;
  final Widget child;
  const ProjectSectionContainer({
    required this.isMobile,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Container(
        width: double.infinity,
        color: AppTheme.projectsBackground,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: child,
      );
    } else {
      return Container(
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height < 1055
                ? 1055
                : MediaQuery.of(context).size.height,
        color: AppTheme.projectsBackground,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: child,
      );
    }
  }
}
