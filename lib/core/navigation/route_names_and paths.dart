part of 'app_router.dart';

// This class will hold all the PATH strings for your routes.
// These are the actual URL segments.
class RoutesPaths {
  // Main routes
  static const String mainSelection = '/';
  static const String portfolio = '/portfolio';
  static const String lab = '/lab';

  // Path segments for nested routes (no leading slash)
  static const String projects = 'projects';

  // Specific lab experiment paths (for direct access/deep linking if needed)
  static const String textOrderVisualizer = 'experiments/text-order-visualizer';
  static const String animationEditor = 'experiments/animation-editor';
  static const String diyInboxCleaner = 'experiments/diy-inbox-cleaner';

  // Error paths
  static const String notFound = '/404';
}

// This class will hold all the NAVIGATION NAMES.
// These are the unique identifiers used in pushNamed() and goNamed().
// It's a good practice to use unique, descriptive names for all routes.
class RouteNames {
  // Main routes
  static const String mainSelection = 'main-selection';
  static const String portfolio = 'portfolio-page';
  static const String lab = 'lab-page';

  // Nested routes
  static const String projectDetail = 'project-detail-page';
  static const String textOrderVisualizer = 'text-order-visualizer-page';
  static const String animationEditor = 'animation-editor-page';
  static const String diyInboxCleaner = 'diy-inbox-cleaner-page';

  // Error routes
  static const String notFound = 'not-found-page';
}
