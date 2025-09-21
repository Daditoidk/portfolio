import 'package:flutter/material.dart';
import 'hover_video_widget.dart';

/// Widget that handles both image and video media assets
/// Automatically detects the file type based on extension and renders accordingly
class MediaWidget extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final bool autoPlayVideo; // New parameter for video auto-play
  final bool enableLooping; // Enable video looping
  final double viewportOffset; // Offset for viewport detection (in pixels)

  const MediaWidget({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.errorWidget,
    this.autoPlayVideo = false, // Default to false (hover required)
    this.enableLooping = true, // Default to true for looping
    this.viewportOffset = 100.0, // 100px offset for early detection
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.isEmpty) {
      return _buildErrorWidget();
    }

    final extension = assetPath.toLowerCase().split('.').last;

    switch (extension) {
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'webm':
        return _buildVideoWidget();
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'webp':
        return _buildImageWidget();
      default:
        return _buildErrorWidget();
    }
  }

  Widget _buildVideoWidget() {
    return HoverVideoWidget(
      videoPath: assetPath,
      width: width,
      height: height,
      fit: fit,
      autoPlay: autoPlayVideo,
      enableLooping: enableLooping,
      viewportOffset: viewportOffset,
      errorWidget: _buildErrorWidget(),
    );
  }

  Widget _buildImageWidget() {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width ?? 200,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Media not found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
