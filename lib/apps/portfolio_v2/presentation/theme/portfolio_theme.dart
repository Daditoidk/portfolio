import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioTheme {
  // Colors
  static const Color bgColor = Color(0xFF2C2C2C);
  static const Color whiteColor = Color(0xFFF5F5F5);
  static const Color orangeColor = Color(0xFFFB6708);
  static const Color grayColor = Color(0xFFECECEC);

  // Manrope Text Styles
  static TextStyle get manropeRegular16 => GoogleFonts.manrope(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: whiteColor,
  );

  static TextStyle get manropeBold16 => GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: whiteColor,
  );

  static TextStyle get manropeRegular24 => GoogleFonts.manrope(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    color: whiteColor,
  );

  static TextStyle get manropeRegular20 => GoogleFonts.manrope(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: whiteColor,
  );

  static TextStyle get manropeSemibold15 => GoogleFonts.manrope(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: whiteColor,
  );

  static TextStyle get manropeLight14 => GoogleFonts.manrope(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    color: whiteColor,
  );

  static TextStyle get manropeBold20 => GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: whiteColor,
  );

  static TextStyle get manropeBold24 => GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: whiteColor,
  );

  static TextStyle get manropeRegular14 => GoogleFonts.manrope(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: whiteColor,
  );

  static TextStyle get manropeExtralight14 => GoogleFonts.manrope(
    fontWeight: FontWeight.w200,
    fontSize: 14,
    color: whiteColor,
  );

  // Monoton Text Styles
  static TextStyle get monotonRegular48 => GoogleFonts.monoton(
    fontWeight: FontWeight.w400,
    fontSize: 48,
    color: grayColor,
  );

  static TextStyle get monotonRegular80 => GoogleFonts.monoton(
    fontWeight: FontWeight.w400,
    fontSize: 80,
    height: 0.89, // 89% line height
    letterSpacing: 0.10, // 10% letter spacing
    color: grayColor,
  );

  static TextStyle get monotonRegular96 => GoogleFonts.monoton(
    fontWeight: FontWeight.w400,
    fontSize: 96,
    height: 0.89, // 89% line height
    color: grayColor,
  );

  static TextStyle get monotonRegular100 => GoogleFonts.monoton(
    fontWeight: FontWeight.w400,
    fontSize: 100,
    letterSpacing: 0.18, // 18% letter spacing
    color: grayColor,
  );

  // Color variations with opacity
  static Color bgColorWithOpacity(double opacity) =>
      bgColor.withValues(alpha: opacity);
  static Color whiteColorWithOpacity(double opacity) =>
      whiteColor.withValues(alpha: opacity);
  static Color orangeColorWithOpacity(double opacity) =>
      orangeColor.withValues(alpha: opacity);
  static Color grayColorWithOpacity(double opacity) =>
      grayColor.withValues(alpha: opacity);

  // Gradient colors
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeColor, Color(0xFFE55A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient createGradient = LinearGradient(
    colors: [
      Color(0xFFFDF99F), // 0% - Light yellow
      Color(0xFFF9E348), // 50% - Bright yellow
      Color(0xFFF0B321), // 75% - Golden yellow
      Color(0xFFFF7F02), // 88% - Orange
      Color(0xFFFB6708), // 100% - Dark orange
    ],
    stops: [0.0, 0.5, 0.75, 0.88, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient grayGradient = LinearGradient(
    colors: [grayColor, Color(0xFFD0D0D0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow colors
  static const Color shadowColor = Color(0x40000000); // 25% opacity black
  static const Color lightShadowColor = Color(
    0x20000000,
  ); // 12.5% opacity black

  // Border colors
  static const Color borderColor = Color(0xFF404040);
  static const Color lightBorderColor = Color(0xFF505050);
}
