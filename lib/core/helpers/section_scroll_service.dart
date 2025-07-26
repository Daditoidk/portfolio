import 'package:flutter/material.dart';

/// A service to handle section scrolling logic across the app
class SectionScrollService {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final Map<String, GlobalKey>? subSectionKeys;

  const SectionScrollService({
    required this.scrollController,
    required this.sectionKeys,
    this.subSectionKeys,
  });

  /// Scroll to a specific section or subsection
  void scrollToSection(
    String sectionId, {
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeInOut,
    double alignment = 0.0,
  }) {
    try {
      // First try to find the section in main section keys
      final mainKey = sectionKeys[sectionId];
      if (mainKey?.currentContext != null) {
        Scrollable.ensureVisible(
          mainKey!.currentContext!,
          duration: duration,
          curve: curve,
          alignment: alignment,
        );
        return;
      }

      // If not found in main keys, try sub-section keys
      if (subSectionKeys != null) {
        final subKey = subSectionKeys![sectionId];
        if (subKey?.currentContext != null) {
          Scrollable.ensureVisible(
            subKey!.currentContext!,
            duration: duration,
            curve: curve,
            alignment: alignment,
          );
          return;
        }
      }

      // If still not found, try to find a parent section
      final parentSection = _findParentSection(sectionId);
      if (parentSection != null) {
        final parentKey = sectionKeys[parentSection];
        if (parentKey?.currentContext != null) {
          Scrollable.ensureVisible(
            parentKey!.currentContext!,
            duration: duration,
            curve: curve,
            alignment: alignment,
          );
          return;
        }
      }

      debugPrint('Section not found: $sectionId');
    } catch (e) {
      debugPrint('Error scrolling to section: $e');
    }
  }

  /// Find the parent section for a subsection
  String? _findParentSection(String sectionId) {
    // Map subsections to their parent sections
    final subsectionMap = {
      // About section subsections
      'about-title': 'about',
      'about-description': 'about',
      'about-subtitle': 'about',

      // Skills section subsections
      'skills-title': 'skills',
      'skills-description': 'skills',
      'programming-languages': 'skills',
      'design-animation': 'skills',
      'editors-tools': 'skills',
      'devops-cicd': 'skills',
      'project-management': 'skills',

      // Resume section subsections
      'resume-title': 'resume',
      'resume-description': 'resume',
      'download-resume': 'resume',
      'last-updated': 'resume',

      // Header section subsections
      'navigation': 'home',
      'profile': 'home',
      'name': 'home',
      'title': 'home',
      'description': 'home',

      // Projects section subsections
      'projects-title': 'projects',
      'projects-description': 'projects',
      'project-b4s': 'projects',
      'project-ecommerce': 'projects',
      'project-social': 'projects',
      'project-weather': 'projects',
      'project-music': 'projects',
      'project-task': 'projects',
      'project-fitness': 'projects',

      // Contact section subsections
      'contact-title': 'contact',
      'contact-description': 'contact',
      'contact-info': 'contact',
      'social-links': 'contact',
    };

    return subsectionMap[sectionId];
  }

  /// Get the current section based on scroll position
  String getCurrentSection(BuildContext context) {
    final scrollPosition = scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerOfScreen = scrollPosition + screenHeight / 2;

    String currentSection = 'home';
    double minDistance = double.infinity;

    sectionKeys.forEach((section, key) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position =
            box.localToGlobal(Offset.zero, ancestor: null).dy + scrollPosition;
        final sectionHeight = box.size.height;
        final sectionCenter = position + sectionHeight / 2;
        final distance = (centerOfScreen - sectionCenter).abs();

        if (distance < minDistance) {
          minDistance = distance;
          currentSection = section;
        }
      }
    });

    return currentSection;
  }

  /// Check if sticky navigation should be shown
  bool shouldShowStickyNav(BuildContext context) {
    final scrollPosition = scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;
    return scrollPosition > screenHeight * 0.3;
  }
}
