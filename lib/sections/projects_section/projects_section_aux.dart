part of 'projects_section.dart';

// All private helper methods for ProjectsSection

Widget _buildPageIndicatorDot({
  required bool isActive,
  required VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 14 : 10,
      height: isActive ? 14 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.navy : Colors.white70,
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: AppTheme.navy.withValues(alpha: 0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
                : [],
      ),
    ),
  );
}

Widget _buildPageIndicators(_ProjectsSectionState state) {
  return AbsorbPointer(
    absorbing: state._isPageAnimating,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        state.projects.length,
        (i) => _buildPageIndicatorDot(
          isActive: i == state._currentPage,
          onTap: i == state._currentPage ? null : () => state._onDotTap(i),
        ),
      ),
    ),
  );
}

Widget _buildDesktopProjectPage(
  BuildContext context,
  Map<String, dynamic> project,
) {
  final theme = Theme.of(context);
  final frameWidget =
      project['frame'].contains('phone')
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  final double frameWidth = constraints.maxWidth * 0.98;
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
      color: Colors.blue.withValues(alpha: 0.1),
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
              project['frame'].contains('phone')
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
          children:
              project['frame'].contains('phone')
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
  return IntrinsicHeight(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Demo available in tablet or desktop device',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.red.withValues(alpha: 0.5),
                shadows: [
                  Shadow(
                    color: AppTheme.red.withValues(alpha: 0.2),
                    blurRadius: 200,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
              ElevatedButton(onPressed: () {}, child: const Text('Know More')),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTabletProjectPage(
  BuildContext context,
  Map<String, dynamic> project,
) {
  final theme = Theme.of(context);
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

Widget _tabletProjectsPageView({
  required _ProjectsSectionState state,
  required bool isMobile,
  required List<Map<String, dynamic>> projects,
  required int currentPage,
  required PageController pageController,
  required ValueChanged<int> onPageChanged,
}) {
  return Expanded(
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: isMobile ? 30.0 : 20.0, right: 20.0),
          child: PageView.builder(
            controller: pageController,
            itemCount: projects.length,
            onPageChanged: onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final project = projects[index];
              return isMobile
                  ? _buildMobileProjectPage(context, project)
                  : _buildTabletProjectPage(context, project);
            },
          ),
        ),
        if (currentPage > 0)
          ProjectPageArrow(
            isLeft: true,
            onPressed: () {
              if (currentPage > 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        if (currentPage < projects.length - 1)
          ProjectPageArrow(
            isLeft: false,
            onPressed: () {
              if (currentPage < projects.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
      ],
    ),
  );
}

Widget _desktopMobileProjectsPageView({
  required _ProjectsSectionState state,
  required bool isMobile,
  required bool isTablet,
  required List<Map<String, dynamic>> projects,
  required int currentPage,
  required PageController pageController,
  required ValueChanged<int> onPageChanged,
}) {
  return SizedBox(
    height:
        isMobile
            ? 320
            : isTablet
            ? 420
            : 420 * 1.35,
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: isMobile ? 30.0 : 20.0, right: 20.0),
          child: PageView.builder(
            controller: pageController,
            itemCount: projects.length,
            onPageChanged: onPageChanged,
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
        if (currentPage > 0)
          ProjectPageArrow(
            isLeft: true,
            onPressed: () {
              if (currentPage > 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        if (currentPage < projects.length - 1)
          ProjectPageArrow(
            isLeft: false,
            onPressed: () {
              if (currentPage < projects.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
      ],
    ),
  );
}
