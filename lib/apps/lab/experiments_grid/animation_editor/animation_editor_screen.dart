import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_web/apps/lab/experiments_grid/animation_editor/canvas/live_preview_canvas_widget.dart';
import 'package:portfolio_web/apps/portfolio/portfolio_screen.dart';
import 'animation_panel/index.dart';

class AnimationEditorScreen extends ConsumerStatefulWidget {
  const AnimationEditorScreen({super.key});

  @override
  ConsumerState<AnimationEditorScreen> createState() =>
      _AnimationEditorScreenState();
}

class _AnimationEditorScreenState extends ConsumerState<AnimationEditorScreen> {
  String _selectedCanvas = 'portfolio';

  final List<Map<String, dynamic>> _availableCanvases = [
    {
      'id': 'portfolio',
      'name': 'Portfolio Screen',
      'description': 'Full portfolio with all sections',
      'icon': Icons.person,
      'color': Colors.blue,
      'widget': const PortfolioScreen(),
    },
    {
      'id': 'basic_scaffold',
      'name': 'Basic Scaffold',
      'description': 'Simple scaffold widget',
      'icon': Icons.dashboard,
      'color': Colors.green,
      'widget': _buildBasicScaffold(),
    },
    {
      'id': 'multi_nav_scaffold',
      'name': 'Multi Navigation',
      'description': 'Scaffold with multiple navigations',
      'icon': Icons.navigation,
      'color': Colors.orange,
      'widget': _buildMultiNavScaffold(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          // Left side - Live Preview Canvas
          Expanded(
            child: LivePreviewCanvasWidget(
              selectedCanvas: _selectedCanvas,
              availableCanvases: _availableCanvases,
            ),
          ),

          // Right side - Animation Panel (400px width)
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(left: BorderSide(color: Colors.grey.shade300)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: AnimationPanelWidget(
              selectedCanvas: _selectedCanvas,
              availableCanvases: _availableCanvases,
              onCanvasChanged: (value) {
                setState(() {
                  _selectedCanvas = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Static methods for building canvas widgets
  static Widget _buildBasicScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Scaffold'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 64, color: Colors.green.shade600),
            const SizedBox(height: 16),
            Text(
              'Basic Scaffold Widget',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('This is a simple scaffold widget for testing animations'),
          ],
        ),
      ),
    );
  }

  static Widget _buildMultiNavScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Navigation'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Row(
        children: [
          // Left Navigation
          Container(
            width: 200,
            color: Colors.orange.shade100,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.navigation,
                    size: 64,
                    color: Colors.orange.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Multi Navigation Scaffold',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('This scaffold has multiple navigation elements'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
