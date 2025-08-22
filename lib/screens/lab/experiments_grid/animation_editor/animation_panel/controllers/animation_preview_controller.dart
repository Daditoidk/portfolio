import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/animations/widgets/text_scramble_widget.dart';
import '../../../../../../core/animations/text_order/text_order_data.dart';
import '../toExport/text_scramble_config.dart';

/// Controller for managing animation previews
class AnimationPreviewController extends ChangeNotifier {
  /// Current animation type
  String _currentAnimationType = 'text_scramble';

  /// Current animation configuration
  Map<String, dynamic> _currentConfig = {};

  /// Current text order data
  TextOrderData? _textOrderData;

  /// Whether the preview is currently playing
  bool _isPlaying = false;

  /// Current animation progress (0.0 to 1.0)
  double _progress = 0.0;

  /// Animation duration in milliseconds
  int _duration = 2000;

  /// Animation controller for the preview
  AnimationController? _animationController;

  /// Current preview widget
  Widget? _currentPreviewWidget;

  /// Error message if any
  String? _errorMessage;

  // Getters
  String get currentAnimationType => _currentAnimationType;
  Map<String, dynamic> get currentConfig => _currentConfig;
  TextOrderData? get textOrderData => _textOrderData;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  int get duration => _duration;
  Widget? get currentPreviewWidget => _currentPreviewWidget;
  String? get errorMessage => _errorMessage;

  /// Initialize the controller
  void initialize(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: Duration(milliseconds: _duration),
      vsync: vsync,
    );

