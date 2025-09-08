import 'package:flutter/material.dart';
import '../models/line.dart';
import '../models/line_manager.dart';
import '../models/text_order_config.dart';
import 'drag_speed_manager.dart';

/// Manages the state and operations of lines in the text layout editor
class LineStateManager {
  final List<Line> _lines = [];
  final VoidCallback? onLinesChanged;
  double _canvasHeight;

  LineStateManager({this.onLinesChanged, double canvasHeight = 3000.0})
    : _canvasHeight = canvasHeight;

  /// Get all lines
  List<Line> get lines => List.unmodifiable(_lines);

  /// Update canvas height
  void updateCanvasHeight(double newHeight) {
    _canvasHeight = newHeight;
  }

  /// Add a new line
  void addLine(Line line) {
    _lines.add(line);
    LineManager.updateLineNumbers(_lines);
    onLinesChanged?.call();
  }

  /// Update line position
  void updateLinePosition(String lineId, double newY, double dragDirection) {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index == -1) return;

    // Apply consistent drag speed
    final adjustedDelta = DragSpeedManager.convertViewportDeltaToCanvasDelta(
      dragDirection,
      DragType.movement,
    );
    final adjustedY = newY + adjustedDelta;

    // Constrain the new position using the stored canvas height
    final constrainedY = adjustedY.clamp(
      0.0,
      _canvasHeight - _lines[index].height,
    );

    // Apply collision detection to prevent overlapping
    final adjustedLine = _lines[index].copyWith(yPosition: constrainedY);
    final finalLine = LineManager.preventLineOverlap(
      adjustedLine,
      _lines,
      adjustedDelta,
    );

    _lines[index] = finalLine;
    LineManager.updateLineNumbers(_lines);
    onLinesChanged?.call();
  }

  /// Resize line
  void resizeLine(String lineId, double delta, ResizeDirection direction) {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index == -1) return;

    // Apply consistent resize speed
    final adjustedDelta = DragSpeedManager.convertViewportDeltaToCanvasDelta(
      delta,
      DragType.resize,
    );

    final newLine = LineManager.resizeLine(
      _lines[index],
      adjustedDelta,
      direction,
    );

    // Prevent overlap after resize
    final finalLine = LineManager.preventLineOverlap(newLine, _lines, 0.0);

    _lines[index] = finalLine;
    LineManager.updateLineNumbers(_lines);
    onLinesChanged?.call();
  }

  /// Clear all lines
  void clearLines() {
    _lines.clear();
    onLinesChanged?.call();
  }

  /// Get line by ID
  Line? getLineById(String id) {
    try {
      return _lines.firstWhere((line) => line.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update detected texts for a specific line
  void updateLineTexts(
    String lineId,
    List<Map<String, dynamic>> detectedTexts,
  ) {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index == -1) return;

    _lines[index] = _lines[index].copyWith(detectedTexts: detectedTexts);
    onLinesChanged?.call();
  }

  /// Delete a line by ID
  void deleteLine(String lineId) {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index == -1) return;

    _lines.removeAt(index);
    // Update line numbers after deletion
    LineManager.updateLineNumbers(_lines);
    onLinesChanged?.call();
  }

  /// Check if a line is being dragged
  bool isLineDragging(String lineId) =>
      false; // This will be managed by the editor

  /// Convert lines to TextLine format for configuration
  List<TextLine> toTextLines() {
    return _lines
        .map(
          (line) => TextLine(
            order: line.order,
            l10nKeys: line.l10nKeys,
            height: line.height,
            yPosition: line.yPosition,
          ),
        )
        .toList();
  }
}

// Remove this duplicate TextLine class since we'll use the one from text_layout_config.dart
