import 'package:flutter/material.dart';
import 'animation_properties/index.dart';
import 'canvas_header_widget.dart';
import 'animation_selection_container.dart';

/// Widget for building the animation panel
class AnimationPanelWidget extends StatefulWidget {
  final String selectedCanvas;
  final List<Map<String, dynamic>> availableCanvases;
  final Function(String) onCanvasChanged;

  const AnimationPanelWidget({
    super.key,
    required this.selectedCanvas,
    required this.availableCanvases,
    required this.onCanvasChanged,
  });

  @override
  State<AnimationPanelWidget> createState() => _AnimationPanelWidgetState();
}

class _AnimationPanelWidgetState extends State<AnimationPanelWidget> {
  String? _selectedAnimation;
  bool _showAnimationSettings = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with back button and canvas dropdown
        CanvasHeaderWidget(
          selectedCanvas: widget.selectedCanvas,
          availableCanvases: widget.availableCanvases,
          onCanvasChanged: widget.onCanvasChanged,
        ),

        // Scrollable content area (combines animation selection and settings)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                // Animation Selection Container
                AnimationSelectionContainer(
                  onAnimationSelected: (animationId) {
                    setState(() {
                      _selectedAnimation = animationId;
                      _showAnimationSettings = animationId != null;
                    });
                  },
                  onShowSettingsChanged: (show) {
                    setState(() {
                      _showAnimationSettings = show;
                    });
                  },
                ),

                // Animation Properties Panel (appears when animation is selected)
                if (_showAnimationSettings) ...[
                  const SizedBox(height: 16),
                  AnimationPropertiesPanel(
                    selectedAnimation: _selectedAnimation,
                    onAnimationChanged: (animationId) {
                      setState(() {
                        _selectedAnimation = animationId;
                        _showAnimationSettings = animationId.isNotEmpty;
                      });
                    },
                    onSettingsChanged: (settings) {
                      // Handle settings changes if needed
                      // Settings are now managed by the AnimationPropertiesPanel
                    },
                    currentSettings: {},
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
