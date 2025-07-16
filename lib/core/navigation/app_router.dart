import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/main_selection_screen.dart';
import '../../screens/portfolio/portfolio_screen.dart';
import '../../screens/lab/lab_screen.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: RouteNames.mainSelection,
      routes: [
        // Main Selection Screen
        GoRoute(
          path: RouteNames.mainSelection,
          name: 'main-selection',
          builder: (context, state) => const MainSelectionScreen(),
        ),

        // Portfolio Screen
        GoRoute(
          path: RouteNames.portfolio,
          name: 'portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),

        // Lab Screen
        GoRoute(
          path: RouteNames.lab,
          name: 'lab',
          builder: (context, state) => const LabScreen(),
        ),

        // Portfolio sub-routes (for future use)
        GoRoute(
          path: RouteNames.portfolioHome,
          name: 'portfolio-home',
          builder: (context, state) => const PortfolioScreen(),
        ),

        GoRoute(
          path: RouteNames.portfolioAbout,
          name: 'portfolio-about',
          builder: (context, state) => const PortfolioScreen(),
        ),

        GoRoute(
          path: RouteNames.portfolioProjects,
          name: 'portfolio-projects',
          builder: (context, state) => const PortfolioScreen(),
        ),

        GoRoute(
          path: RouteNames.portfolioContact,
          name: 'portfolio-contact',
          builder: (context, state) => const PortfolioScreen(),
        ),

        // Lab sub-routes (for future use)
        GoRoute(
          path: RouteNames.labMain,
          name: 'lab-main',
          builder: (context, state) => const LabScreen(),
        ),

        GoRoute(
          path: RouteNames.labExperiment,
          name: 'lab-experiment',
          builder: (context, state) => const LabScreen(),
        ),
      ],

      // Error handling
      errorBuilder: (context, state) => _buildErrorScreen(context, state),

      // Redirect logic (if needed)
      redirect: (context, state) {
        // Add any redirect logic here if needed
        return null;
      },
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
