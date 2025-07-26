import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sections/header_section/header_section.dart';
import 'sections/about_section/about_section.dart';
import 'sections/skills section/skills_section.dart';
import 'sections/projects section/projects_section.dart';
import 'sections/contact_section/contact_section.dart';
import 'sections/resume_section/resume_section.dart';
import '../../widgets/portfolio_nav_bar.dart';
import '../../core/accessibility/accessibility_floating_button.dart';
import '../../widgets/language_switcher.dart';
import '../../core/helpers/section_scroll_service.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'resume': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  late SectionScrollService _scrollService;
  String _currentSection = 'home';
  bool _showStickyNav = false;
  Locale _currentLocale = const Locale('en');
  bool _accessibilityMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollService = SectionScrollService(
      scrollController: _scrollController,
      sectionKeys: _sectionKeys,
    );
    _scrollController.addListener(_onScroll);
    
    // Clear page structure items when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pageStructureItemsProvider.notifier).clearItems();
    });
  }

  void _onScroll() {
    if (!mounted) return;

    // Update current section
    final newSection = _scrollService.getCurrentSection(context);
    if (_currentSection != newSection) {
      _updateCurrentSection(newSection);
    }

    // Update sticky nav visibility
    final shouldShowStickyNav = _scrollService.shouldShowStickyNav(context);
    if (_showStickyNav != shouldShowStickyNav) {
      setState(() {
        _showStickyNav = shouldShowStickyNav;
      });
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
    _scrollService.scrollToSection(
      sectionId,
      alignment: sectionId == 'resume' ? 0.5 : 0.0, // Center Resume section
    );
  }

  void _onLocaleChanged(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
  }

  void _toggleAccessibilityMenu() {
    setState(() {
      _accessibilityMenuOpen = !_accessibilityMenuOpen;
    });
  }

  void _closeAccessibilityMenu() {
    setState(() {
      _accessibilityMenuOpen = false;
    });
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
                        child: AboutSection(onSectionTap: scrollToSection),
                      ),
                      Container(
                        key: _sectionKeys['skills'],
                        child: SkillsSectionScreen(
                          onSectionTap: scrollToSection,
                        ),
                      ),
                      // Resume Section (moved after Skills)
                      Container(
                        key: _sectionKeys['resume'],
                        child: ResumeSection(onSectionTap: scrollToSection),
                      ),
                      Container(
                        key: _sectionKeys['projects'],
                        child: ProjectsSection(onSectionTap: scrollToSection),
                      ),
                      Container(
                        key: _sectionKeys['contact'],
                        child: ContactSection(onSectionTap: scrollToSection),
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
                // LanguageSwitcher at bottom left
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: LanguageSwitcher(
                    currentLocale: _currentLocale,
                    onLocaleChanged: _onLocaleChanged,
                  ),
                ),
                // AccessibilityMenu button at bottom right
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: AccessibilityMenu(
                    languageCode: _currentLocale.languageCode,
                    onLanguageChanged: (lang) {
                      setState(() {
                        _currentLocale = Locale(lang);
                      });
                    },
                    onPressed: _toggleAccessibilityMenu,
                  ),
                ),
                // AccessibilityMenu side panel (in-tree, persistent, non-blocking)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  bottom: 0,
                  right: _accessibilityMenuOpen ? 0 : -340,
                  child: _accessibilityMenuOpen
                      ? Material(
                          color: Colors.grey.shade100,
                          child: SizedBox(
                            width: (MediaQuery.of(context).size.width * 0.9)
                                .clamp(0, 340),
                            height: MediaQuery.of(context).size.height,
                            child: AccessibilityMenuContent(
                              languageCode: _currentLocale.languageCode,
                              onLanguageChanged: (lang) {
                                setState(() {
                                  _currentLocale = Locale(lang);
                                });
                              },
                              onClose: _toggleAccessibilityMenu,
                              onPageStructureOpen:
                                  _closeAccessibilityMenu, // Close AFB when page structure opens
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
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
