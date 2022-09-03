// TODO: Should something as simple as this be put into business logic (domain) of the project? Surely not...?

import 'dart:math';

HintText getHint() => hintTexts[Random().nextInt(hintTexts.length)];

List<HintText> hintTexts = [
  HintText(
      title: 'Catch our attention here', body: 'Then live up to it here...'),
  HintText(
      title: 'Write a cool title',
      body: 'And then ensure the body is in MLA format!'),
  HintText(
      title: "Don't be boring please",
      body: 'Write something interesting here'),
  HintText(
      title: 'Write us an essay', body: 'And be sure to cite your sources!'),
  HintText(
      title: 'Write something good',
      body: "Or we'll be forced to give you an F"),
];

class HintText {
  final String title;
  final String body;

  HintText({required this.title, required this.body});
}
