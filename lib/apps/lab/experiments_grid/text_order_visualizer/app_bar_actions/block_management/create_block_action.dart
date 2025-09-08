import 'package:flutter/material.dart';

/// Widget for the create block action in the AppBar
class CreateBlockAction extends StatelessWidget {
  final bool hasSelectedLines;
  final int selectedLinesCount;
  final List<String> selectedLineIds;
  final VoidCallback onCreateBlock;

  const CreateBlockAction({
    super.key,
    required this.hasSelectedLines,
    required this.selectedLinesCount,
    required this.selectedLineIds,
    required this.onCreateBlock,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: hasSelectedLines ? _createBlock : null,
      tooltip: hasSelectedLines
          ? 'Create Block with $selectedLinesCount selected lines (Ctrl+G)'
          : 'Select lines to create a block (Ctrl+G)',
      icon: Stack(
        children: [
          const Icon(Icons.group_work),
          if (hasSelectedLines)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                child: Text(
                  selectedLinesCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Create a block from selected lines
  void _createBlock() {
    if (selectedLineIds.isEmpty) return;
    onCreateBlock();
  }
}
