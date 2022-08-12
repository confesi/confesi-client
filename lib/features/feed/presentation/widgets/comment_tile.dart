import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/core/widgets/text/tight_group.dart';
import 'package:Confessi/features/feed/presentation/widgets/slidable_section.dart';
import 'package:Confessi/features/feed/presentation/widgets/vote_tile_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/widgets/buttons/touchable_opacity.dart';
import '../../constants.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    required this.votes,
    required this.text,
    required this.depth,
    Key? key,
  }) : super(key: key);

  final String text;
  final int votes;
  final CommentDepth depth;

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
    for (var i = barsToAdd; i >= 0; i--) {
      bars.add(
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: depth == CommentDepth.root
              ? Container()
              : Container(
                  width: .7,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
        ),
      );
    }
    return Row(children: bars);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      dragStartBehavior: DragStartBehavior.start,
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableSection(
            text: 'Report',
            icon: CupertinoIcons.flag,
            onPress: () => print('tap'),
          ),
          SlidableSection(
            text: 'Share',
            icon: CupertinoIcons.share,
            onPress: () => print('tap'),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableSection(
            text: 'Copy Text',
            icon: CupertinoIcons.collections,
            onPress: () => print('tap'),
          ),
          SlidableSection(
            text: 'Reply',
            icon: CupertinoIcons.arrowshape_turn_up_right,
            onPress: () => print('tap'),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: IntrinsicHeight(
          child: Row(
            children: [
              addBars(context),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: depth == CommentDepth.root ? 0 : 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.flame,
                                size: 15,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const TightGroupText(
                            header: 'Matthew',
                            body: '2h',
                          ),
                          const Spacer(),
                          TouchableOpacity(
                            tooltip: 'comment options',
                            tooltipLocation: TooltipLocation.above,
                            onTap: () => print('tap'),
                            child: Container(
                              // Transparent container hitbox trick.
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  CupertinoIcons.ellipsis,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        text,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TouchableOpacity(
                            tooltip:
                                'reply to this comment at this thread level',
                            onTap: () => print('tappp'),
                            child: Text(
                              'reply',
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          VoteTileSet(
                            votes: votes,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
