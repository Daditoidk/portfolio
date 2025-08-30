import '../base/index.dart';

/// Main export manager for animations
class AnimationExporter {
  static Map<String, dynamic> exportAnimation(
    String animationType,
    Map<String, dynamic> config,
    ExportType exportType,
  ) {
    switch (exportType) {
      case ExportType.json:
        return _exportAsJson(animationType, config);
      case ExportType.dartCode:
        return _exportAsDartCode(animationType, config);
    }
  }

  /// Export animation as JSON for complex animations
  static Map<String, dynamic> _exportAsJson(
    String animationType,
    Map<String, dynamic> config,
  ) {
    return {
      'metadata': {
        'type': animationType,
        'exportFormat': 'json',
        'version': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'widgetType': config['widgetType'] ?? 'Unknown',
      },
      'textOrder': config['textOrder'],
      'animationConfig': {
        'type': animationType,
        'properties': config['properties'] ?? {},
        'settings': config['settings'] ?? {},
      },
    };
  }

  /// Export animation as Dart code for simple animations
  static Map<String, dynamic> _exportAsDartCode(
    String animationType,
    Map<String, dynamic> config,
  ) {
    return {
      'type': animationType,
      'exportFormat': 'dart_code',
      'code': _generateDartCode(animationType, config),
      'usage': _generateUsageExample(animationType, config),
      'dependencies': _getDependencies(animationType),
      'metadata': {
        'version': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
      },
    };
  }

  /// Generate Dart code for the animation
  static String _generateDartCode(
    String animationType,
    Map<String, dynamic> config,
  ) {
    switch (animationType) {
      case 'fade_in':
        return _generateFadeInCode(config);
      case 'slide_in':
        return _generateSlideInCode(config);
      case 'scale_in':
        return _generateScaleInCode(config);
      case 'bounce_in':
        return _generateBounceInCode(config);
      default:
        return _generateGenericCode(animationType, config);
    }
  }

  /// Generate usage example for the animation
  static String _generateUsageExample(
    String animationType,
    Map<String, dynamic> config,
  ) {
    switch (animationType) {
      case 'fade_in':
        return 'Wrap your widget with FadeInAnimation(child: YourWidget())';
      case 'slide_in':
        return 'Wrap your widget with SlideInAnimation(child: YourWidget())';
      case 'scale_in':
        return 'Wrap your widget with ScaleInAnimation(child: YourWidget())';
      case 'bounce_in':
        return 'Wrap your widget with BounceInAnimation(child: YourWidget())';
      default:
        return 'Wrap your widget with ${animationType.replaceAll('_', ' ').split(' ').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}Animation(child: YourWidget())';
    }
  }

  /// Get dependencies for the animation
  static List<String> _getDependencies(String animationType) {
    switch (animationType) {
      case 'fade_in':
      case 'slide_in':
      case 'scale_in':
      case 'bounce_in':
        return ['flutter'];
      default:
        return ['flutter'];
    }
  }

  /// Generate FadeIn animation code
  static String _generateFadeInCode(Map<String, dynamic> config) {
    final duration = config['duration'] ?? 500;
    final curve = config['curve'] ?? 'Curves.easeInOut';
    final triggerOnViewport = config['triggerOnViewport'] ?? true;

    return '''
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool triggerOnViewport;
  
  const FadeInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: $duration),
    this.curve = $curve,
    this.triggerOnViewport = $triggerOnViewport,
    super.key,
  });
  
  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    if (!widget.triggerOnViewport) {
      _controller.forward();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''';
  }

  /// Generate SlideIn animation code
  static String _generateSlideInCode(Map<String, dynamic> config) {
    final duration = config['duration'] ?? 500;
    final curve = config['curve'] ?? 'Curves.easeInOut';
    final direction = config['direction'] ?? 'SlideDirection.left';
    final distance = config['distance'] ?? 50.0;

    return '''
enum SlideDirection { left, right, top, bottom }

class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final SlideDirection direction;
  final double distance;
  
  const SlideInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: $duration),
    this.curve = $curve,
    this.direction = $direction,
    this.distance = $distance,
    super.key,
  });
  
  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    final begin = _getBeginOffset();
    _animation = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _controller.forward();
  }
  
  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.left:
        return Offset(-widget.distance, 0);
      case SlideDirection.right:
        return Offset(widget.distance, 0);
      case SlideDirection.top:
        return Offset(0, -widget.distance);
      case SlideDirection.bottom:
        return Offset(0, widget.distance);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: widget.child,
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''';
  }

  /// Generate ScaleIn animation code
  static String _generateScaleInCode(Map<String, dynamic> config) {
    final duration = config['duration'] ?? 500;
    final curve = config['curve'] ?? 'Curves.easeInOut';
    final beginScale = config['beginScale'] ?? 0.0;

    return '''
class ScaleInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double beginScale;
  
  const ScaleInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: $duration),
    this.curve = $curve,
    this.beginScale = $beginScale,
    super.key,
  });
  
  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.beginScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''';
  }

  /// Generate BounceIn animation code
  static String _generateBounceInCode(Map<String, dynamic> config) {
    final duration = config['duration'] ?? 800;
    final curve = config['curve'] ?? 'Curves.bounceOut';

    return '''
class BounceInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  const BounceInAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: $duration),
    this.curve = $curve,
    super.key,
  });
  
  @override
  State<BounceInAnimation> createState() => _BounceInAnimationState();
}

class _BounceInAnimationState extends State<BounceInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''';
  }

  /// Generate generic animation code
  static String _generateGenericCode(
    String animationType,
    Map<String, dynamic> config,
  ) {
    final duration = config['duration'] ?? 500;
    final curve = config['curve'] ?? 'Curves.easeInOut';

    return '''
class ${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}Animation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  const ${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}Animation({
    required this.child,
    this.duration = const Duration(milliseconds: $duration),
    this.curve = $curve,
    super.key,
  });
  
  @override
  State<${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}Animation> createState() => _${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}AnimationState();
}

class _${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}AnimationState extends State<${animationType.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join('')}Animation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _controller.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}''';
  }
}
