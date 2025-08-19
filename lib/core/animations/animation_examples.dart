import 'package:flutter/material.dart';
import 'animation_controller.dart';
import 'scroll_animations.dart';
import 'animation_mixins.dart';
import 'language_change_animation.dart';

/// Example widget showing how to use the animation system
class AnimationExamples extends StatelessWidget {
  const AnimationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Examples')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Example 1: Simple fade in animation
            FadeInAnimation(
              duration: const Duration(milliseconds: 1000),
              slideDirection: SlideDirection.fromBottom,
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Fade In Animation',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            // Example 2: Staggered animation for list
            StaggeredAnimation(
              delayBetweenItems: const Duration(milliseconds: 150),
              children: List.generate(
                5,
                (index) => Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100 + (index * 50)],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Staggered Item ${index + 1}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),

            // Example 3: Parallax animation
            SizedBox(
              height: 200,
              child: ParallaxAnimation(
                parallaxFactor: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.pink],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Parallax Effect',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),

            // Example 4: Custom animation with settings
            ScrollTriggeredAnimation(
              settings: const AnimationSettings.fast(
                trigger: AnimationTriggerSettings(
                  useViewport: true,
                  viewportDelay: Duration(milliseconds: 200),
                ),
              ),
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Custom Settings Animation',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            // Example 5: Language change animation trigger
            Container(
              height: 100,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Trigger language change animation
                  LanguageChangeAnimationController().animateLanguageChange(
                    context: context,
                    settings: const LanguageChangeSettings.fast(),
                    onComplete: () {
                      print('Language change animation completed');
                    },
                  );
                },
                child: const Text('Trigger Language Change Animation'),
              ),
            ),

            // Example 6: Scramble text widget
            Container(
              padding: const EdgeInsets.all(16),
              child: const ScrambleText(
                text: 'This text can scramble!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                scrambleType: ScrambleType.mixed,
                isAnimating: false, // Set to true to see scramble effect
              ),
            ),

            const SizedBox(height: 100), // Extra space for scrolling
          ],
        ),
      ),
    );
  }
}

/// Example widget using animation mixins
class AnimatedCard extends StatefulWidget {
  final String title;
  final String content;

  const AnimatedCard({super.key, required this.title, required this.content});

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with FadeInAnimationMixin, SlideAnimationMixin {
  @override
  void initState() {
    super.initState();

    // Initialize animations
    initFadeAnimation(
      duration: const Duration(milliseconds: 800),
      triggerOnViewport: true,
    );

    initSlideAnimation(
      duration: const Duration(milliseconds: 800),
      direction: SlideDirection.fromRight,
      triggerOnViewport: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: fadeValue,
          child: Transform.translate(
            offset: slideValue,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.content),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Example of how to integrate with accessibility
class AccessibleAnimationExample extends StatelessWidget {
  const AccessibleAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // This animation will respect the accessibility skip setting
        FadeInAnimation(
          duration: const Duration(milliseconds: 800),
          triggerOnViewport: true,
          child: Container(
            height: 100,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Accessible Animation',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),

        // Language change button that integrates with accessibility
        ElevatedButton(
          onPressed: () {
            // This will check the accessibility skip setting automatically
            LanguageChangeAnimationController().animateLanguageChange(
              context: context,
              settings: const LanguageChangeSettings(
                strategy: LanguageChangeStrategy.readingWave,
                scrambleType: ScrambleType.morphing,
              ),
              onComplete: () {
                // Handle language change completion
                print('Language changed with accessibility support');
              },
            );
          },
          child: const Text('Change Language (Accessible)'),
        ),
      ],
    );
  }
}
