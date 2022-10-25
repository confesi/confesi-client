import 'package:flutter/material.dart';

/// Gets the current appearance.
Brightness appearanceBrightness(BuildContext context) => MediaQuery.of(context).platformBrightness;
