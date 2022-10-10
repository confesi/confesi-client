import 'package:flutter/material.dart';

/// Gets the current appearance.
Brightness appearanceType(BuildContext context) =>
    MediaQuery.of(context).platformBrightness;
