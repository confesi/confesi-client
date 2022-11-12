import '../../../constants/authentication_and_settings/text.dart';
import 'package:flutter/material.dart';

/// Gets the app's appearance name.
///
/// Primarily for display purposes.
String appearanceName(BuildContext context) {
  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    return kDarkAppearance;
  } else {
    return kLightAppearance;
  }
}
