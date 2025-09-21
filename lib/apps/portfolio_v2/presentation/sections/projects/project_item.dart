import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/shared/components/text_button.dart';
import 'package:portfolio_web/core/navigation/app_router.dart';
import '../../providers/scroll_providers.dart';
import '../../shared/widgets/reveal_from_animation.dart';
import '../../theme/portfolio_theme.dart';
import '../../../data/models/project.dart';
import 'widgets/index.dart';

class ProjectItem extends ConsumerWidget {
  final Project project;

  const ProjectItem({required this.project, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 768;
        final isMedium = width >= 768 && width < 1200;

        if (isSmall) {
          return _buildSmallLayout(context, ref, height, width);
        }

        if (isMedium) {
          return _buildMediumLayout(context, ref, height, width);
        }

        return _buildLargeLayout(context, ref, height);
      },
    );
  }

  Widget _buildLargeLayout(BuildContext context, WidgetRef ref, double height) {
    return SizedBox(
      height: height + height * 0.2,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTypeAndButtonColumnLarge(context, height, ref),
            Flexible(child: mainImageColumn(height, ref)),
            Flexible(child: secondaryImageAndDescriptionColumn(height, ref)),
            Flexible(child: logoColumn(ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumLayout(
    BuildContext context,
    WidgetRef ref,
    double height,
    double width,
  ) {
    final contentHeight = (height * 0.8).toDouble();
    const horizontalGap = 24.0;
    const totalFlex = 8; // 3 + 3 + 2
    final availableWidth = (width - (horizontalGap * 2))
        .clamp(480.0, width)
        .toDouble();
    final unitWidth = availableWidth / totalFlex;
    final clampedSecondaryWidth = (unitWidth * 3)
        .clamp(220.0, 320.0)
        .toDouble();
    final clampedSecondaryMaxWidth = (unitWidth * 3)
        .clamp(240.0, 360.0)
        .toDouble();
    final clampedLogoWidth = (unitWidth * 2).clamp(160.0, 280.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeLabelHorizontal(
            ref,
            width,
            alignment: Alignment.bottomLeft,
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: contentHeight,
                    minHeight: contentHeight,
                  ),
                  child: mainImageColumn(
                    height,
                    ref,
                    heightOverride: contentHeight,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: contentHeight,
                    minHeight: contentHeight,
                    maxWidth: clampedSecondaryMaxWidth,
                  ),
                  child: secondaryImageAndDescriptionColumn(
                    height,
                    ref,
                    mediaSize: clampedSecondaryWidth,
                    bottomPadding: 32,
                    totalHeight: contentHeight,
                    maxWidth: clampedSecondaryMaxWidth,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: contentHeight,
                    minHeight: contentHeight,
                    maxWidth: clampedLogoWidth,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      logoColumn(
                        ref,
                        width: clampedLogoWidth,
                        rowAlignment: MainAxisAlignment.start,
                        columnAlignment: CrossAxisAlignment.center,
                        textAlign: TextAlign.left,
                      ),
                      RevealOnScroll(
                        scrollController: ref.watch(scrollControllerProvider),
                        from: RevealFrom.bottom,
                        fadeDuration: const Duration(milliseconds: 800),
                        staggerDelay: const Duration(milliseconds: 800),
                        child: _buildViewProjectButton(
                          context,
                          alignment: Alignment.center,
                          textColor: PortfolioTheme.grayColor,
                          underlineColor: PortfolioTheme.grayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallLayout(
    BuildContext context,
    WidgetRef ref,
    double height,
    double width,
  ) {
    final mainMediaWidth = width.clamp(0.0, 420.0).toDouble();
    // final mainMediaHeight = (width * 0.75).clamp(240.0, 380.0).toDouble();
    final mainMediaHeight = height * 0.8;
    final secondaryMediaSize = (width * 0.6).clamp(200.0, 320.0).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeLabelHorizontal(
            ref,
            width,
            alignment: Alignment.bottomLeft,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: mainMediaWidth,
            child: mainImageColumn(
              height,
              ref,
              widthOverride: mainMediaWidth,
              heightOverride: mainMediaHeight,
            ),
          ),
          const SizedBox(height: 24),
          secondaryMediaDescriptionWithLogoSmall(
            height,
            ref,
            width,
            mediaSize: secondaryMediaSize,
          ),
          const SizedBox(height: 24),
          RevealOnScroll(
            scrollController: ref.watch(scrollControllerProvider),
            from: RevealFrom.right,
            fadeDuration: const Duration(milliseconds: 800),
            staggerDelay: const Duration(milliseconds: 800),
            child: _buildViewProjectButton(
              context,
              alignment: Alignment.centerLeft,
              textColor: PortfolioTheme.grayColor,
              underlineColor: PortfolioTheme.grayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeAndButtonColumnLarge(
    BuildContext context,
    double height,
    WidgetRef ref,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          height: height * 0.82,
          child: RevealOnScroll(
            scrollController: ref.watch(scrollControllerProvider),
            from: RevealFrom.bottom,
            fadeDuration: const Duration(milliseconds: 500),
            staggerDelay: const Duration(milliseconds: 500),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                project.projectType.displayName,
                style: PortfolioTheme.monotonRegular96.copyWith(
                  color: PortfolioTheme.orangeColor.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: RevealOnScroll(
            scrollController: ref.watch(scrollControllerProvider),
            from: RevealFrom.left,
            fadeDuration: const Duration(milliseconds: 800),
            staggerDelay: const Duration(milliseconds: 800),
            child: _buildViewProjectButton(
              context,
              alignment: Alignment.centerLeft,
              textColor: PortfolioTheme.grayColor,
              underlineColor: PortfolioTheme.grayColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeLabelHorizontal(
    WidgetRef ref,
    double maxWidth, {
    Alignment alignment = Alignment.centerLeft,
  }) {
    return RevealOnScroll(
      scrollController: ref.watch(scrollControllerProvider),
      from: RevealFrom.bottom,
      fadeDuration: const Duration(milliseconds: 500),
      staggerDelay: const Duration(milliseconds: 500),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, minHeight: 72),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: alignment,
            child: Text(
              project.projectType.displayName,
              style: PortfolioTheme.monotonRegular96.copyWith(
                color: PortfolioTheme.orangeColor.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewProjectButton(
    BuildContext context, {
    Alignment alignment = Alignment.centerLeft,
    Color? textColor,
    Color? underlineColor,
  }) {
    return Align(
      alignment: alignment,
      child: CustomTextButton(
        text: 'View Project',
        textColor: textColor ?? PortfolioTheme.grayColor,
        underlineColor: underlineColor ?? PortfolioTheme.grayColor,
        onTap: () {
          context.goNamed(
            RouteNames.projectDetail,
            pathParameters: {'id': project.id},
            extra: project,
          );
        },
      ),
    );
  }

  Widget mainImageColumn(
    double height,
    WidgetRef ref, {
    double? widthOverride,
    double? heightOverride,
  }) {
    final containerHeight = heightOverride ?? height * 0.85;
    final double? containerWidth = widthOverride;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: containerHeight,
        width: containerWidth,
        child: RevealOnScroll(
          scrollController: ref.watch(scrollControllerProvider),
          from: RevealFrom.top,
          fadeDuration: const Duration(milliseconds: 1000),
          staggerDelay: const Duration(milliseconds: 1000),
          child: DemoMediaWidget(
            project: project,
            fit: BoxFit.cover,
            width: containerWidth,
            height: containerHeight,
            autoPlayVideo: true,
          ),
        ),
      ),
    );
  }

  Widget secondaryImageAndDescriptionColumn(
    double height,
    WidgetRef ref, {
    double mediaSize = 300,
    double? bottomPadding,
    double? totalHeight,
    double? maxWidth,
  }) {
    final descPadding = bottomPadding ?? height * 0.15;
    double adjustedMediaSize = mediaSize;
    if (maxWidth != null && maxWidth.isFinite) {
      final widthClamped = mediaSize.clamp(0.0, maxWidth).toDouble();
      final widthResponsive = math.max(0, maxWidth * 0.6);
      adjustedMediaSize = math.min(widthClamped, widthResponsive.toDouble());
    }

    if (totalHeight != null && totalHeight.isFinite) {
      final heightResponsive = math.max(0, totalHeight * 0.45);
      adjustedMediaSize = math.min(
        adjustedMediaSize,
        heightResponsive.toDouble(),
      );
    }

    final content = Column(
      mainAxisSize: totalHeight != null ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: MediaWidget(
              assetPath: project.mediaSecondRectangle,
              fit: BoxFit.cover,
              width: adjustedMediaSize,
              height: adjustedMediaSize,
              errorWidget: Container(
                height: adjustedMediaSize,
                width: adjustedMediaSize,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 30),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (totalHeight != null && totalHeight.isFinite)
          Expanded(child: _buildDescriptionBlock(descPadding))
        else
          _buildDescriptionBlock(descPadding),
      ],
    );

    Widget wrappedContent = content;
    if (totalHeight != null || maxWidth != null) {
      wrappedContent = SizedBox(
        height: totalHeight,
        width: maxWidth,
        child: content,
      );
    }

    return RevealOnScroll(
      scrollController: ref.watch(scrollControllerProvider),
      from: RevealFrom.bottom,
      fadeDuration: const Duration(milliseconds: 1500),
      staggerDelay: const Duration(milliseconds: 1500),
      child: wrappedContent,
    );
  }

  Widget _buildDescriptionBlock(double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            project.projectName,
            style: PortfolioTheme.manropeBold20,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            project.projectDescription,
            style: PortfolioTheme.manropeRegular14,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            project.projectHashtags,
            style: PortfolioTheme.manropeLight14.copyWith(
              fontWeight: FontWeight.w200,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget secondaryMediaDescriptionWithLogoSmall(
    double height,
    WidgetRef ref,
    double width, {
    double mediaSize = 260,
  }) {
    final maxMediaExtent = (width * 0.45).clamp(160.0, 320.0);
    final adjustedMediaSize = mediaSize.clamp(160.0, maxMediaExtent).toDouble();

    return RevealOnScroll(
      scrollController: ref.watch(scrollControllerProvider),
      from: RevealFrom.bottom,
      fadeDuration: const Duration(milliseconds: 1200),
      staggerDelay: const Duration(milliseconds: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: adjustedMediaSize,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: MediaWidget(
                    assetPath: project.mediaSecondRectangle,
                    fit: BoxFit.cover,
                    width: adjustedMediaSize,
                    height: adjustedMediaSize,
                    errorWidget: Container(
                      height: adjustedMediaSize,
                      width: adjustedMediaSize,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: logoColumn(
                  ref,
                  width: double.infinity,
                  rowAlignment: MainAxisAlignment.end,
                  columnAlignment: CrossAxisAlignment.end,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.projectName,
            style: PortfolioTheme.manropeBold20,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            project.projectDescription,
            style: PortfolioTheme.manropeRegular14,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            project.projectHashtags,
            style: PortfolioTheme.manropeLight14.copyWith(
              fontWeight: FontWeight.w200,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget logoColumn(
    WidgetRef ref, {
    double? width,
    MainAxisAlignment rowAlignment = MainAxisAlignment.end,
    CrossAxisAlignment columnAlignment = CrossAxisAlignment.end,
    TextAlign textAlign = TextAlign.end,
  }) {
    return SizedBox(
      width: width ?? 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: columnAlignment,
        children: [
          Row(
            mainAxisAlignment: rowAlignment,
            children: [
              RevealOnScroll(
                scrollController: ref.watch(scrollControllerProvider),
                from: RevealFrom.center,
                fadeDuration: const Duration(milliseconds: 600),
                staggerDelay: const Duration(milliseconds: 600),
                child: Center(
                  child: MediaWidget(
                    assetPath: project.companyLogo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: RevealOnScroll(
                  scrollController: ref.watch(scrollControllerProvider),
                  from: RevealFrom.right,
                  fadeDuration: const Duration(milliseconds: 600),
                  staggerDelay: const Duration(milliseconds: 600),
                  child: Text(
                    project.companyName,
                    style: PortfolioTheme.manropeBold20.copyWith(fontSize: 19),
                    maxLines: 2,
                    textAlign: textAlign,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RevealOnScroll(
            scrollController: ref.watch(scrollControllerProvider),
            from: RevealFrom.right,
            fadeDuration: const Duration(milliseconds: 600),
            staggerDelay: const Duration(milliseconds: 600),
            child: Text(
              project.companyLocation,
              style: PortfolioTheme.manropeRegular16.copyWith(
                fontSize: 12,
                color: PortfolioTheme.orangeColor,
              ),
              textAlign: textAlign,
            ),
          ),
        ],
      ),
    );
  }
}
