import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/animations/text_animation_registry.dart';
import '../core/integration/text_layout_integration.dart';
import '../core/models/text_layout_config.dart';
import '../core/scanners/live_preview_text_scanner.dart';
import 'portfolio_preview_widget.dart';
import '../core/models/line.dart';
import '../core/models/line_manager.dart';
import '../core/managers/line_state_manager.dart';
import '../core/managers/scroll_manager.dart';
import '../core/managers/drag_speed_manager.dart';
import 'package:flutter/services.dart';

import '../widgets/line_widget.dart';
import '../widgets/line_creation_widget.dart';
import '../widgets/custom_toast.dart';
import '../app_bar_actions/index.dart';

/// Visual layout editor for organizing text lines and sections
class TextLayoutEditor extends StatefulWidget {
  final VoidCallback? onLayoutChanged;

  const TextLayoutEditor({super.key, this.onLayoutChanged});

  @override
  State<TextLayoutEditor> createState() => _TextLayoutEditorState();
}

class _TextLayoutEditorState extends State<TextLayoutEditor> {
  final List<TextSection> _sections = [];
  final Map<String, String> _l10nKeyToText = {};

  // Managers
  late final LineStateManager _lineStateManager;
  late final ScrollManager _scrollManager;

  // Line creation state
  bool _isCreatingLine = false;
  Offset? _lineStartPosition;
  Offset? _lineEndPosition;
  String? _draggingLineId;

  // Text detection state
  bool _isDetectionEnabled = false;
  bool _hasDetectedTexts = false;

  // Line selection state for blocks
  final Set<String> _selectedLineIds = {};

  // Keyboard shortcuts state
  final FocusNode _focusNode = FocusNode();
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  // Portfolio measurement
  final GlobalKey _portfolioKey = GlobalKey();
  final double _viewportHeight = 800.0; // Height of what's visible on screen
  double _absoluteHeight = 800.0; // Total height of entire page content

  @override
  void initState() {
    super.initState();

    // Initialize managers
    _lineStateManager = LineStateManager(
      onLinesChanged: () => setState(() {}),
      canvasHeight: _absoluteHeight,
    );
    _scrollManager = ScrollManager(
      scrollController: ScrollController(),
      onScrollChanged: () => setState(() {}),
    );

    _loadCurrentLayout();
    _measurePortfolioHeights();

    // Measure again after a delay to ensure scroll controller is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      _measurePortfolioHeights();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollManager.dispose();
    super.dispose();
  }

