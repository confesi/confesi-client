import 'package:flutter/material.dart';

/// Gets the app's appearance name.
///
/// Primarily for display purposes.
String appearanceName(BuildContext context) {
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    return "Dark";
  } else {
    return "Light";
  }
}
