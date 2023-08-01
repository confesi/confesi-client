import 'package:flutter/material.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';

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
      // secondary: Color.fromARGB(255, 254, 224, 115),
      secondary: Color.fromARGB(255, 59, 123, 197),
      onSecondary: Color(0xff333333),
      error: Color.fromARGB(255, 231, 104, 104), // "ERROR" color
      onError: Colors.white,
      surfaceTint: Color(0xff90A17D), // "SUCCESS" color
      background: Color.fromARGB(255, 251, 251, 251),
      onBackground: Color.fromARGB(255, 217, 217, 217),
      surface: Color.fromARGB(255, 246, 246, 246),
      onSurface: Color.fromARGB(255, 179, 179, 179),
      shadow: Color.fromARGB(255, 233, 233, 233),
      primaryContainer: Color(0xfffde5b6), // Badge's light color.
      secondaryContainer: Color(0xfffde5b6), // Badge's dark color.
      onErrorContainer: Color.fromARGB(255, 147, 246, 150), // Color for post reaction
      onSecondaryContainer: Color.fromARGB(255, 230, 125, 121), // Color for post reaction
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
      // secondary: Color.fromARGB(255, 254, 224, 115),
      // secondary: Color.fromARGB(255, 255, 221, 141),
      secondary: Color(0xff5CE1E6),
      onSecondary: Color.fromARGB(255, 45, 45, 45),
      surfaceTint: Color(0xff90A17D), // "SUCCESS" color
      error: Color.fromARGB(255, 231, 104, 104), // "ERROR" color
      onError: Colors.white, // Color for on error and on surfaceTint.
      background: Color.fromARGB(255, 28, 28, 28),
      onBackground: Color.fromARGB(255, 46, 46, 46),
      surface: Color.fromARGB(255, 36, 36, 36),
      onSurface: Color(0xff7d7d7d),
      shadow: Color.fromARGB(255, 23, 23, 23),
      primaryContainer: Color(0xff333333), // Badge's light color.
      secondaryContainer: Color(0xfffde5b6), // Badge's dark color.
      onErrorContainer: Color(0xff59CE8F), // Color for post reaction
      onSecondaryContainer: Color(0xffEB4747), // Color for post reaction
    ),
  );
}
