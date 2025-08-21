class RouteNames {
  // Main routes
  static const String mainSelection = '/';
  static const String portfolio = '/portfolio';
  static const String lab = '/lab';

  // Portfolio sub-routes (if needed in the future)
  static const String portfolioHome = '/portfolio/home';
  static const String portfolioAbout = '/portfolio/about';
  static const String portfolioProjects = '/portfolio/projects';
  static const String portfolioContact = '/portfolio/contact';

  // Project detail route
  static const String projectDetail = '/project/:id';

  // Lab sub-routes (if needed in the future)
  static const String labMain = '/lab/main';
  static const String labExperiment = '/lab/experiment';

  // Lab experiment routes
  static const String textOrderVisualizer = '/lab/experiments/text-order-visualizer';
  static const String animationEditor = '/lab/experiments/animation-editor';
  static const String diyInboxCleaner = '/lab/experiments/diy-inbox-cleaner';

  // Error routes
  static const String notFound = '/404';
}
