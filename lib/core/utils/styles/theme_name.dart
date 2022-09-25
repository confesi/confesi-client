import 'package:flutter/material.dart';

String themeName(BuildContext context) {
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    return "Dark";
  } else {
    return "Light";
  }
}
