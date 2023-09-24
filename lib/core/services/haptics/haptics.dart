// does not need to be injected, since it can be called statically

import 'package:flutter/services.dart';

enum H { off, select, regular, medium, large }

class Haptics {
  // static method to do vibration via type
  static void f(H type) {
    switch (type) {
      case H.off:
        break;
      case H.select:
        HapticFeedback.selectionClick();
        break;
      case H.regular:
        HapticFeedback.lightImpact();
        break;
      case H.medium:
        HapticFeedback.mediumImpact();
        break;
      case H.large:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}
