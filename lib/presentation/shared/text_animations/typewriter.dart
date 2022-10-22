import 'package:flutter/material.dart';

class TypewriterController extends ChangeNotifier {
  final String fullText;
  final int durationInMilliseconds;
  String _animatingText = "";

  TypewriterController({required this.fullText, this.durationInMilliseconds = 1500});

  void forward() async {
    for (var i = 0; i < fullText.length; i++) {
      await Future.delayed(Duration(milliseconds: (durationInMilliseconds / fullText.length).round()));
      _animatingText = "${fullText.substring(0, i + 1)}${i + 1 == fullText.length ? "" : "_"}";
      notifyListeners();
    }
  }
}

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.textStyle,
    required this.controller,
    this.textAlign = TextAlign.left,
  });

  final TypewriterController controller;
  final TextStyle textStyle;
  final TextAlign textAlign;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  @override
  void initState() {
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAll = true;
        });
      },
      child: Container(
        width: double.infinity,
        // Transparent hitbox trick.
        color: Colors.transparent,
        child: Text(
          showAll ? widget.controller.fullText : widget.controller._animatingText,
          style: widget.textStyle,
          textAlign: widget.textAlign,
        ),
      ),
    );
  }
}
