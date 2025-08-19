import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'animation_controller.dart';

/// Direction for slide animations
enum SlideDirection { fromLeft, fromRight, fromTop, fromBottom }

/// Scroll animation widget that triggers on viewport entry
class ScrollTriggeredAnimation extends StatefulWidget {
  final Widget child;
  final AnimationSettings settings;
  final VoidCallback? onAnimationComplete;

  const ScrollTriggeredAnimation({
    super.key,
    required this.child,
    required this.settings,
    this.onAnimationComplete,
  });

  @override
  State<ScrollTriggeredAnimation> createState() =>
      _ScrollTriggeredAnimationState();
}

class _ScrollTriggeredAnimationState extends State<ScrollTriggeredAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.settings.behavior.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.settings.behavior.curve,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_hasAnimated && widget.settings.trigger.useViewport) {
      _hasAnimated = true;
      Future.delayed(widget.settings.trigger.viewportDelay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll_animation_${widget.key.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && widget.settings.trigger.useViewport) {
          _startAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Transform.translate(
              offset: _getSlideOffset(),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }

  Offset _getSlideOffset() {
    // Calculate slide offset based on animation value
    double slideDistance = 50.0;
    double currentValue = 1.0 - _animation.value;

    // This will be enhanced with direction settings
    return Offset(0, slideDistance * currentValue);
  }
}

/// Fade in animation widget
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool triggerOnViewport;
  final Duration viewportDelay;
  final SlideDirection? slideDirection;
  final double slideDistance;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.triggerOnViewport = true,
    this.viewportDelay = Duration.zero,
    this.slideDirection,
    this.slideDistance = 50.0,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(widget.viewportDelay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: _getSlideOffset(),
            child: widget.child,
          ),
        );
      },
    );

    if (widget.triggerOnViewport) {
      return VisibilityDetector(
        key: Key('fade_in_${widget.key.hashCode}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            _startAnimation();
          }
        },
        child: animatedWidget,
      );
    } else {
      return animatedWidget;
    }
  }

  Offset _getSlideOffset() {
    if (widget.slideDirection == null) return Offset.zero;

    double slideDistance = widget.slideDistance;
    double currentValue = 1.0 - _animation.value;

    switch (widget.slideDirection!) {
      case SlideDirection.fromLeft:
        return Offset(-slideDistance * currentValue, 0);
      case SlideDirection.fromRight:
        return Offset(slideDistance * currentValue, 0);
      case SlideDirection.fromTop:
        return Offset(0, -slideDistance * currentValue);
      case SlideDirection.fromBottom:
        return Offset(0, slideDistance * currentValue);
    }
  }
}

/// Scroll-based parallax animation
class ParallaxAnimation extends StatefulWidget {
  final Widget child;
  final double parallaxFactor;
  final ScrollController? scrollController;

  const ParallaxAnimation({
    super.key,
    required this.child,
    this.parallaxFactor = 0.5,
    this.scrollController,
  });

  @override
  State<ParallaxAnimation> createState() => _ParallaxAnimationState();
}

class _ParallaxAnimationState extends State<ParallaxAnimation> {
  double _offset = 0.0;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ?? PrimaryScrollController.of(context);
    _scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController?.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController != null) {
      setState(() {
        _offset = _scrollController!.offset * widget.parallaxFactor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(0, _offset), child: widget.child);
  }
}

/// Staggered animation for lists
class StaggeredAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration delayBetweenItems;
  final Duration itemDuration;
  final Curve curve;
  final bool triggerOnViewport;

  const StaggeredAnimation({
    super.key,
    required this.children,
    this.delayBetweenItems = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.triggerOnViewport = true,
  });

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) =>
          AnimationController(duration: widget.itemDuration, vsync: this),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: widget.curve));
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startStaggeredAnimation() {
    if (!_hasStarted) {
      _hasStarted = true;
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(
          Duration(milliseconds: i * widget.delayBetweenItems.inMilliseconds),
          () {
            if (mounted) {
              _controllers[i].forward();
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedList = Column(
      children: List.generate(
        widget.children.length,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[index].value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - _animations[index].value)),
                child: widget.children[index],
              ),
            );
          },
        ),
      ),
    );

    if (widget.triggerOnViewport) {
      return VisibilityDetector(
        key: Key('staggered_${widget.key.hashCode}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.1) {
            _startStaggeredAnimation();
          }
        },
        child: animatedList,
      );
    } else {
      return animatedList;
    }
  }
}
