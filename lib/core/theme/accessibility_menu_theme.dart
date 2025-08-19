import 'package:flutter/material.dart';

class AccessibilityMenuTheme {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color iconColor;
  final double iconSize;
  final double buttonSize;
  final List<BoxShadow> boxShadow;

  const AccessibilityMenuTheme({
    this.backgroundColor = const Color(0xFF1A1A2E), // Navy background
    this.borderColor = const Color(0xFF3B82F6), // Blue border
    this.borderWidth = 2.0,
    this.iconColor = Colors.white,
    this.iconSize = 36.0,
    this.buttonSize = 56.0,
    this.boxShadow = const [
      BoxShadow(color: Color(0x1A000000), blurRadius: 8, spreadRadius: 2),
    ],
  });
}

const defaultAccessibilityMenuTheme = AccessibilityMenuTheme(
  backgroundColor: Color(0xFF1A1A2E), // Navy background
  borderColor: Color(0xFF3B82F6), // Blue border
  borderWidth: 2.0,
  iconColor: Colors.white,
  iconSize: 36.0,
  buttonSize: 56.0,
  boxShadow: [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, spreadRadius: 2),
  ],
);
