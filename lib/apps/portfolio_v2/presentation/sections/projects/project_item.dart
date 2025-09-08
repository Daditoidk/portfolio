import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_web/apps/portfolio_v2/presentation/shared/components/text_button.dart';
import '../../theme/portfolio_theme.dart';
import '../../../data/models/project.dart';
import 'widgets/index.dart';

class ProjectItem extends StatelessWidget {
  final Project project;

  const ProjectItem({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height + height * 0.2,
      width: double.infinity,

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            typeAndButtonColumn(height),
            Flexible(child: mainImageColumn(height)),
            Flexible(child: secondaryImageAndDescriptionColumn(height)),
            Flexible(child: logoColumn()),
          ],
        ),
      ),
    );
  }

  Widget typeAndButtonColumn(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          height: height * 0.82,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                top: 0,
                child: Transform.rotate(
                  angle: 270 * pi / 180,
                  child: SizedBox(
                    width: 680,
                    child: Text(
                      project.projectType.displayName,
                      style: PortfolioTheme.monotonRegular96.copyWith(
                        color: PortfolioTheme.orangeColor.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: CustomTextButton(
            text: 'View Project',
            textColor: PortfolioTheme.grayColor,
            underlineColor: PortfolioTheme.grayColor,
          ),
        ),
      ],
    );
  }

  Widget mainImageColumn(double height) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: height * 0.85,
        width: 300,
        child: DemoMediaWidget(
          project: project,
          fit: BoxFit.cover,
          width: 300,
          height: height * 0.85,
          autoPlayVideo: true, // Enable auto-play for main image column
        ),
      ),
    );
  }

  Widget secondaryImageAndDescriptionColumn(double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top section with secondary image and company info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: MediaWidget(
                assetPath: project.mediaSecondRectangle,
                fit: BoxFit.fitHeight,
                width: 300,
                height: 300,
                errorWidget: Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 30),
                  ),
                ),
              ),
            ),
            SizedBox(width: 1),
          ],
        ),
        // Bottom section with project details
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ],
    );
  }

  Widget logoColumn() {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: MediaWidget(
                      assetPath: project.companyLogo,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      project.companyName,
                      style: PortfolioTheme.manropeBold20.copyWith(
                        fontSize: 19,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                project.companyLocation,
                style: PortfolioTheme.manropeRegular16.copyWith(
                  fontSize: 12,
                  color: PortfolioTheme.orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
