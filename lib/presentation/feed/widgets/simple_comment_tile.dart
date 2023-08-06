import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/styles/typography.dart';
import '../../../models/comment.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/button_touch_effects/touchable_shrink.dart';
import '../../shared/slideables/slidable_section.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils/post_metadata_formatters.dart';
import 'comment_bottom_button.dart';

/// How deep a threaded comment is. Root essentially means level zero.
enum CommentDepth { root, reply }

class SimpleCommentTile extends StatelessWidget {
  const SimpleCommentTile({
    super.key,
    required this.comment,
    this.isRootComment = false,
    this.isGettingRepliedTo = false,
  });

  final CommentWithMetadata comment;
  final bool isRootComment;
  final bool isGettingRepliedTo;

  void showOptions(BuildContext context) {
    // Implement your logic to show the options for the comment
    // Here you can use the same logic as in the old `CommentTile`
    // For example, use `showButtonOptionsSheet` to display options in a bottom sheet
    // or show `Slidable` action panes similar to the old `CommentTile`.
    print("Show options");
  }

  List<TextSpan> _buildReplyHeaderSpans(BuildContext context) {
    List<TextSpan> spans = [];

    String replying =
        comment.comment.numericalReplyingUserIsOp ? "OP" : comment.comment.numericalReplyingUser.toString();
    String user = comment.comment.numericalUserIsOp ? "OP" : comment.comment.numericalUser.toString();

    if (comment.comment.numericalReplyingUser != null || comment.comment.numericalReplyingUserIsOp) {
      spans.add(TextSpan(
        text: replying,
        style: kDetail.copyWith(color: Theme.of(context).colorScheme.secondary), // Set the color for "OP"
      ));
    }

    if (comment.comment.numericalReplyingUser != null || comment.comment.numericalReplyingUserIsOp) {
      spans.add(
        TextSpan(
          text: " < ",
          style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface), // Set the color for "OP"
        ),
      );
    }

    if (comment.comment.numericalUser != null || comment.comment.numericalUserIsOp) {
      spans.add(TextSpan(
        text: user,
        style: kDetail.copyWith(color: Theme.of(context).colorScheme.secondary),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      dragStartBehavior: DragStartBehavior.start,
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (isRootComment)
            SlidableSection(
              text: 'Share',
              tooltip: 'Share this content',
              icon: CupertinoIcons.share,
              onPress: () => print('tap'),
            ),
          SlidableSection(
            text: 'Reply',
            tooltip: 'Reply to this comment',
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
            tooltip: 'Number of hates',
            icon: CupertinoIcons.hand_thumbsdown,
            onPress: () => print('tap'),
          ),
          SlidableSection(
            text: '23.2k',
            tooltip: 'Number of likes',
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
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  if (!isRootComment) ...[
                    Container(
                      width: 0.8,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 15),
                  ],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
                                      children: _buildReplyHeaderSpans(context),
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    timeAgoFromMicroSecondUnixTime(comment.comment.createdAt),
                                    style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              if (!isRootComment)
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
                            comment.comment.content,
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.left,
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
