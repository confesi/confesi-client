import '../../../core/styles/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/feed/enums.dart';
import 'comment_bottom_button.dart';

class SimpleCommentTile extends StatelessWidget {
  const SimpleCommentTile({
    super.key,
    required this.depth,
    this.isGettingRepliedTo = false,
  });

  final CommentDepth depth;
  final bool isGettingRepliedTo;

  double get commentDepthAdditivePadding {
    switch (depth) {
      case CommentDepth.root:
        return 0;
      case CommentDepth.one:
        return 0;
      case CommentDepth.two:
        return 15;
      case CommentDepth.three:
        return 30;
      case CommentDepth.four:
        return 45;
      default:
        throw UnimplementedError('Comment depth specified doesn\'t exist');
    }
  }

  int get barsToAdd {
    switch (depth) {
      case CommentDepth.root:
        return 0;
      case CommentDepth.one:
        return 0;
      case CommentDepth.two:
        return 1;
      case CommentDepth.three:
        return 2;
      case CommentDepth.four:
        return 3;
      default:
        throw UnimplementedError('Comment depth specified doesn\'t exist');
    }
  }

  Widget addBars(BuildContext context) {
    List<Widget> bars = [];
    for (var i = 0; i <= barsToAdd; i++) {
      bars.add(
        Padding(
          padding: EdgeInsets.only(left: i != 0 ? 15 : 0),
          child: depth == CommentDepth.root
              ? Container()
              : Container(
                  width: 2,
                  color: Theme.of(context).colorScheme.surface,
                ),
        ),
      );
    }
    return Row(children: bars);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: isGettingRepliedTo ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2) : null,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            addBars(context),
            SizedBox(width: depth != CommentDepth.root ? 15 : 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "25m / University of British Columbia",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam porttitor accumsan turpis at ornare. Ut est massa, scelerisque quis felis id, posuere pellentesque ante.",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      runSpacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () => print("replying"),
                          child: Container(
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_turn_up_left,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Reply",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => print("more options"),
                          child: Container(
                            // Transparent hitbox trick
                            color: Colors.transparent,
                            child: Icon(
                              CupertinoIcons.ellipsis,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "43.1k",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.arrow_up,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 18,
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => print("left tap"),
                                      // Transparent hitbox trick.
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => print("right tap"),
                                      // Transparent hitbox trick.
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const CommentBottomButton(text: "Load more replies"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
