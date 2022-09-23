import 'package:flutter/material.dart';

class InitScale extends StatefulWidget {
  /// On [initState], makes the widget animate to its full size.
  const InitScale({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<InitScale> createState() => InitScaleState();
}

class InitScaleState extends State<InitScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
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
    return Transform.scale(
      scale: _anim.value,
      child: widget.child,
    );
  }
}
