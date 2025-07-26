import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/accessibility_settings.dart';
import '../../../../core/l10n/app_localizations.dart';

// Global provider to manage all page structure items
final pageStructureItemsProvider =
    StateNotifierProvider<PageStructureItemsNotifier, List<PageStructureItem>>(
      (ref) => PageStructureItemsNotifier(),
    );

class PageStructureItemsNotifier
    extends StateNotifier<List<PageStructureItem>> {
  PageStructureItemsNotifier() : super([]);

  void addItem(PageStructureItem item) {
    if (!state.any((existing) => existing.sectionId == item.sectionId)) {
      state = [...state, item];
    }
  }

  void addItems(List<PageStructureItem> items) {
    final newItems = items
        .where(
          (item) =>
              !state.any((existing) => existing.sectionId == item.sectionId),
        )
        .toList();

    if (newItems.isNotEmpty) {
      state = [...state, ...newItems];
    }
  }

  void clearItems() {
    state = [];
  }

  // Method to get localized items
  List<PageStructureItem> getLocalizedItems(AppLocalizations l10n) {
    return state.map((item) {
      // Map section IDs to localized labels
      String localizedLabel = _getLocalizedLabel(item.sectionId, l10n);
      return PageStructureItem(
        label: localizedLabel,
        description: item.description,
        type: item.type,
        key: item.key,
        level: item.level,
        sectionId: item.sectionId,
      );
    }).toList();
  }

  String _getLocalizedLabel(String? sectionId, AppLocalizations l10n) {
    if (sectionId == null) return '';

    // Map section IDs to l10n keys
    switch (sectionId) {
      case 'home':
        return l10n.headerSection;
      case 'navigation':
        return l10n.navigationMenu;
      case 'profile':
        return l10n.profilePicture;
      case 'name':
        return l10n.nameTitle;
      case 'title':
        return l10n.professionalTitle;
      case 'description':
        return l10n.professionalDescription;
      case 'about':
        return l10n.aboutSection;
      case 'about-title':
        return l10n.aboutTitleLabel;
      case 'about-description':
        return l10n.aboutDescriptionLabel;
      case 'about-subtitle':
        return l10n.aboutSubtitleLabel;
      case 'skills':
        return l10n.skillsSection;
      case 'skills-title':
        return l10n.skillsTitleLabel;
      case 'skills-description':
        return l10n.skillsDescriptionLabel;
      case 'programming-languages':
        return l10n.programmingLanguages;
      case 'design-animation':
        return l10n.designAnimation;
      case 'editors-tools':
        return l10n.editorsTools;
      case 'devops-cicd':
        return l10n.devopsCICD;
      case 'project-management':
        return l10n.projectManagement;
      case 'resume':
        return l10n.resumeSection;
      case 'resume-title':
        return l10n.resumeTitleLabel;
      case 'resume-description':
        return l10n.resumeDescriptionLabel;
      case 'download-resume':
        return l10n.downloadResumeButton;
      case 'last-updated':
        return l10n.lastUpdated;
      case 'projects':
        return l10n.projectsSection;
      case 'projects-title':
        return l10n.projectsTitleLabel;
      case 'projects-description':
        return l10n.projectsDescriptionLabel;
      case 'project-b4s':
        return l10n.projectB4S;
      case 'project-ecommerce':
        return l10n.projectEcommerce;
      case 'project-social':
        return l10n.projectSocial;
      case 'project-weather':
        return l10n.projectWeather;
      case 'project-music':
        return l10n.projectMusic;
      case 'project-task':
        return l10n.projectTask;
      case 'project-fitness':
        return l10n.projectFitness;
      case 'contact':
        return l10n.contactSection;
      case 'contact-title':
        return l10n.contactTitleLabel;
      case 'contact-description':
        return l10n.contactDescriptionLabel;
      case 'contact-info':
        return l10n.contactInfo;
      case 'social-links':
        return l10n.socialLinks;
      default:
        return sectionId; // Fallback to section ID if no mapping found
    }
  }
}

/// A widget that shows page structure/outline when accessibility setting is enabled
///
/// This widget automatically displays a page structure dialog when the
/// page structure setting is enabled.
class AccessiblePageStructure extends ConsumerStatefulWidget {
  final Widget child;
  final List<PageStructureItem>? structureItems;
  final Function(String)? onSectionTap; // Add callback for section navigation
  final Locale? currentLocale; // Add current locale parameter

