import 'dart:math';

class SplashScreenHintManager {
  static final SplashScreenHintManager _instance = SplashScreenHintManager._internal();

  factory SplashScreenHintManager() {
    return _instance;
  }

  SplashScreenHintManager._internal();

  final List<SplashScreenHintText> _hintTexts = [
    SplashScreenHintText(text: 'Get ready to ROFL'),
    SplashScreenHintText(text: 'Here we go...'),
    SplashScreenHintText(text: 'Woooooo'),
    SplashScreenHintText(text: "I'm bored"),
  ];

  SplashScreenHintText getHint() => _hintTexts[Random().nextInt(_hintTexts.length)];
}

class SplashScreenHintText {
  final String text;

  SplashScreenHintText({required this.text});
}
