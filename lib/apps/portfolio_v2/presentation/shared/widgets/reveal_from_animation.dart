import 'package:flutter/material.dart';

enum RevealFrom { left, right, top, bottom, center }

class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.child,
    required this.scrollController,
    this.from = RevealFrom.bottom,
    this.offset = 40.0,
    this.fadeDuration = const Duration(milliseconds: 450),
    this.slideDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.triggerFraction = 0.15, // % de alto visible para disparar
    this.once = true, // true: anima una sola vez
    this.staggerDelay, // opcional: retardo inicial
  });

  final Widget child;
  final ScrollController scrollController;
  final RevealFrom from;
  final double offset;
  final Duration fadeDuration;
  final Duration slideDuration;
  final Curve curve;
  final double triggerFraction;
  final bool once;
  final Duration? staggerDelay;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: widget.fadeDuration,
  );
  late final AnimationController _slideCtrl = AnimationController(
    vsync: this,
    duration: widget.slideDuration,
  );
  late final AnimationController _scaleCtrl = AnimationController(
    vsync: this,
    duration: widget.slideDuration,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _fadeCtrl,
    curve: widget.curve,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: switch (widget.from) {
      RevealFrom.left => Offset(-widget.offset, 0),
      RevealFrom.right => Offset(widget.offset, 0),
      RevealFrom.top => Offset(0, -widget.offset),
      RevealFrom.bottom => Offset(0, widget.offset),
      RevealFrom.center => Offset.zero,
    },
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _slideCtrl, curve: widget.curve));

  late final Animation<double> _scale = Tween<double>(
    begin: widget.from == RevealFrom.center ? 0.6 : 1.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _scaleCtrl, curve: widget.curve));

  final _key = GlobalKey();
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didUpdateWidget(covariant RevealOnScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_checkVisibility);
      widget.scrollController.addListener(_checkVisibility);
      _checkVisibility();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    if (widget.staggerDelay != null) {
      await Future.delayed(widget.staggerDelay!);
      if (!mounted) return;
    }
    await Future.wait([
      _fadeCtrl.forward(),
      _slideCtrl.forward(),
      _scaleCtrl.forward(),
    ]);
  }

  void _checkVisibility() {
    if (_revealed && widget.once) return;

    final ctx = _key.currentContext;
    final box = ctx?.findRenderObject() as RenderBox?;
    if (ctx == null || box == null || !box.attached) return;

    if (!box.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkVisibility();
        }
      });
      return;
    }

    final size = box.size;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(ctx).size.height;

    final top = pos.dy;
    final bottom = pos.dy + size.height;
    final needed = size.height * widget.triggerFraction;

    final intersects = (bottom > needed) && (top < screenH - needed);

    if (intersects) {
      _revealed = true;
      _play();
    } else if (!widget.once) {
      _revealed = false;
      _fadeCtrl.reverse();
      _slideCtrl.reverse();
      _scaleCtrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _key,
      child: AnimatedBuilder(
        animation: Listenable.merge([_fade, _slide]),
        builder: (context, child) {
          final dx = _slide.value.dx;
          final dy = _slide.value.dy;
          return Opacity(
            opacity: _fade.value,
            child: Transform.translate(
              offset: Offset(dx, dy),
              child: Transform.scale(scale: _scale.value, child: child),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
