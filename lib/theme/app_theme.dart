import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Palette
  static const Color cream = Color(0xFFF0EAD2);
  static const Color lightGreen = Color(0xFFDDE5B6);
  static const Color green = Color(0xFFADC178);
  static const Color brown = Color(0xFFA98467);
  static const Color darkBrown = Color(0xFF6C584C);

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: brown,
        surface: cream,
        onPrimary: darkBrown,
        onSecondary: cream,
        onSurface: darkBrown,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        headlineMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkBrown,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkBrown,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: darkBrown),
        bodyMedium: TextStyle(fontSize: 16, color: darkBrown),
        bodySmall: TextStyle(fontSize: 14, color: darkBrown),
      ),
    );
  }

  // Section Background Colors
  static const Color headerBackground = lightGreen;
  static const Color aboutBackground = cream;
  static const Color projectsBackground = lightGreen;
  static const Color labBackground = cream;
  static const Color contactBackground = cream;

  // Card Colors
  static const Color cardBackground = cream;
  static const Color cardBorder = brown;
  static const Color cardShadow = Color(0xFFE0E0E0);

  // Navigation Colors
  static const Color navActive = darkBrown;
  static const Color navInactive = brown;
  static const Color navIndicator = green;
  static const Color stickyNavBackground = Color(0xFFF8F8F8);

  // Icon Colors
  static const Color primaryIcon = green;
  static const Color secondaryIcon = brown;
  static const Color avatarBackground = green;
  static const Color avatarIcon = cream;

  // Button Colors
  static const Color primaryButton = green;
  static const Color primaryButtonText = cream;
  static const Color secondaryButton = brown;
  static const Color secondaryButtonText = cream;
}
