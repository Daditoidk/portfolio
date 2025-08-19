import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Manages scroll behavior and coordinates for the text layout editor
class ScrollManager {
  final ScrollController scrollController;
  final VoidCallback? onScrollChanged;

  ScrollManager({required this.scrollController, this.onScrollChanged}) {
    scrollController.addListener(() {
      onScrollChanged?.call();
    });
  }

  /// Get current scroll offset safely
  double get scrollOffset =>
      scrollController.hasClients ? scrollController.offset : 0.0;

  /// Check if scroll controller has clients
  bool get hasClients => scrollController.hasClients;

  /// Handle pointer scroll events and forward to scroll controller
  void handlePointerScroll(PointerScrollEvent event) {
    if (scrollController.hasClients) {
      final maxExtent = scrollController.position.maxScrollExtent;
      final target = (scrollController.offset + event.scrollDelta.dy).clamp(
        0.0,
        maxExtent,
      );
      scrollController.jumpTo(target);
    }
  }

  /// Calculate canvas height based on portfolio height and viewport
  double calculateCanvasHeight(
    double portfolioHeight,
    double screenHeight,
    double appBarHeight,
  ) {
    final availableHeight = screenHeight - appBarHeight;
    return portfolioHeight > availableHeight
        ? portfolioHeight
        : availableHeight;
  }

  /// Convert global position to absolute canvas position
  double convertGlobalToCanvasPosition(double globalY, double appBarHeight) {
    return globalY - appBarHeight;
  }

  /// Dispose the scroll controller
  void dispose() {
    scrollController.dispose();
  }
}
