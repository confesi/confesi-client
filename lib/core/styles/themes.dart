import 'package:flutter/material.dart';

/// The theme class for the app.
class AppTheme {
  /// App's light theme.
  static ThemeData lightTheme = ThemeData(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    cardColor: const Color(0xfffde5b6), // Badge's light color.
    canvasColor: const Color.fromARGB(255, 151, 107, 20), // Badge's dark color.
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff333333),
      onPrimary: Colors.white,
      secondary: Color(0xfffde5b6),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      background: Colors.white,
      onBackground: Color.fromARGB(255, 214, 214, 214),
      surface: Color.fromARGB(255, 246, 246, 246),
      onSurface: Color.fromARGB(255, 147, 147, 147),
      shadow: Color.fromARGB(255, 232, 232, 232),
    ),
  );

  /// App's dark theme.
  static ThemeData darkTheme = ThemeData(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    cardColor: const Color(0xff2a2a2a), // Badge's light color.
    canvasColor: const Color(0xfffde5b6), // Badge's dark color.
    colorScheme: const ColorScheme(
      surfaceVariant: Color.fromARGB(255, 23, 23, 23),
      brightness: Brightness.dark,
      primary: Color(0xffd7dadc),
      onPrimary: Color(0xff333333),
      secondary: Color(0xfffde5b6),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      background: Color(0xff2a2a2a),
      onBackground: Color.fromARGB(255, 83, 83, 83),
      surface: Color.fromARGB(255, 55, 55, 55),
      onSurface: Color(0xff7d7d7d),
      shadow: Color.fromARGB(255, 19, 18, 18),
    ),
  );
}
