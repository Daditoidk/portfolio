import 'package:flutter/material.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

class FieldFlag extends StatelessWidget {
  final String label;
  final String flagAsset;
  final int percent;
  final bool isToday;
  final bool isCenter;
  final bool isActive;
  final double height;
  final double width;

  const FieldFlag({
    super.key,
    required this.label,
    required this.flagAsset,
    required this.percent,
    required this.isToday,
    required this.isCenter,
    required this.isActive,
    this.height = 64,
    this.width = 44,
  });

  Widget _percentageOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '$percent%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
            fontFamily: 'Satoshi',
            shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
      ),
    );
  }

  Widget _hoyLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      bottom: 18,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        width: 43.5,
        color: Colors.white,
        child: Center(
          child: Text(
            l10n.todayLabel.length <= 3 ? l10n.todayLabel : 'HOY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.red,
              fontFamily: 'Satoshi',
            ),
          ),
        ),
      ),
    );
  }

  Widget _ballOverlay() {
    return Positioned(
      bottom: -30,
      left: -10,
      right: -10,
      child: Image.asset(
        percent > 0
            ? 'assets/demos/b4s/ball_unlock.png'
            : 'assets/demos/b4s/ball_lock.png',
        width: 64,
        height: 64,
      ),
    );
  }

  Widget _flagLine() {
    // Place the line below the flag image, except for the center flag
    if (isCenter) return SizedBox.shrink();
    return Positioned(
      top: 50, // directly below the flag image (height: 64)
      left: 21,
      child: Container(width: 2, height: 18, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _flagLine(),
            Image.asset(flagAsset, height: height, width: width),
            if (isToday) _hoyLabel(context),
            if (isCenter) _ballOverlay(),
            _percentageOverlay(), // Move this to the end so it's on top
          ],
        ),
        // Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xff2C2B2B),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Satoshi',
            ),
          ),
        ),
      ],
    );
  }
}
