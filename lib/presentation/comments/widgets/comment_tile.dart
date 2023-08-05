import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/button_touch_effects/touchable_shrink.dart';
import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';
import '../../feed/widgets/comment_header_text.dart';
import '../../shared/slideables/slidable_section.dart';

/// How deep a threaded comment is. Root essentially means level zero.
enum CommentDepth { root, reply }

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
            text: 'Share',
            icon: CupertinoIcons.share,
          ),
          if (depth == CommentDepth.root)
            OptionButton(
              onTap: () => print('tap'),
              text: 'Reply',
              icon: CupertinoIcons.arrowshape_turn_up_right,
            ),
          OptionButton(
            onTap: () => print('tap'),
            text: '195',
            icon: CupertinoIcons.hand_thumbsup,
          ),
          OptionButton(
            onTap: () => print('tap'),
            text: '28.3k',
            icon: CupertinoIcons.hand_thumbsdown,
          ),
        ],
        text: 'Tip: swiping horizontally, or long pressing on a comment brings up actions.',
      );

  @override
  Widget build(BuildContext context) {
    return Slidable(
      dragStartBehavior: DragStartBehavior.start,
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (depth == CommentDepth.root) ...[
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
      child: TouchableShrink(
        onLongPress: () => showOptions(context),
        child: Container(
          // Container hitbox trick.
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: depth == CommentDepth.reply ? 15 : 0,
            ),
            child: Row(
              children: [
                if (depth == CommentDepth.reply) ...[
                  Container(
                    width: 0.8,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  SizedBox(width: 15),
                ],
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
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CommentHeaderText(
                              likes: 129387,
                              hates: 1289,
                              header: 'Matthew',
                              time: '24d',
                            ),
                          ),
                          if (depth == CommentDepth.reply)
                            TouchableOpacity(
                              onTap: () => showOptions(context),
                              child: Container(
                                // Transparent container hitbox trick.
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    CupertinoIcons.ellipsis,
                                    color: Theme.of(context).colorScheme.onBackground,
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
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
