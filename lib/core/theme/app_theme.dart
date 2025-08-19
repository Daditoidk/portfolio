import 'package:flutter/material.dart';

class AppTheme {
  // Custom Color Palette - White-based theme with subtle variations
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure white
  static const Color warmWhite = Color(0xFFFEFEFE); // Slightly warm white
  static const Color coolWhite = Color(0xFFFDFDFD); // Slightly cool white
  static const Color softWhite = Color(0xFFFCFCFC); // Very soft white
  static const Color creamWhite = Color(0xFFFBFBFB); // Cream white
  static const Color pearlWhite = Color(0xFFFAFAFA); // Pearl white
  static const Color ivoryWhite = Color(0xFFF9F9F9); // Ivory white

  // Accent colors for contrast
  static const Color navy = Color(0xFF1A1A2E); // Dark navy for text and accents
  static const Color darkGray = Color(
    0xFF2D2D2D,
  ); // Dark gray for secondary text
  static const Color mediumGray = Color(
    0xFF666666,
  ); // Medium gray for tertiary text
  static const Color lightGray = Color(0xFFE0E0E0); // Light gray for borders
  static const Color accentBlue = Color(
    0xFF3B82F6,
  ); // Blue accent for links and buttons

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: navy, // Main accent
        onPrimary: pureWhite, // Text/icons on primary
        secondary: accentBlue, // Secondary accent
        onSecondary: pureWhite,
        surface: pureWhite, // Main background
        onSurface: navy, // Text on background
        error: Color(0xFFDC2626), // Error color
        onError: pureWhite,
        outline: lightGray, // Borders
        outlineVariant: Color(0xFFF0F0F0), // Subtle borders
      ),
      scaffoldBackgroundColor: pureWhite,
      cardTheme: CardThemeData(
        color: pureWhite,
        elevation: 2,
        shadowColor: navy.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: navy,
        foregroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: pureWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: accentBlue),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: navy,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: navy, fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: navy, fontWeight: FontWeight.w600
        ),
        titleSmall: TextStyle(color: navy, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: darkGray),
        bodyMedium: TextStyle(color: darkGray),
        bodySmall: TextStyle(color: mediumGray),
        labelLarge: TextStyle(color: navy, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: navy, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: navy, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Section Background Colors - Different whites for each section
  static const Color headerBackground =
      pureWhite; // Header section - Pure white
  static const Color aboutBackground = warmWhite; // About section - Warm white
  static const Color projectsBackground =
      coolWhite; // Projects section - Cool white
  static const Color labBackground = softWhite; // Lab section - Soft white
  static const Color contactBackground =
      creamWhite; // Contact section - Cream white

  // Sticky Bar Colors (match section backgrounds)
  static const Color stickyNavHeader = pureWhite;
  static const Color stickyNavAbout = warmWhite;
  static const Color stickyNavProjects = coolWhite;
  static const Color stickyNavLab = softWhite;
  static const Color stickyNavContact = creamWhite;

  // Card Colors
  static const Color cardBackground = pureWhite;
  static const Color cardBorder = lightGray;
  static const Color cardShadow = Color(0x0A000000); // Very subtle shadow

  // Navigation Colors
  static const Color navActive = navy;
  static const Color navInactive = mediumGray;
  static const Color navIndicator = accentBlue;

  // Icon Colors
  static const Color primaryIcon = navy;
  static const Color secondaryIcon = accentBlue;
  static const Color avatarBackground = navy;
  static const Color avatarIcon = pureWhite;

  // Button Colors
  static const Color primaryButton = navy;
  static const Color primaryButtonText = pureWhite;
  static const Color secondaryButton = accentBlue;
  static const Color secondaryButtonText = pureWhite;

  // Additional common colors
  static const Color black = Colors.black;
  static const Color white = pureWhite;
  static const Color red = Color(0xFFDC2626); // For errors or warnings
  static const Color green = Color(0xFF10B981); // For success states
  static const Color yellow = Color(0xFFF59E0B); // For warnings

  // --- Aliases for backward compatibility ---
  static const Color brown = navy;
  static const Color blue = accentBlue;
  static const Color cream = creamWhite;
  static const Color beige = warmWhite;
  // You can add more aliases as needed for other old color names
}
