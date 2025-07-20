import 'package:flutter/material.dart';

/// Un widget helper que envuelve un [child] con una imagen de frame,
/// y permite superponer contenido en el área de pantalla del frame.
/// Mantiene los tamaños y proporciones actuales por defecto.
class FrameContainer extends StatelessWidget {
  final String frameAsset;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets overlayPadding;
  final BorderRadius borderRadius;

  /// [frameAsset]: ruta de la imagen del frame
  /// [child]: widget a mostrar dentro del área de pantalla del frame
  /// [width], [height]: tamaño total del frame
  /// [overlayPadding]: padding para posicionar el área de overlay dentro del frame
  /// [borderRadius]: radio de borde para el overlay
  const FrameContainer({
    super.key,
    required this.frameAsset,
    required this.child,
    required this.width,
    required this.height,
    required this.overlayPadding,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Contenido del demo - Completamente contenido en el área de pantalla
          Positioned(
            left: overlayPadding.left,
            top: overlayPadding.top,
            right: overlayPadding.right,
            bottom: overlayPadding.bottom,
            child: Container(
              width: width - overlayPadding.horizontal,
              height: height - overlayPadding.vertical,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.transparent,
              ),
              clipBehavior: Clip.hardEdge,
              child: ClipRRect(
                borderRadius: borderRadius,
                child: SizedBox(
                  width: width - overlayPadding.horizontal,
                  height: height - overlayPadding.vertical,
                  child: child,
                ),
              ),
            ),
          ),
          // Frame del dispositivo (capa superior)
          Image.asset(
            frameAsset,
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
