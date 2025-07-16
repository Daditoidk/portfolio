import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Palette (new)
  static const Color darkRed = Color(0xFF780000); // 780000
  static const Color red = Color(0xFFC1121F); // C1121F
  static const Color cream = Color(0xFFFDF0D5); // FDF0D5
  static const Color navy = Color(0xFF003049); // 003049
  static const Color blue = Color(0xFF669BBC); // 669BBC

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: navy, // Main accent
        onPrimary: Colors.white, // Text/icons on primary
        secondary: red, // Secondary accent
        onSecondary: Colors.white,
        surface: cream, // Card backgrounds, surfaces
        onSurface: navy, // App background
        error: red,
        onError: Colors.white,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
        headlineMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: navy,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: navy),
        bodyMedium: TextStyle(fontSize: 16, color: navy),
        bodySmall: TextStyle(fontSize: 14, color: navy),
      ),
    );
  }

  // Section Background Colors (unique for each section)
  static const Color headerBackground = darkRed; // Header section
  static const Color aboutBackground = Colors.white; // About section
  static const Color projectsBackground = blue; // Projects section
  static const Color labBackground = Colors.white; // Lab section
  static const Color contactBackground = red; // Contact section (light red)

  // Sticky Bar Colors (match section backgrounds)
  static const Color stickyNavHeader = cream;
  static const Color stickyNavAbout = Colors.white;
  static const Color stickyNavProjects = blue;
  static const Color stickyNavLab = Colors.white;
  static const Color stickyNavContact = red;

  // Card Colors
  static const Color cardBackground = blue;
  static const Color cardBorder = navy;
  static const Color cardShadow = Color(0x22000000); // semi-transparent black

  // Navigation Colors
  static const Color navActive = navy;
  static const Color navInactive = blue;
  static const Color navIndicator = red;

  // Icon Colors
  static const Color primaryIcon = navy;
  static const Color secondaryIcon = blue;
  static const Color avatarBackground = red;
  static const Color avatarIcon = Colors.white;

  // Button Colors
  static const Color primaryButton = navy;
  static const Color primaryButtonText = Colors.white;
  static const Color secondaryButton = red;
  static const Color secondaryButtonText = Colors.white;
}
