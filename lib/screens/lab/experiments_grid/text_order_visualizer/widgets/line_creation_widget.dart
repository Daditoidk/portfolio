import 'package:flutter/material.dart';
import '../core/models/line.dart';
import '../core/models/line_manager.dart';

/// Widget for showing line creation preview
class LineCreationWidget extends StatelessWidget {
  final Offset? lineStartPosition;
  final Offset? lineEndPosition;
  final List<Line> lines;
  final double scrollOffset;

  const LineCreationWidget({
    super.key,
    this.lineStartPosition,
    required this.lineEndPosition,
    required this.lines,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (lineStartPosition == null || lineEndPosition == null) {
      return const SizedBox.shrink();
    }

    // Calculate line position: from center of editor to end of preview
    final editorCenterX = 100.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final previewEndX = screenWidth.isFinite ? screenWidth - 4 : 800.0;

    // Use the end position and subtract inner scroll to align visually
    final yPosition = lineEndPosition!.dy - scrollOffset;

    // Calculate what the line number would be at this position
    final potentialLineNumber = LineManager.calculateLineNumberAtPosition(
      lineEndPosition!.dy,
      lines,
    );

    return Transform.translate(
      offset: Offset(editorCenterX, yPosition),
      child: Container(
        width: (previewEndX - editorCenterX).clamp(100.0, double.infinity),
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.red.withValues(alpha: 0.8),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Line $potentialLineNumber',
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
