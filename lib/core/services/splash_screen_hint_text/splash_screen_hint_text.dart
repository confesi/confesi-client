import 'dart:math';

class SplashScreenHintManager {
  static final SplashScreenHintManager _instance = SplashScreenHintManager._internal();

  factory SplashScreenHintManager() {
    return _instance;
  }

  SplashScreenHintManager._internal();

  final List<SplashScreenHintText> _hintTexts = [
    SplashScreenHintText(text: 'Catch our attention here'),
    SplashScreenHintText(text: 'Welcome'),
  ];

  SplashScreenHintText getHint() => _hintTexts[Random().nextInt(_hintTexts.length)];
}

class SplashScreenHintText {
  final String text;

  SplashScreenHintText({required this.text});
}
