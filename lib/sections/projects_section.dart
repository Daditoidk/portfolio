import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/semantic_labels.dart';
import '../theme/app_theme.dart';
import '../helpers/frame_container.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> projects = List.generate(
    7,
    (index) => {
      'title': 'Project ${index + 1}',
      'description': 'This is a description for project ${index + 1}.',
      'frame':
          index % 2 == 0 ? 'assets/phone_frame.png' : 'assets/laptop_frame.png',
    },
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: SemanticLabels.projectsSection,
      child: Container(
        width: double.infinity,
        height:
            isTablet
                ? screenHeight * 2
                : (MediaQuery.of(context).size.width >= 1024
                    ? screenHeight * 1.5
                    : screenHeight),
        color: AppTheme.projectsBackground,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 60,
          vertical: isMobile ? 0 : 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Semantics(
              label: SemanticLabels.sectionTitle,
              child: Text(
                l10n.projectsTitle,
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: SemanticLabels.sectionDescription,
              child: Text(
                l10n.projectsSubtitle,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            isTablet
                ? Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: isMobile ? 30.0 : 20.0,
                          right: 20.0,
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: projects.length,
                          onPageChanged:
                              (i) => setState(() => _currentPage = i),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return isMobile
                                ? _buildMobileProjectPage(context, project)
                                : isTablet
                                ? _buildTabletProjectPage(context, project)
                                : _buildDesktopProjectPage(context, project);
                          },
                        ),
                      ),
                      // Left arrow
                      if (_currentPage > 0)
                        ProjectPageArrow(
                          isLeft: true,
                          onPressed: () {
                            if (_currentPage > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      // Right arrow
                      if (_currentPage < projects.length - 1)
                        ProjectPageArrow(
                          isLeft: false,
                          onPressed: () {
                            if (_currentPage < projects.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                    ],
                  ),
                )
                : SizedBox(
                  height:
                      isMobile
                          ? 320
                          : isTablet
                          ? 420
                          : 420 * 1.35,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: isMobile ? 30.0 : 20.0,
                          right: 20.0,
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: projects.length,
                          onPageChanged:
                              (i) => setState(() => _currentPage = i),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return isMobile
                                ? _buildMobileProjectPage(context, project)
                                : isTablet
                                ? _buildTabletProjectPage(context, project)
                                : _buildDesktopProjectPage(context, project);
                          },
                        ),
                      ),
                      // Left arrow
                      if (_currentPage > 0)
                        ProjectPageArrow(
                          isLeft: true,
                          onPressed: () {
                            if (_currentPage > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      // Right arrow
                      if (_currentPage < projects.length - 1)
                        ProjectPageArrow(
                          isLeft: false,
                          onPressed: () {
                            if (_currentPage < projects.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                projects.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPage ? AppTheme.navy : Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopProjectPage(
    BuildContext context,
    Map<String, dynamic> project,
  ) {
    final theme = Theme.of(context);
    final isPhone = project['frame'].contains('phone');
    final isLaptop = project['frame'].contains('laptop');
    // Si es phone, frame a la izquierda, texto a la derecha; si no, texto a la izquierda, frame a la derecha
    final frameWidget =
        isPhone
            ? Expanded(
              flex: 2,
              child: Center(
                child: FrameContainer(
                  frameAsset: project['frame'],
                  width: 370,
                  height: 655,
                  overlayPadding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
                  borderRadius: BorderRadius.circular(32),
                  child: const Center(
                    child: Text(
                      'Hello world',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
            : Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 64.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double frameWidth =
                        constraints.maxWidth * 0.98; // leave a little margin
                    final double frameHeight = constraints.maxHeight * 0.98;
                    return Center(
                      child: FrameContainer(
                        frameAsset: project['frame'],
                        width: frameWidth,
                        height: frameHeight,
                        overlayPadding: EdgeInsets.fromLTRB(
                          frameWidth * 0.10,
                          frameHeight * 0.08,
                          frameWidth * 0.10,
                          frameHeight * 0.14,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        child: const Center(
                          child: Text(
                            'Hello world',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
    final textWidget = Expanded(
      flex: 2,
      child: Container(
        color: Colors.blue.withOpacity(0.1), // Visual debug color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project['title'], style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(project['description'], style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () {}, child: const Text('Know More')),
            ],
          ),
        ),
      ),
    );
    return Container(
      color: Colors.amber,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment:
                isPhone ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children:
                isPhone
                    ? [
                      SizedBox(width: 60),
                      frameWidget,
                      SizedBox(width: 40),
                      textWidget,
                    ]
                    : [textWidget, frameWidget],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProjectPage(
    BuildContext context,
    Map<String, dynamic> project,
  ) {
    final theme = Theme.of(context);
    // Only show the text instead of the demo view on mobile
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
          child: Container(
              padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Demo available in tablet or desktop device',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.red.withValues(alpha: 0.5),
                  shadows: [
                    Shadow(
                      color: AppTheme.red.withOpacity(0.2),
                      blurRadius: 200,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Bottom: Text and button
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project['title'], style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(project['description'], style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Know More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tablet: Column layout (frame on top, text below)
  Widget _buildTabletProjectPage(
    BuildContext context,
    Map<String, dynamic> project,
  ) {
    final theme = Theme.of(context);
    final isPhone = project['frame'].contains('phone');
    final isLaptop = project['frame'].contains('laptop');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: FrameContainer(
            frameAsset: project['frame'],
            width: 400,
            height: 600,
            overlayPadding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            borderRadius: BorderRadius.circular(24),
            child: const Center(
              child: Text(
                'Hello world',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project['title'], style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(project['description'], style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () {}, child: const Text('Know More')),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for the left/right arrow buttons in the PageView
class ProjectPageArrow extends StatelessWidget {
  final bool isLeft;
  final VoidCallback onPressed;
  const ProjectPageArrow({
    required this.isLeft,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? 10 : null,
      right: isLeft ? null : 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(
                isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              ),
              padding: isLeft ? EdgeInsets.only(left: 10) : EdgeInsets.zero,
              iconSize: 32,
              color: AppTheme.navy,
              splashRadius: 24,
              alignment: Alignment.center,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to handle height logic for the project section
class ProjectSectionContainer extends StatelessWidget {
  final bool isMobile;
  final Widget child;
  const ProjectSectionContainer({
    required this.isMobile,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Container(
        width: double.infinity,
        color: AppTheme.projectsBackground,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: child,
      );
    } else {
      return Container(
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height < 1055
                ? 1055
                : MediaQuery.of(context).size.height,
        color: AppTheme.projectsBackground,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: child,
      );
    }
  }
}