    _animationController?.addListener(() {
      _progress = _animationController!.value;
      notifyListeners();
    });

    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isPlaying = false;
        notifyListeners();
      }
    });

    _createPreviewWidget();
  }

  /// Dispose the controller
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  /// Set animation type
  void setAnimationType(String type) {
    if (_currentAnimationType != type) {
      _currentAnimationType = type;
      _createPreviewWidget();
      notifyListeners();
    }
  }

  /// Update configuration
  void updateConfig(Map<String, dynamic> config) {
    _currentConfig = Map.from(config);
    _createPreviewWidget();
    notifyListeners();
  }

  /// Set text order data
  void setTextOrderData(TextOrderData? data) {
    _textOrderData = data;
    _createPreviewWidget();
    notifyListeners();
  }

  /// Set animation duration
  void setDuration(int milliseconds) {
    if (_duration != milliseconds) {
      _duration = milliseconds;
      _animationController?.duration = Duration(milliseconds: _duration);
      notifyListeners();
    }
  }

  /// Play the preview
  void play() {
    if (_animationController != null && !_isPlaying) {
      _isPlaying = true;
      _animationController!.forward(from: _progress);
      notifyListeners();
    }
  }

  /// Pause the preview
  void pause() {
    if (_animationController != null && _isPlaying) {
      _isPlaying = false;
      _animationController!.stop();
      notifyListeners();
    }
  }

  /// Stop the preview
  void stop() {
    if (_animationController != null) {
      _isPlaying = false;
      _animationController!.stop();
      _progress = 0.0;
      notifyListeners();
    }
  }

  /// Reset the preview
  void reset() {
    if (_animationController != null) {
      _isPlaying = false;
      _animationController!.reset();
      _progress = 0.0;
      notifyListeners();
    }
  }

  /// Set progress manually
  void setProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);
    if (_animationController != null) {
      _animationController!.value = _progress;
    }
    notifyListeners();
  }

  /// Create the preview widget based on current configuration
  void _createPreviewWidget() {
    try {
      _errorMessage = null;

      switch (_currentAnimationType) {
        case 'text_scramble':
          _currentPreviewWidget = _createTextScramblePreview();
          break;
        case 'text_fade_in':
          _currentPreviewWidget = _createTextFadeInPreview();
          break;
        case 'text_typewriter':
          _currentPreviewWidget = _createTextTypewriterPreview();
          break;
        default:
          _currentPreviewWidget = _createDefaultPreview();
      }
    } catch (e) {
      _errorMessage = 'Error creating preview: $e';
      _currentPreviewWidget = _createErrorPreview();
    }
  }

  /// Create text scramble preview widget
  Widget _createTextScramblePreview() {
    final config = TextScrambleConfig(
      name: 'Preview',
      type: 'text_scramble',
      properties: _currentConfig,
      textIds: _extractTextIds(),
      textOrderData: _textOrderData?.toJson() ?? {},
      mode: _getAnimationMode(),
      direction: _getAnimationDirection(),
      timing: _getAnimationTiming(),
      speed: _currentConfig['speed'] ?? 1.0,
      delay: _currentConfig['delay'] ?? 0.0,
      loop: _currentConfig['loop'] ?? false,
      reverse: _currentConfig['reverse'] ?? false,
      scrambleCharacters: _currentConfig['scrambleCharacters'] ?? r'!@#$%^&*()',
      scrambleIterations: _currentConfig['scrambleIterations'] ?? 10,
      maintainCase: _currentConfig['maintainCase'] ?? true,
    );

    return TextScrambleWidget(
      animationId: 'preview_scramble',
      text: _getPreviewText(),
      scrambleConfig: config,
      textOrderData: _textOrderData,
      autoStart: false,
      onProgressUpdate: (progress) {
        _progress = progress;
        notifyListeners();
      },
    );
  }

  /// Create text fade in preview widget
  Widget _createTextFadeInPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        _getPreviewText(),
        style: TextStyle(
          fontSize: 18,
          color: Colors.white.withValues(alpha: _progress),
        ),
      ),
    );
  }

  /// Create text typewriter preview widget
  Widget _createTextTypewriterPreview() {
    final text = _getPreviewText();
    final visibleLength = (text.length * _progress).round();
    final visibleText = text.substring(0, visibleLength.clamp(0, text.length));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        visibleText,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  /// Create default preview widget
  Widget _createDefaultPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        _getPreviewText(),
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  /// Create error preview widget
  Widget _createErrorPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Preview Error: $_errorMessage',
        style: const TextStyle(fontSize: 14, color: Colors.red),
      ),
    );
  }

  /// Get preview text
  String _getPreviewText() {
    if (_textOrderData != null) {
      return _textOrderData!.combinedText;
    }
    return _currentConfig['text'] ?? 'Preview Text';
  }

  /// Extract text IDs from configuration
  List<String> _extractTextIds() {
    final textIds = _currentConfig['textIds'] as List<dynamic>?;
    if (textIds != null) {
      return textIds.map((id) => id.toString()).toList();
    }
    return [];
  }

  /// Get animation mode from configuration
  AnimationMode _getAnimationMode() {
    final mode = _currentConfig['mode'] as String? ?? 'line';
    switch (mode.toLowerCase()) {
      case 'line':
        return AnimationMode.line;
      case 'block':
        return AnimationMode.block;
      case 'random':
        return AnimationMode.random;
      case 'custom':
        return AnimationMode.custom;
      default:
        return AnimationMode.line;
    }
  }

  /// Get animation direction from configuration
  AnimationDirection _getAnimationDirection() {
    final direction = _currentConfig['direction'] as String? ?? 'leftToRight';
    switch (direction.toLowerCase()) {
      case 'lefttoright':
        return AnimationDirection.leftToRight;
      case 'righttoleft':
        return AnimationDirection.rightToLeft;
      case 'toptobottom':
        return AnimationDirection.topToBottom;
      case 'bottomtotop':
        return AnimationDirection.bottomToTop;
      case 'centerout':
        return AnimationDirection.centerOut;
      case 'outsidein':
        return AnimationDirection.outsideIn;
      default:
        return AnimationDirection.leftToRight;
    }
  }

  /// Get animation timing from configuration
  AnimationTimingMode _getAnimationTiming() {
    final timing = _currentConfig['timing'] as String? ?? 'simultaneous';
    switch (timing.toLowerCase()) {
      case 'simultaneous':
        return AnimationTimingMode.simultaneous;
      case 'cascade':
        return AnimationTimingMode.cascade;
      case 'wave':
        return AnimationTimingMode.wave;
      case 'random':
        return AnimationTimingMode.random;
      case 'custom':
        return AnimationTimingMode.custom;
      default:
        return AnimationTimingMode.simultaneous;
    }
  }

  /// Get preview statistics
  Map<String, dynamic> getPreviewStats() {
    return {
      'animationType': _currentAnimationType,
      'isPlaying': _isPlaying,
      'progress': _progress,
      'duration': _duration,
      'hasTextOrderData': _textOrderData != null,
      'textOrderDataSize': _textOrderData?.sections.length ?? 0,
      'errorMessage': _errorMessage,
      'configKeys': _currentConfig.keys.toList(),
    };
  }
}

/// Provider for AnimationPreviewController
final animationPreviewControllerProvider =
    ChangeNotifierProvider<AnimationPreviewController>((ref) {
      return AnimationPreviewController();
    });
