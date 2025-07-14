import 'package:flutter/material.dart';
import '../sections/header_section.dart';
import '../sections/about_section.dart';
import '../sections/projects_section.dart';
import '../sections/lab_section.dart';
import '../sections/contact_section.dart';
import '../widgets/sticky_nav_bar.dart';
import '../widgets/language_switcher.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'projects': GlobalKey(),
    'lab': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _currentSection = 'home';
  bool _showStickyNav = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollPosition = _scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;

    // Show sticky nav when scrolling past header
    final shouldShowStickyNav = scrollPosition > screenHeight * 0.3;
    if (_showStickyNav != shouldShowStickyNav) {
      setState(() {
        _showStickyNav = shouldShowStickyNav;
      });
    }

    // Calculate which section is currently visible with 20% threshold
    final sectionHeight = screenHeight;
    final threshold = sectionHeight * 0.2; // 20% threshold

    String newSection = 'home';

    if (scrollPosition < sectionHeight - threshold) {
      newSection = 'home';
    } else if (scrollPosition < sectionHeight * 2 - threshold) {
      newSection = 'about';
    } else if (scrollPosition < sectionHeight * 3 - threshold) {
      newSection = 'projects';
    } else if (scrollPosition < sectionHeight * 4 - threshold) {
      newSection = 'lab';
    } else {
      newSection = 'contact';
    }

    // If section changed, update navigation
    if (_currentSection != newSection) {
      _updateCurrentSection(newSection);
    }
  }

  void _updateCurrentSection(String section) {
    if (_currentSection != section) {
      setState(() {
        _currentSection = section;
      });
    }
  }

  void scrollToSection(String sectionId) {
    try {
      final key = _sectionKeys[sectionId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      // Handle scroll errors gracefully
      debugPrint('Error scrolling to section: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  key: _sectionKeys['home'],
                  child: HeaderSection(
                    onSectionTap: scrollToSection,
                    currentSection: _currentSection,
                    currentLocale: widget.currentLocale,
                    onLocaleChanged: widget.onLocaleChanged,
                  ),
                ),
                Container(
                  key: _sectionKeys['about'],
                  child: const AboutSection(),
                ),
                Container(
                  key: _sectionKeys['projects'],
                  child: const ProjectsSection(),
                ),
                Container(key: _sectionKeys['lab'], child: const LabSection()),
                Container(
                  key: _sectionKeys['contact'],
                  child: const ContactSection(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StickyNavBar(
              onSectionTap: scrollToSection,
              currentSection: _currentSection,
              isVisible: _showStickyNav,
              currentLocale: widget.currentLocale,
              onLocaleChanged: widget.onLocaleChanged,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        child: LanguageSwitcher(
          currentLocale: widget.currentLocale,
          onLocaleChanged: widget.onLocaleChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
