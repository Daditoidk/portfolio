// Core exports
export 'menu/accessibility_settings.dart';
export 'menu/accessibility_text_style.dart';

// Widget exports
export '../../shared/accessibility/accessible_text.dart';
export '../../shared/accessibility/accessible_tooltip.dart';
export '../../shared/accessibility/accessible_high_contrast.dart';
export '../../shared/accessibility/accessible_hide_images.dart';
export '../../shared/accessibility/accessible_highlight_links.dart';
export '../../shared/accessibility/accessible_pause_animations.dart';
export '../../shared/accessibility/accessible_custom_cursor.dart';
export '../../shared/accessibility/accessible_page_structure.dart';
export '../../shared/accessibility/accessible_text_align.dart';
export '../../shared/accessibility/global_cursor_manager.dart';

// Specialized widget exports
export '../../shared/accessibility/accessible_custom_cursor.dart'
    show
        AccessibleButton,
        AccessibleLink,
        AccessibleTextLink,
        AccessibleIconButton;
export '../../shared/accessibility/accessible_hide_images.dart'
    show AccessibleImage;
export '../../shared/accessibility/accessible_highlight_links.dart'
    show AccessibleInkWell, AccessibleGestureDetector;
export '../../shared/accessibility/accessible_pause_animations.dart'
    show
        AccessibleAnimatedContainer,
        AccessibleAnimatedOpacity,
        AccessibleAnimatedSwitcher,
        AccessibleHero;
export '../../shared/accessibility/accessible_text_align.dart'
    show AccessibleTextWithAlign, AccessibleRichText;

// Feature exports
export 'menu/accessibility_menu.dart';
export 'menu/accessibility_menu_content.dart';

// Theme exports
export '../theme/accessibility_menu_theme.dart';
