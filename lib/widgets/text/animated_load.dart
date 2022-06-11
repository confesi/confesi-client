import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class AnimatedLoadText extends StatefulWidget {
  const AnimatedLoadText({required this.text, Key? key}) : super(key: key);

  final String text;

  @override
  State<AnimatedLoadText> createState() => _AnimatedLoadTextState();
}

class _AnimatedLoadTextState extends State<AnimatedLoadText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation anim;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    anim = CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: kBody.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(1)),
      textAlign: TextAlign.center,
    );
  }
}
