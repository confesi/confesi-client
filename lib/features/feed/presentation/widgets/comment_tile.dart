import 'package:Confessi/core/constants/buttons.dart';
import 'package:Confessi/core/utils/large_number_formatter.dart';
import 'package:Confessi/core/widgets/buttons/option.dart';
import 'package:Confessi/core/widgets/sheets/button_options_sheet.dart';
import 'package:Confessi/features/feed/presentation/widgets/comment_header_text.dart';
import 'package:Confessi/features/authentication/presentation/screens/open.dart';
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
    required this.likes,
    required this.hates,
    required this.text,
    required this.depth,
    Key? key,
  }) : super(key: key);

  final String text;
  final int likes;
  final int hates;
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

  void showOptions(BuildContext context) => showButtonOptionsSheet(
      context,
      [
        OptionButton(
          onTap: () => print('tap'),
          text: 'Report',
          icon: CupertinoIcons.flag,
        ),
        OptionButton(
          onTap: () => print('tap'),
          text: 'Copy Text',
          icon: CupertinoIcons.collections,
        ),
        OptionButton(
          onTap: () => print('tap'),
          text: '195',
          icon: CupertinoIcons.hand_thumbsup,
        ),
        OptionButton(
          onTap: () => print('tap'),
          text: 'Share',
          icon: CupertinoIcons.share,
        ),
        OptionButton(
          onTap: () => print('tap'),
          text: 'Reply',
          icon: CupertinoIcons.arrowshape_turn_up_right,
        ),
        OptionButton(
          onTap: () => print('tap'),
          text: '28.3k',
          icon: CupertinoIcons.hand_thumbsdown,
        ),
      ],
      text:
          'Tip: swiping horizontally, or long pressing on a comment brings up actions.');

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
            text: 'Share',
            tooltip: 'share this content',
            icon: CupertinoIcons.share,
            onPress: () => print('tap'),
          ),
          SlidableSection(
            text: 'Reply',
            tooltip: 'reply to this comment',
            icon: CupertinoIcons.arrowshape_turn_up_right,
            onPress: () => print('tap'),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableSection(
            text: '195',
            tooltip: 'number of hates',
            icon: CupertinoIcons.hand_thumbsdown,
            onPress: () => print('tap'),
          ),
          SlidableSection(
            text: '23.2k',
            tooltip: 'number of likes',
            icon: CupertinoIcons.hand_thumbsup,
            onPress: () => print('tap'),
          ),
        ],
      ),
      child: GestureDetector(
        // onDoubleTap: () => showOptions(context),
        onLongPress: () => showOptions(context),
        // onTap: () => showOptions(context),
        child: Container(
          // Container hitbox trick.
          color: Colors.transparent,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.flame,
                                    size: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: CommentHeaderText(
                                  likes: 129387,
                                  hates: 1289,
                                  header: 'Matthew',
                                  time: '24d',
                                ),
                              ),
                              TouchableOpacity(
                                tooltip: 'comment options',
                                tooltipLocation: TooltipLocation.above,
                                onTap: () => showOptions(context),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
