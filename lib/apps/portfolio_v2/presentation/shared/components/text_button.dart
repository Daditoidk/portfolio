import 'package:flutter/material.dart';
import '../../theme/portfolio_theme.dart';

/// Custom text button with underline and arrow
/// Similar to "Get my cv" with orange underline and arrow
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? underlineColor;
  final Color? arrowColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? underlineThickness;
  final double? arrowSize;
  final double? spacing;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.underlineColor,
    this.arrowSize,
    this.fontSize,
    this.fontWeight,
    this.underlineThickness,
    this.spacing,
  }) : arrowColor = textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? PortfolioTheme.orangeColor;
    final effectiveUnderlineColor =
        underlineColor ?? PortfolioTheme.orangeColor;
    final effectiveArrowColor = arrowColor ?? PortfolioTheme.orangeColor;
    final effectiveFontSize = fontSize ?? 16;
    final effectiveFontWeight = fontWeight ?? FontWeight.w400;
    final effectiveUnderlineThickness = underlineThickness ?? 1.0;
    final effectiveArrowSize = arrowSize ?? 16;
    final effectiveSpacing = spacing ?? 8;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text and arrow row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: effectiveFontSize,
                    fontWeight: effectiveFontWeight,
                    fontFamily: 'Manrope',
                  ),
                ),
                SizedBox(width: effectiveSpacing),
                Icon(
                  Icons.arrow_forward,
                  color: effectiveArrowColor,
                  size: effectiveArrowSize,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Underline
            Container(
              height: effectiveUnderlineThickness,
              width: _calculateUnderlineWidth(
                text,
                effectiveFontSize,
                effectiveSpacing,
                effectiveArrowSize,
              ),
              color: effectiveUnderlineColor,
            ),
          ],
        ),
      ),
      ),
    );
  }

  double _calculateUnderlineWidth(
    String text,
    double fontSize,
    double spacing,
    double arrowSize,
  ) {
    // Approximate calculation for underline width
    // This is a rough estimation - you might want to use TextPainter for more accuracy
    double textWidth =
        text.length * (fontSize * 0.6); // Rough character width estimation
    return textWidth + spacing + arrowSize;
  }
}

/// Predefined button for "Get my cv" style
class GetMyCvButton extends StatelessWidget {
  final VoidCallback? onTap;

  const GetMyCvButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      text: 'Get my cv',
      onTap: onTap,
      textColor: PortfolioTheme.orangeColor,
      underlineColor: PortfolioTheme.orangeColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      underlineThickness: 1.0,
      arrowSize: 16,
      spacing: 8,
    );
  }
}

/// Alternative version with more precise underline calculation
class PreciseTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? underlineColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? underlineThickness;
  final double? arrowSize;
  final double? spacing;

  const PreciseTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.underlineColor,
    this.fontSize,
    this.fontWeight,
    this.underlineThickness,
    this.arrowSize,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? PortfolioTheme.orangeColor;
    final effectiveUnderlineColor =
        underlineColor ?? PortfolioTheme.orangeColor;
    final effectiveFontSize = fontSize ?? 16;
    final effectiveFontWeight = fontWeight ?? FontWeight.w400;
    final effectiveUnderlineThickness = underlineThickness ?? 1.0;
    final effectiveArrowSize = arrowSize ?? 16;
    final effectiveSpacing = spacing ?? 8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text and arrow row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: effectiveFontSize,
                    fontWeight: effectiveFontWeight,
                    fontFamily: 'Manrope',
                  ),
                ),
                SizedBox(width: effectiveSpacing),
                Icon(
                  Icons.arrow_forward,
                  color: effectiveTextColor,
                  size: effectiveArrowSize,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Precise underline using LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: effectiveUnderlineThickness,
                  width: constraints.maxWidth,
                  color: effectiveUnderlineColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
