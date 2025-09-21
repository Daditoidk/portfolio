import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/sections/contact/contact_section.dart';
import '../../theme/portfolio_theme.dart';
import '../../../data/models/project.dart';
import 'widgets/hastags_carrousel.dart';

const double _detailWideBreakpoint = 900;
const double _detailMediumBreakpoint = 600;

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  static const double _railWidth = 180;
  static const double _horizontalPadding = 24;
  static const double _gapWidth = 24;

  final ScrollController _outerController = ScrollController();
  final ScrollController _rightController = ScrollController();

  @override
  void dispose() {
    _outerController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  void _routeScroll({required double dy, required double viewportHeight}) {
    if (dy == 0) return;

    final outerPos = _outerController.position;
    final onFirstSection = outerPos.pixels <= 0.5;
    final atContactSection = outerPos.pixels >= viewportHeight - 0.5;

    if (!onFirstSection) {
      final target = (dy > 0)
          ? math.min(viewportHeight, outerPos.pixels + dy)
          : math.max(0, outerPos.pixels + dy);
      if ((target - outerPos.pixels).abs() >= 0.5) {
        _outerController.jumpTo(target.toDouble());
      }
      return;
    }

    final rightPos = _rightController.position;
    final canScrollRightDown = rightPos.extentAfter > 0;
    final canScrollRightUp = rightPos.extentBefore > 0;

    if (dy > 0) {
      if (canScrollRightDown) {
        final target = math.min(rightPos.maxScrollExtent, rightPos.pixels + dy);
        _rightController.jumpTo(target);
      } else {
        final target = math.min(viewportHeight, outerPos.pixels + dy);
        if ((target - outerPos.pixels).abs() >= 0.5) {
          _outerController.jumpTo(target);
        }
      }
    } else {
      if (canScrollRightUp) {
        final target = math.max(0, rightPos.pixels + dy);
        _rightController.jumpTo(target.toDouble());
      } else {
        final target = math.max(0, outerPos.pixels + dy);
        if ((target - outerPos.pixels).abs() >= 0.5) {
          _outerController.jumpTo(target.toDouble());
        }
      }
    }
  }

  void _handleDragUpdate(DragUpdateDetails details, double viewportHeight) {
    _routeScroll(dy: -details.delta.dy, viewportHeight: viewportHeight);
  }

  void _handlePointerSignal(PointerSignalEvent event, double viewportHeight) {
    if (event is PointerScrollEvent) {
      _routeScroll(dy: event.scrollDelta.dy, viewportHeight: viewportHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewportHeight = size.height;

    return Scaffold(
      backgroundColor: PortfolioTheme.bgColor,
      body: Listener(
        onPointerSignal: (event) => _handlePointerSignal(event, viewportHeight),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) =>
              _handleDragUpdate(details, viewportHeight),
          child: SizedBox(
            height: viewportHeight,
            child: SingleChildScrollView(
              controller: _outerController,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: viewportHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalPadding,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: _railWidth,
                            child: _HashtagRail(
                              tags: widget.project.getHashtagsList(),
                            ),
                          ),
                          const SizedBox(width: _gapWidth),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: const _NoGlowBehavior(),
                              child: PrimaryScrollController(
                                controller: _rightController,
                                child: ListView(
                                  controller: _rightController,
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    24,
                                    0,
                                    48,
                                  ),
                                  children: [
                                    _ProjectDetailsColumn(
                                      project: widget.project,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: viewportHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalPadding,
                      ),
                      child: ContactSection(controller: _outerController),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HashtagRail extends StatelessWidget {
  const _HashtagRail({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final reversedTags = List<String>.from(tags.reversed);

    return Row(
      children: [
        Expanded(child: HashtagCarousel(tags: tags)),
        const SizedBox(height: 16),
        Expanded(
          child: HashtagCarousel(tags: reversedTags, scrollUpwards: false),
        ),
        const SizedBox(height: 16),
        Expanded(child: HashtagCarousel(tags: tags)),
      ],
    );
  }
}

class _ProjectDetailsColumn extends StatelessWidget {
  const _ProjectDetailsColumn({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight * 3,
          child: Center(
            child: Text(
              project.projectName,
              style: PortfolioTheme.manropeRegular16.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: PortfolioTheme.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ..._buildNarrativeSection(
          title: 'Company, Team & Objectives',
          paragraphs: project.companyTeamAndObjectivesParagraphs,
          mediaPath: project.companyTeamAndObjectivesMedia.isEmpty
              ? project.companyLogo
              : project.companyTeamAndObjectivesMedia,
          fit: BoxFit.fitHeight,
        ),
        ..._buildNarrativeSection(
          title: 'Problem',
          paragraphs: project.requestOrProblemParagraphs,
          mediaPath: project.requestOrProblemMedia,
          reverseLayout: true,
        ),
        ..._buildNarrativeSection(
          title: 'Solution',
          paragraphs: project.solutionParagraphs,
          mediaPath: project.solutionMedia,
        ),
        if (project.projectHashtags.isNotEmpty) ...[
          Text(
            'Technologies & Tags:',
            style: PortfolioTheme.manropeRegular16.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: PortfolioTheme.whiteColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project
                .getHashtagsList()
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: PortfolioTheme.orangeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PortfolioTheme.orangeColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: PortfolioTheme.manropeRegular16.copyWith(
                        color: PortfolioTheme.orangeColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          'Project Type:',
          style: PortfolioTheme.manropeRegular16.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: PortfolioTheme.whiteColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: PortfolioTheme.orangeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: PortfolioTheme.orangeColor, width: 1),
          ),
          child: Text(
            project.projectTypeDisplayName,
            style: PortfolioTheme.manropeRegular16.copyWith(
              color: PortfolioTheme.orangeColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNarrativeSection({
    required String title,
    required List<String> paragraphs,
    required String mediaPath,
    bool reverseLayout = false,
    BoxFit fit = BoxFit.cover,
  }) {
    final hasMedia = mediaPath.trim().isNotEmpty;
    if (paragraphs.isEmpty && !hasMedia) {
      return const [];
    }

    return [
      _DetailSection(
        title: title,
        paragraphs: paragraphs,
        mediaPath: mediaPath,
        reverseLayout: reverseLayout,
        fit: fit,
      ),
      const SizedBox(height: 32),
    ];
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.paragraphs,
    required this.mediaPath,
    this.reverseLayout = false,
    required this.fit,
  });

  final String title;
  final List<String> paragraphs;
  final String mediaPath;
  final bool reverseLayout;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final trimmedParagraphs = paragraphs
        .where((paragraph) => paragraph.trim().isNotEmpty)
        .toList();
    final media = mediaPath.trim().isEmpty ? null : mediaPath;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= _detailWideBreakpoint && media != null;
        final isMedium =
            constraints.maxWidth >= _detailMediumBreakpoint && media != null;

        final textContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildParagraphs(trimmedParagraphs),
        );

        Widget? mediaContent;
        if (media != null) {
          mediaContent = _DetailMedia(
            fit: fit,
            assetPath: media,
            maxHeight: _mediaMaxHeight(constraints.maxWidth, isWide, isMedium),
          );
        }

        final sectionChildren = <Widget>[
          Text(
            title,
            style: PortfolioTheme.manropeRegular16.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: PortfolioTheme.whiteColor,
            ),
          ),
          const SizedBox(height: 12),
        ];

        if (isWide && mediaContent != null) {
          sectionChildren.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reverseLayout) ...[
                  Flexible(flex: 3, child: mediaContent),
                  if (trimmedParagraphs.isNotEmpty) const SizedBox(width: 24),
                  Expanded(flex: 2, child: textContent),
                ] else ...[
                  Expanded(flex: 2, child: textContent),
                  if (trimmedParagraphs.isNotEmpty) const SizedBox(width: 24),
                  Flexible(flex: 3, child: mediaContent),
                ],
              ],
            ),
          );
        } else {
          if (trimmedParagraphs.isNotEmpty) {
            sectionChildren.addAll(_buildParagraphs(trimmedParagraphs));
          }
          if (mediaContent != null) {
            if (trimmedParagraphs.isNotEmpty) {
              sectionChildren.add(const SizedBox(height: 16));
            }
            sectionChildren.add(mediaContent);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sectionChildren,
        );
      },
    );
  }

  List<Widget> _buildParagraphs(List<String> paragraphs) {
    final paragraphWidgets = <Widget>[];
    for (var i = 0; i < paragraphs.length; i++) {
      paragraphWidgets.add(
        Text(
          paragraphs[i],
          style: PortfolioTheme.manropeRegular16.copyWith(
            fontSize: 16,
            color: PortfolioTheme.grayColor,
            height: 1.6,
          ),
        ),
      );
      if (i != paragraphs.length - 1) {
        paragraphWidgets.add(const SizedBox(height: 12));
      }
    }
    return paragraphWidgets;
  }

  double _mediaMaxHeight(double width, bool isWide, bool isMedium) {
    if (!isWide && !isMedium) {
      return 280;
    }

    if (width >= 1200) {
      return 420;
    }

    if (isWide) {
      return 360;
    }

    if (isMedium) {
      return 320;
    }

    return 280;
  }
}

class _DetailMedia extends StatelessWidget {
  const _DetailMedia({
    required this.assetPath,
    this.maxHeight = 300,
    required this.fit,
  });

  final String assetPath;
  final double maxHeight;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: PortfolioTheme.orangeColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            assetPath,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: PortfolioTheme.orangeColor.withValues(alpha: 0.1),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: PortfolioTheme.orangeColor,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Media not found',
                        style: PortfolioTheme.manropeRegular16.copyWith(
                          color: PortfolioTheme.orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
