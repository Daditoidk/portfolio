import 'package:flutter/material.dart';

/// Widget for building the live preview canvas container
class LivePreviewCanvasWidget extends StatelessWidget {
  final String selectedCanvas;
  final List<Map<String, dynamic>> availableCanvases;

  const LivePreviewCanvasWidget({
    super.key,
    required this.selectedCanvas,
    required this.availableCanvases,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildSelectedCanvas(context),
      ),
    );
  }

  Widget _buildSelectedCanvas(BuildContext context) {
    final selectedCanvasData = availableCanvases.firstWhere(
      (canvas) => canvas['id'] == selectedCanvas,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the real screen dimensions
        final realScreenSize = MediaQuery.of(context).size;

        // The widget "thinks" it's in a screen of the real width
        // (canvas + animation panel width)
        final simulatedScreenWidth = realScreenSize.width;
        final simulatedScreenHeight = realScreenSize.height;

        // Get canvas dimensions from ancestor widget instead of hardcoded values
        final canvasHeight = constraints.maxHeight;

        // Calculate scale to fit the simulated screen into the canvas
        final scaleY = canvasHeight / simulatedScreenHeight;

        return Transform.scale(
          scaleY: scaleY,
          child: MediaQuery(
            // The widget "thinks" it has access to the full screen width
            data: MediaQuery.of(context).copyWith(
              size: Size(simulatedScreenWidth, simulatedScreenHeight),
              devicePixelRatio: 1.0,
            ),
            child: selectedCanvasData['widget'],
          ),
        );
      },
    );
  }
}
