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
        primary: Colors.yellow,
        onPrimary: Colors.orange,
        secondary: Colors.blue,
        onSecondary: Colors.green,
        error: Colors.pink,
        onError: Colors.white,
        background: Colors.indigo,
        onBackground: Colors.black,
        surface: Colors.orange,
        onSurface: Colors.cyanAccent),
  )
];
