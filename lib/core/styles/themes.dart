import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Colors.white,
      surfaceVariant: Color.fromARGB(255, 23, 23, 23),
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 238, 239, 240),
      onPrimary: Color(0xff333333),
      tertiary: Color.fromARGB(255, 255, 78, 164),
      onSecondary: Color.fromARGB(255, 45, 45, 45),
      secondary: Color.fromARGB(255, 255, 193, 131),
      surfaceTint: Color(0xff90A17D),
      error: Color.fromARGB(255, 231, 104, 104),
      onError: Colors.white,
      background: Color.fromARGB(255, 28, 28, 28),
      onBackground: Color.fromARGB(255, 46, 46, 46),
      surface: Color.fromARGB(255, 36, 36, 36),
      onSurface: Color(0xff7d7d7d),
      shadow: Color(0xff171717),
      primaryContainer: Color(0xff333333),
      secondaryContainer: Color(0xfffde5b6),
      onErrorContainer: Color(0xff59CE8F),
      onSecondaryContainer: Color(0xffEB4747),
    ),
  );

  static ThemeData light = ThemeData(
    brightness: Brightness.dark,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Color.fromARGB(255, 20, 20, 20), // Slightly brighter than dark theme
      surfaceVariant: Color.fromARGB(255, 25, 25, 25), // Slightly brighter than dark theme
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 240, 241, 242), // Slightly brighter than dark theme
      onPrimary: Color(0xff333333), // Same as dark theme
      tertiary: Color(0xff8BE8E5), // Same as dark theme
      onSecondary: Color.fromARGB(255, 45, 45, 45), // Same as dark theme
      secondary: Color(0xffFFE17B), // Same as dark theme
      surfaceTint: Color(0xff90A17D), // Same as dark theme
      error: Color.fromARGB(255, 231, 104, 104), // Same as dark theme
      onError: Colors.white, // Same as dark theme
      background: Color.fromARGB(255, 30, 30, 30), // Slightly brighter than dark theme
      onBackground: Color.fromARGB(255, 46, 46, 46), // Same as dark theme
      surface: Color.fromARGB(255, 38, 38, 38), // Slightly brighter than dark theme
      onSurface: Color(0xff7d7d7d), // Same as dark theme
      shadow: Color(0xff171717),
      primaryContainer: Color(0xff333333), // Same as dark theme
      secondaryContainer: Color(0xfffde5b6), // Same as dark theme
      onErrorContainer: Color(0xff59CE8F), // Same as dark theme
      onSecondaryContainer: Color(0xffEB4747), // Same as dark theme
    ),
  );
}
