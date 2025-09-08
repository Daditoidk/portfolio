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
  double get scrollOffset {
    try {
      return scrollController.hasClients ? scrollController.offset : 0.0;
    } catch (e) {
      // Controller might be disposed
      return 0.0;
    }
  }

  /// Check if scroll controller has clients
  bool get hasClients {
    try {
      return scrollController.hasClients;
    } catch (e) {
      // Controller might be disposed
      return false;
    }
  }

  /// Handle pointer scroll events and forward to scroll controller
  void handlePointerScroll(PointerScrollEvent event) {
    try {
      if (scrollController.hasClients) {
        final maxExtent = scrollController.position.maxScrollExtent;
        final target = (scrollController.offset + event.scrollDelta.dy).clamp(
          0.0,
          maxExtent,
        );
        scrollController.jumpTo(target);
      }
    } catch (e) {
      // Controller might be disposed
      print('ScrollManager: Controller disposed, ignoring scroll event');
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
    try {
      if (scrollController.hasClients) {
        scrollController.dispose();
      }
    } catch (e) {
      // Controller might already be disposed
      print('ScrollManager: Controller already disposed');
    }
  }
}
