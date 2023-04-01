import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFE04D01);
  static const Color secondaryColor = Color(0xFF0C4F9A);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color backgroundAccent = Color(0xFFEEEEEE);

  static const Color errorColor = Color(0xFFFF5252);
  static const Color succesColor = Color(0xFF11AD42);

  static const fontFamily = 'JetbrainsMono';

  static const defaultBoxShadow = BoxShadow(
    color: Color(0x27000000),
    blurRadius: 8.0,
    spreadRadius: 2.0,
  );

  static const bigHeader = TextStyle(
    fontSize: 25,
    color: primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const mediumHeader = TextStyle(
    fontSize: 19,
    color: primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const mediumBody = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );

  static const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: primaryColor,
    secondary: secondaryColor,
    onSecondary: secondaryColor,
    error: errorColor,
    onError: errorColor,
    background: backgroundColor,
    onBackground: backgroundAccent,
    surface: backgroundColor,
    onSurface: backgroundAccent,
  );

  static var themeData = ThemeData(
    colorScheme: colorScheme,
    textTheme: const TextTheme(
      headlineLarge: bigHeader,
      headlineMedium: mediumHeader,
      bodyMedium: mediumBody,
    ),
  );
}
