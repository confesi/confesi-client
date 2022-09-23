import 'package:flutter/material.dart';

/// Returns the screen width * [fraction].
double widthFraction(BuildContext context, double fraction) =>
    MediaQuery.of(context).size.width * fraction;
