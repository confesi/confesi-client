import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class FadeSizeText extends StatefulWidget {
  const FadeSizeText(
      {this.verticalPadding = 20.0, required this.text, required this.childController, Key? key})
      : super(key: key);

  final String text;
  final double verticalPadding;
  final AnimationController childController;

  @override
  State<FadeSizeText> createState() => _FadeSizeTextState();
}

class _FadeSizeTextState extends State<FadeSizeText> with SingleTickerProviderStateMixin {
  late Animation anim;

  @override
  void initState() {
    super.initState();
    anim = CurvedAnimation(parent: widget.childController, curve: Curves.linear);
  }

  void testFunction() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: anim.value == 0 ? 0 : anim.value * widget.verticalPadding),
      child: Text(
        anim.value == 0.0 ? "" : widget.text,
        style: kBody.copyWith(
          color: Theme.of(context).colorScheme.error.withOpacity(anim.value ?? 0),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
