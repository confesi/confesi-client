import 'package:flutter/material.dart';

class InitBorderRadius extends StatefulWidget {
  /// On [initState], makes the widget animate from x border radius to 0 border radius.
  const InitBorderRadius({
    super.key,
    required this.child,
    this.durationOfScaleInMilliseconds = 2500,
    this.delayDurationInMilliseconds = 0,
    this.borderRadius = 60,
  });

  final Widget child;
  final int durationOfScaleInMilliseconds;
  final int delayDurationInMilliseconds;
  final double borderRadius;

  @override
  State<InitBorderRadius> createState() => InitBorderRadiusState();
}

class InitBorderRadiusState extends State<InitBorderRadius> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationOfScaleInMilliseconds),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  void startAnim() async {
    widget.delayDurationInMilliseconds == 0
        ? null
        : await Future.delayed(Duration(milliseconds: widget.delayDurationInMilliseconds));
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius - widget.borderRadius * _anim.value)),
      child: widget.child,
    );
  }
}
