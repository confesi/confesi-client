import 'package:Confessi/core/widgets/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'infinite_comment_thread.dart';

enum ScrollToRootDirection {
  up,
  down,
}

class CircleCommentSwitcherButton extends StatelessWidget {
  const CircleCommentSwitcherButton({
    required this.scrollToRootDirection,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final InfiniteCommentThreadController controller;
  final ScrollToRootDirection scrollToRootDirection;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => scrollToRootDirection == ScrollToRootDirection.down
          ? controller.scrollDownToRoot()
          : controller.scrollUpToRoot(),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(scrollToRootDirection == ScrollToRootDirection.down
            ? CupertinoIcons.down_arrow
            : CupertinoIcons.up_arrow),
      ),
    );
  }
}
