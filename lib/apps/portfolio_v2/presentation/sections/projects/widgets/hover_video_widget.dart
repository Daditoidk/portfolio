import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Widget that shows a video with hover-to-play functionality
/// Shows a thumbnail image initially, and plays video on hover
class HoverVideoWidget extends StatefulWidget {
  final String videoPath;
  final String? thumbnailPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final bool autoPlay; // New parameter to control auto-play behavior

  const HoverVideoWidget({
    super.key,
    required this.videoPath,
    this.thumbnailPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorWidget,
    this.autoPlay = false, // Default to false (hover required)
  });

  @override
  State<HoverVideoWidget> createState() => _HoverVideoWidgetState();
}

class _HoverVideoWidgetState extends State<HoverVideoWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Auto-play if enabled
        if (widget.autoPlay) {
          _startPlaying();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _startPlaying() {
    if (_isInitialized && !_hasError) {
      setState(() {
        _isPlaying = true;
      });
      _controller?.play();
    }
  }

  void _stopPlaying() {
    if (_isInitialized && !_hasError) {
      setState(() {
        _isPlaying = false;
      });
      _controller?.pause();
      _controller?.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (_isInitialized && !_hasError) {
      // Only start playing on hover if auto-play is disabled
      if (!widget.autoPlay) {
        _startPlaying();
      }
    }
  }

  void _onHoverExit() {
    if (_isInitialized && !_hasError) {
      // Only stop playing on hover exit if auto-play is disabled
      if (!widget.autoPlay) {
        _stopPlaying();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _isInitialized ? _buildVideoPlayer() : _buildLoadingWidget(),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        FittedBox(
          fit: widget.fit,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),

        // Play button overlay (shown when not playing)
        if (!_isPlaying)
          Container(
            color: Colors.black26,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.autoPlay
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.autoPlay ? 'Auto-playing' : 'Hover to play',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Container(
      width: widget.width ?? 200,
      height: widget.height ?? 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Video not found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
