import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/accessibility_settings.dart';

/// A widget that conditionally hides images and shows alt text when enabled
///
/// This widget automatically hides images and replaces them with accessible
/// text descriptions when the hide images setting is enabled.
/// It preserves the original widget's size and shape.
class AccessibleHideImages extends ConsumerWidget {
  final Widget child;
  final String? altText;
  final Widget? placeholder;
  final bool showAltText;
  final TextStyle? altTextStyle;

  const AccessibleHideImages({
    super.key,
    required this.child,
    this.altText,
    this.placeholder,
    this.showAltText = true,
    this.altTextStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.hideImages) {
      return child;
    }

    return _ImageReplacer(
      altText: altText,
      placeholder: placeholder,
      showAltText: showAltText,
      altTextStyle: altTextStyle,
      child: child,
    );
  }
}

class _ImageReplacer extends StatelessWidget {
  final Widget child;
  final String? altText;
  final Widget? placeholder;
  final bool showAltText;
  final TextStyle? altTextStyle;

  const _ImageReplacer({
    this.altText,
    this.placeholder,
    required this.showAltText,
    this.altTextStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (placeholder != null) {
      return placeholder!;
    }

    // Check if the child is a CircleAvatar to maintain circular shape
    final isCircleAvatar = child is CircleAvatar;

    if (isCircleAvatar) {
      // For CircleAvatar, we need to extract the radius and create a circular container
      final circleAvatar = child as CircleAvatar;
      final radius =
          circleAvatar.radius ?? 20.0; // Default radius if not specified

      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.grey.shade100,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade600,
                size: radius * 0.3, // Scale icon based on radius
              ),
              if (showAltText && altText != null && altText!.isNotEmpty) ...[
                SizedBox(height: radius * 0.1),
                SizedBox(
                  width: radius * 1.6, // Constrain text width
                  child: Text(
                    altText!,
                    style:
                        altTextStyle ??
                        TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: radius * 0.15, // Scale font based on radius
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // For other widgets, use the original layout approach
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: _buildContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (showAltText && altText != null && altText!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade600,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                altText!,
                style:
                    altTextStyle ??
                    TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Default placeholder when no alt text is provided
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade500,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Image hidden',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// A specialized Image widget that automatically handles accessibility hiding
class AccessibleImage extends ConsumerWidget {
  final String imagePath;
  final String? altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final bool showAltText;
  final TextStyle? altTextStyle;

  const AccessibleImage({
    super.key,
    required this.imagePath,
    this.altText,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.showAltText = true,
    this.altTextStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (settings.hideImages) {
      return SizedBox(
        width: width,
        height: height,
        child: _ImageReplacer(
          altText: altText,
          placeholder: placeholder,
          showAltText: showAltText,
          altTextStyle: altTextStyle,
          child: Image.asset(imagePath, width: width, height: height, fit: fit),
        ),
      );
    }

    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: altText,
    );
  }
}
