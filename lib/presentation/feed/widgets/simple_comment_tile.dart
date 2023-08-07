import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../core/styles/typography.dart';
import '../../../models/comment.dart';
import '../utils/post_metadata_formatters.dart';

/// How deep a threaded comment is. Root essentially means level zero.
enum CommentDepth { root, reply }

class SimpleCommentTile extends StatefulWidget {
  const SimpleCommentTile({
    super.key,
    required this.comment,
    this.isRootComment = false,
    this.isGettingRepliedTo = false,
    required this.totalNumOfReplies,
    required this.currentReplyNum,
    required this.currentlyRetrievedReplies,
  });

  final CommentWithMetadata comment;
  final bool isRootComment;
  final bool isGettingRepliedTo;
  final int totalNumOfReplies;
  final int currentReplyNum;
  final int currentlyRetrievedReplies;

  @override
  State<SimpleCommentTile> createState() => _SimpleCommentTileState();
}

class _SimpleCommentTileState extends State<SimpleCommentTile> {
  List<TextSpan> _buildReplyHeaderSpans(BuildContext context) {
    List<TextSpan> spans = [];

    String replying = widget.comment.comment.numericalReplyingUserIsOp
        ? "OP"
        : "#${widget.comment.comment.numericalReplyingUser.toString()}";
    String user =
        widget.comment.comment.numericalUserIsOp ? "OP" : "#${widget.comment.comment.numericalUser.toString()}";

    if (widget.comment.comment.numericalReplyingUser != null || widget.comment.comment.numericalReplyingUserIsOp) {
      spans.add(TextSpan(
        text: replying,
        style: kDetail.copyWith(color: Theme.of(context).colorScheme.secondary), // Set the color for "OP"
      ));
    }

    if (widget.comment.comment.numericalReplyingUser != null || widget.comment.comment.numericalReplyingUserIsOp) {
      spans.add(
        TextSpan(
          text: " <- ",
          style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary), // Set the color for "OP"
        ),
      );
    }

    if (widget.comment.comment.numericalUser != null || widget.comment.comment.numericalUserIsOp) {
      spans.add(TextSpan(
        text: user,
        style: kDetail.copyWith(color: Theme.of(context).colorScheme.secondary),
      ));
    }

    spans.add(TextSpan(
      text:
          " • ${timeAgoFromMicroSecondUnixTime(widget.comment.comment.createdAt)}${widget.comment.comment.edited ? " (edited)" : ""}",
      style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));

    return spans;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: !widget.isRootComment ? 15 : 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: !widget.isRootComment
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.shadow,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.8,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
                                children: _buildReplyHeaderSpans(context),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.comment.comment.content,
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TouchableScale(
                                  onTap: () => print("todo: reply"),
                                  child: Container(
                                    // Transparent container hitbox trick.
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.reply,
                                          size: 18,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Reply",
                                          style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ReactionTile(
                                  simpleView: true,
                                  onTap: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                      .voteOnComment(widget.comment, widget.comment.userVote != 1 ? 1 : 0)
                                      .then((value) => value.fold(
                                          (err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                                  extraLeftPadding: true,
                                  amount: widget.comment.comment.upvote,
                                  isSelected: widget.comment.userVote == 1,
                                  icon: CupertinoIcons.up_arrow,
                                  iconColor: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                ReactionTile(
                                  simpleView: true,
                                  onTap: () async => await Provider.of<GlobalContentService>(context, listen: false)
                                      .voteOnComment(widget.comment, widget.comment.userVote != -1 ? -1 : 0)
                                      .then((value) => value.fold(
                                          (err) => context.read<NotificationsCubit>().show(err), (_) => null)),
                                  extraLeftPadding: true,
                                  amount: widget.comment.comment.downvote,
                                  isSelected: widget.comment.userVote == -1,
                                  icon: CupertinoIcons.down_arrow,
                                  iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ],
                            ),
                            WidgetOrNothing(
                              showWidget: !widget.isRootComment &&
                                  widget.currentReplyNum == widget.currentlyRetrievedReplies &&
                                  widget.currentReplyNum < widget.totalNumOfReplies,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SimpleTextButton(
                                    onTap: () async {
                                      setState(() => isLoading = true);
                                      await context
                                          .read<CommentSectionCubit>()
                                          .loadReplies(
                                              widget.comment.comment.parentRoot, widget.comment.comment.createdAt)
                                          .then(
                                            (possibleSuccess) => possibleSuccess
                                                ? null
                                                : context.read<NotificationsCubit>().show("Error loading more"),
                                          );
                                      if (mounted) setState(() => isLoading = false);
                                    },
                                    text: isLoading
                                        ? "Loading..."
                                        : "Load ${widget.totalNumOfReplies - widget.currentReplyNum} more",
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
