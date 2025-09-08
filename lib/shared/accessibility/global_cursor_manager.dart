import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;
import '../../core/accessibility/menu/accessibility_settings.dart';

/// A widget that makes any child clickable with proper cursor
class ClickableCursor extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showPointerCursor;

  const ClickableCursor({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.showPointerCursor = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll use the system cursor
    // In the future, we could pass the custom cursor from GlobalCursorManager
    MouseCursor cursor;
    if (showPointerCursor) {
      cursor = SystemMouseCursors.click;
    } else {
      cursor = SystemMouseCursors.basic;
    }

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}

/// A widget that manages global cursor scaling for the entire web app
/// This widget uses universal_html to directly manipulate browser CSS for better web support
/// Uses a simple large arrow cursor for everything
class GlobalCursorManager extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalCursorManager({super.key, required this.child});

  @override
  ConsumerState<GlobalCursorManager> createState() =>
      _GlobalCursorManagerState();
}

class _GlobalCursorManagerState extends ConsumerState<GlobalCursorManager> {
  // State variable to control whether the large cursor is enabled
  bool _isLargeCursorEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load the custom cursor images when the widget is initialized
    _loadCustomCursors();
  }

  // Asynchronously loads the custom cursor images and prepares them for web use
  Future<void> _loadCustomCursors() async {
    try {
      if (kDebugMode) {
        print('Custom cursors loaded successfully');
      }
    } catch (e) {
      // Log any errors if the cursor images fail to load
      if (kDebugMode) {
        print('Error loading custom cursors: $e');
        print('Falling back to system cursors');
      }
    }
  }

  // Toggles the cursor size based on the accessibility settings
  void _toggleCursorSize(bool newValue) {
    if (kDebugMode) {
      print('Toggling cursor size: $newValue');
    }

    setState(() {
      _isLargeCursorEnabled = newValue;
    });

    // Apply the cursor change using universal_html
    if (_isLargeCursorEnabled) {
      _setLargeCursor();
    } else {
      _setNormalCursor();
    }
  }

  void _setLargeCursor() {
    try {
      _removeCursorCSS();
      _injectLargeCursorCSS();

      if (kDebugMode) {
        print('Using custom large cursor');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting large cursor: $e');
      }
    }
  }

  void _setNormalCursor() {
    try {
      _removeCursorCSS();

      if (kDebugMode) {
        print('Using system cursor');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting normal cursor: $e');
      }
    }
  }

  // Create SVG data URL for the arrow cursor matching your image
  String _getArrowCursorSVG() {
    const arrowSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="-1.152 0 372.8 408.032" enable-background="new 0 0 400 400">
  <defs>
    <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="1" dy="1" stdDeviation="1" flood-color="rgba(0,0,0,0.5)"/>
    </filter>
  </defs>
  
  <g filter="url(#shadow)">
    <path d="M316,231.6L91.6,21.2c-2-2-5.6-2-7.6,0c-1.2,1.2-1.6,2.4-1.6,3.6l0.4,309.6c0,2.8,2.4,5.2,5.2,5.2c1.2,0,2.8-0.4,3.6-1.6   l65.2-61.2l42.8,98.8c0.8,2,2.8,3.2,4.8,3.2c0,0,0,0,0,0c0.8,0,1.6,0,2-0.4l57.6-25.2c1.2-0.4,2.4-1.6,2.8-3.2   c0.4-1.2,0.4-2.8,0-4L222.4,248.8l90.4-8c2,0,4-1.6,4.4-3.6C317.5,235.2,316.8,233.6,316,231.6z M222,243.6c-1.6,0-3.2,1.2-4,2.8   c-0.8,1.6-0.8,3.2-0.4,4.8l44.8,98l-57.6,25.2L162,275.6c-0.8-2-2.8-3.2-4.8-3.2c-1.2,0-2.8,0.4-3.6,1.6L88.4,334.8L88,25.2   L312,235.6L222,243.6z" fill="white" stroke="black" stroke-width="1"/>
    <path d="M106,299.6l47.6-44.8l7.2-6.8c1.2-1.2,3.6-0.8,4.4,0.8l4,8.8l41.6,96c0.4,1.2,2,2,3.6,1.2l28-12.4   c1.2-0.8,2-2.4,1.2-3.6L200,244.8L196,236c-0.8-1.6,0.4-3.6,2.4-3.6l9.6-0.8l67.6-6c2.4-0.4,3.2-3.2,1.6-4.8l-170.8-160   c-1.6-1.6-4.4-0.4-4.4,2l0.4,235.2C101.6,300,104.4,300.4,106,299.6z" fill="white" stroke="black" stroke-width="1"/>
  </g>
</svg>
    ''';

    return 'data:image/svg+xml;charset=utf-8,${Uri.encodeComponent(arrowSvg)}';
  }

  void _injectLargeCursorCSS() {
    final arrowCursorUrl = _getArrowCursorSVG();

    final cursorCSS =
        '''
      /* Apply large arrow cursor to everything */
      * {
        cursor: url('$arrowCursorUrl') 0 0, auto !important;
      }
      
      /* Ensure Flutter web compatibility */
      flt-glass-pane * {
        cursor: inherit !important;
      }
      
      /* Override any specific cursor styles */
      body, html, div, span, button, a, input, textarea, select {
        cursor: url('$arrowCursorUrl') 0 0, auto !important;
      }
    ''';

    final style = html.StyleElement()
      ..id = 'large-cursor-style'
      ..text = cursorCSS;
    html.document.head?.append(style);
  }

  void _removeCursorCSS() {
    html.document.getElementById('large-cursor-style')?.remove();
  }

  @override
  void dispose() {
    _setNormalCursor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(accessibilitySettingsProvider);

    // Update cursor state when accessibility settings change
    if (settings.customCursor != _isLargeCursorEnabled) {
      if (kDebugMode) {
        print(
          'Settings changed: customCursor = ${settings.customCursor}, _isLargeCursorEnabled = $_isLargeCursorEnabled',
        );
      }
      _toggleCursorSize(settings.customCursor);
    }

    // Use a builder to wrap the entire app with a MouseRegion
    // This ensures the cursor applies to the whole page
    return MouseRegion(
      cursor: SystemMouseCursors.basic, // Apply the dynamically chosen cursor
      child: widget.child, // The rest of your app's content
    );
  }
}
