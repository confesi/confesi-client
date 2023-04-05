import 'dart:math';

HintText getHint() => _hintTexts[Random().nextInt(_hintTexts.length)];

List<HintText> _hintTexts = [
  HintText(title: 'Catch our attention here', body: 'Then live up to it here...'),
  HintText(title: 'Write a cool title', body: 'And then ensure the body is in MLA format'),
  HintText(title: "Don't be boring please", body: '... write something interesting here'),
  HintText(title: 'Write us an essay', body: 'And be sure to cite your sources!'),
  HintText(title: 'Write something good', body: "... or we'll be forced to give you an F"),
  HintText(title: 'Pen something amazing', body: "... maybe a haiku?"),
  HintText(title: 'Title here', body: "Body here (yes, this is a boring prompt)"),
  HintText(title: 'Send me cool prompt ideas', body: "... coming up with these myself hurts"),
  HintText(title: "Beep boop, I'm a robot", body: "... I'm not crazy"),
  HintText(title: 'Grab our attention with a pun', body: 'And then follow it up with a witty remark'),
  HintText(title: 'Write something controversial', body: 'And back it up with solid evidence'),
  HintText(title: 'Tell us a story', body: 'But make it short and sweet'),
  HintText(title: 'Share a life lesson', body: 'And explain how it has impacted your life'),
  HintText(title: 'Write a love letter', body: 'To someone or something you care deeply about'),
  HintText(title: 'Create a poem', body: 'About the beauty of nature, or the complexity of human emotions'),
  HintText(title: 'Write a review', body: 'Of your favorite book, movie, or restaurant'),
  HintText(title: 'Share your opinion', body: 'On a current event or topic that you feel passionately about'),
];

class HintText {
  final String title;
  final String body;

  HintText({required this.title, required this.body});
}
