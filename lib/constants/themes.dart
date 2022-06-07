import 'package:flutter/material.dart';

// Light theme (index 0), dark theme (index 1)
List<ThemeData> themesList = [
  ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff333333),
      onPrimary: Colors.white,
      secondary: Color(0xffF6C0F6),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      background: Colors.white,
      onBackground: Color(0xff595959),
      surface: Color(0xffDFDFDE),
      onSurface: Color(0xff595959),
    ),
  ),
  ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe6f5fc),
      onPrimary: Color(0xff333333),
      secondary: Color(0xffe6dcf5),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      background: Color(0xff2a2a2a),
      onBackground: Color(0xff7d7d7d),
      surface: Color(0xff7d7d7d),
      onSurface: Color(0xff7d7d7d),
    ),
  )
];
