import 'dart:math';

import 'package:flutter/material.dart';

class BounceBack extends Curve {
  @override
  double transformInternal(double t) {
    return -(pow((1.62438 * t - 1.12), 2)) + 1.2544;
  }
}