  const AccessiblePageStructure({
    super.key,
    required this.child,
    this.structureItems,
    this.onSectionTap, // Add this parameter
    this.currentLocale, // Add this parameter
  });

  @override
  ConsumerState<AccessiblePageStructure> createState() =>
      _AccessiblePageStructureState();
}

class _AccessiblePageStructureState
    extends ConsumerState<AccessiblePageStructure> {
  bool _itemsAdded = false;
  static bool _dialogShowing = false; // Global flag to prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    _addStructureItems();
  }

  @override
  void didUpdateWidget(AccessiblePageStructure oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild items when locale changes
    if (oldWidget.currentLocale != widget.currentLocale ||
        oldWidget.structureItems != widget.structureItems) {
      _itemsAdded = false;
      _addStructureItems();
    }
  }

  void _addStructureItems() {
    // Add structure items to the global provider in a post-frame callback
    if (widget.structureItems != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_itemsAdded) {
          ref
              .read(pageStructureItemsProvider.notifier)
              .addItems(widget.structureItems!);
          _itemsAdded = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.pageStructureEnabled) {
      return widget.child;
    }

    // Show the dialog when page structure is enabled (only if not already showing)
    if (!_dialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (settings.pageStructureEnabled && !_dialogShowing) {
          _dialogShowing = true; // Set flag before showing dialog
          _showPageStructureDialog(context);
          // Disable the setting after showing the dialog
          ref
              .read(accessibilitySettingsProvider.notifier)
              .setPageStructureEnabled(false);
        }
      });
    }

    return widget.child;
  }

  void _showPageStructureDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _PageStructureDialog(
        onSectionTap: widget.onSectionTap,
        onDialogClosed: () {
          _dialogShowing = false; // Reset flag when dialog is closed
        },
        currentLocale: widget.currentLocale, // Pass the current locale
      ),
    );
  }
}

/// Represents a page structure item
class PageStructureItem {
  final String label;
  final String? description;
  final PageStructureType type;
  final GlobalKey? key;
  final int level;
  final String? sectionId; // Add section ID for navigation

  const PageStructureItem({
    required this.label,
    this.description,
    required this.type,
    this.key,
    this.level = 0,
    this.sectionId, // Add this parameter
  });
}

/// Types of page structure items
enum PageStructureType {
  heading,
  navigation,
  main,
  section,
  article,
  aside,
  footer,
  button,
  link,
  form,
  other,
}

class _PageStructureDialog extends ConsumerStatefulWidget {
  final Function(String)? onSectionTap; // Add callback
  final VoidCallback? onDialogClosed; // Add callback for when dialog is closed
  final Locale? currentLocale; // Add current locale parameter

  const _PageStructureDialog({
    this.onSectionTap, // Add this parameter
    this.onDialogClosed, // Add this parameter
    this.currentLocale, // Add this parameter
  });

  @override
  ConsumerState<_PageStructureDialog> createState() =>
      _PageStructureDialogState();
}

