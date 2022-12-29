import 'package:flutter/material.dart';

/// The theme class for the app.
class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Colors.white,
      brightness: Brightness.light,
      primary: Color(0xff333333),
      onPrimary: Color.fromARGB(255, 244, 244, 244),
      secondary: Color(0xffF1A661),
      onSecondary: Color(0xff333333),
      error: Color(0xffEB5353),
      onError: Colors.white,
      surfaceTint: Color(0xff90A17D),
      background: Colors.white,
      onBackground: Color.fromARGB(255, 214, 214, 214),
      surface: Color.fromARGB(255, 240, 239, 239),
      onSurface: Color.fromARGB(255, 147, 147, 147),
      shadow: Color.fromARGB(255, 223, 221, 221),
      primaryContainer: Color(0xfffde5b6), // Badge's light color.
      secondaryContainer: Color.fromARGB(255, 151, 107, 20), // Badge's dark color.
    ),
  );

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
      secondary: Color.fromARGB(255, 254, 224, 115),
      onSecondary: Color(0xff333333),
      surfaceTint: Color(0xff90A17D),
      error: Color(0xffEB5353),
      onError: Colors.white, // Color for on error and on surfaceTint.
      background: Color(0xff2a2a2a),
      onBackground: Color.fromARGB(255, 83, 83, 83),
      surface: Color.fromARGB(255, 55, 55, 55),
      onSurface: Color(0xff7d7d7d),
      shadow: Color.fromARGB(255, 29, 28, 28),
      primaryContainer: Color(0xff333333), // Badge's light color.
      secondaryContainer: Color(0xfffde5b6), // Badge's dark color.
      onErrorContainer: Color(0xff59CE8F), // Color for post reaction
      onSecondaryContainer: Color(0xffEB4747), // Color for post reaction
      onInverseSurface: Color(0xffFF9F29), // Color for post reaction
      // onPrimaryContainer: Color(0xffF473B9), // Color for post reaction (link)
    ),
  );
}
