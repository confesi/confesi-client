// TODO: Should something as simple as this be put into business logic (domain) of the project? Surely not...?

import 'dart:math';

HintText getHint() => hintTexts[Random().nextInt(hintTexts.length)];

List<HintText> hintTexts = [
  HintText(
      title: 'Catch our attention here', body: 'Then live up to it here...'),
  HintText(
      title: 'Write a cool title',
      body: 'And then ensure the body is in MLA format!!!'),
];

class HintText {
  final String title;
  final String body;

  HintText({required this.title, required this.body});
}
