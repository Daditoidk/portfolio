import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';

class SkillChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isSelected;

  const SkillChip({
    super.key,
    required this.text,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: PortfolioTheme.grayColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: PortfolioTheme.manropeLight14.copyWith(
            color: PortfolioTheme.bgColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

