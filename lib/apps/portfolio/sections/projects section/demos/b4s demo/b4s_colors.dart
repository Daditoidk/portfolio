import 'package:flutter/material.dart';

/// Colores específicos para el demo de B4S
/// Basado en las constantes del proyecto real
class B4SDemoColors {
  // Colores principales
  static const Color primaryRed = Color(0xffD51118);
  static const Color lightRed = Color(0xFFFF001B);
  static const Color darkRed = Color(0xFFB71C1C);

  // Colores de fondo
  static const Color scaffoldBackground = Color(0xffE5E5E5);
  static const Color modalsBackground = Color(0xffFFFFFF);
  static const Color appBarBackground = Color(0xffFFFFFF);

  // Colores de texto
  static const Color textWhite = Color(0xffF3F3F3);
  static const Color textBlack = Colors.black;
  static const Color textGrey = Color(0xff3D3D3D);

  // Colores de botones
  static const Color buttonRed = Color(0xffD51118);
  static const Color buttonBlack = Colors.black;
  static const Color buttonWhite = Colors.white;

  // Colores de gradientes
  static const Color gradientRed = Color(0xff9F3C3C);
  static const Color gradientPink = Color(0xff47353F);
  static const Color gradientBlack = Color(0xff121B21);
  static const Color gradientPinkRed = Color(0xff42333D);
  static const Color gradientYellow = Color(0xff775B2E);

  // Colores de elementos UI
  static const Color dividerColor = Color(0xffE1E1E1);
  static const Color progressBackground = Colors.white54;
  static const Color progressColor = Colors.white;

  // Gradientes
  static const LinearGradient mainGradient = LinearGradient(
    colors: [gradientRed, gradientPink, gradientBlack],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient registerGradient = LinearGradient(
    colors: [gradientPinkRed, gradientYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const gradientRegisterDetailView = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff1E1F1F), Color(0xff775B2E)],
    stops: [0.25, 0.75],
  );
}

/// Assets específicos para el demo de B4S
/// Basado en las constantes del proyecto real
class B4SDemoAssets {
  static const String logo = 'assets/demos/b4s/logo_clean.svg';
  static const String backgroundField = 'assets/demos/b4s/field.png';
  static const String redFlag = 'assets/demos/b4s/red_flag.png';
  static const String grayFlag = 'assets/demos/b4s/gray_flag.png';
}
