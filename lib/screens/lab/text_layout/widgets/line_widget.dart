import 'package:flutter/material.dart';
import '../core/models/line.dart';
import '../core/managers/drag_speed_manager.dart';
import '../core/scanners/live_preview_text_scanner.dart';

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
  final bool isDetectionEnabled;
  final double? availableWidth;
  final bool isSelected;
  final VoidCallback? onToggleSelection;

  const LineWidget({
    super.key,
    required this.line,
    required this.isDragging,
    this.onDragStart,
    required this.onDragUpdate,
    this.onDragEnd,
    required this.onResize,
    this.onDelete,
    required this.scrollOffset,
    this.isDetectionEnabled = false,
    this.availableWidth,
    this.isSelected = false,
    this.onToggleSelection,
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
              color: isSelected
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.red,
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Stack(
              children: [
                // Line content
                _buildLineContent(),
                // Y range indicator (only show when detection is enabled)

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
    return Row(
      children: [
        // Left side: Text and delete button (100px total width)
        Container(
          width: 100,
          padding: const EdgeInsets.only(left: 2, right: 6),
          child: Row(
            children: [
              // Line number and selection
              GestureDetector(
                onTap: onToggleSelection,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 14,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'L${line.order}',
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Show detected texts count if any
              if (line.detectedTexts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: Text(
                    '${line.detectedTexts.length}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              // Delete button
              GestureDetector(
                onTap: () => _showDeleteConfirmation(),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right side: Detected text coordinates overlay (only show when detection is active)
        Expanded(
          child: Stack(
            children: [
              _buildTextCoordinatesOverlay(),
              // Y range indicator on the right side (only show when detection is active)
              if (isDetectionEnabled)
                Positioned(right: 8, top: 4, child: _buildYRangeIndicator()),
              // Debug tooltip on the right side
              Positioned(
                right: 8,
                top: 40,
                child: Tooltip(
                  message: _buildLineDebugTooltip(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    // This will be handled by the parent widget
    // For now, we'll use a simple callback
    if (onDelete != null) {
      onDelete!();
    }
  }

  /// Build debug tooltip showing line range and detected texts
  String _buildLineDebugTooltip() {
    final lineTop = line.yPosition;
    final lineBottom = line.yPosition + line.height;

    String tooltip = 'L${line.order} Debug Info:\n';
    tooltip += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
    tooltip += '📏 Line Range:\n';
    tooltip += '   Y Top: ${lineTop.toStringAsFixed(1)}\n';
    tooltip += '   Y Bottom: ${lineBottom.toStringAsFixed(1)}\n';
    tooltip += '   Height: ${line.height.toStringAsFixed(1)}\n';
    tooltip += '   Width: ${line.xPosition.toStringAsFixed(1)}\n\n';

    if (line.detectedTexts.isNotEmpty) {
      tooltip += '📝 Detected Texts (${line.detectedTexts.length}):\n';
      for (int i = 0; i < line.detectedTexts.length; i++) {
        final text = line.detectedTexts[i];
        final textY = text['y'] as double? ?? 0.0;
        final textX = text['x'] as double? ?? 0.0;
        final textId = text['id'] as String? ?? 'unknown';
        final textContent = text['text'] as String? ?? 'unknown';

        tooltip += '   ${i + 1}. "$textContent"\n';
        tooltip += '      ID: $textId\n';
        tooltip +=
            '      Position (Viewport): X=${textX.toStringAsFixed(1)}, Y=${textY.toStringAsFixed(1)}\n';

        // Get absolute coordinates if available
        final textYAbsolute = text['yAbsolute'] as double?;
        final textXAbsolute = text['xAbsolute'] as double?;
        if (textYAbsolute != null && textXAbsolute != null) {
          tooltip +=
              '      Position (Absolute): X=${textXAbsolute.toStringAsFixed(1)}, Y=${textYAbsolute.toStringAsFixed(1)}\n';
        }

        // Check if text is within line bounds (using viewport coordinates for UI)
        if (textY >= lineTop && textY <= lineBottom) {
          tooltip += '      ✅ Within line bounds (Viewport)\n';
        } else {
          tooltip += '      ❌ OUTSIDE line bounds (Viewport)!\n';
          tooltip +=
              '         Distance from line: ${(textY - lineTop).abs().toStringAsFixed(1)}px\n';
        }
        tooltip += '\n';
      }
    } else {
      tooltip += '📝 No texts detected in this line\n';
    }

    tooltip +=
        '🔍 Detection Status: ${isDetectionEnabled ? "Enabled" : "Disabled"}';

    return tooltip;
  }

  /// Build Y range indicator showing the line's Y bounds
  Widget _buildYRangeIndicator() {
    final appBarHeight = LivePreviewTextScanner.getAppBarHeight();
    final viewportYTop = line.yPosition - appBarHeight;
    final viewportYBottom = (line.yPosition + line.height) - appBarHeight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'V: ${viewportYTop.toStringAsFixed(0)}-${viewportYBottom.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'A: ${line.yPosition.toStringAsFixed(0)}-${(line.yPosition + line.height).toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the overlay showing detected text coordinates
  Widget _buildTextCoordinatesOverlay() {
    // Use provided available width or fallback to fixed width
    final overlayWidth = availableWidth ?? 800.0;

    // Don't show anything if detection is not enabled
    if (!isDetectionEnabled) {
      return Container(
        height: line.height,
        width: availableWidth,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      );
    }

    if (line.detectedTexts.isEmpty) {
      return Container(
        height: line.height,
        width: availableWidth,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Text(
            'No texts detected',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      );
    }

    return Container(
      height: line.height,
      width: availableWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Stack(
        children: line.detectedTexts.asMap().entries.map((entry) {
          final index = entry.key;
          final textData = entry.value;

          // Use viewport coordinates for positioning
          final textY = (textData['y'] as double?) ?? 0.0;
          final textX = (textData['x'] as double?) ?? 0.0;
          final lineTop = line.yPosition;
          final relativeY = textY - lineTop;

          // Ensure the box is within the line bounds
          final clampedY = relativeY.clamp(0.0, line.height - 20.0);

          // Calculate X position within the available width
          // Map the viewport X coordinate to the available overlay width
          final viewportX = textX;
          // Use a reasonable screen width for calculation (will be dynamic in future)
          final screenWidth = 1200.0; // Approximate screen width
          final overlayX = (viewportX / screenWidth) * overlayWidth;
          final clampedX = overlayX.clamp(
            8.0,
            overlayWidth - 28.0,
          ); // 8px left margin, 28px for box width

          // Create detailed tooltip content
          final tooltipContent =
              'Text ${index + 1}:\n'
              '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
              '📝 Content: "${textData['text']}"\n'
              '🆔 ID: ${textData['id']}\n'
              '📍 Viewport Position (UI):\n'
              '   X: ${textX.toStringAsFixed(1)}\n'
              '   Y: ${textY.toStringAsFixed(1)}\n'
              '📍 Absolute Position (Page):\n'
              '   X: ${(textData['xAbsolute'] as double?)?.toStringAsFixed(1) ?? 'N/A'}\n'
              '   Y: ${(textData['yAbsolute'] as double?)?.toStringAsFixed(1) ?? 'N/A'}\n'
              '📍 Overlay Position:\n'
              '   X: ${overlayX.toStringAsFixed(1)} (${clampedX.toStringAsFixed(1)})\n'
              '   Y: ${relativeY.toStringAsFixed(1)} (${clampedY.toStringAsFixed(1)})\n'
              '📍 Available Width: ${overlayWidth.toStringAsFixed(1)}px\n'
              '📍 Screen Width (approx): ${screenWidth.toStringAsFixed(1)}px';

          return Positioned(
            left: clampedX,
            top: clampedY,
            child: Tooltip(
              message: tooltipContent,
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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
