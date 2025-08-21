import 'package:flutter/material.dart';
import 'viewport_animation_system.dart';
import 'json_layout_integrator.dart';
import 'language_change_animation.dart';

/// Demo widget to test viewport-aware animations
class ViewportAnimationDemo extends StatefulWidget {
  const ViewportAnimationDemo({super.key});

  @override
  State<ViewportAnimationDemo> createState() => _ViewportAnimationDemoState();
}

class _ViewportAnimationDemoState extends State<ViewportAnimationDemo> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _jsonController = TextEditingController();

  String _demoJson = '';
  bool _isJsonLoaded = false;
  String _statusMessage = 'Ready to test animations';
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _loadDemoJson();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  /// Load demo JSON configuration
  void _loadDemoJson() {
    _demoJson = '''
{
  "lines": [
    {
      "order": 0,
      "yPosition": 18.5,
      "height": 40.0,
      "detectedTexts": [
        {
          "id": "text_portfolio",
          "text": "Portfolio",
          "x": 100.0,
          "y": 18.5
        }
      ]
    },
    {
      "order": 1,
      "yPosition": 413.0,
      "height": 40.0,
      "detectedTexts": [
        {
          "id": "text_camilo",
          "text": "Camilo Santacruz",
          "x": 200.0,
          "y": 413.0
        }
      ]
    }
  ],
  "sections": [
    {
      "name": "Navigation",
      "order": 0,
      "lineIds": ["line_0"],
      "lineOrders": [0],
      "color": 4280391411
    },
    {
      "name": "Header",
      "order": 1,
      "lineIds": ["line_1"],
      "lineOrders": [1],
      "color": 4280391411
    }
  ]
}
''';

    _jsonController.text = _demoJson;
  }

  /// Load JSON configuration
  Future<void> _loadJsonConfiguration() async {
    setState(() {
      _statusMessage = 'Loading configuration...';
    });

    try {
      final integrator = JsonLayoutIntegrator();
      final success = await integrator.loadLayoutFromJson(_jsonController.text);

      if (success) {
        setState(() {
          _isJsonLoaded = true;
          _statusMessage = 'Configuration loaded successfully!';
        });

        // Apply to registry
        await integrator.applyConfigurationToRegistry();

        setState(() {
          _statusMessage = 'Configuration applied to registry!';
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to load configuration';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  /// Test viewport animation
  Future<void> _testViewportAnimation(LanguageChangeStrategy strategy) async {
    if (!_isJsonLoaded) {
      setState(() {
        _statusMessage = 'Please load JSON configuration first';
      });
      return;
    }

    setState(() {
      _isAnimating = true;
      _statusMessage = 'Testing $strategy animation...';
    });

    try {
      final viewportSystem = ViewportAnimationSystem();

      await viewportSystem.animateLanguageChangeViewportAware(
        context: context,
        scrollController: _scrollController,
        viewportHeight: MediaQuery.of(context).size.height,
        appBarHeight: kToolbarHeight,
        strategy: strategy,
        onComplete: () {
          setState(() {
            _isAnimating = false;
            _statusMessage = '$strategy animation completed!';
          });
        },
      );
    } catch (e) {
      setState(() {
        _isAnimating = false;
        _statusMessage = 'Animation error: $e';
      });
    }
  }

  /// Test language change animation controller
  Future<void> _testLanguageChangeController(
    LanguageChangeStrategy strategy,
  ) async {
    if (!_isJsonLoaded) {
      setState(() {
        _statusMessage = 'Please load JSON configuration first';
      });
      return;
    }

    setState(() {
      _isAnimating = true;
      _statusMessage = 'Testing controller $strategy animation...';
    });

    try {
      final controller = LanguageChangeAnimationController();

      await controller.animateLanguageChangeViewportAware(
        context: context,
        scrollController: _scrollController,
        viewportHeight: MediaQuery.of(context).size.height,
        appBarHeight: kToolbarHeight,
        strategy: strategy,
        onComplete: () {
          setState(() {
            _isAnimating = false;
            _statusMessage = 'Controller $strategy animation completed!';
          });
        },
      );
    } catch (e) {
      setState(() {
        _isAnimating = false;
        _statusMessage = 'Controller animation error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewport Animation Demo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // Left panel: Controls and JSON input
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              color: _isAnimating
                                  ? Colors.orange
                                  : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                _isJsonLoaded
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: _isJsonLoaded
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isJsonLoaded
                                    ? 'JSON Loaded'
                                    : 'JSON Not Loaded',
                                style: TextStyle(
                                  color: _isJsonLoaded
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // JSON Configuration
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JSON Configuration',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: TextField(
                                controller: _jsonController,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      'Paste your JSON configuration here...',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _loadJsonConfiguration,
                                icon: const Icon(Icons.upload),
                                label: const Text('Load Configuration'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right panel: Demo content and animation tests
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animation Test Controls
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Viewport Animations',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Strategy selection
                          Row(
                            children: [
                              const Text('Strategy: '),
                              const SizedBox(width: 8),
                              DropdownButton<LanguageChangeStrategy>(
                                value:
                                    LanguageChangeStrategy.cascadeTopToBottom,
                                onChanged: (strategy) {
                                  if (strategy != null) {
                                    _testViewportAnimation(strategy);
                                  }
                                },
                                items: LanguageChangeStrategy.values.map((
                                  strategy,
                                ) {
                                  return DropdownMenuItem(
                                    value: strategy,
                                    child: Text(strategy.name),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Test buttons
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _isJsonLoaded && !_isAnimating
                                    ? () => _testViewportAnimation(
                                        LanguageChangeStrategy
                                            .cascadeTopToBottom,
                                      )
                                    : null,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Cascade'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isJsonLoaded && !_isAnimating
                                    ? () => _testViewportAnimation(
                                        LanguageChangeStrategy.readingWave,
                                      )
                                    : null,
                                icon: const Icon(Icons.waves),
                                label: const Text('Reading Wave'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isJsonLoaded && !_isAnimating
                                    ? () => _testViewportAnimation(
                                        LanguageChangeStrategy.blockCascade,
                                      )
                                    : null,
                                icon: const Icon(Icons.layers),
                                label: const Text('Block Cascade'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _isJsonLoaded && !_isAnimating
                                    ? () => _testViewportAnimation(
                                        LanguageChangeStrategy.fadeInOut,
                                      )
                                    : null,
                                icon: const Icon(Icons.opacity),
                                label: const Text('Fade In/Out'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Controller test
                          Text(
                            'Test Language Change Controller',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _isJsonLoaded && !_isAnimating
                                    ? () => _testLanguageChangeController(
                                        LanguageChangeStrategy
                                            .cascadeTopToBottom,
                                      )
                                    : null,
                                icon: const Icon(Icons.control_camera),
                                label: const Text('Controller Cascade'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade600,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Demo content (scrollable)
                  Expanded(
                    child: Card(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Demo content that simulates the portfolio
                              _buildDemoSection('Navigation', 0, [
                                'Portfolio',
                                'Home',
                                'About',
                                'Skills',
                                'Resume',
                                'Projects',
                                'Contact',
                              ]),

                              const SizedBox(height: 100),

                              _buildDemoSection('Header', 1, [
                                'Camilo Santacruz Abadiano',
                                'Mobile Developer',
                                'Creating beautiful mobile experiences',
                              ]),

                              const SizedBox(height: 100),

                              _buildDemoSection('About', 2, [
                                'About Me',
                                'I am a curious person passionate about technology...',
                                'A tech enthusiast who believes in continuous learning...',
                              ]),

                              const SizedBox(height: 100),

                              _buildDemoSection('Skills', 3, [
                                'Skills & Technologies',
                                'My technical expertise and tools I work with',
                                'Programming Languages',
                                'Flutter',
                                'Dart',
                                'Kotlin',
                                'Swift',
                              ]),

                              const SizedBox(height: 100),

                              _buildDemoSection('Projects', 4, [
                                'My Projects',
                                'A selection of my recent projects',
                                'Brain4Goals App',
                                'A comprehensive sports management app...',
                              ]),

                              const SizedBox(height: 100),

                              _buildDemoSection('Contact', 5, [
                                'Get In Touch',
                                'Let\'s work together on your next project',
                                'Email: camilo@example.com',
                                'Phone: +57 3025298355',
                                'Location: Funza, Cundinamarca, Colombia',
                              ]),

                              const SizedBox(height: 100),
                            ],
                          ),
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
    );
  }

  /// Build demo section
  Widget _buildDemoSection(String title, int sectionIndex, List<String> texts) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          ...texts.map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
