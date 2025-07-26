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
    this.backgroundColor = const Color(0xFFFFEB3B),
    this.borderColor = Colors.black,
    this.borderWidth = 3.0,
    this.iconColor = Colors.black,
    this.iconSize = 36.0,
    this.buttonSize = 56.0,
    this.boxShadow = const [
      BoxShadow(color: Color(0x660000FF), blurRadius: 8, spreadRadius: 2),
    ],
  });
}

const defaultAccessibilityMenuTheme = AccessibilityMenuTheme(
  backgroundColor: Color(0xFFFFEB3B),
  borderColor: Colors.black,
  borderWidth: 3.0,
  iconColor: Colors.black,
  iconSize: 36.0,
  buttonSize: 56.0,
  boxShadow: [
    BoxShadow(color: Color(0x660000FF), blurRadius: 8, spreadRadius: 2),
  ],
);
