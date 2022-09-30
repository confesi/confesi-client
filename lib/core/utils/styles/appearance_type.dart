import 'package:flutter/material.dart';

/// Gets the current appearance.
Brightness appAppearance(BuildContext context) =>
    MediaQuery.of(context).platformBrightness;
