import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({this.onLongTap, required this.child, required this.onTap, Key? key})
      : super(key: key);

  final Widget child;
  final Function onTap;
  final Function? onLongTap;

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0),
        reverseDuration: const Duration(milliseconds: 400));
    anim =
        CurvedAnimation(parent: animController, curve: Curves.linear, reverseCurve: Curves.linear);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void startAnim() async {
    animController.forward().then((value) async {
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
      // onLongPress: () {
      //   if (widget.onLongTap != null) {
      //     widget.onLongTap!();
      //   }
      // },
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
