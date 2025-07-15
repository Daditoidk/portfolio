import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProjectPageArrow extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onPressed;
  const ProjectPageArrow({
    required this.isLeft,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? 10 : null,
      right: isLeft ? null : 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(
                isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              ),
              padding: isLeft ? EdgeInsets.only(left: 10) : EdgeInsets.zero,
              iconSize: 32,
              color: AppTheme.navy,
              splashRadius: 24,
              alignment: Alignment.center,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
