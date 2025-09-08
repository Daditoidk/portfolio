import 'package:flutter/material.dart';

/// Widget for the animation selection container
class AnimationSelectionContainer extends StatefulWidget {
  final Function(String?) onAnimationSelected;
  final Function(bool) onShowSettingsChanged;

  const AnimationSelectionContainer({
    super.key,
    required this.onAnimationSelected,
    required this.onShowSettingsChanged,
  });

  @override
  State<AnimationSelectionContainer> createState() =>
      _AnimationSelectionContainerState();
}

class _AnimationSelectionContainerState
    extends State<AnimationSelectionContainer> {
  String? _selectedAnimation;
  String? _selectedCategory;

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
          'description': 'Flashlight effect reveals content',
          'settings': ['Direction', 'Speed', 'Intensity'],
        },
        {
          'id': 'transition_slide_up',
          'name': 'Slide Up',
          'icon': Icons.arrow_upward,
          'description': 'Elements slide up into view',
          'settings': ['Distance', 'Speed', 'Curve'],
        },
        {
          'id': 'transition_zoom_in',
          'name': 'Zoom In',
          'icon': Icons.zoom_in,
          'description': 'Elements zoom in from center',
          'settings': ['Scale', 'Speed', 'Curve'],
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
          'id': 'effect_particle',
          'name': 'Particle',
          'icon': Icons.grain,
          'description': 'Particle effects around elements',
          'settings': ['Count', 'Speed', 'Size', 'Color'],
        },
        {
          'id': 'effect_glow',
          'name': 'Glow',
          'icon': Icons.lightbulb,
          'description': 'Glowing effect around elements',
          'settings': ['Intensity', 'Color', 'Radius'],
        },
        {
          'id': 'effect_shake',
          'name': 'Shake',
          'icon': Icons.vibration,
          'description': 'Shake elements for attention',
          'settings': ['Intensity', 'Duration', 'Direction'],
        },
        {
          'id': 'effect_bounce',
          'name': 'Bounce',
          'icon': Icons.sports_basketball,
          'description': 'Bouncing animation effect',
          'settings': ['Height', 'Speed', 'Damping'],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                    widget.onShowSettingsChanged(false);
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
                    widget.onShowSettingsChanged(_selectedAnimation != null);
                    widget.onAnimationSelected(_selectedAnimation);
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
}
