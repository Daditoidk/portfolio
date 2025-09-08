import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../b4s_colors.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

class B4SSplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const B4SSplashScreen({super.key, required this.onSplashComplete});

  @override
  State<B4SSplashScreen> createState() => _B4SSplashScreenState();
}

class _B4SSplashScreenState extends State<B4SSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _startSplashAnimation();
  }

  void _startSplashAnimation() async {
    // Iniciar animación del logo
    await _logoAnimationController.forward();

    // Esperar un poco
    await Future.delayed(const Duration(milliseconds: 500));

    // Iniciar fade out
    await _fadeAnimationController.forward();

    // Llamar al callback cuando termine
    widget.onSplashComplete();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: B4SDemoColors.registerGradient,
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_logoScaleAnimation, _fadeAnimation]),
          builder: (context, child) {
            final scale = _logoScaleAnimation.value.clamp(0.0, 1.0);
            final opacity = (1.0 - _fadeAnimation.value).clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Center(
                child: Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 40),
                      Text(
                        l10n.b4sSplashTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.b4sSplashSubtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
