import 'package:flutter/material.dart';

/// The theme class for the app.
class AppTheme {
  /// App's light theme.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Colors.white,
      brightness: Brightness.light,
      primary: Color(0xff333333),
      onPrimary: Color.fromARGB(255, 244, 244, 244),
      secondary: Color(0xfffde5b6),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      background: Colors.white,
      onBackground: Color.fromARGB(255, 214, 214, 214),
      surface: Color.fromARGB(255, 246, 246, 246),
      onSurface: Color.fromARGB(255, 147, 147, 147),
      shadow: Color.fromARGB(255, 232, 232, 232),
      primaryContainer: Color(0xfffde5b6), // Badge's light color.
      secondaryContainer:
          Color.fromARGB(255, 151, 107, 20), // Badge's dark color.
    ),
  );

  /// App's dark theme.
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Colors.white,
      surfaceVariant: Color.fromARGB(255, 23, 23, 23),
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 238, 239, 240),
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
      primaryContainer: Color(0xff333333), // Badge's light color.
      secondaryContainer: Color(0xfffde5b6), // Badge's dark color.
    ),
  );
}
