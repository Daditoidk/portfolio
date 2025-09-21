import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/pages/portfolio_screen.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/theme/index.dart';
import '../../apps/main selection/main_selection_screen.dart';
import '../../apps/lab/lab_screen.dart';
import '../../apps/portfolio_v2/data/models/project.dart';
import '../../apps/portfolio_v2/data/providers/project_providers.dart';
import '../../apps/portfolio_v2/presentation/sections/projects/project_detail_screen.dart';
import '../../apps/lab/experiments_grid/text_order_visualizer/editor/text_order_visualizer.dart';
import '../../apps/lab/experiments_grid/animation_editor/animation_editor_screen.dart';
import '../../apps/lab/experiments_grid/diy_inbox_cleaner/diy_inbox_cleaner_screen.dart';

part '../navigation/route_names_and paths.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: RoutesPaths.mainSelection,
      debugLogDiagnostics: true,
      routes: [
        // Main Selection Screen
        GoRoute(
          name: RouteNames.mainSelection,

          path: RoutesPaths.mainSelection,
          builder: (context, state) => const MainSelectionScreen(),
        ),

        // Portfolio Screen
        GoRoute(
          name: RouteNames.portfolio,

          path: RoutesPaths.portfolio,
          builder: (context, state) => const PortfolioV2Screen(),
          routes: [
            GoRoute(
              name: RouteNames.projectDetail,
              path: '${RoutesPaths.projects}/:id',
              builder: (context, state) {
                final projectId = state.pathParameters['id'] ?? '';
                // Try to get project from extra first, fallback to ID
                final projectFromExtra = state.extra as Project?;

                if (projectFromExtra != null) {

                  return ProjectDetailScreen(project: projectFromExtra);
                } else if (projectId.isEmpty) {
                  // If no project in extra, we could fetch by ID here
                  // For now, return an error screen
                  return projectNotFound(projectId);
                } else {
                  return Consumer(
                    builder: (context, ref, child) {
                      final projects = ref.read(projectsProvider);

                      // You can use a try-catch to handle the not found case.
                      try {
                        final project = projects.firstWhere(
                          (p) => p.id == projectId,
                          orElse: () => throw Exception('Project not found'),
                        );
                        // Now you can safely pass the project data to your screen.
                        return ProjectDetailScreen(project: project);
                      } catch (e) {
                        return projectNotFound(projectId);
                      }

                      // Your logic for the `localizedProjectsProvider` would look like this:
                      // final l10n = AppLocalizations.of(context);
                      // final localizedProjects = ref.read(localizedProjectsProvider(l10n!));
                    },
                  );
                }
              },
            ),
          ],
        ),

        // Lab Screen
        GoRoute(
          name: RouteNames.lab,
          path: RoutesPaths.lab,
          builder: (context, state) => const LabScreen(),
          routes: [
            GoRoute(
              name: RouteNames.textOrderVisualizer,
              path: RoutesPaths.textOrderVisualizer,
              builder: (context, state) => const TextOrderVisualizer(),
            ),

            GoRoute(
              name: RouteNames.animationEditor,
              path: RoutesPaths.animationEditor,
              builder: (context, state) => const AnimationEditorScreen(),
            ),

            GoRoute(
              name: RouteNames.diyInboxCleaner,
              path: RoutesPaths.diyInboxCleaner,
              builder: (context, state) => const DIYInboxCleanerScreen(),
            ),
          ],
        ),
      ],

      // Error handling
      errorBuilder: (context, state) => _buildErrorScreen(context, state),
    );
  }

  static Scaffold projectNotFound(String projectId) {
    return Scaffold(
      backgroundColor: PortfolioTheme.bgColor,
      body: Center(
        child: Text(
          'Project not found: $projectId',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.mainSelection),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
