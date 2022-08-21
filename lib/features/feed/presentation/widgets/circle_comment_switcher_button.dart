import 'package:Confessi/core/widgets/behaviours/touchable_opacity.dart';
import 'package:Confessi/features/feed/presentation/widgets/infinite_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

class CircleCommentSwitcherButton extends StatefulWidget {
  const CircleCommentSwitcherButton({
    required this.scrollToRootDirection,
    required this.controller,
    this.visible = true,
    Key? key,
  }) : super(key: key);

  final InfiniteController controller;
  final ScrollToRootDirection scrollToRootDirection;
  final bool visible;

  @override
  State<CircleCommentSwitcherButton> createState() =>
      _CircleCommentSwitcherButtonState();
}

class _CircleCommentSwitcherButtonState
    extends State<CircleCommentSwitcherButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0),
        reverseDuration: const Duration(milliseconds: 200));
    anim = CurvedAnimation(
        parent: animController,
        curve: Curves.linear,
        reverseCurve: Curves.easeInOutCubic);
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
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: !widget.visible
          ? Container()
          : GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                startAnim();
                widget.scrollToRootDirection == ScrollToRootDirection.down
                    ? widget.controller.scrollDownToRoot()
                    : widget.controller.scrollUpToRoot();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: anim.value / 4 + 1,
                  child: Opacity(
                    opacity: -anim.value * 0.8 + 1,
                    child: Icon(widget.scrollToRootDirection ==
                            ScrollToRootDirection.down
                        ? CupertinoIcons.down_arrow
                        : CupertinoIcons.up_arrow),
                  ),
                ),
              ),
            ),
    );
  }
}
