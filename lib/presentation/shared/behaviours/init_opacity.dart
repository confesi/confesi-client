import 'package:flutter/material.dart';

class InitOpacity extends StatefulWidget {
  /// On [initState], makes the widget animate from 0 to 1 opacity.
  const InitOpacity({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<InitOpacity> createState() => InitOpacityState();
}

class InitOpacityState extends State<InitOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _anim.value,
      child: widget.child,
    );
  }
}
