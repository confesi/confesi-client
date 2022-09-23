import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../behaviours/touchable_opacity.dart';

class TouchableTextButton extends StatefulWidget {
  const TouchableTextButton(
      {this.isLoading = false,
      this.textAlignCenter = false,
      required this.onTap,
      required this.animatedClick, // should this button animate when clicked?
      required this.text,
      required this.textColor,
      Key? key})
      : super(key: key);

  final String text;
  final Color textColor;
  final VoidCallback onTap;
  final bool textAlignCenter;
  final bool isLoading;
  final bool animatedClick;

  @override
  State<TouchableTextButton> createState() => _TouchableTextButtonState();
}

class _TouchableTextButtonState extends State<TouchableTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    anim = CurvedAnimation(parent: animController, curve: Curves.linear);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void manageAnim() {
    animController.forward().then((value) async {
      animController.reverse().then((value) => {
            if (widget.isLoading) {manageAnim()}
          });
    });
    animController.addListener(() {
      setState(() {});
    });
  }

  String textToDisplay(double animValue) {
    if (animValue < 1 / 4) {
      return widget.text;
    } else if (animValue < 1 / 2) {
      return "${widget.text}.";
    } else if (animValue < 3 / 4) {
      return "${widget.text}..";
    } else {
      return "${widget.text}...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        widget.animatedClick ? manageAnim() : null;
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        // transparent hitbox trick
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            textToDisplay(anim.value),
            style: kBody.copyWith(color: widget.textColor),
            textAlign: widget.textAlignCenter ? TextAlign.center : TextAlign.left,
          ),
        ),
      ),
    );
  }
}
