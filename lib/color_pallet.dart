import 'dart:math';
import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class Palette {
  static const Color cuiOffWhite = Color(0xFFF0F0F0);
  static const Color appredColor = Color(0xffE74140);
  static const Color cuiBlue = Color(0xFF115ea6);
  static const Color frenchBlue = Color(0xffE74140);
  static const Color aeroBlue = Color(0xFF8BBCE5);
  static const Color aliceBlue = Color(0xFFEFF2FA);
  static const Color red = Color(0xFFF32423);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkWhite = Color.fromARGB(255, 235, 235, 235);
  static const Color black = Color(0xFF040F0F);
  static const Color grey = Color(0xFF7C8483);
  static const Color hintGrey = Color(0xFF989BA2);
  static const Color yellow = Color(0xFFFFCC49);
  static const Color blueInformation = Color(0xffE74140);
  static const Color green = Color(0xFF48B527);
  static const Color textColor = Color(0xFF2F2E41);
  static const Color homeButtonGrey = Color(0xFFAEB0BB);
  static const Color buttonBackground = Color.fromARGB(36, 231, 64, 64);
  static const Color location = Color(0xffE74140);
  static const Color faceid = Color(0xffE74140);
  static const Color notifications = Color(0xFF48B527);
  static const Color language = Color(0xFFFFB8B8);
  static const Color help = Color(0xffE74140);
  static const Color privacyPolicy = Color(0xFF37393F);
  static const Color orange = Color(0xFFFFA500);
  static const Color logOut = Color(0xFFF32423);
}
