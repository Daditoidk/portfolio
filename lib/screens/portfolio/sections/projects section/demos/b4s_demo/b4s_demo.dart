import 'package:flutter/material.dart';
import 'widgets/field_screen.dart';
import 'widgets/b4s_splash_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'b4s_colors.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

// Demo de Brain4Goals App - Versión simplificada
class Brain4GoalsDemo extends StatefulWidget {
  const Brain4GoalsDemo({super.key});

  @override
  State<Brain4GoalsDemo> createState() => _Brain4GoalsDemoState();
}

class _Brain4GoalsDemoState extends State<Brain4GoalsDemo> {
  bool _showOverlay = true;
  bool _splashComplete = false;

  void _startDemo() {
    setState(() {
      _showOverlay = false;
    });
  }

  void _onSplashComplete() {
    setState(() {
      _splashComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_showOverlay) {
      return GestureDetector(
        onTap: _startDemo,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/demos/b4s/logo_clean.svg',
                  width: 80,
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    B4SDemoColors.buttonRed,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.b4sDemoTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    l10n.b4sDemoTapToStart,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

        ),
      );
    } else if (!_splashComplete) {
      return B4SSplashScreen(onSplashComplete: _onSplashComplete);
    } else {
      return const FieldScreen();
    }
  }
}
