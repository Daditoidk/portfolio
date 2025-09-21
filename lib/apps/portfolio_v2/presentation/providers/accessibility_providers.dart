import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the locale selected via the accessibility menu.
final accessibilityLocaleProvider =
    StateProvider<Locale>((ref) => const Locale('en'));

/// Toggles the visibility of the accessibility side menu.
final isAccessibilityMenuOpenProvider = StateProvider<bool>((ref) => false);
