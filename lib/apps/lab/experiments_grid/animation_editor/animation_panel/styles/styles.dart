import 'package:flutter/material.dart';

// This class centralizes all the typography styles for your animation settings panel.
// By defining them here, you can ensure consistency and make future updates easy.
class AnimationPanelStyles {
  // A const value for spacing to keep the UI consistent.
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 8.0;

  // Defines a base text style for the entire panel.
  // We'll use this as a foundation for other styles.
  static const TextStyle baseTextStyle = TextStyle(
    fontFamily: 'Roboto', // You can change this to your preferred font.
    color: Colors.white70,
  );

  // Style for major titles in the panel.
  static TextStyle title = baseTextStyle.copyWith(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Style for subheadings or section headers.
  static TextStyle subheading = baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
  );

  // Style for dropdown menu options.
  static TextStyle dropdownOption = baseTextStyle.copyWith(fontSize: 12.0);

  // Style for labels next to numbers or sliders.
  static TextStyle label = baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
  );

  // Style for the actual numbers or values in input fields.
  static TextStyle numberValue = baseTextStyle.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Style for the slider label.
  static TextStyle sliderLabel = baseTextStyle.copyWith(
    fontSize: 10.0,
    color: Colors.white54,
  );

  // Style for property names in the panel.
  static TextStyle propertyName = baseTextStyle.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );
}
