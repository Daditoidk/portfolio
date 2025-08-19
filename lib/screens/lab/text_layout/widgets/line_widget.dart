import 'package:flutter/material.dart';
import '../core/models/line.dart';
import '../core/managers/drag_speed_manager.dart';

/// Widget for displaying and interacting with a single line
class LineWidget extends StatelessWidget {
  final Line line;
  final bool isDragging;
  final VoidCallback? onDragStart;
  final Function(double delta) onDragUpdate;
  final VoidCallback? onDragEnd;
  final Function(double delta, ResizeDirection direction) onResize;
  final double scrollOffset;
  final VoidCallback? onDelete;

  const LineWidget({
    super.key,
    required this.line,
    required this.isDragging,
    this.onDragStart,
    required this.onDragUpdate,
    this.onDragEnd,
    required this.onResize,
    required this.scrollOffset,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final editorCenterX = 100.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final previewEndX = screenWidth.isFinite ? screenWidth - 4 : 800.0;

    return Transform.translate(
      offset: Offset(editorCenterX, line.yPosition - scrollOffset),
      child: GestureDetector(
        onPanStart: (_) => onDragStart?.call(),
        onPanUpdate: (details) {
          // Apply consistent drag speed for line movement
          final adjustedDelta =
              DragSpeedManager.convertViewportDeltaToCanvasDelta(
                details.delta.dy,
                DragType.movement,
              );
          onDragUpdate(adjustedDelta);
        },
        onPanEnd: (_) => onDragEnd?.call(),
        child: MouseRegion(
          cursor: isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: Container(
            width: (previewEndX - editorCenterX).clamp(100.0, double.infinity),
            height: line.height.clamp(20.0, double.infinity),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Stack(
              children: [
                // Line content
                _buildLineContent(),
                // Top resize handle
                _buildResizeHandle(ResizeDirection.top),
                // Bottom resize handle
                _buildResizeHandle(ResizeDirection.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Line ${line.order}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Show detected texts count if any
          if (line.detectedTexts.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Text(
                '${line.detectedTexts.length} texts',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          // Delete button
          GestureDetector(
            onTap: () => _showDeleteConfirmation(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Icon(
                Icons.delete_outline,
                size: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    // This will be handled by the parent widget
    // For now, we'll use a simple callback
    if (onDelete != null) {
      onDelete!();
    }
  }

  Widget _buildResizeHandle(ResizeDirection direction) {
    final isTop = direction == ResizeDirection.top;

    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: 0,
      right: 0,
      height: 8,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: GestureDetector(
          onPanUpdate: (details) {
            // Apply consistent drag speed for line resizing
            final adjustedDelta =
                DragSpeedManager.convertViewportDeltaToCanvasDelta(
                  details.delta.dy,
                  DragType.resize,
                );
            onResize(adjustedDelta, direction);
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                isTop ? Icons.remove : Icons.add,
                size: 12,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
