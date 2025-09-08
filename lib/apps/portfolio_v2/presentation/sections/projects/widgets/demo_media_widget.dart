import 'package:flutter/material.dart';
import '../../../../data/models/project.dart';
import '../../../../data/enums/project_type.dart';
import 'media_widget.dart';
import '../../../../../../apps/portfolio/sections/projects section/demos/b4s demo/b4s_demo.dart';

/// Widget that shows either a demo or media based on project type
/// - If project type is liveDemo: shows interactive demo
/// - Otherwise: shows media (image or video)
class DemoMediaWidget extends StatelessWidget {
  final Project project;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool autoPlayVideo; // New parameter for video auto-play

  const DemoMediaWidget({
    super.key,
    required this.project,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.autoPlayVideo = false, // Default to false (hover required)
  });

  @override
  Widget build(BuildContext context) {
    // If project type is liveDemo, show the demo
    if (project.projectType == ProjectType.liveDemo) {
      return _buildDemoWidget();
    }

    // Otherwise, show the media
    return _buildMediaWidget();
  }

  Widget _buildDemoWidget() {
    // Show demo based on project name
    if (project.projectName.toLowerCase().contains('brain4goals') ||
        project.projectName.toLowerCase().contains('b4s')) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const Brain4GoalsDemo(),
        ),
      );
    } else {
      // Default demo placeholder for other live demo projects
      return Container(
        width: width ?? double.infinity,
        height: height ?? 400,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_outline, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Interactive Demo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Tap to explore',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMediaWidget() {
    // If no main media, show a placeholder
    if (project.mediaMainRectangle == null ||
        project.mediaMainRectangle!.isEmpty) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? 400,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No media available',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show the media using MediaWidget
    return MediaWidget(
      assetPath: project.mediaMainRectangle!,
      fit: fit,
      width: width,
      height: height,
      autoPlayVideo: autoPlayVideo,
      errorWidget: Container(
        width: width ?? double.infinity,
        height: height ?? 400,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Media not found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
