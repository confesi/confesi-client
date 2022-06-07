import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({required this.child, required this.onTap, Key? key})
      : super(key: key);

  final Widget child;
  final Function onTap;
  final Duration duration = const Duration(milliseconds: 50);
  final double opacity = 0.3;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0),
        reverseDuration: const Duration(milliseconds: 400));
    anim = CurvedAnimation(
        parent: animController,
        curve: Curves.linear,
        reverseCurve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    animController.dispose();
  }

  void startAnim() async {
    animController.forward().then((value) async {
      await Future.delayed(const Duration(milliseconds: 0));
      animController.reverse();
    });
    animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    animController.reverse();
    animController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        animController.forward();
        animController.addListener(() {
          setState(() {});
        });
      }),
      onTapUp: (_) => setState(() {
        // animController.forward();
        // reverseAnim();
      }),
      onTapCancel: () => setState(() {
        animController.reverse();
        animController.addListener(() {
          setState(() {});
        });
      }),
      onTap: () {
        widget.onTap();
        startAnim();
      },
      child: Opacity(
        opacity: -anim.value * 0.8 + 1,
        child: widget.child,
      ),
    );
  }
}
