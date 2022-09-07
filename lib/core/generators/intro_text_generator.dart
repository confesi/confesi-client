import 'dart:math';

IntroText getIntro() => introTexts[Random().nextInt(introTexts.length)];

List<IntroText> introTexts = [
  IntroText(text: "Confessions are always anonymous."),
  IntroText(text: "Juicy confessions always rise to the top!"),
  IntroText(
      text:
          "You can reply with a confession to a confession by clicking \"reply\"."),
];

class IntroText {
  final String text;

  IntroText({required this.text});
}
