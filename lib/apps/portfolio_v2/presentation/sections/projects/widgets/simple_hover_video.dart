import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Simple hover video widget for direct use
/// Shows a thumbnail and plays video on hover
class SimpleHoverVideo extends StatefulWidget {
  final String videoAsset;
  final String? thumbnailAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool autoPlay; // New parameter for auto-play
  final bool enableLooping; // Enable video looping
  final double viewportOffset; // Offset for viewport detection (in pixels)

  const SimpleHoverVideo({
    super.key,
    required this.videoAsset,
    this.thumbnailAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.autoPlay = false, // Default to false (hover required)
    this.enableLooping = true, // Default to true for looping
    this.viewportOffset = 100.0, // 100px offset for early detection
  });

  @override
  State<SimpleHoverVideo> createState() => _SimpleHoverVideoState();
}

class _SimpleHoverVideoState extends State<SimpleHoverVideo> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoAsset);
      await _controller!.initialize();
      
      // Enable looping if specified
      if (widget.enableLooping) {
        _controller!.setLooping(true);
      }
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Auto-play if enabled
        if (widget.autoPlay) {
          setState(() {
            _isPlaying = true;
          });
          _controller?.play();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    // Only handle viewport detection for auto-play videos
    if (!widget.autoPlay || !_isInitialized) return;

    final visibleFraction = visibilityInfo.visibleFraction;

    if (visibleFraction > 0.3) {
      // Video is entering viewport - start playing
      if (!_isPlaying) {
        setState(() => _isPlaying = true);
        _controller?.play();
      }
    } else {
      // Video is leaving viewport - stop playing
      if (_isPlaying) {
        setState(() => _isPlaying = false);
        _controller?.pause();
        _controller?.seekTo(Duration.zero);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoContent = MouseRegion(
      onEnter: (_) {
        if (_isInitialized) {
          // Only start playing on hover if auto-play is disabled
          if (!widget.autoPlay) {
            setState(() => _isPlaying = true);
            _controller?.play();
          }
        }
      },
      onExit: (_) {
        if (_isInitialized) {
          // Only stop playing on hover exit if auto-play is disabled
          if (!widget.autoPlay) {
            setState(() => _isPlaying = false);
            _controller?.pause();
            _controller?.seekTo(Duration.zero);
          }
        }
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _isInitialized && _isPlaying
            ? FittedBox(
                fit: widget.fit,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            : _buildThumbnail(),
      ),
    );

    // Wrap with VisibilityDetector only for auto-play videos
    if (widget.autoPlay) {
      return VisibilityDetector(
        key: Key('simple_video_${widget.videoAsset}'),
        onVisibilityChanged: _onVisibilityChanged,
        child: videoContent,
      );
    }

    return videoContent;
  }

  Widget _buildThumbnail() {
    if (widget.thumbnailAsset != null) {
      return Image.asset(
        widget.thumbnailAsset!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Hover to play',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
