import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class FadeSizeText extends StatefulWidget {
  const FadeSizeText(
      {this.verticalPadding = 20.0,
      required this.text,
      required this.childController,
      Key? key})
      : super(key: key);

  final String text;
  final double verticalPadding;
  final AnimationController childController;

  @override
  State<FadeSizeText> createState() => _FadeSizeTextState();
}

class _FadeSizeTextState extends State<FadeSizeText>
    with SingleTickerProviderStateMixin {
  late Animation anim;

  @override
  void initState() {
    super.initState();
    anim =
        CurvedAnimation(parent: widget.childController, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSize(
        clipBehavior: Clip.antiAlias,
        duration: const Duration(milliseconds: 400),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
          child: Container(
            height: widget.text == "" ? 0 : null,
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                style: kBody.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withOpacity(anim.value ?? 0),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
