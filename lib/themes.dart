import 'package:flutter/material.dart';

// TODO: Add my colors from "constants/colors.dart" into here

// Light theme (index 0), dark theme (index 1)
List<ThemeData> themesList = [
  ThemeData(
    backgroundColor: Colors.blue,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.pink,
        onPrimary: Colors.green,
        secondary: Colors.red,
        onSecondary: Colors.amber,
        error: Colors.lightBlue,
        onError: Colors.purple,
        background: Colors.deepPurple,
        onBackground: Colors.pink,
        surface: Colors.cyan,
        onSurface: Colors.orange),
  ),
  ThemeData(
    backgroundColor: Colors.pink,
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
