import 'dart:math';

IntroText getIntro() => _introTexts[Random().nextInt(_introTexts.length)];

List<IntroText> _introTexts = [
  IntroText(text: "Confessions are always anonymous."),
  IntroText(text: "Juicy confessions often rise to the top!"),
  IntroText(
      text: "You can reply with a post to a confession by clicking \"reply\"."),
];

class IntroText {
  final String text;

  IntroText({required this.text});
}
