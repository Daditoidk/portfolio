// Core exports
export 'core/accessibility_settings.dart';
export 'core/accessibility_text_style.dart';

// Widget exports
export 'widgets/accessible_text.dart';
export 'widgets/accessible_tooltip.dart';
export 'widgets/accessible_high_contrast.dart';
export 'widgets/accessible_hide_images.dart';
export 'widgets/accessible_highlight_links.dart';
export 'widgets/accessible_pause_animations.dart';
export 'widgets/accessible_custom_cursor.dart';
export 'widgets/accessible_page_structure.dart';
export 'widgets/accessible_text_align.dart';
export 'widgets/global_cursor_manager.dart';

// Specialized widget exports
export 'widgets/accessible_custom_cursor.dart'
    show
        AccessibleButton,
        AccessibleLink,
        AccessibleTextLink,
        AccessibleIconButton;
export 'widgets/accessible_hide_images.dart' show AccessibleImage;
export 'widgets/accessible_highlight_links.dart'
    show AccessibleInkWell, AccessibleGestureDetector;
export 'widgets/accessible_pause_animations.dart'
    show
        AccessibleAnimatedContainer,
        AccessibleAnimatedOpacity,
        AccessibleAnimatedSwitcher,
        AccessibleHero;
export 'widgets/accessible_text_align.dart'
    show AccessibleTextWithAlign, AccessibleRichText;

// Feature exports
export 'features/accessibility_menu.dart';
export 'features/accessibility_menu_content.dart';

// Theme exports
export 'themes/accessibility_menu_theme.dart';
