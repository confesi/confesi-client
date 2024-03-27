import 'package:flutter/material.dart';

// tertiary: Color(0xff9EDDFF),

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Color.fromARGB(220, 239, 239, 239),
      surfaceVariant: Color.fromARGB(255, 23, 23, 23),
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 229, 233, 243),
      onPrimary: Color(0xff333333),
      secondary: Color.fromARGB(255, 255, 172, 241),
      onSecondary: Color(0xff333333),
      tertiary: Color.fromARGB(255, 255, 172, 241),
      surfaceTint: Color(0xff90A17D),
      error: Color(0xffFF6F6F),
      onError: Color.fromARGB(255, 247, 230, 230),
      background: Color.fromARGB(255, 30, 34, 43),
      onBackground: Color.fromARGB(255, 58, 63, 79),
      surface: Color.fromARGB(255, 38, 44, 58),
      onSurface: Color.fromARGB(255, 56, 71, 87),
      shadow: Color.fromARGB(255, 26, 27, 36), // Color.fromARGB(255, 26, 27, 36)
      primaryContainer: Color(0xff333333),
      secondaryContainer: Color(0xfffde5b6),
      onErrorContainer: Color(0xff59CE8F),
      onSecondaryContainer: Color(0xffEB4747),
      onTertiaryContainer: Color.fromARGB(255, 38, 44, 58),
    ),
  );

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    colorScheme: const ColorScheme(
      onSurfaceVariant: Color.fromARGB(255, 45, 45, 45), // Darker text for white background
      surfaceVariant: Color.fromARGB(255, 250, 250, 250), // Very light gray surface
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 0, 0, 0), // Darker shade for primary text/actions
      onPrimary: Color(0xffFAFAFA), // Almost white for content on primary
      tertiary: Color.fromARGB(255, 247, 95, 95),
      onSecondary: Color.fromARGB(255, 255, 255, 255), // White for content on secondary color
      secondary: Color.fromARGB(255, 247, 95, 95),
      surfaceTint: Color(0xffA1B19C), // A slightly brighter surface tint
      error: Color.fromARGB(255, 231, 104, 104), // Keeping error color consistent
      onError: Colors.white, // White text/icons for error background
      background: Color.fromARGB(255, 255, 255, 255), // Pure white background
      onBackground: Color.fromARGB(255, 212, 212, 212), // Darker text on white background
      surface: Color.fromARGB(255, 241, 241, 241), // Almost white surface
      onSurface: Color.fromARGB(255, 0, 0, 0), // Dark text/icons for almost white surface
      shadow: Color.fromARGB(255, 236, 236, 236), // Light shadow
      primaryContainer: Color(0xff555555), // Dark primary container for contrast
      secondaryContainer: Color(0xfffde5b6), // Keeping the secondary container consistent
      onErrorContainer: Color(0xff59CE8F), // Keeping it consistent
      onSecondaryContainer: Color(0xffEB4747), // Keeping it consistent
      onTertiaryContainer: Color.fromARGB(255, 227, 224, 224),
    ),
  );
}
