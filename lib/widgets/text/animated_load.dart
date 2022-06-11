import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class AnimatedLoadText extends StatefulWidget {
<<<<<<< HEAD
  const AnimatedLoadText({required this.text, Key? key}) : super(key: key);

  final String text;
=======
  const AnimatedLoadText(
      {required this.text, this.duration = const Duration(milliseconds: 600), Key? key})
      : super(key: key);

  final String text;
  final Duration duration;
>>>>>>> 2663f0f90251f97cd75ae0035ecf7400a528d149

  @override
  State<AnimatedLoadText> createState() => _AnimatedLoadTextState();
}

class _AnimatedLoadTextState extends State<AnimatedLoadText> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation anim;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    anim = CurvedAnimation(parent: controller, curve: Curves.linear, reverseCurve: Curves.linear);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
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
      style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(anim.value)),
      textAlign: TextAlign.center,
    );
  }
}
