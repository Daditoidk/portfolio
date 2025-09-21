import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/portfolio_theme.dart';
import '../../providers/scroll_providers.dart';

class CustomNavBarPortfolioV2 extends ConsumerWidget {
  const CustomNavBarPortfolioV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(currentSectionProvider);
    final scrollService = ref.watch(sectionScrollServiceProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: PortfolioTheme.bgColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PortfolioTheme.orangeColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem(
            label: 'Home',
            isActive: currentSection == 'home',
            onTap: () => scrollService.scrollToSection('home'),
          ),
          const SizedBox(width: 20),
          _buildNavItem(
            label: 'About',
            isActive: currentSection == 'about',
            onTap: () => scrollService.scrollToSection('about'),
          ),
          const SizedBox(width: 20),
          _buildNavItem(
            label: 'Skills',
            isActive: currentSection == 'skills',
            onTap: () => scrollService.scrollToSection('skills'),
          ),
          const SizedBox(width: 20),
          _buildNavItem(
            label: 'Projects',
            isActive: currentSection == 'projects',
            onTap: () => scrollService.scrollToSection('projects'),
          ),
          const SizedBox(width: 20),
          _buildNavItem(
            label: 'Contact',
            isActive: currentSection == 'contact',
            onTap: () => scrollService.scrollToSection('contact'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: PortfolioTheme.manropeRegular16.copyWith(
            color: PortfolioTheme.grayColor,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}
