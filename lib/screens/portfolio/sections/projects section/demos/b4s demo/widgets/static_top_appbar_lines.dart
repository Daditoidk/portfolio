import 'package:flutter/material.dart';

class StaticAppBarInnerLineTop extends StatelessWidget {
  const StaticAppBarInnerLineTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/demos/b4s/in_line_appbar.png',
      height: 486.37,
      width: 550.61,
    );
  }
}

class StaticAppBarOuterLineTop extends StatelessWidget {
  const StaticAppBarOuterLineTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/demos/b4s/in_line_appbar.png',
      height: 486.37,
      width: 550.61,
      color: Color(0xFF909090),
      colorBlendMode: BlendMode.srcIn,
    );
  }
}
