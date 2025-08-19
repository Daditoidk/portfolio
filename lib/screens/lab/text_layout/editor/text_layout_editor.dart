import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import '../../../../core/animations/text_animation_registry.dart';
import '../core/integration/text_layout_integration.dart';
import '../core/models/text_layout_config.dart';
import 'portfolio_preview_widget.dart';
import '../core/models/line.dart';
import '../core/models/line_manager.dart';
import '../core/managers/line_state_manager.dart';
import '../core/managers/scroll_manager.dart';
import '../core/managers/drag_speed_manager.dart';
import '../widgets/line_widget.dart';
import '../widgets/line_creation_widget.dart';

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
      final maxLineIndex = _lineStateManager.lines
          .map((l) => l.order)
          .reduce((a, b) => a > b ? a : b);

      // Create sections dynamically based on loaded lines
      _sections.addAll([
        TextSection(
          name: 'Navigation',
          startLine: 0,
          endLine: 0,
          color: Colors.blue.shade100,
        ),
        TextSection(
          name: 'Header',
          startLine: 1,
          endLine: 3,
          color: Colors.green.shade100,
        ),
        TextSection(
          name: 'About',
          startLine: 4,
          endLine: 6,
          color: Colors.orange.shade100,
        ),
        TextSection(
          name: 'Skills',
          startLine: 7,
          endLine: 18,
          color: Colors.purple.shade100,
        ),
        TextSection(
          name: 'Resume',
          startLine: 19,
          endLine: 22,
          color: Colors.red.shade100,
        ),
        TextSection(
          name: 'Projects',
          startLine: 23,
          endLine: 27,
          color: Colors.teal.shade100,
        ),
        TextSection(
          name: 'Contact',
          startLine: 28,
          endLine: 30,
          color: Colors.indigo.shade100,
        ),
        TextSection(
          name: 'Footer',
          startLine: 31,
          endLine: maxLineIndex,
          color: Colors.grey.shade100,
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
        // Import/Export buttons
        IconButton(
          onPressed: _exportLayout,
          tooltip: 'Export Layout',
          icon: const Icon(Icons.download),
        ),
        IconButton(
          onPressed: () {
            // For now, just show a placeholder for import
            // In a real implementation, you'd show a file picker or text input
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Import functionality: Use _importLayout(jsonString) method',
                ),
              ),
            );
          },
          tooltip: 'Import Layout',
          icon: const Icon(Icons.upload),
        ),
        // Add line button
        _buildAddLineButton(),
        // Clear canvas button
        IconButton(
          onPressed: _clearCanvas,
          tooltip: 'Clear Canvas',
          icon: const Icon(Icons.clear_all),
        ),
        // Save button
        IconButton(
          onPressed: _saveLayout,
          tooltip: 'Save Layout',
          icon: const Icon(Icons.save),
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

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Base content (editor + live preview handles its own internal scroll)
              _buildCanvas(),
              // Overlay lines that visually track the inner scroll offset
              Positioned.fill(child: _buildOverlayLayer()),
            ],
          ),
        ),
      ],
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

    return Container(
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
    return LineWidget(
      key: ValueKey(line.id),
      line: line,
      isDragging: _draggingLineId == line.id,
      onDragStart: () => setState(() => _draggingLineId = line.id),
      onDragUpdate: (delta) => _lineStateManager.updateLinePosition(
        line.id,
        line.yPosition + delta,
        delta,
      ),
      onDragEnd: () => setState(() => _draggingLineId = null),
      onResize: (delta, direction) =>
          _lineStateManager.resizeLine(line.id, delta, direction),
      scrollOffset: _scrollManager.scrollOffset,
    );
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: const Center(
        child: Text(
          'Editor Panel',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
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
    return TextLayoutConfig(
      sections: _sections,
      lines: _lineStateManager.toTextLines(),
      l10nKeyToText: _l10nKeyToText,
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
    setState(() {
      _isCreatingLine = false;
      _lineStartPosition = null;
      _lineEndPosition = null;
      _draggingLineId = null;
    });
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

    // You could also implement a download mechanism here
    // or copy to clipboard functionality
  }

  /// Import layout configuration from JSON
  void _importLayout(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final config = TextLayoutConfig.fromJson(json);

      // Clear current lines and sections
      _lineStateManager.clearLines();
      _sections.clear();

      // Load imported configuration
      _loadImportedLayout(config);

      setState(() {});
      widget.onLayoutChanged?.call();

      print('Layout imported successfully');
    } catch (e) {
      print('Error importing layout: $e');
    }
  }

  /// Load imported layout configuration
  void _loadImportedLayout(TextLayoutConfig config) {
    // Load sections
    _sections.addAll(config.sections);

    // Load lines
    for (final textLine in config.lines) {
      final line = Line(
        id: LineManager.generateId(),
        order: textLine.order,
        l10nKeys: textLine.l10nKeys,
        height: textLine.height,
        yPosition: textLine.yPosition,
      );
      _lineStateManager.addLine(line);
    }

    // Load l10n key mappings
    _l10nKeyToText.addAll(config.l10nKeyToText);
  }
}