  void _measurePortfolioHeights() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_portfolioKey.currentContext != null) {
        final RenderBox renderBox =
            _portfolioKey.currentContext!.findRenderObject() as RenderBox;
        final viewportHeight = renderBox.size.height;

        // Get the absolute height from the portfolio's scroll controller
        double absoluteHeight = viewportHeight;
        if (_scrollManager.scrollController.hasClients) {
          final maxScrollExtent =
              _scrollManager.scrollController.position.maxScrollExtent;
          final scrollViewportHeight =
              _scrollManager.scrollController.position.viewportDimension;
          absoluteHeight = maxScrollExtent + scrollViewportHeight;
        }

        if (absoluteHeight > 0 && absoluteHeight != _absoluteHeight) {
          setState(() {
            _absoluteHeight = absoluteHeight;
          });
          // Update canvas height in line state manager with absolute height
          _lineStateManager.updateCanvasHeight(absoluteHeight);
        }
      }
    });
  }

  void _loadCurrentLayout() {
    // Load current layout from registry
    final registry = TextAnimationRegistry();
    final elements = registry.getSortedElements();

    // Group by line index
    final lineGroups = <int, List<TextElement>>{};
    for (final element in elements) {
      lineGroups.putIfAbsent(element.lineIndex, () => []).add(element);
    }

    // Create lines only from existing elements in the registry
    for (final entry in lineGroups.entries) {
      final lineIndex = entry.key;
      final lineElements = entry.value;
      final line = Line(
        id: LineManager.generateId(),
        order: lineIndex,
        l10nKeys: lineElements
            .map((e) => e.id ?? '')
            .where((id) => id.isNotEmpty)
            .toList(),
        height: 60.0,
        yPosition: lineIndex * 60.0,
      );
      _lineStateManager.addLine(line);
    }

    // Create sections based on the actual lines loaded
    _sections.clear();
    if (_lineStateManager.lines.isNotEmpty) {

      // Create sections dynamically based on loaded lines
      _sections.addAll([
        TextSection(
          name: 'Navigation',
          lineIds: ['line_0'],
          lineOrders: [0],
          color: Colors.blue.shade100,
          order: 0,
        ),
        TextSection(
          name: 'Header',
          lineIds: ['line_1', 'line_2', 'line_3'],
          lineOrders: [1, 2, 3],
          color: Colors.green.shade100,
          order: 1,
        ),
        TextSection(
          name: 'About',
          lineIds: ['line_4', 'line_5', 'line_6'],
          lineOrders: [4, 5, 6],
          color: Colors.orange.shade100,
          order: 2,
        ),
        TextSection(
          name: 'Skills',
          lineIds: [
            'line_7',
            'line_8',
            'line_9',
            'line_10',
            'line_11',
            'line_12',
            'line_13',
            'line_14',
            'line_15',
            'line_16',
            'line_17',
            'line_18',
          ],
          lineOrders: [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
          color: Colors.purple.shade100,
          order: 3,
        ),
        TextSection(
          name: 'Resume',
          lineIds: ['line_19', 'line_20', 'line_21', 'line_22'],
          lineOrders: [19, 20, 21, 22],
          color: Colors.red.shade100,
          order: 4,
        ),
        TextSection(
          name: 'Projects',
          lineIds: ['line_23', 'line_24', 'line_25', 'line_26', 'line_27'],
          lineOrders: [23, 24, 25, 26, 27],
          color: Colors.teal.shade100,
          order: 5,
        ),
        TextSection(
          name: 'Contact',
          lineIds: ['line_28', 'line_29', 'line_30'],
          lineOrders: [28, 29, 30],
          color: Colors.indigo.shade100,
          order: 6,
        ),
        TextSection(
          name: 'Footer',
          lineIds: ['line_31', 'line_32'],
          lineOrders: [31, 32],
          color: Colors.grey.shade100,
          order: 7,
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Text Layout Editor'),
      actions: [
        // Detection toggle
        DetectionToggleAction(
          isDetectionEnabled: _isDetectionEnabled,
          hasDetectedTexts: _hasDetectedTexts,
          linesWithTextsCount: _lineStateManager.lines
              .where((l) => l.detectedTexts.isNotEmpty)
              .length,
          debugTooltip: _buildDetectionDebugTooltip(),
          onChanged: (value) {
            setState(() {
              _isDetectionEnabled = value;
              if (value) {
                // Scroll to top before starting detection
                _scrollToTopAndRunDetection();
              } else {
                _clearTextDetection();
              }
            });
          },
        ),
        const SizedBox(width: 16),
        // Import/Export buttons
        ExportAction(
          canExport: _canExport(),
          onPressed: _exportLayout,
          tooltip: _canExport()
              ? 'Export Layout'
              : 'Enable detection and add lines to export',
        ),
        ImportAction(onPressed: _showImportDialog),
        // Add line button
        _buildAddLineButton(),
        // Clear canvas button
        IconButton(
          onPressed: _clearCanvas,
          tooltip: 'Clear Canvas',
          icon: const Icon(Icons.clear_all),
        ),
        // Save button
        SaveLayoutAction(onPressed: _saveLayout),
        // Create block button (only show when lines are selected)
        if (_selectedLineIds.isNotEmpty)
          CreateBlockAction(
            hasSelectedLines: _selectedLineIds.isNotEmpty,
            selectedLinesCount: _selectedLineIds.length,
            selectedLineIds: _selectedLineIds.toList(),
            onCreateBlock: () {
              _createBlockFromSelectedLines();
              setState(() {});
              widget.onLayoutChanged?.call();
            },
          ),
        // Ungroup button (only visible when lines are selected)
        if (_selectedLineIds.isNotEmpty)
          IconButton(
            onPressed: _ungroupSelectedLines,
            tooltip: 'Ungroup Selected Lines (Ctrl+Shift+G)',
            icon: const Icon(Icons.group_remove),
          ),
      ],
    );
  }

  Widget _buildAddLineButton() {
    return GestureDetector(
      onPanStart: (details) {
        _isCreatingLine = true;
        _lineStartPosition = const Offset(0, 0);
      },
      onPanUpdate: (details) {
        if (_isCreatingLine) {
          setState(() {
            final appBarHeight = kToolbarHeight;
            final scrollOffset = _scrollManager.scrollOffset;

            // Apply consistent drag speed for line creation
            final adjustedDelta =
                DragSpeedManager.convertViewportDeltaToCanvasDelta(
                  details.delta.dy,
                  DragType.creation,
                );

            final absoluteY =
                _scrollManager.convertGlobalToCanvasPosition(
                  details.globalPosition.dy,
                  appBarHeight,
                ) +
                scrollOffset +
                adjustedDelta;
            _lineEndPosition = Offset(0, absoluteY);
          });
        }
      },
      onPanEnd: (details) {
        if (_isCreatingLine) {
          _createLine();
          _isCreatingLine = false;
        }
      },
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Do nothing when pressed - only drag creates lines
        },
        tooltip: 'Add New Line (Drag to position)',
      ),
    );
  }

  void _createLine() {
    if (_lineStartPosition == null || _lineEndPosition == null) return;

    final line = Line(
      id: LineManager.generateId(),
      order: 0, // Temporary order, will be updated
      l10nKeys: [],
      height: 40.0,
      yPosition: _lineEndPosition!.dy,
    );

    _lineStateManager.addLine(line);
  }

  void _clearCanvas() {
    _lineStateManager.clearLines();
    // Clear all sections/blocks when clearing canvas
    _sections.clear();
    // Clear line selections
    _clearLineSelections();
    setState(() {
      _isCreatingLine = false;
      _lineStartPosition = null;
      _lineEndPosition = null;
      _draggingLineId = null;
    });
    print('🧹 Canvas cleared - all blocks and lines removed');

    // No need to reorder blocks here since all sections are cleared
    // But we could add validation if needed in the future
  }

  /// Scroll to top and then run text detection
  void _scrollToTopAndRunDetection() {
    // First, scroll to the top (Y = 0)
    if (_scrollManager.scrollController.hasClients) {
      _scrollManager.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Wait for scroll animation to complete, then run detection
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted && _isDetectionEnabled) {
          _runTextDetection();
        }
      });
    } else {
      // If scroll controller is not ready, run detection immediately
      _runTextDetection();
    }
  }

  void _createBlockFromSelectedLines() {
    if (_selectedLineIds.isEmpty) return;

    final selectedLines = _lineStateManager.lines
        .where((line) => _selectedLineIds.contains(line.id))
        .toList();

    if (selectedLines.isEmpty) return;

    // Check if any line already belongs to a block
    for (final line in selectedLines) {
      if (_isLineInAnyBlock(line)) {
        CustomToast.showError(
          context,
          message: 'Lines can only belong to one block',
        );
        return;
      }
    }

    // Sort lines by order
    selectedLines.sort((a, b) => a.order.compareTo(b.order));

    // Create a new section/block
    final blockName = 'Block'; // Simple name, order will be dynamic
    final lineIds = selectedLines.map((line) => line.id).toList();

    // Get line orders for the new section
    final lineOrders = selectedLines.map((line) => line.order).toList();

    final newSection = TextSection(
      name: blockName,
      lineIds: lineIds,
      lineOrders: lineOrders,
      color: Colors.blue,
      order: _calculateBlockOrder(selectedLines),
    );

    // Add the section to the list
    _sections.add(newSection);

    // Clear selection
    _clearLineSelections();

    print('✅ Block created: $blockName with ${lineIds.length} lines');

    // IMPORTANT: Reorder all blocks after creating a new one
    print('🔄 Reordering blocks after creation...');
    _reorderBlocks();
  }

  /// Calculate block order based on the Y position of its lines
  /// This method is DEPRECATED - use _reorderBlocks() instead
  int _calculateBlockOrder(List<Line> lines) {
    if (lines.isEmpty) return 0;

    // Calculate the average Y position of all lines in the block
    final averageY =
        lines.map((line) => line.yPosition).reduce((a, b) => a + b) /
        lines.length;

    // For new blocks, assign a temporary order that will be corrected by _reorderBlocks
    return _sections.length; // Temporary order, will be corrected
  }

  /// Reorder all blocks based on their current Y positions
  void _reorderBlocks() {
    if (_sections.isEmpty) return;

    print('🔄 Starting block reordering...');
    print('📊 Current blocks before reordering:');
    for (final section in _sections) {
      final sectionLines = _lineStateManager.lines
          .where((line) => section.lineIds.contains(line.id))
          .toList();
      if (sectionLines.isNotEmpty) {
        final averageY =
            sectionLines.map((line) => line.yPosition).reduce((a, b) => a + b) /
            sectionLines.length;
        print(
          '   Block "${section.name}" (order: ${section.order}) - Y: ${averageY.toStringAsFixed(1)}',
        );
      }
    }

    // Create a list of blocks with their average Y positions
    final blocksWithY = <MapEntry<TextSection, double>>[];

    for (final section in _sections) {
      final sectionLines = _lineStateManager.lines
          .where((line) => section.lineIds.contains(line.id))
          .toList();

      if (sectionLines.isNotEmpty) {
        final averageY =
            sectionLines.map((line) => line.yPosition).reduce((a, b) => a + b) /
            sectionLines.length;
        blocksWithY.add(MapEntry(section, averageY));
        print(
          '   📍 Block "${section.name}" - Average Y: ${averageY.toStringAsFixed(1)}',
        );
      }
    }

    if (blocksWithY.isEmpty) return;

    // Sort blocks by Y position (top to bottom)
    blocksWithY.sort((a, b) => a.value.compareTo(b.value));
    print('📈 Sorted blocks by Y position:');
    for (int i = 0; i < blocksWithY.length; i++) {
      print(
        '   ${i}: "${blocksWithY[i].key.name}" - Y: ${blocksWithY[i].value.toStringAsFixed(1)}',
      );
    }

    // Create new sections list with updated orders
    final newSections = <TextSection>[];
    final usedOrders = <int>{};

    for (int i = 0; i < blocksWithY.length; i++) {
      final section = blocksWithY[i].key;
      final newOrder = i; // This will be 0, 1, 2, 3...

      // Validate that order is unique
      if (usedOrders.contains(newOrder)) {
        print('❌ ERROR: Duplicate order detected: $newOrder');
        continue;
      }
      usedOrders.add(newOrder);

      // Create new section with updated order
      final updatedSection = TextSection(
        name: section.name,
        lineIds: section.lineIds,
        lineOrders: section.lineOrders, // Preserve existing line orders
        color: section.color,
        order: newOrder,
      );

      newSections.add(updatedSection);
      print('   ✅ Block "${section.name}" -> Order $newOrder');
    }

    // Replace the entire sections list
    _sections.clear();
    _sections.addAll(newSections);

    print(
      '🎯 Final block order: ${newSections.map((s) => 'Block ${s.order}').join(', ')}',
    );

    // Validate final result
    final finalOrders = newSections.map((s) => s.order).toSet();
    if (finalOrders.length != newSections.length) {
      print('❌ CRITICAL ERROR: Duplicate orders found in final result!');
      print(
        '   Expected ${newSections.length} unique orders, found ${finalOrders.length}',
      );
      print('   Orders found: ${finalOrders.toList()..sort()}');
    } else {
      print('✅ SUCCESS: All blocks have unique orders');
    }

    // Additional validation: check for gaps in order sequence
    final sortedOrders = finalOrders.toList()..sort();
    final expectedOrders = List.generate(newSections.length, (i) => i);
    if (!listEquals(sortedOrders, expectedOrders)) {
      print('⚠️  WARNING: Order sequence has gaps or is not sequential');
      print('   Expected: $expectedOrders');
      print('   Found: $sortedOrders');
    }
  }

  // Check if a line already belongs to any block
  bool _isLineInAnyBlock(Line line) {
    for (final section in _sections) {
      if (section.lineIds.contains(line.id)) {
        return true;
      }
    }
    return false;
  }

  // Ungroup selected lines from their blocks
  void _ungroupSelectedLines() {
    if (_selectedLineIds.isEmpty) return;

    final selectedLines = _lineStateManager.lines
        .where((line) => _selectedLineIds.contains(line.id))
        .toList();

    if (selectedLines.isEmpty) return;

    // Find and remove sections that contain any of the selected lines
    final sectionsToRemove = <TextSection>[];
    for (final section in _sections) {
      for (final line in selectedLines) {
        if (section.lineIds.contains(line.id)) {
          sectionsToRemove.add(section);
          break;
        }
      }
    }

    // Remove the sections
    for (final section in sectionsToRemove) {
      _sections.remove(section);
    }

    // Clear selection
    _clearLineSelections();

    // Show success message
    if (sectionsToRemove.isNotEmpty) {
      CustomToast.showWarning(
        context,
        message: '${sectionsToRemove.length} block(s) removed',
      );
      print('✅ ${sectionsToRemove.length} block(s) removed');

      // IMPORTANT: Reorder remaining blocks after deletion
      print('🔄 Reordering blocks after deletion...');
      _reorderBlocks();
    }
  }

  // Handle keyboard events for shortcuts
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Update the set of pressed keys only on KeyDown and KeyUp events
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }

    // We only want to act on KeyDown events to prevent repeated actions
    if (event is KeyDownEvent) {
      // Check for Ctrl + G (create block) - exactly 2 keys
      final isCtrlG =
          _pressedKeys.length == 2 &&
          _pressedKeys.contains(LogicalKeyboardKey.controlLeft) &&
          _pressedKeys.contains(LogicalKeyboardKey.keyG);

      // Check for Ctrl + Shift + G (ungroup block) - exactly 3 keys
      final isCtrlShiftG =
          _pressedKeys.length == 3 &&
          _pressedKeys.contains(LogicalKeyboardKey.controlLeft) &&
          _pressedKeys.contains(LogicalKeyboardKey.shiftLeft) &&
          _pressedKeys.contains(LogicalKeyboardKey.keyG);

      if (isCtrlG && _selectedLineIds.isNotEmpty) {
        print('✅ Ctrl+G detected - creating block');
        _createBlockFromSelectedLines();
        return KeyEventResult.handled;
      } else if (isCtrlShiftG && _selectedLineIds.isNotEmpty) {
        print('✅ Ctrl+Shift+G detected - ungrouping block');
        _ungroupSelectedLines();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        print('✅ Escape detected - clearing selections');
        _clearLineSelections();
        // Don't clear pressed keys immediately for Escape to show in the card
        return KeyEventResult.handled;
      }
    }

    // Let other key listeners handle the event if it's not our shortcut
    return KeyEventResult.ignored;
  }

  // Helper method to get a string representation of the pressed keys
  String _getPressedKeysString() {
    // Map LogicalKeyboardKey to a readable string
    final keyNames = _pressedKeys.map((key) {
      if (key == LogicalKeyboardKey.controlLeft) {
        return 'Ctrl';
      } else if (key == LogicalKeyboardKey.shiftLeft) {
        return 'Shift';
      } else if (key == LogicalKeyboardKey.escape) {
        return 'Esc';
      } else {
        return key.keyLabel.toUpperCase();
      }
    }).toList();

    // Custom sort order: Ctrl, Shift, then other keys
    keyNames.sort((a, b) {
      if (a == 'Ctrl') return -1;
      if (b == 'Ctrl') return 1;
      if (a == 'Shift') return -1;
      if (b == 'Shift') return 1;
      return a.compareTo(b);
    });

    // Join the key names with a plus sign
    return keyNames.join(' + ');
  }


  Widget _buildBody() {
    return Focus(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Base content (editor + live preview handles its own internal scroll)
                _buildCanvas(),
                // Overlay lines that visually track the inner scroll offset
                Positioned.fill(child: _buildOverlayLayer()),
                // Keyboard shortcuts display
                if (_pressedKeys.isNotEmpty)
                  Builder(
                    builder: (context) {
                      // Calculate the center position of the live preview
                      final screenWidth = MediaQuery.of(context).size.width;
                      final editorWidth =
                          206; // Editor panel (200) + padding (6)
                      final livePreviewWidth = screenWidth - editorWidth;
                      final livePreviewCenter =
                          editorWidth + (livePreviewWidth / 2);

                      return Positioned(
                        bottom: 20,
                        left:
                            livePreviewCenter -
                            60, // Approximate card width offset
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              _getPressedKeysString(),
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = kToolbarHeight;
    final canvasHeight = _scrollManager.calculateCanvasHeight(
      _absoluteHeight,
      screenHeight,
      appBarHeight,
    );

    // Ensure we have a valid height to prevent rendering issues
    final validHeight = canvasHeight.isFinite && canvasHeight > 0
        ? canvasHeight
        : screenHeight - appBarHeight;

    return SizedBox(
      height: validHeight,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: _buildEditor(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: _buildLivePreview(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayLayer() {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _scrollManager.handlePointerScroll(event);
        }
      },
      child: Stack(
        children: [
          // Lines created by dragging
          ..._lineStateManager.lines.map((line) => _buildLineWidget(line)),
          // Line being created
          if (_isCreatingLine &&
              _lineStartPosition != null &&
              _lineEndPosition != null)
            LineCreationWidget(
              lineStartPosition: _lineStartPosition,
              lineEndPosition: _lineEndPosition,
              lines: _lineStateManager.lines,
              scrollOffset: _scrollManager.scrollOffset,
            ),
        ],
      ),
    );
  }

  Widget _buildLineWidget(Line line) {
    // Calculate available width: screen width - editor width (200) - padding (6)
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 200 - 6; // 200 editor + 6 padding
    
    return LineWidget(
      key: ValueKey(line.id),
      line: line,
      isDragging: _draggingLineId == line.id,
      onDragStart: () => setState(() => _draggingLineId = line.id),
      onDragUpdate: (delta) {
        _lineStateManager.updateLinePosition(
          line.id,
          line.yPosition + delta,
          delta,
        );
        // Don't reorder during drag - only on drag end
      },
      onDragEnd: () {
        setState(() => _draggingLineId = null);
        // Reorder blocks after drag ends
        _reorderBlocks();
      },
      onResize: (delta, direction) =>
          _lineStateManager.resizeLine(line.id, delta, direction),
      onDelete: () => _deleteLine(line.id),
      scrollOffset: _scrollManager.scrollOffset,
      isDetectionEnabled: _isDetectionEnabled,
      availableWidth: availableWidth,
      isSelected: _selectedLineIds.contains(line.id),
      onToggleSelection: () => _toggleLineSelection(line.id),
    );
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          // Block management area (100px width)
          SizedBox(width: 100, child: _buildBlockManagementArea()),
          Spacer(),

          // Separator
          // Main editor area
        ],
      ),
    );
  }

  Widget _buildBlockManagementArea() {
    return Stack(children: _buildBlockVisualizations());
  }

  List<Widget> _buildBlockVisualizations() {
    final widgets = <Widget>[];

    for (final section in _sections) {
      // Find lines that belong to this section
      final sectionLines = _lineStateManager.lines
          .where((line) => section.lineIds.contains(line.id))
          .toList();

      if (sectionLines.isNotEmpty) {
        // Sort lines by order to ensure proper visualization
        sectionLines.sort((a, b) => a.order.compareTo(b.order));

        // Calculate the visual position for this block
        final firstLine = sectionLines.first;
        final lastLine = sectionLines.last;

        // Calculate total block height and center position
        final blockHeight =
            (lastLine.yPosition + lastLine.height) - firstLine.yPosition;
        final blockCenterY = firstLine.yPosition + (blockHeight / 2);
        final blockCenterYAdjusted = blockCenterY - _scrollManager.scrollOffset;

        // Block label with background - centered between all lines
        widgets.add(
          Positioned(
            left: 5,
            top: blockCenterYAdjusted - 12, // Center the text
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Block ${section.order}', // Use dynamic order instead of name
                style: TextStyle(
                  color: section.color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

        // Vertical lines for each line in the block - same height as the line
        for (final line in sectionLines) {
          final lineYAdjusted = line.yPosition - _scrollManager.scrollOffset;

          // Only show lines that are visible in the viewport
          if (lineYAdjusted >= -20 && lineYAdjusted <= 800) {
            widgets.add(
              Positioned(
                left: 0,
                top: lineYAdjusted,
                child: Container(
                  width: 4, // Thin vertical line
                  height: line.height, // Same height as the line
                  decoration: BoxDecoration(
                    color: section.color.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            );
          }
        }
      }
    }

    return widgets;
  }

  Widget _buildLivePreview() {
    return Container(
      key: _portfolioKey,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PortfolioPreviewWidget(
        config: _buildCurrentConfig(),
        onSectionTap: () {},
        scrollController: _scrollManager.scrollController,
      ),
    );
  }

  TextLayoutConfig _buildCurrentConfig() {
    // Convert Line objects to TextLine objects
    final textLines = _lineStateManager.lines.map((line) {
      // Convert detected texts to use absolute coordinates for export
      final exportTexts = line.detectedTexts.map((text) {
        final Map<String, dynamic> exportText = Map.from(text);
        // Use absolute coordinates for export
        if (text.containsKey('yAbsolute') && text.containsKey('xAbsolute')) {
          exportText['y'] = text['yAbsolute'];
          exportText['x'] = text['xAbsolute'];
        }
        return exportText;
      }).toList();

      return TextLine(
        order: line.order,
        l10nKeys: line.l10nKeys,
        height: line.height,
        yPosition: line.yPosition,
        detectedTexts: exportTexts,
      );
    }).toList();

    // Convert sections to include lineOrders for better import/export
    final exportSections = _sections.map((section) {
      // Get the orders of lines in this section
      final sectionLineOrders = <int>[];
      for (final lineId in section.lineIds) {
        final line = _lineStateManager.lines.firstWhere(
          (l) => l.id == lineId,
          orElse: () => Line(
            id: 'not_found',
            order: -1,
            l10nKeys: [],
            height: 40.0,
            yPosition: 0.0,
          ),
        );
        if (line.order != -1) {
          sectionLineOrders.add(line.order);
        }
      }

      return TextSection(
        name: section.name,
        lineIds: section.lineIds,
        lineOrders: sectionLineOrders,
        color: section.color,
        order: section.order,
      );
    }).toList();

    return TextLayoutConfig(
      sections: exportSections,
      lines: textLines,
      l10nKeyToText: _l10nKeyToText,
    );
  }



  void _saveLayout() {
    final config = _buildCurrentConfig();
    final json = jsonEncode(config.toJson());
    print('Layout saved: $json');

    // Update the registry using integration
    TextLayoutIntegration().applyConfiguration(config);

    // Re-measure portfolio height after layout changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurePortfolioHeights();
    });

    widget.onLayoutChanged?.call();
  }

  /// Export current layout configuration to JSON
  void _exportLayout() {
    final config = _buildCurrentConfig();
    final json = jsonEncode(config.toJson());

    // In a web environment, you can copy to clipboard or download
    // For now, just print to console
    print('Layout exported: $json');

    // Show success message
    CustomToast.showSuccess(
      context,
      message:
          'Layout exported with ${_lineStateManager.lines.where((l) => l.detectedTexts.isNotEmpty).length} lines containing detected texts',
    );

    // You could also implement a download mechanism here
    // or copy to clipboard functionality
  }

  /// Import layout configuration from JSON
  void _importLayout(String jsonString) {
    try {
      // Clean the JSON string to remove any control characters
      final cleanedJson = jsonString
          .replaceAll(
            RegExp(r'[\x00-\x1F\x7F]'),
            '',
          ) // Remove control characters
          .replaceAll(RegExp(r'\\n'), ' ') // Replace \n with space
          .replaceAll(RegExp(r'\\r'), ' ') // Replace \r with space
          .replaceAll(RegExp(r'\\t'), ' '); // Replace \t with space

      print('🔍 Cleaning JSON...');
      print('Original length: ${jsonString.length}');
      print('Cleaned length: ${cleanedJson.length}');

      final json = jsonDecode(cleanedJson) as Map<String, dynamic>;
      final config = TextLayoutConfig.fromJson(json);

      // Clear current lines and sections
      _lineStateManager.clearLines();
      _sections.clear();

      // Load imported configuration
      _loadImportedLayout(config);

      // Enable detection to show the imported texts
      setState(() {
        _isDetectionEnabled = true;
        _hasDetectedTexts = true;
      });

      // Show success message
      CustomToast.showSuccess(
        context,
        message:
            'Layout imported successfully with ${config.lines.length} lines and ${config.lines.fold(0, (sum, line) => sum + line.detectedTexts.length)} detected texts',
      );

      widget.onLayoutChanged?.call();
      print('✅ Layout imported successfully');
    } catch (e) {
      print('❌ Error importing layout: $e');
      CustomToast.showError(
        context,
        message:
            'Error importing layout: ${e.toString().split(':').last.trim()}',
        duration: const Duration(seconds: 5),
      );
    }
  }

  /// Load imported layout configuration
  void _loadImportedLayout(TextLayoutConfig config) {
    print('🔄 Starting import process...');
    print('📊 Config contains:');
    print('   - ${config.sections.length} sections');
    print('   - ${config.lines.length} lines');

    // Clear existing data first
    _lineStateManager.clearLines();
    _sections.clear();

    // Create a mapping from old line IDs to new line IDs
    final lineIdMapping = <String, String>{};

    // Load lines with detected texts first
    print('📝 Loading ${config.lines.length} lines...');
    for (final textLine in config.lines) {
      // Generate a new ID for the line
      final newLineId = LineManager.generateId();

      print(
        '   📍 Line ${textLine.order}: Y=${textLine.yPosition.toStringAsFixed(1)}, Height=${textLine.height.toStringAsFixed(1)}',
      );
      print('      📝 ${textLine.detectedTexts.length} detected texts');

      // Store the mapping from old ID to new ID
      // We'll use the order as a temporary key since we don't have the old ID
      final tempKey = 'line_${textLine.order}';
      lineIdMapping[tempKey] = newLineId;
      
      final line = Line(
        id: newLineId,
        order: textLine.order,
        l10nKeys: textLine.l10nKeys,
        height: textLine.height,
        yPosition: textLine.yPosition,
        detectedTexts: textLine.detectedTexts, // Include detected texts
      );
      
      // Add the line to the manager
      _lineStateManager.addLine(line);
      
      // Update the line's detected texts
      if (textLine.detectedTexts.isNotEmpty) {
        _lineStateManager.updateLineTexts(line.id, textLine.detectedTexts);
      }
    }

    // Now load sections using lineOrders for accurate mapping
    print('🔍 Processing ${config.sections.length} sections...');

    for (final section in config.sections) {
      print(
        '   📦 Section: "${section.name}" (order: ${section.order}) with ${section.lineIds.length} line IDs',
      );

      // Check if this section has lineOrders (new format) or just lineIds (old format)
      if (section.lineOrders.isNotEmpty) {
        print('      🆕 Using new format: lineOrders available');
        final updatedLineIds = <String>[];

        // Map using lineOrders for accurate matching
        for (int i = 0; i < section.lineOrders.length; i++) {
          final targetOrder = section.lineOrders[i];
          print('         🎯 Looking for line with order: $targetOrder');

          // Find the line with this order in our imported lines
          final matchingLine = _lineStateManager.lines.firstWhere(
            (l) => l.order == targetOrder,
            orElse: () => Line(
              id: 'not_found',
              order: -1,
              l10nKeys: [],
              height: 40.0,
              yPosition: 0.0,
            ),
          );

          if (matchingLine.order != -1) {
            updatedLineIds.add(matchingLine.id);
            print(
              '         ✅ Found line L${matchingLine.order} -> ${matchingLine.id}',
            );
          } else {
            print('         ❌ Line with order $targetOrder not found');
            print(
              '         🔍 Available orders: ${_lineStateManager.lines.map((l) => l.order).toList()}',
            );
          }
        }

        // Create updated section with new line IDs
        if (updatedLineIds.isNotEmpty) {
          final updatedSection = TextSection(
            name: section.name,
            lineIds: updatedLineIds,
            lineOrders: section.lineOrders, // Preserve existing line orders
            color: section.color,
            order: section.order,
          );
          _sections.add(updatedSection);
          print('      ✅ Created section with ${updatedLineIds.length} lines');
        } else {
          print('      ❌ No valid lines found for section "${section.name}"');
          print('      💡 This section will be skipped');
        }
      } else {
        print('      ⚠️  Using fallback format: no lineOrders available');
        // Fallback to old method for backward compatibility
        final updatedLineIds = <String>[];

        for (final oldLineId in section.lineIds) {
          print('      🔗 Old line ID: $oldLineId');

          // Try to extract order from ID as fallback
          final orderMatch = RegExp(r'line_\d+_(\d+)').firstMatch(oldLineId);
          if (orderMatch != null) {
            final extractedOrder = int.tryParse(orderMatch.group(1) ?? '');
            print('         📍 Extracted order from ID: $extractedOrder');

            if (extractedOrder != null) {
              final matchingLine = _lineStateManager.lines.firstWhere(
                (l) => l.order == extractedOrder,
                orElse: () => Line(
                  id: 'not_found',
                  order: -1,
                  l10nKeys: [],
                  height: 40.0,
                  yPosition: 0.0,
                ),
              );

              if (matchingLine.order != -1) {
                updatedLineIds.add(matchingLine.id);
                print(
                  '         ✅ Found line L${matchingLine.order} -> ${matchingLine.id}',
                );
              } else {
                print(
                  '         ❌ Line with extracted order $extractedOrder not found',
                );
              }
            }
          }
        }

        if (updatedLineIds.isNotEmpty) {
          final updatedSection = TextSection(
            name: section.name,
            lineIds: updatedLineIds,
            lineOrders: [], // Empty for old format
            color: section.color,
            order: section.order,
          );
          _sections.add(updatedSection);
          print(
            '      ✅ Created section with ${updatedLineIds.length} lines (fallback)',
          );
        } else {
          print(
            '      ❌ No valid lines found for section "${section.name}" (fallback)',
          );
        }
      }
    }

    // Load l10n key mappings
    _l10nKeyToText.addAll(config.l10nKeyToText);
    
    // Reorder blocks based on imported positions
    _reorderBlocks();

    print('✅ Import completed successfully!');
    print('   📊 Final result:');
    print('      - Lines: ${_lineStateManager.lines.length}');
    print('      - Blocks: ${_sections.length}');
    print(
      '      - Lines with detected texts: ${_lineStateManager.lines.where((l) => l.detectedTexts.isNotEmpty).length}',
    );

    // Show detailed section information
    print('   📦 Section details:');
    for (final section in _sections) {
      print(
        '      - ${section.name} (order: ${section.order}): ${section.lineIds.length} lines',
      );
    }
  }

  /// Show import dialog with JSON input
  void _showImportDialog() {
    final TextEditingController jsonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Layout from JSON'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste your exported JSON layout here:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: jsonController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Paste JSON here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Load sample JSON for testing
                      jsonController.text = _getSampleJson();
                    },
                    child: const Text('Load Sample'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Load JSON from terminal export
                      jsonController.text = _getTerminalJson();
                    },
                    child: const Text('Load Terminal'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Format and clean the current JSON input
                      _formatJsonInput(jsonController);
                    },
                    child: const Text('Format JSON'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Clear the text field
                      jsonController.clear();
                    },
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final jsonString = jsonController.text.trim();
              if (jsonString.isEmpty) {
                CustomToast.showWarning(
                  context,
                  message: 'Please enter JSON content',
                );
                return;
              }

              // Validate JSON format before importing
              try {
                jsonDecode(jsonString);
                Navigator.of(context).pop();
                _importLayout(jsonString);
              } catch (e) {
                CustomToast.showError(
                  context,
                  message:
                      'Invalid JSON format: ${e.toString().split(':').last.trim()}',
                  duration: const Duration(seconds: 5),
                );
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  /// Get sample JSON for testing
  String _getSampleJson() {
    return '''
{
  "sections": [],
  "lines": [
    {
      "order": 0,
      "l10nKeys": [],
      "height": 40,
      "yPosition": 0,
      "detectedTexts": [
        {
          "id": "text_portfolio_1755583127738",
          "text": "Portfolio",
          "y": 67,
          "x": 626.390625,
          "yAbsolute": 67,
          "xAbsolute": 626.390625,
          "fontSize": 28,
          "isBold": true
        }
      ]
    },
    {
      "order": 1,
      "l10nKeys": [],
      "height": 40,
      "yPosition": 100,
      "detectedTexts": [
        {
          "id": "text_camilo_santacruz_abadiano_1755583127739",
          "text": "Camilo Santacruz Abadiano",
          "y": 167,
          "x": 500.1015625,
          "yAbsolute": 167,
          "xAbsolute": 500.1015625,
          "fontSize": 32,
          "isBold": true
        }
      ]
    }
  ],
  "l10nKeyToText": {}
}
''';
  }

  /// Get JSON from terminal export (cleaned and formatted)
  String _getTerminalJson() {
    return '''
{
  "sections": [],
  "lines": [
    {
      "order": 0,
      "l10nKeys": [],
      "height": 40,
      "yPosition": 18.490615844726562,
      "detectedTexts": [
        {
          "id": "text_portfolio_1755583127717",
          "text": "Portfolio",
          "y": 80.7,
          "x": 244,
          "yAbsolute": 80.7,
          "xAbsolute": 244,
          "fontSize": 21,
          "isBold": true
        },
        {
          "id": "text_home_1755583127719",
          "text": "Home",
          "y": 85.2,
          "x": 705.94140625,
          "yAbsolute": 85.2,
          "xAbsolute": 705.94140625,
          "fontSize": 12,
          "isBold": true
        },
        {
          "id": "text_about_1755583127722",
          "text": "About",
          "y": 85.2,
          "x": 754.21484375,
          "yAbsolute": 85.2,
          "xAbsolute": 754.21484375,
          "fontSize": 12,
          "isBold": false
        }
      ]
    },
    {
      "order": 1,
      "l10nKeys": [],
      "height": 40,
      "yPosition": 413.009033203125,
      "detectedTexts": [
        {
          "id": "text_camilo_santacruz_abadiano_1755583127695",
          "text": "Camilo Santacruz Abadiano",
          "y": 482,
          "x": 705.94140625,
          "yAbsolute": 482,
          "xAbsolute": 705.94140625,
          "fontSize": 16,
          "isBold": true
        }
      ]
    },
    {
      "order": 2,
      "l10nKeys": [],
      "height": 40,
      "yPosition": 452.77349853515625,
      "detectedTexts": [
        {
          "id": "text_mobile_developer_1755583127709",
          "text": "Mobile Developer",
          "y": 511,
          "x": 638.4296875,
          "yAbsolute": 511,
          "xAbsolute": 638.4296875,
          "fontSize": 16,
          "isBold": false
        }
      ]
    }
  ],
  "l10nKeyToText": {}
}
''';
  }

  /// Format and clean JSON input from the text field
  void _formatJsonInput(TextEditingController controller) {
    final inputText = controller.text.trim();

    if (inputText.isEmpty) {
      CustomToast.showWarning(
        context,
        message: 'Please enter some text to format',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // Clean the JSON string using the same logic as import
      final cleanedJson = inputText
          .replaceAll(
            RegExp(r'[\x00-\x1F\x7F]'),
            '',
          ) // Remove control characters
          .replaceAll(RegExp(r'\\n'), ' ') // Replace \n with space
          .replaceAll(RegExp(r'\\r'), ' ') // Replace \r with space
          .replaceAll(RegExp(r'\\t'), ' '); // Replace \t with space

      // Validate JSON by parsing it
      final json = jsonDecode(cleanedJson) as Map<String, dynamic>;

      // Format the JSON with proper indentation
      final formattedJson = JsonEncoder.withIndent('  ').convert(json);

      // Update the text field with formatted JSON
      controller.text = formattedJson;

      // Show success message
      CustomToast.showSuccess(
        context,
        message: 'JSON formatted successfully!',
        duration: const Duration(seconds: 2),
      );

      print('✅ JSON formatted successfully');
      print('Original length: ${inputText.length}');
      print('Formatted length: ${formattedJson.length}');
    } catch (e) {
      // Show error message
      CustomToast.showError(
        context,
        message: 'Invalid JSON: ${e.toString().split(':').last.trim()}',
        duration: const Duration(seconds: 3),
      );

      print('❌ Error formatting JSON: $e');
    }
  }

  /// Run text detection on all lines using the new LivePreviewTextScanner
  void _runTextDetection() {
    if (!_isDetectionEnabled || _lineStateManager.lines.isEmpty) return;

    setState(() {
      _hasDetectedTexts = false;
    });

    // Use the new LivePreviewTextScanner to get real text positions
    final portfolioContext = _portfolioKey.currentContext;
    if (portfolioContext == null) {
      print('❌ Portfolio context is null - cannot scan texts');
      return;
    }

    print('🔍 Starting real text detection with LivePreviewTextScanner...');

    // Get all detected texts with real coordinates
    final detectedTexts = LivePreviewTextScanner.scanLivePreview(
      portfolioContext,
    );

    print('📊 Total texts detected from live preview: ${detectedTexts.length}');

    // Map detected texts to lines based on Y coordinates
    for (final line in _lineStateManager.lines) {
      final textsInLine = <Map<String, dynamic>>[];

      for (final detectedText in detectedTexts) {
        if (detectedText.yPosition != null &&
            _isTextInLineBounds(detectedText, line)) {
          textsInLine.add({
            'id': detectedText.id,
            'text': detectedText.text,
            // Use viewport coordinates for UI display (without AppBar)
            'y': detectedText.yPositionViewport,
            'x': detectedText.xPositionViewport,
            // Keep absolute coordinates for export
            'yAbsolute': detectedText.yPosition,
            'xAbsolute': detectedText.xPosition,
            'fontSize': detectedText.style.fontSize,
            'isBold': detectedText.style.isBold,
          });
        }
      }

      if (textsInLine.isNotEmpty) {
        _hasDetectedTexts = true;
        // Update line with detected texts
        _lineStateManager.updateLineTexts(line.id, textsInLine);

        // Log detected texts for this line
        print(
          '📍 L${line.order} (Y: ${line.yPosition.toStringAsFixed(1)}) - ${textsInLine.length} texts detected:',
        );
        for (final text in textsInLine) {
          print(
            '   📝 ID: ${text['id']}, Text: "${text['text']}", Y: ${text['y']?.toStringAsFixed(1) ?? 'null'}',
          );
        }
      } else {
        // Clear any previous detections for this line
        _lineStateManager.updateLineTexts(line.id, []);
        print(
          '📍 L${line.order} (Y: ${line.yPosition.toStringAsFixed(1)}) - No texts detected',
        );
      }
    }

    print(
      '✅ Text detection completed. Total lines with texts: ${_lineStateManager.lines.where((l) => l.detectedTexts.isNotEmpty).length}',
    );
    setState(() {});
  }

  /// Clear text detection results
  void _clearTextDetection() {
    setState(() {
      _hasDetectedTexts = false;
    });

    // Clear detected texts from all lines
    for (final line in _lineStateManager.lines) {
      _lineStateManager.updateLineTexts(line.id, []);
    }
  }

  /// Toggle line selection for block creation
  void _toggleLineSelection(String lineId) {
    setState(() {
      if (_selectedLineIds.contains(lineId)) {
        _selectedLineIds.remove(lineId);
      } else {
        _selectedLineIds.add(lineId);
      }
    });
  }



  /// Clear all line selections
  void _clearLineSelections() {
    setState(() {
      _selectedLineIds.clear();
    });
  }



  /// Check if a detected text is within line bounds
  /// Line uses ABSOLUTE coordinates, Text uses VIEWPORT coordinates
  bool _isTextInLineBounds(DetectedText detectedText, Line line) {
    if (detectedText.yPositionViewport == null) return false;

    // Text Y is in VIEWPORT coordinates (without AppBar)
    final textY = detectedText.yPositionViewport!;

    // Line Y is in ABSOLUTE coordinates (with AppBar)
    // Convert line to viewport coordinates for comparison
    final lineTop = line.yPosition;
    final lineBottom = lineTop + line.height;

    // Check if text Y position (viewport) is within line bounds (converted to viewport)
    return textY >= lineTop && textY <= lineBottom;
  }

  /// Check if export button should be enabled
  bool _canExport() {
    return _isDetectionEnabled &&
        _lineStateManager.lines.isNotEmpty &&
        _hasDetectedTexts;
  }

  /// Build debug tooltip for detection status
  String _buildDetectionDebugTooltip() {
    if (!_isDetectionEnabled) {
      return 'Detection is disabled';
    }

    String tooltip = '🔍 Text Detection Debug Info:\n';
    tooltip += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
    tooltip += '📊 Detection Status:\n';
    tooltip += '   Enabled: ✅\n';
    tooltip += '   Has Detected Texts: ${_hasDetectedTexts ? "✅" : "❌"}\n';
    tooltip += '   Total Lines: ${_lineStateManager.lines.length}\n';
    tooltip +=
        '   Lines with Texts: ${_lineStateManager.lines.where((l) => l.detectedTexts.isNotEmpty).length}\n\n';

    if (_lineStateManager.lines.isNotEmpty) {
      tooltip += '📏 Line Ranges:\n';
      for (final line in _lineStateManager.lines) {
        final lineTop = line.yPosition;
        final lineBottom = line.yPosition + line.height;
        final textsCount = line.detectedTexts.length;

        tooltip +=
            '   L${line.order}: Y=${lineTop.toStringAsFixed(0)}-${lineBottom.toStringAsFixed(0)} ($textsCount texts)\n';
      }
    }

    tooltip += '\n💡 Hover over any line to see detailed debug info!';

    return tooltip;
  }

  /// Delete a line by its ID
  void _deleteLine(String lineId) {
    final line = _lineStateManager.getLineById(lineId);
    if (line == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Line'),
        content: Text('Are you sure you want to delete L${line.order}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _lineStateManager.deleteLine(lineId);
              setState(() {});
              widget.onLayoutChanged?.call();
              
              // Show success message
              CustomToast.showError(
                context,
                message: 'Line ${line.order} deleted successfully',
                duration: const Duration(seconds: 2),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
