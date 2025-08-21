import 'line.dart';

/// Manages line operations, collision detection, and positioning
class LineManager {
  static const double _minHeight = 20.0;
  static const double _maxHeight = 200.0;
  static const double _overlapBuffer = 5.0;
  
  // Static counter to ensure unique IDs
  static int _idCounter = 0;

  /// Resize line height
  static Line resizeLine(Line line, double delta, ResizeDirection direction) {
    double newHeight = line.height;

    if (direction == ResizeDirection.top) {
      newHeight = (line.height - delta).clamp(_minHeight, _maxHeight);
    } else {
      newHeight = (line.height + delta).clamp(_minHeight, _maxHeight);
    }

    return line.copyWith(height: newHeight);
  }

  /// Generate unique ID for new lines
  static String generateId() {
    _idCounter++;
    return 'line_${DateTime.now().millisecondsSinceEpoch}_$_idCounter';
  }

  /// Calculate what line number a position would have based on current line positions
  static int calculateLineNumberAtPosition(
    double yPosition,
    List<Line> allLines,
  ) {
    if (allLines.isEmpty) return 0;

    // Create a temporary list with the potential new line
    final tempLines = List<Line>.from(allLines);
    final tempLine = Line(
      id: 'temp',
      order: 0,
      l10nKeys: [],
      height: 40.0,
      yPosition: yPosition,
    );
    tempLines.add(tempLine);

    // Sort by Y position and find the index
    tempLines.sort((a, b) => a.yPosition.compareTo(b.yPosition));
    final index = tempLines.indexWhere((line) => line.id == 'temp');

    return index;
  }

  /// Update line numbers based on absolute Y position
  static void updateLineNumbers(List<Line> lines) {
    // Sort lines by Y position (0 = top of page, higher Y = lower on page)
    final sortedLines = List<Line>.from(lines);
    sortedLines.sort((a, b) => a.yPosition.compareTo(b.yPosition));

    // Update order numbers based on new positions
    for (int i = 0; i < sortedLines.length; i++) {
      final line = sortedLines[i];
      final index = lines.indexWhere((l) => l.id == line.id);
      if (index != -1) {
        lines[index] = line.copyWith(order: i);
      }
    }
  }

  /// Prevent lines from overlapping by applying smart collision detection
  static Line preventLineOverlap(
    Line line,
    List<Line> allLines,
    double dragDirection,
  ) {
    Line adjustedLine = line;

    for (final otherLine in allLines) {
      if (otherLine.id == line.id) continue;

      // Check if lines would overlap
      if (_wouldOverlap(adjustedLine, otherLine)) {
        // Calculate safe position to avoid overlap
        final safePosition = _calculateSafePosition(
          adjustedLine,
          otherLine,
          dragDirection,
        );
        adjustedLine = adjustedLine.copyWith(yPosition: safePosition);
      }
    }

    return adjustedLine;
  }

  /// Check if two lines would overlap
  static bool _wouldOverlap(Line line1, Line line2) {
    final line1Top = line1.yPosition;
    final line1Bottom = line1.yPosition + line1.height;
    final line2Top = line2.yPosition;
    final line2Bottom = line2.yPosition + line2.height;

    // Check for overlap with a small buffer
    return !(line1Bottom <= line2Top + _overlapBuffer ||
        line1Top + _overlapBuffer >= line2Bottom);
  }

  /// Calculate a safe position to avoid overlap
  static double _calculateSafePosition(
    Line line,
    Line otherLine,
    double dragDirection,
  ) {
    if (dragDirection > 0) {
      // Dragging down - place above the other line
      return otherLine.yPosition - line.height - _overlapBuffer;
    } else if (dragDirection < 0) {
      // Dragging up - place below the other line
      return otherLine.yPosition + otherLine.height + _overlapBuffer;
    } else {
      // No drag direction (resize) - find closest safe position
      final abovePosition = otherLine.yPosition - line.height - _overlapBuffer;
      final belowPosition =
          otherLine.yPosition + otherLine.height + _overlapBuffer;

      // Choose the position that requires less movement
      final currentY = line.yPosition;
      final distanceToAbove = (currentY - abovePosition).abs();
      final distanceToBelow = (currentY - belowPosition).abs();

      return distanceToAbove < distanceToBelow ? abovePosition : belowPosition;
    }
  }
}
