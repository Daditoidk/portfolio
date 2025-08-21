import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_web/screens/portfolio/portfolio_screen.dart';
import 'animation_settings_panel/index.dart';

class AnimationEditorScreen extends ConsumerStatefulWidget {
  const AnimationEditorScreen({super.key});

  @override
  ConsumerState<AnimationEditorScreen> createState() =>
      _AnimationEditorScreenState();
}

class _AnimationEditorScreenState extends ConsumerState<AnimationEditorScreen> {
  String _selectedCanvas = 'portfolio';
  String? _selectedAnimation;
  bool _showAnimationSettings = false;
  String? _selectedCategory;

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

  final List<Map<String, dynamic>> _availableAnimationCategories = [
    {
      'id': 'text',
      'name': 'Text',
      'icon': Icons.text_fields,
      'color': Colors.blue,
      'animations': [
        {
          'id': 'text_scramble',
          'name': 'Scramble',
          'icon': Icons.shuffle,
          'description': 'Text scrambles into place',
          'settings': ['Direction', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'text_fade_in',
          'name': 'Fade In',
          'icon': Icons.visibility,
          'description': 'Text fades in smoothly',
          'settings': ['Direction', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'text_typewriter',
          'name': 'Typewriter',
          'icon': Icons.keyboard,
          'description': 'Text types out character by character',
          'settings': ['Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'text_wave',
          'name': 'Wave',
          'icon': Icons.waves,
          'description': 'Text waves into view',
          'settings': ['Amplitude', 'Speed', 'Curve', 'Delay'],
        },
      ],
    },
    {
      'id': 'transitions',
      'name': 'Transitions',
      'icon': Icons.swap_horiz,
      'color': Colors.green,
      'animations': [
        {
          'id': 'transition_fade_right',
          'name': 'Fade In Right',
          'icon': Icons.arrow_forward,
          'description': 'Elements fade in from right',
          'settings': ['Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'transition_flashlight',
          'name': 'Flashlight',
          'icon': Icons.flashlight_on,
          'description': 'Flashlight effect transition',
          'settings': ['Intensity', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'transition_slide_up',
          'name': 'Slide Up',
          'icon': Icons.keyboard_arrow_up,
          'description': 'Elements slide up into view',
          'settings': ['Distance', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'transition_zoom',
          'name': 'Zoom',
          'icon': Icons.zoom_in,
          'description': 'Elements zoom into view',
          'settings': ['Scale', 'Speed', 'Curve', 'Delay'],
        },
      ],
    },
    {
      'id': 'images',
      'name': 'Images',
      'icon': Icons.image,
      'color': Colors.orange,
      'animations': [
        {
          'id': 'image_reveal',
          'name': 'Reveal',
          'icon': Icons.visibility_off,
          'description': 'Image reveals progressively',
          'settings': ['Direction', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'image_morph',
          'name': 'Morph',
          'icon': Icons.transform,
          'description': 'Image morphs into view',
          'settings': ['Intensity', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'image_pixelate',
          'name': 'Pixelate',
          'icon': Icons.grid_on,
          'description': 'Image pixelates into view',
          'settings': ['Resolution', 'Speed', 'Curve', 'Delay'],
        },
      ],
    },
    {
      'id': 'effects',
      'name': 'Effects',
      'icon': Icons.auto_awesome,
      'color': Colors.purple,
      'animations': [
        {
          'id': 'effect_bounce',
          'name': 'Bounce',
          'icon': Icons.animation,
          'description': 'Elements bounce into view',
          'settings': ['Intensity', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'effect_rotate',
          'name': 'Rotate',
          'icon': Icons.rotate_right,
          'description': 'Elements rotate into view',
          'settings': ['Angle', 'Speed', 'Curve', 'Delay'],
        },
        {
          'id': 'effect_flip',
          'name': 'Flip',
          'icon': Icons.flip,
          'description': 'Elements flip into view',
          'settings': ['Axis', 'Speed', 'Curve', 'Delay'],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          // Left side - Live Preview Canvas
          Expanded(child: _buildLivePreviewCanvas()),

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
            child: _buildAnimationPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildLivePreviewCanvas() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildSelectedCanvas(),
      ),
    );
  }

  Widget _buildSelectedCanvas() {
    final selectedCanvas = _availableCanvases.firstWhere(
      (canvas) => canvas['id'] == _selectedCanvas,
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
            child: selectedCanvas['widget'],
          ),
        );
      },
    );
  }

  Widget _buildAnimationPanel() {
    return Column(
      children: [
        // Header with back button and canvas dropdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/lab'),
                    icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back to Lab',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Canvas dropdown
              Text(
                'Select Canvas',
                style: TextStyle(
                  fontSize: 11, // Reduced from 14 to 11
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              DropdownButton<String>(
                value: _selectedCanvas,
                isExpanded: true,
                underline: Container(),
                items: _availableCanvases.map((canvas) {
                  return DropdownMenuItem<String>(
                    value: canvas['id'] as String,
                    child: Row(
                      children: [
                        Icon(
                          canvas['icon'] as IconData,
                          size: 16,
                          color: canvas['color'] as Color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          canvas['name'] as String,
                          style: TextStyle(fontSize: 12), // Reduced font size
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCanvas = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        // Scrollable content area (combines animation selection and settings)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                // Animation Selection Container
                _buildAnimationSelectionContainer(),

                // Animation Settings Panel (appears when animation is selected)
                if (_showAnimationSettings) ...[
                  const SizedBox(height: 16),
                  _buildAnimationSettingsPanel(),
                ],
              ],
            ),
          ),
        ),

        // Run Animation Button
        _buildRunAnimationButton(),
      ],
    );
  }

  Widget _buildAnimationSelectionContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.animation, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Select Animation',
              style: TextStyle(
                fontSize: 12, // Reduced from 15 to 12
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Animation Categories List
        if (_selectedCategory == null) ...[
          // Show categories
          ..._availableAnimationCategories.map(
            (category) => _buildCategoryTile(category),
          ),
        ] else ...[
          // Show back button and animations for selected category
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _selectedAnimation = null;
                    _showAnimationSettings = false;
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(
                _availableAnimationCategories.firstWhere(
                  (c) => c['id'] == _selectedCategory,
                )['name'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Animation Grid for selected category
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: _availableAnimationCategories
                .firstWhere((c) => c['id'] == _selectedCategory)['animations']
                .length,
            itemBuilder: (context, index) {
              final category = _availableAnimationCategories.firstWhere(
                (c) => c['id'] == _selectedCategory,
              );
              final animations =
                  category['animations'] as List<Map<String, dynamic>>;
              final animation = animations[index];
              final isSelected = _selectedAnimation == animation['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAnimation = isSelected ? null : animation['id'];
                    _showAnimationSettings = _selectedAnimation != null;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade100 : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        animation['icon'],
                        color: isSelected
                            ? Colors.blue.shade700
                            : Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        animation['name'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryTile(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(category['icon'], color: category['color'], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    '${(category['animations'] as List).length} animations',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSettingsPanel() {
    return AnimationSettingsPanel(
      selectedAnimation: _selectedAnimation,
      onAnimationChanged: (animationId) {
        setState(() {
          _selectedAnimation = animationId;
          _showAnimationSettings = animationId.isNotEmpty;
        });
      },
      onSettingsChanged: (settings) {
        // Handle settings changes if needed
        // Settings are now managed by the AnimationSettingsPanel
      },
      currentSettings: {},
    );
  }

  String _getSelectedAnimationName() {
    if (_selectedAnimation == null || _selectedCategory == null) {
      return 'Unknown';
    }

    final category = _availableAnimationCategories.firstWhere(
      (c) => c['id'] == _selectedCategory,
    );
    final animations = category['animations'] as List<Map<String, dynamic>>;
    final animation = animations.firstWhere(
      (a) => a['id'] == _selectedAnimation,
    );
    return animation['name'] as String;
  }

  Widget _buildRunAnimationButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedAnimation != null
            ? () {
                // TODO: Implement animation execution
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Running ${_getSelectedAnimationName()} animation!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Run Animation',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
