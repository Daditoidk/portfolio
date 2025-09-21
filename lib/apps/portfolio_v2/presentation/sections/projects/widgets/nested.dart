import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TwoStageScrollPage extends StatefulWidget {
  const TwoStageScrollPage({super.key});

  @override
  State<TwoStageScrollPage> createState() => _TwoStageScrollPageState();
}

class _TwoStageScrollPageState extends State<TwoStageScrollPage> {
  final ScrollController _outer =
      ScrollController(); // scroll vertical “general”
  final ScrollController _rightInner =
      ScrollController(); // scroll de la columna derecha

  // Ajustes de animación para suavidad.
  static const _outerAnimDuration = Duration(milliseconds: 180);
  static const _outerAnimCurve = Curves.easeOutCubic;

  @override
  void dispose() {
    _outer.dispose();
    _rightInner.dispose();
    super.dispose();
  }

  /// Lógica central: decide a qué controlador aplicar el delta de scroll.
  void _routeScroll({
    required double dy, // + abajo, - arriba
    required double viewportHeight,
  }) {
    if (dy == 0) return;

    final outerPos = _outer.position;
    final onSection1 = outerPos.pixels <= 0.5; // tolerancia para floats
    final atSection2 = outerPos.pixels >= viewportHeight - 0.5;

    // Si NO estamos exactamente en sección 1, prioriza mover el outer.
    if (!onSection1) {
      final target = (dy > 0)
          ? math.min(viewportHeight, outerPos.pixels + dy) // hacia abajo
          : math.max(0, outerPos.pixels + dy); // hacia arriba
      if ((target - outerPos.pixels).abs() >= 0.5) {
        _outer.jumpTo(target.toDouble());
      }
      return;
    }

    // ---- Estamos en Sección 1 (outer == 0) ----
    final innerPos = _rightInner.position;
    final canScrollRightDown = innerPos.extentAfter > 0;
    final canScrollRightUp = innerPos.extentBefore > 0;

    if (dy > 0) {
      if (canScrollRightDown) {
        final target = math.min(innerPos.maxScrollExtent, innerPos.pixels + dy);
        _rightInner.jumpTo(target);
      } else {
        // derecha al final: ahora sí mueve outer hacia Sección 2
        final target = math.min(viewportHeight, outerPos.pixels + dy);
        if ((target - outerPos.pixels).abs() >= 0.5) _outer.jumpTo(target);
      }
    } else {
      if (canScrollRightUp) {
        final target = math.max(0, innerPos.pixels + dy);
        _rightInner.jumpTo(target.toDouble());
      } else {
        // derecha en el tope: outer hacia arriba (se queda en 0)
        final target = math.max(0, outerPos.pixels + dy);
        if ((target - outerPos.pixels).abs() >= 0.5) {
          _outer.jumpTo(target.toDouble());
        }
      }
    }
  }

  /// Para gestos de arrastre (touch/drag). Convertimos desplazamiento horizontal en 0 y
  /// usamos solo el delta vertical.
  void _handleDragUpdate(DragUpdateDetails details, double viewportHeight) {
    _routeScroll(dy: -details.delta.dy, viewportHeight: viewportHeight);
  }

  /// Para rueda del mouse / trackpad.
  void _handlePointerSignal(PointerSignalEvent event, double viewportHeight) {
    if (event is PointerScrollEvent) {
      // En web/desktop normalmente dy positivo es scroll hacia abajo.
      _routeScroll(dy: event.scrollDelta.dy, viewportHeight: viewportHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final vh = size.height;

    return Scaffold(
      body: Listener(
        onPointerSignal: (e) => _handlePointerSignal(e, vh),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (d) => _handleDragUpdate(d, vh),
          child: SizedBox(
            height: vh,
            child: SingleChildScrollView(
              controller: _outer,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  // ===== SECCIÓN 1 =====
                  SizedBox(
                    height: vh,
                    child: Row(
                      children: [
                        Container(
                          width: 180,
                          color: const Color(0xFF111318),
                          child: const _LeftPane(),
                        ),
                        Expanded(
                          child: Container(
                            color: const Color(0xFF161A20),
                            child: ScrollConfiguration(
                              behavior: const _NoGlowBehavior(),
                              child: PrimaryScrollController(
                                controller: _rightInner,
                                child: ListView(
                                  controller: _rightInner,
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    24,
                                    24,
                                    48,
                                  ),
                                  children: const [_RightContent()],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ===== SECCIÓN 2 =====
                  SizedBox(
                    height: vh,
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFF0F172A),
                        child: const Text(
                          'contact us',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // sin glow
  }
}

class _LeftPane extends StatelessWidget {
  const _LeftPane();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Panel fijo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Este lado izquierdo estará fijo con un width de 180.',
                style: TextStyle(color: Colors.white.withOpacity(0.85)),
              ),
              const Spacer(),
              Text(
                'Permanece anclado durante todo el scroll del lado derecho.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RightContent extends StatelessWidget {
  const _RightContent();

  Widget _paragraph([int sentences = 6]) {
    const text =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec non dui non risus vehicula fermentum. '
        'Maecenas at arcu in metus feugiat eleifend. Suspendisse potenti. Integer facilisis mauris at augue '
        'tempor, a volutpat mi interdum.';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        List.filled(sentences, text).join(' '),
        style: const TextStyle(
          color: Colors.white,
          height: 1.35,
          fontSize: 14.5,
        ),
      ),
    );
  }

  Widget _image(double h) {
    return Container(
      height: h,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.white70, size: 48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contenido derecho (scrollable)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _paragraph(4),
        _image(220),
        _paragraph(6),
        _image(300),
        _paragraph(7),
        _image(180),
        _paragraph(8),
        const SizedBox(height: 80),
      ],
    );
  }
}
