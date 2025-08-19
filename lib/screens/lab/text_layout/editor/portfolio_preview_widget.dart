import 'package:flutter/material.dart';
import '../../../../screens/portfolio/portfolio_screen.dart';
import '../core/models/text_layout_config.dart';

/// Portfolio preview widget for the visual editor
class PortfolioPreviewWidget extends StatelessWidget {
  final TextLayoutConfig? config;
  final VoidCallback? onSectionTap;
  final ScrollController? scrollController;

  const PortfolioPreviewWidget({
    super.key,
    this.config,
    this.onSectionTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: PortfolioScreen(
        key: const ValueKey('portfolio_preview'),
        scrollController: scrollController,
      ),
    );
  }
}
