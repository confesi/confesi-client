import 'package:flutter/material.dart';

/// The theme class for the app.
class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Color.fromARGB(255, 0, 0, 0), // Change to black
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 0, 0, 0), // Change to black
      onPrimary: Colors.white, // White text on black
      secondary: Color.fromARGB(255, 111, 191, 197), // Strong secondary color
      onSecondary: Color.fromARGB(255, 75, 75, 75),
      error: Color.fromARGB(255, 232, 96, 96),
      onError: Colors.black,
      tertiary: Color(0xffFFE891),
      surfaceTint: Color.fromARGB(255, 132, 135, 132),
      background: Colors.white, // White background
      onBackground: Color.fromARGB(255, 180, 180, 180), // Darker text on light background
      surface: Color.fromARGB(255, 230, 230, 230), // Slightly darker surface color
      onSurface: Color.fromARGB(255, 104, 104, 104),
      shadow: Color.fromARGB(255, 200, 200, 200), // Slightly darker shadow color
      primaryContainer: Color(0xffF7DDB4),
      secondaryContainer: Color(0xffF7DDB4),
      onErrorContainer: Color.fromARGB(255, 140, 235, 144),
      onSecondaryContainer: Color.fromARGB(255, 215, 120, 115),
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
      tertiary: Color(0xff8BE8E5),
      onSecondary: Color.fromARGB(255, 45, 45, 45),
      secondary: Color(0xffFFE17B),
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
