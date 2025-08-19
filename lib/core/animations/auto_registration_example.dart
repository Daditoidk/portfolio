import 'package:flutter/material.dart';
import 'advanced_text_registry.dart';
import 'language_change_animation.dart';
import 'scroll_animations.dart';

/// Example widget demonstrating auto-registration of text elements
class AutoRegistrationExample extends StatefulWidget {
  const AutoRegistrationExample({super.key});

  @override
  State<AutoRegistrationExample> createState() => _AutoRegistrationExampleState();
}

class _AutoRegistrationExampleState extends State<AutoRegistrationExample> {
  final ScrollController _scrollController = ScrollController();
  String _debugInfo = '';
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    // Update debug info after widgets are built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDebugInfo();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateDebugInfo() {
    setState(() {
      _debugInfo = AdvancedTextRegistry().getDetailedDebugInfo();
      _statistics = AdvancedTextRegistry().getStatistics();
    });
  }

  void _triggerLanguageChange() {
    LanguageChangeAnimationController().animateLanguageChange(
      context: context,
      settings: const LanguageChangeSettings(
        strategy: LanguageChangeStrategy.readingWave,
      ),
      onComplete: () {
        print('Language change animation completed!');
        _updateDebugInfo();
      },
    );
  }

  void _triggerBlockCascade() {
    LanguageChangeAnimationController().animateLanguageChange(
      context: context,
      settings: const LanguageChangeSettings.fast(),
      onComplete: () {
        print('Block cascade animation completed!');
        _updateDebugInfo();
      },
    );
  }

  void _clearRegistry() {
    AdvancedTextRegistry().clear();
    _updateDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Registration Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateDebugInfo,
            tooltip: 'Refresh Debug Info',
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Header Section - Line 0
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AdvancedAnimatedText(
                    'Camilo Santacruz',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'header',
                    id: 'name',
                  ),
                  const SizedBox(height: 10),
                  AdvancedAnimatedText(
                    'Flutter Developer & UI/UX Designer',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    sectionId: 'header',
                    id: 'title',
                  ),
                ],
              ),
            ),

            // About Section - Line 1
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvancedAnimatedText(
                    'About Me',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'about',
                    id: 'section_title',
                  ),
                  const SizedBox(height: 15),
                  AdvancedAnimatedText(
                    'Passionate Flutter developer with expertise in creating beautiful, accessible, and performant applications.',
                    style: const TextStyle(fontSize: 16),
                    sectionId: 'about',
                    id: 'description',
                  ),
                ],
              ),
            ),

            // Skills Section - Line 2
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvancedAnimatedText(
                    'Skills',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'skills',
                    id: 'section_title',
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildSkillChip('Flutter'),
                      _buildSkillChip('Dart'),
                      _buildSkillChip('Firebase'),
                      _buildSkillChip('Git'),
                      _buildSkillChip('UI/UX Design'),
                      _buildSkillChip('Accessibility'),
                    ],
                  ),
                ],
              ),
            ),

            // Projects Section - Line 3
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvancedAnimatedText(
                    'Projects',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'projects',
                    id: 'section_title',
                  ),
                  const SizedBox(height: 15),
                  _buildProjectCard('Portfolio Website', 'A beautiful, accessible portfolio built with Flutter'),
                  const SizedBox(height: 10),
                  _buildProjectCard('E-commerce App', 'Full-featured e-commerce application with payment integration'),
                  const SizedBox(height: 10),
                  _buildProjectCard('Task Manager', 'Productive task management app with cloud sync'),
                ],
              ),
            ),

            // Contact Section - Line 4
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvancedAnimatedText(
                    'Contact',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'contact',
                    id: 'section_title',
                  ),
                  const SizedBox(height: 15),
                  AdvancedAnimatedText(
                    'Get in touch with me for collaboration opportunities.',
                    style: const TextStyle(fontSize: 16),
                    sectionId: 'contact',
                    id: 'description',
                  ),
                  const SizedBox(height: 10),
                  AdvancedAnimatedText(
                    'Email: camilo@example.com',
                    style: const TextStyle(fontSize: 16),
                    sectionId: 'contact',
                    id: 'email',
                  ),
                ],
              ),
            ),

            // Debug Information Panel
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvancedAnimatedText(
                    'Debug Information',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    sectionId: 'debug',
                    id: 'section_title',
                  ),
                  const SizedBox(height: 15),
                  
                  // Statistics
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Total Elements: ${_statistics['totalElements'] ?? 0}'),
                          Text('Total Lines: ${_statistics['totalLines'] ?? 0}'),
                          Text('Total Blocks: ${_statistics['totalBlocks'] ?? 0}'),
                          Text('Avg Elements/Line: ${(_statistics['averageElementsPerLine'] ?? 0).toStringAsFixed(1)}'),
                          Text('Avg Elements/Block: ${(_statistics['averageElementsPerBlock'] ?? 0).toStringAsFixed(1)}'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Action Buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _triggerLanguageChange,
                        child: const Text('Reading Wave'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _triggerBlockCascade,
                        child: const Text('Block Cascade'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _clearRegistry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Clear Registry'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Detailed Debug Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detailed Debug Info:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 300,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                _debugInfo,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Extra space for scrolling
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: AdvancedAnimatedText(
        skill,
        style: const TextStyle(fontSize: 14),
        sectionId: 'skills',
        id: 'skill_${skill.toLowerCase()}',
      ),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
    );
  }

  Widget _buildProjectCard(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdvancedAnimatedText(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              sectionId: 'projects',
              id: 'project_title_${title.toLowerCase().replaceAll(' ', '_')}',
            ),
            const SizedBox(height: 8),
            AdvancedAnimatedText(
              description,
              style: const TextStyle(fontSize: 14),
              sectionId: 'projects',
              id: 'project_desc_${title.toLowerCase().replaceAll(' ', '_')}',
            ),
          ],
        ),
      ),
    );
  }
}

/// Example showing how to use the system with scroll animations
class ScrollAnimationExample extends StatelessWidget {
  const ScrollAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scroll Animation Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fade in animations with auto-registered text
            FadeInAnimation(
              slideDirection: SlideDirection.fromBottom,
              child: AdvancedAnimatedText(
                'Welcome to My Portfolio',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                sectionId: 'scroll_demo',
                id: 'welcome_title',
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Staggered animation with auto-registered text
            StaggeredAnimation(
              children: [
                AdvancedAnimatedText(
                  'Feature 1: Auto-registration',
                  style: const TextStyle(fontSize: 18),
                  sectionId: 'scroll_demo',
                  id: 'feature_1',
                ),
                AdvancedAnimatedText(
                  'Feature 2: Line detection',
                  style: const TextStyle(fontSize: 18),
                  sectionId: 'scroll_demo',
                  id: 'feature_2',
                ),
                AdvancedAnimatedText(
                  'Feature 3: Block animation',
                  style: const TextStyle(fontSize: 18),
                  sectionId: 'scroll_demo',
                  id: 'feature_3',
                ),
              ],
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
} 