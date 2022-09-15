import 'dart:math';

IntroText getIntro() => _introTexts[Random().nextInt(_introTexts.length)];

List<IntroText> _introTexts = [
  IntroText(text: "Confessions are always anonymous."),
  IntroText(text: "Juicy confessions often rise to the top!"),
  IntroText(text: "You can quote a confession in your own post."),
  IntroText(text: "Made proudly by UVic students!"),
  IntroText(text: "Give us your feedback!"),
  IntroText(text: "Share your confessions with your friends!"),
  IntroText(text: "Get in on campus gossip!"),
  IntroText(text: "Running out of ideas for this..."),
];

class IntroText {
  final String text;

  IntroText({required this.text});
}
