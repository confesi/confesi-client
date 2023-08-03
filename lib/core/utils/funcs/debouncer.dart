import 'dart:async';

import 'package:flutter/foundation.dart';

/// A single instance will only call the passed function if it hasn't been called previously
/// within the last [milliseconds], after waiting [milliseconds].
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 250});

  void run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
