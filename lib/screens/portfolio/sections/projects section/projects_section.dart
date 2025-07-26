import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/helpers/frame_container.dart';
import '../../../../core/accessibility/accessibility_floating_button.dart';
import 'project_page_arrow.dart';
import 'demos/b4s demo/b4s_demo.dart';
import 'demos/ecommerce_demo/ecommerce_demo.dart';
import 'demos/social_media_demo/social_media_demo.dart';
import 'demos/weather_demo/weather_demo.dart';
import 'demos/music_player_demo/music_player_demo.dart';
import 'demos/task_manager_demo/task_manager_demo.dart';
import 'demos/fitness_tracker_demo/fitness_tracker_demo.dart';
part 'projects_section_aux.dart';

class ProjectsSection extends StatefulWidget {
  final Function(String)? onSectionTap; // Add this parameter

  const ProjectsSection({
    super.key,
    this.onSectionTap, // Add this parameter
  });

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final List<Map<String, dynamic>> projects = [
    {
      'title': 'Brain4Goals App',
      'description':
          'A comprehensive sports management application with community features, profile management, and activity tracking.',
      'frame': 'assets/device_frames/phone_frame.png',
      'demo': const Brain4GoalsDemo(),
    },
    {
      'title': 'E-commerce Platform',
      'description':
          'Modern online shopping experience with product catalog, shopping cart, and secure payment processing.',
      'frame': 'assets/device_frames/laptop_frame.png',
      'demo': const EcommerceDemo(),
    },
    {
      'title': 'Social Media App',
      'description':
          'Connect with friends and share moments through posts, likes, and real-time messaging.',
      'frame': 'assets/device_frames/phone_frame.png',
      'demo': const SocialMediaDemo(),
    },
    {
      'title': 'Weather Forecast',
      'description':
          'Real-time weather information with detailed forecasts, location-based alerts, and beautiful UI.',
      'frame': 'assets/device_frames/phone_frame.png',
      'demo': const WeatherDemo(),
    },
    {
      'title': 'Music Player',
      'description':
          'Premium music streaming experience with playlists, offline mode, and high-quality audio.',
      'frame': 'assets/device_frames/phone_frame.png',
      'demo': const MusicPlayerDemo(),
    },
    {
      'title': 'Task Manager',
      'description':
          'Organize your life with intuitive task management, priority levels, and progress tracking.',
      'frame': 'assets/device_frames/laptop_frame.png',
      'demo': const TaskManagerDemo(),
    },
    {
      'title': 'Fitness Tracker',
      'description':
          'Monitor your health and fitness goals with step counting, calorie tracking, and workout plans.',
      'frame': 'assets/device_frames/phone_frame.png',
      'demo': const FitnessTrackerDemo(),
    },
  ];
  int _currentPage = 0;
  bool _isPageAnimating = false;
  final PageController _pageController = PageController();

  void _onDotTap(int i) async {
    if (_isPageAnimating) return;
    setState(() => _isPageAnimating = true);
    await _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // _isPageAnimating will be set to false in onPageChanged
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;

    return AccessiblePageStructure(
      structureItems: [
        PageStructureItem(
          label: 'projects-section', // Will be localized dynamically
          type: PageStructureType.section,
          level: 1,
          sectionId: "projects",
        ),
        PageStructureItem(
          label: 'projects-title', // Will be localized dynamically
          type: PageStructureType.heading,
          level: 2,
          sectionId: "projects-title",
        ),
        PageStructureItem(
          label: 'projects-description', // Will be localized dynamically
          type: PageStructureType.main,
          level: 2,
          sectionId: "projects-description",
        ),
        PageStructureItem(
          label: 'project-b4s', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-b4s",
        ),
        PageStructureItem(
          label: 'project-ecommerce', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-ecommerce",
        ),
        PageStructureItem(
          label: 'project-social', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-social",
        ),
        PageStructureItem(
          label: 'project-weather', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-weather",
        ),
        PageStructureItem(
          label: 'project-music', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-music",
        ),
        PageStructureItem(
          label: 'project-task', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-task",
        ),
        PageStructureItem(
          label: 'project-fitness', // Will be localized dynamically
          type: PageStructureType.article,
          level: 3,
          sectionId: "project-fitness",
        ),
      ],
      onSectionTap: widget.onSectionTap, // Pass the navigation callback
      currentLocale: Localizations.localeOf(context), // Pass the current locale
      child: Semantics(
        label: SemanticLabels.projectsSection,
        child: Container(
          width: double.infinity,
          height: isTablet
              ? screenHeight * 2
              : (MediaQuery.of(context).size.width >= 1024
                    ? screenHeight * 1.2
                    : screenHeight),
          color: AppTheme.projectsBackground,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : 60,
            vertical: isMobile ? 0 : 40,
          ),
          child: Stack(
            children: [
              // Contenido principal
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  AccessibleText(
                    l10n.projectsTitle,
                    semanticsLabel: SemanticLabels.sectionTitle,
                    baseFontSize:
                        theme.textTheme.headlineMedium?.fontSize ?? 24,
                    fontWeight: theme.textTheme.headlineMedium?.fontWeight,
                  ),
                  const SizedBox(height: 12),
                  AccessibleText(
                    l10n.projectsSubtitle,
                    semanticsLabel: SemanticLabels.sectionDescription,
                    baseFontSize: theme.textTheme.bodyLarge?.fontSize ?? 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  isTablet
                      ? _tabletProjectsPageView(
                          state: this,
                          isMobile: isMobile,
                          projects: projects,
                          currentPage: _currentPage,
                          pageController: _pageController,
                          onPageChanged: (i) {
                            setState(() {
                              _currentPage = i;
                              _isPageAnimating = false;
                            });
                          },
                        )
                      : _desktopMobileProjectsPageView(
                          state: this,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          projects: projects,
                          currentPage: _currentPage,
                          pageController: _pageController,
                          onPageChanged: (i) {
                            setState(() {
                              _currentPage = i;
                              _isPageAnimating = false;
                            });
                          },
                        ),
                  const SizedBox(height: 12),
                  _buildPageIndicators(this),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
