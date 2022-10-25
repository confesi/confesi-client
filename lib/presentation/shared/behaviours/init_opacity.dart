import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:flutter/material.dart';

class InitOpacity extends StatefulWidget {
  /// On [initState], makes the widget animate from 0 to 1 opacity.
  const InitOpacity({
    super.key,
    required this.child,
    this.defaultOpacity = 0.0,
    this.durationInMilliseconds = 1000,
    this.delayDurationInMilliseconds,
  });

  final Widget child;
  final double defaultOpacity;
  final int durationInMilliseconds;
  final int? delayDurationInMilliseconds;

  @override
  State<InitOpacity> createState() => InitOpacityState();
}

class InitOpacityState extends State<InitOpacity> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationInMilliseconds),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  void startAnim() async {
    if (widget.delayDurationInMilliseconds != null) {
      await Future.delayed(Duration(milliseconds: widget.delayDurationInMilliseconds!));
    }
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
      opacity: numberUntilLimit(_anim.value + widget.defaultOpacity, 1),
      child: widget.child,
    );
  }
}
