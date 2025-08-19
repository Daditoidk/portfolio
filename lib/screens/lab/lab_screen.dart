import 'package:flutter/material.dart';
import '../../widgets/language_switcher.dart';
import '../../widgets/nav_toggle_button.dart';
import 'text_layout/editor/text_layout_editor.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  Locale _currentLocale = const Locale('en');

  void _onLocaleChanged(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
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
            body: Stack(
              children: [
                // Background Image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bgs/lab_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Content Overlay (optional - for future content)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Portfolio Navigation Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  child: NavToggleButton(goLab: false),
                ),
                // Language Switcher
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: LanguageSwitcher(
                    currentLocale: _currentLocale,
                    onLocaleChanged: _onLocaleChanged,
                  ),
                ),
                // Text Layout Editor Button
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TextLayoutEditor(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Text Layout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
