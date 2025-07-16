import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/constants/semantic_labels.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/helpers/frame_container.dart';
import 'project_page_arrow.dart';
part 'projects_section_aux.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isPageAnimating = false;

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
                    ? screenHeight * 1.2
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
      ),
    );
  }
}
