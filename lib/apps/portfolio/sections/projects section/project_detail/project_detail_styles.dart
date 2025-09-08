import 'package:flutter/material.dart';

/// Styles for the Project Detail Screen
class ProjectDetailStyles {
  // Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color leftColumnBackground = Colors.transparent;
  static const Color rightColumnBackground = Colors.white;
  static const Color borderColor = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color accentColor = Color(0xFF3498DB);

  // Dimensions
  static const double leftColumnWidthRatio = 0.5 / 3.0; // 0.5/3 of screen width (narrower navigation)
  static const double rightColumnWidthRatio = 2.5 / 3.0; // 2.5/3 of screen width (wider content)
  static const double borderWidth = 1.0;
  static const double borderRadius = 16.0;
  static const double padding = 24.0;
  static const double sectionSpacing = 32.0;

  // Left Column Styles
  static BoxDecoration get leftColumnDecoration => const BoxDecoration(
    color: leftColumnBackground,
  );

  // Right Column Styles
  static BoxDecoration get rightColumnDecoration => BoxDecoration(
    color: rightColumnBackground,
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    border: Border.all(color: borderColor, width: borderWidth),
  );

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    height: 1.3,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  // Navigation Styles
  static const TextStyle navigationTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle navigationItemStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.3,
  );

  static const TextStyle navigationItemActiveStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: accentColor,
    height: 1.3,
  );

  // Section Styles
  static const EdgeInsets sectionPadding = EdgeInsets.all(padding);
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: padding,
    vertical: padding / 2,
  );

  // Responsive breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;

  /// Get responsive column widths based on screen size
  static Map<String, double> getColumnWidths(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      // Mobile: stack vertically
      return {'left': 1.0, 'right': 1.0};
    } else if (screenWidth < tabletBreakpoint) {
      // Tablet: 25% left, 75% right (narrower navigation)
      return {'left': 0.25, 'right': 0.75};
    } else {
      // Desktop: 0.5/3 left, 2.5/3 right (narrower navigation)
      return {'left': leftColumnWidthRatio, 'right': rightColumnWidthRatio};
    }
  }

  /// Get responsive layout type
  static String getLayoutType(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return 'mobile';
    } else if (screenWidth < tabletBreakpoint) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }
}
