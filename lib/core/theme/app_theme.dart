import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Palette (updated to exact colors from the 3 squares)
  static const Color veryDarkRed = Color(
    0xFF240046,
  ); // #240046 - Square 1 top-left
  static const Color darkRed = Color(
    0xFF3C096C,
  ); // #3C096C - Square 1 bottom-right
  static const Color deepRed = Color(0xFF5A189A); // #5A189A - Square 2 top-left
  static const Color red = Color(0xFF7B2CBF); // #7B2CBF - Square 2 bottom-right
  static const Color lightRed = Color(
    0xFF9D4EDD,
  ); // #9D4EDD - Square 3 top-left
  static const Color softPink = Color(0xFFC77DFF); // #C77DFF - Square 3 middle
  static const Color palePink = Color(
    0xFFE0AAFF,
  ); // #E0AAFF - Square 3 bottom-right

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: red, // Main accent
        onPrimary: Colors.white, // Text/icons on primary
        secondary: lightRed, // Secondary accent
        onSecondary: Colors.white,
        surface: palePink, // Main background
        onSurface: veryDarkRed, // Text on background
        error: deepRed, // Error color
        onError: Colors.white,
        outline: softPink, // Borders
        outlineVariant: palePink, // Subtle borders
      ),
      scaffoldBackgroundColor: palePink,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: veryDarkRed.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: red,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: red),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: veryDarkRed,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: veryDarkRed, fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: veryDarkRed, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: veryDarkRed, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: veryDarkRed),
        bodyMedium: TextStyle(color: veryDarkRed),
        bodySmall: TextStyle(color: veryDarkRed),
        labelLarge: TextStyle(color: veryDarkRed, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: veryDarkRed, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: veryDarkRed,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Section Background Colors (unique for each section)
  static const Color headerBackground = palePink; // Header section
  static const Color aboutBackground = softPink; // About section
  static const Color projectsBackground = lightRed; // Projects section
  static const Color labBackground = red; // Lab section
  static const Color contactBackground = deepRed; // Contact section/accent

  // Sticky Bar Colors (match section backgrounds)
  static const Color stickyNavHeader = palePink;
  static const Color stickyNavAbout = softPink;
  static const Color stickyNavProjects = lightRed;
  static const Color stickyNavLab = red;
  static const Color stickyNavContact = deepRed;

  // Card Colors
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = veryDarkRed;
  static const Color cardShadow = Color(0x22000000); // semi-transparent black

  // Navigation Colors
  static const Color navActive = red;
  static const Color navInactive = deepRed;
  static const Color navIndicator = lightRed;

  // Icon Colors
  static const Color primaryIcon = red;
  static const Color secondaryIcon = lightRed;
  static const Color avatarBackground = deepRed;
  static const Color avatarIcon = Colors.white;

  // Button Colors
  static const Color primaryButton = red;
  static const Color primaryButtonText = Colors.white;
  static const Color secondaryButton = lightRed;
  static const Color secondaryButtonText = Colors.white;

  // Additional common colors
  static const Color black = Colors.black;
  static const Color red200 = Color(0xFFEF9A9A); // Material Red 200
  static const Color white200 = Color(0xFFEEEEEE); // Material White 200

  // --- Aliases for backward compatibility ---
  static const Color navy = veryDarkRed;
  static const Color brown = red;
  static const Color green = deepRed;
  static const Color blue = darkRed;
  static const Color cream = palePink;
  static const Color beige = softPink;
  // You can add more aliases as needed for other old color names
}
