import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/section_scroll_service.dart';

/// Provides a single ScrollController for the Portfolio V2 page
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Provides GlobalKeys for the main sections on the page
final sectionKeysProvider = Provider<Map<String, GlobalKey>>((ref) {
  return {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };
});

/// Provides the SectionScrollService configured with controller and keys
final sectionScrollServiceProvider = Provider<SectionScrollService>((ref) {
  final controller = ref.read(scrollControllerProvider);
  final keys = ref.read(sectionKeysProvider);
  return SectionScrollService(scrollController: controller, sectionKeys: keys);
});

/// Holds the id of the currently active section to highlight nav items
final currentSectionProvider = StateProvider<String>((ref) => 'home');
