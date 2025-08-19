import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/accessibility/accessibility_floating_button.dart';
import '../../../../../core/navigation/route_names.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, dynamic>? _getProjectData() {
    final projects = [
      {
        'id': 'brain4goals',
        'title': 'Brain4Goals App',
        'description':
            'A comprehensive sports management application with community features, profile management, and activity tracking.',
        'longDescription': '''
Brain4Goals is a comprehensive sports management application designed to help athletes, coaches, and sports organizations track performance, manage training programs, and build community engagement.

Key Features:
• Community leaderboards and social features
• Performance tracking and analytics
• Training program management
• Real-time notifications and updates
• Cross-platform compatibility
• Accessibility features for inclusive design

Technologies Used:
• Flutter for cross-platform development
• Firebase for backend services
• Real-time database for live updates
• Push notifications for engagement
• Custom UI components and animations
        ''',
        'technologies': ['Flutter', 'Firebase', 'Dart', 'Provider'],
        'features': [
          'Community Management',
          'Performance Tracking',
          'Real-time Updates',
          'Cross-platform',
          'Accessibility',
        ],
      },
      {
        'id': 'ecommerce',
        'title': 'E-commerce Platform',
        'description':
            'Modern online shopping experience with product catalog, shopping cart, and secure payment processing.',
        'longDescription': '''
A comprehensive e-commerce platform designed to provide a seamless online shopping experience. This application features a modern, user-friendly interface with advanced functionality for both customers and administrators.

Key Features:
• Product catalog with search and filtering
• Shopping cart and wishlist management
• Secure payment processing
• Order tracking and history
• User reviews and ratings
• Admin dashboard for inventory management

Technologies Used:
• Flutter for cross-platform development
• Node.js backend with Express
• MongoDB for database management
• Stripe for payment processing
• AWS for cloud hosting and storage
        ''',
        'technologies': ['Flutter', 'Node.js', 'MongoDB', 'Stripe', 'AWS'],
        'features': [
          'Product Management',
          'Payment Processing',
          'Order Tracking',
          'User Reviews',
          'Admin Dashboard',
        ],
      },
      {
        'id': 'social_media',
        'title': 'Social Media App',
        'description':
            'Connect with friends, share moments, and discover content in a modern social networking platform.',
        'longDescription': '''
A modern social media application that enables users to connect, share, and discover content in an engaging and interactive environment. The platform focuses on user experience and community building.

Key Features:
• User profiles and friend connections
• Photo and video sharing
• Real-time messaging and notifications
• Content discovery and recommendations
• Privacy controls and security features
• Cross-platform synchronization

Technologies Used:
• Flutter for mobile and web development
• Firebase for real-time database and authentication
• Cloud Storage for media files
• Push notifications for engagement
• Machine learning for content recommendations
        ''',
        'technologies': ['Flutter', 'Firebase', 'Cloud Storage', 'ML Kit'],
        'features': [
          'Social Networking',
          'Media Sharing',
          'Real-time Messaging',
          'Content Discovery',
          'Privacy Controls',
        ],
      },
      {
        'id': 'weather',
        'title': 'Weather App',
        'description':
            'Beautiful weather application with real-time forecasts, location-based services, and detailed meteorological data.',
        'longDescription': '''
A comprehensive weather application that provides accurate, real-time weather information with beautiful visualizations and detailed meteorological data. The app offers location-based services and personalized weather insights.

Key Features:
• Real-time weather data and forecasts
• Location-based weather services
• Detailed meteorological information
• Weather alerts and notifications
• Beautiful weather visualizations
• Multiple location support

Technologies Used:
• Flutter for cross-platform development
• OpenWeatherMap API for weather data
• Geolocation services
• Custom weather animations
• Local storage for offline access
        ''',
        'technologies': ['Flutter', 'OpenWeatherMap API', 'Geolocation'],
        'features': [
          'Real-time Weather',
          'Location Services',
          'Weather Alerts',
          'Visual Forecasts',
          'Multiple Locations',
        ],
      },
      {
        'id': 'music_player',
        'title': 'Music Player',
        'description':
            'Feature-rich music player with playlist management, audio controls, and a beautiful user interface.',
        'longDescription': '''
A sophisticated music player application that offers a premium listening experience with advanced audio controls, playlist management, and a beautiful, intuitive user interface designed for music enthusiasts.

Key Features:
• Advanced audio playback controls
• Playlist creation and management
• Audio equalizer and sound effects
• Background playback support
• Music library organization
• Cross-device synchronization

Technologies Used:
• Flutter for cross-platform development
• Audio plugins for playback control
• Local storage for music files
• Cloud storage integration
• Audio processing libraries
        ''',
        'technologies': ['Flutter', 'Audio Plugins', 'Local Storage'],
        'features': [
          'Audio Playback',
          'Playlist Management',
          'Audio Equalizer',
          'Background Play',
          'Music Library',
        ],
      },
      {
        'id': 'task_manager',
        'title': 'Task Manager',
        'description':
            'Productivity app for task management, project organization, and team collaboration with intuitive workflows.',
        'longDescription': '''
A comprehensive task management application designed to boost productivity through intuitive project organization, team collaboration, and efficient workflow management. Perfect for both individual users and teams.

Key Features:
• Task creation and organization
• Project management and timelines
• Team collaboration tools
• Progress tracking and analytics
• Reminder and notification system
• Cross-platform synchronization

Technologies Used:
• Flutter for cross-platform development
• Firebase for real-time collaboration
• Local storage for offline access
• Push notifications for reminders
• Data synchronization services
        ''',
        'technologies': ['Flutter', 'Firebase', 'Local Storage'],
        'features': [
          'Task Management',
          'Project Organization',
          'Team Collaboration',
          'Progress Tracking',
          'Reminder System',
        ],
      },
      {
        'id': 'fitness_tracker',
        'title': 'Fitness Tracker',
        'description':
            'Comprehensive fitness tracking with workout plans, progress monitoring, and health analytics.',
        'longDescription': '''
A comprehensive fitness tracking application that helps users achieve their health and fitness goals through detailed workout tracking, progress monitoring, and personalized health analytics. The app provides motivation and insights for a healthier lifestyle.

Key Features:
• Workout tracking and planning
• Progress monitoring and analytics
• Health metrics and goal setting
• Social features and challenges
• Integration with wearable devices
• Personalized recommendations

Technologies Used:
• Flutter for cross-platform development
• Health and fitness APIs
• Wearable device integration
• Data analytics and visualization
• Cloud storage for user data
        ''',
        'technologies': ['Flutter', 'Health APIs', 'Wearable Integration'],
        'features': [
          'Workout Tracking',
          'Progress Analytics',
          'Health Metrics',
          'Social Features',
          'Device Integration',
        ],
      },
    ];

    try {
      return projects.firstWhere(
        (project) => project['id'] == widget.projectId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final project = _getProjectData();
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (project == null) {
      return Scaffold(
        backgroundColor: AppTheme.projectsBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.projectsBackground,
          elevation: 0,
          leading: AccessibleCustomCursor(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
              onPressed: () => context.go(RouteNames.portfolio),
            ),
          ),
          title: Text(
            'Project Not Found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.navy,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Project not found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The project you are looking for does not exist.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.portfolio),
                child: const Text('Back to Portfolio'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.projectsBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.projectsBackground,
        elevation: 0,
        leading: AccessibleCustomCursor(
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
            onPressed: () => context.go(RouteNames.portfolio),
          ),
        ),
        title: Text(
          project['title'],
          style: theme.textTheme.headlineSmall?.copyWith(color: AppTheme.navy),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 60,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Title
              Text(
                project['title'],
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Project Description
              Text(
                project['longDescription'],
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Technologies Section
              Text(
                'Technologies Used',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (project['technologies'] as List<String>).map((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.navy.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.navy.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      tech,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Features Section
              Text(
                'Key Features',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...(project['features'] as List<String>).map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.navy, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 40),

              // Back to Portfolio Button
              Center(
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.portfolio),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Back to Portfolio',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