class _PageStructureDialogState extends ConsumerState<_PageStructureDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Call the callback when dialog is disposed
    widget.onDialogClosed?.call();
    super.dispose();
  }

  void _navigateToSection(String? sectionId) {
    if (sectionId != null && widget.onSectionTap != null) {
      widget.onSectionTap!(sectionId);
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    // Use Localizations.override to get the correct locale
    return Localizations.override(
      context: context,
      locale: widget.currentLocale,
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);

          // Get localized items
          final localizedItems = ref
              .read(pageStructureItemsProvider.notifier)
              .getLocalizedItems(l10n!);

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.layers, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.pageStructureTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _closeDialog,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tabs
                  Container(
                    color: Colors.grey[100],
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue[600],
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: Colors.blue[600],
                      tabs: [
                        Tab(text: l10n.pageStructureHeadings),
                        Tab(text: l10n.pageStructureLandmarks),
                        Tab(text: l10n.pageStructureLinks),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHeadingsTab(localizedItems, l10n),
                        _buildLandmarksTab(localizedItems, l10n),
                        _buildLinksTab(localizedItems, l10n),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadingsTab(
    List<PageStructureItem> structureItems,
    AppLocalizations l10n,
  ) {
    final headings = structureItems
        .where((item) => item.type == PageStructureType.heading)
        .toList();

    if (headings.isEmpty) {
      return _buildEmptyState(l10n.pageStructureNoHeadings);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: headings.length,
      itemBuilder: (context, index) {
        final heading = headings[index];
        return _buildStructureItem(
          heading,
          'H${heading.level}',
          Colors.blue[600]!,
          isClickable: heading.sectionId != null,
        );
      },
    );
  }

  Widget _buildLandmarksTab(
    List<PageStructureItem> structureItems,
    AppLocalizations l10n,
  ) {
    final landmarks = structureItems
        .where(
          (item) => [
            PageStructureType.navigation,
            PageStructureType.main,
            PageStructureType.section,
            PageStructureType.article,
            PageStructureType.aside,
            PageStructureType.footer,
          ].contains(item.type),
        )
        .toList();

    if (landmarks.isEmpty) {
      return _buildEmptyState(l10n.pageStructureNoLandmarks);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: landmarks.length,
      itemBuilder: (context, index) {
        final landmark = landmarks[index];
        return _buildStructureItem(
          landmark,
          _getLandmarkIcon(landmark.type),
          _getLandmarkColor(landmark.type),
          isClickable: landmark.sectionId != null,
        );
      },
    );
  }

  Widget _buildLinksTab(
    List<PageStructureItem> structureItems,
    AppLocalizations l10n,
  ) {
    final links = structureItems
        .where((item) => item.type == PageStructureType.link)
        .toList();

    if (links.isEmpty) {
      return _buildEmptyState(l10n.pageStructureNoLinks);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: links.length,
      itemBuilder: (context, index) {
        final link = links[index];
        return _buildStructureItem(
          link,
          '🔗',
          Colors.green[600]!,
          isClickable: link.sectionId != null,
        );
      },
    );
  }

  Widget _buildStructureItem(
    PageStructureItem item,
    String icon,
    Color color, {
    bool isClickable = false,
  }) {
    // Calculate indentation for levels 2 and above
    final double indent = item.level > 1 ? (item.level * 16).toDouble() : 0.0;

    final listTile = ListTile(
      contentPadding: EdgeInsets.only(
        left: 16 + indent, // Base padding + indentation
        right: 16,
        top: 4,
        bottom: 4,
      ),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          icon,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isClickable ? Colors.blue[700] : Colors.black87,
        ),
      ),
      trailing: isClickable
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[600])
          : null,
      onTap: isClickable ? () => _navigateToSection(item.sectionId) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isClickable ? Colors.blue[200]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      tileColor: isClickable ? Colors.blue[50] : Colors.grey[50],
      hoverColor: isClickable ? Colors.blue[100] : Colors.grey[100],
    );

    return Container(margin: const EdgeInsets.only(bottom: 4), child: listTile);
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLandmarkIcon(PageStructureType type) {
    switch (type) {
      case PageStructureType.navigation:
        return '🧭';
      case PageStructureType.main:
        return '📄';
      case PageStructureType.section:
        return '📋';
      case PageStructureType.article:
        return '📰';
      case PageStructureType.aside:
        return '📌';
      case PageStructureType.footer:
        return '🏁';
      default:
        return '📍';
    }
  }

  Color _getLandmarkColor(PageStructureType type) {
    switch (type) {
      case PageStructureType.navigation:
        return Colors.blue[600]!;
      case PageStructureType.main:
        return Colors.green[600]!;
      case PageStructureType.section:
        return Colors.orange[600]!;
      case PageStructureType.article:
        return Colors.purple[600]!;
      case PageStructureType.aside:
        return Colors.teal[600]!;
      case PageStructureType.footer:
        return Colors.grey[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}

/// A specialized widget that automatically adds itself to page structure
class AccessibleStructureItem extends ConsumerWidget {
  final Widget child;
  final String label;
  final String? description;
  final PageStructureType type;
  final int level;

  const AccessibleStructureItem({
    super.key,
    required this.child,
    required this.label,
    this.description,
    required this.type,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);

    if (!settings.pageStructureEnabled) {
      return child;
    }

    return child;
  }
}
