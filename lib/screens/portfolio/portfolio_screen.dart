import 'package:flutter/material.dart';
import 'sections/header_section/header_section.dart';
import 'sections/about_section/about_section.dart';
import 'sections/skills section/skills_section.dart';
import 'sections/projects section/projects_section.dart';
import 'sections/contact_section/contact_section.dart';
import 'sections/resume_section/resume_section.dart';
import '../../widgets/portfolio_nav_bar.dart';
import '../../widgets/language_switcher.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'resume': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _currentSection = 'home';
  bool _showStickyNav = false;
  Locale _currentLocale = const Locale('en');

  void _onLocaleChanged(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    final scrollPosition = _scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerOfScreen = scrollPosition + screenHeight / 2;

    // Show sticky nav when scrolling past header
    final shouldShowStickyNav = scrollPosition > screenHeight * 0.3;
    if (_showStickyNav != shouldShowStickyNav) {
      setState(() {
        _showStickyNav = shouldShowStickyNav;
      });
    }

    // Find the section whose center is closest to the center of the viewport
    String newSection = 'home';
    double minDistance = double.infinity;
    _sectionKeys.forEach((section, key) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position =
            box.localToGlobal(Offset.zero, ancestor: null).dy + scrollPosition;
        final sectionHeight = box.size.height;
        final sectionCenter = position + sectionHeight / 2;
        final distance = (centerOfScreen - sectionCenter).abs();
        if (distance < minDistance) {
          minDistance = distance;
          newSection = section;
        }
      }
    });

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
          alignment: sectionId == 'resume' ? 0.5 : 0.0, // Center Resume section
        );
      }
    } catch (e) {
      // Handle scroll errors gracefully
      debugPrint('Error scrolling to section: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: _currentLocale,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
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
                          currentLocale: _currentLocale,
                          onLocaleChanged: _onLocaleChanged,
                        ),
                      ),
                      Container(
                        key: _sectionKeys['about'],
                        child: const AboutSection(),
                      ),
                      Container(
                        key: _sectionKeys['skills'],
                        child: const SkillsSectionScreen(),
                      ),
                      // Resume Section (moved after Skills)
                      Container(
                        key: _sectionKeys['resume'],
                        child: const ResumeSection(),
                      ),
                      Container(
                        key: _sectionKeys['projects'],
                        child: const ProjectsSection(),
                      ),
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
                  child: PortfolioNavBar(
                    onSectionTap: scrollToSection,
                    currentSection: _currentSection,
                    isVisible: _showStickyNav,
                    currentLocale: _currentLocale,
                    onLocaleChanged: _onLocaleChanged,
                    isSticky: true,
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: LanguageSwitcher(
                currentLocale: _currentLocale,
                onLocaleChanged: _onLocaleChanged,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
