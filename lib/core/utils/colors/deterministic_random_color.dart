import 'dart:math';

import 'package:flutter/material.dart';

Color genColor(int seed, int val) {
  int calcSeed = seed.hashCode ^ val.hashCode;
  // Create a Random object with the seed
  Random random = Random(calcSeed);
  // Generate a random number within the valid color range
  int rando = random.nextInt(0xFFFFFF + 1);
  // Ensure that the randomVal is within the valid color range (0x000000 to 0xFFFFFF)
  rando &= 0xFFFFFF;
  // Set the alpha value to 255 (fully opaque)
  rando |= 0xFF000000;
  return Color(rando);
}
