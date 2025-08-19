/// Manages consistent drag speed for line operations
class DragSpeedManager {
  /// Default drag sensitivity multiplier
  static const double defaultSensitivity = 1.0;

  /// Drag sensitivity for line creation (from app bar button)
  static const double creationSensitivity = 1.0;

  /// Drag sensitivity for line movement (after line is created)
  static const double movementSensitivity = 1.0;

  /// Drag sensitivity for line resizing
  static const double resizeSensitivity = 1.0;

  /// Apply drag sensitivity to a delta value
  static double applySensitivity(double delta, DragType type) {
    switch (type) {
      case DragType.creation:
        return delta * creationSensitivity;
      case DragType.movement:
        return delta * movementSensitivity;
      case DragType.resize:
        return delta * resizeSensitivity;
    }
  }

  /// Convert viewport delta to absolute canvas delta
  static double convertViewportDeltaToCanvasDelta(
    double viewportDelta,
    DragType type,
  ) {
    return applySensitivity(viewportDelta, type);
  }
}

/// Types of drag operations
enum DragType {
  creation, // Creating a new line from app bar
  movement, // Moving an existing line
  resize, // Resizing a line
}
