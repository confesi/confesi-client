import 'dart:math';

import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/presentation/comments/widgets/sheet.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/behaviours/init_border_radius.dart';
import 'package:confesi/presentation/shared/behaviours/init_scale.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/user/cubit/quick_actions_cubit.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/colors/deterministic_random_color.dart';
import '../../../models/comment.dart';
import '../../shared/buttons/option.dart';
import '../../feed/utils/post_metadata_formatters.dart';

enum CommentDepth { root, reply }

class SimpleCommentTile extends StatefulWidget {
  const SimpleCommentTile({
    Key? key,
    required this.comment,
    this.isRootComment = false,
    this.isGettingRepliedTo = false,
    required this.totalNumOfReplies,
    required this.currentReplyNum,
    required this.currentlyRetrievedReplies,
    required this.feedController,
    required this.commentSheetController,
    required this.postCreatedAtTime,
  }) : super(key: key);

  final CommentWithMetadata comment;
  final FeedListController feedController;
  final bool isRootComment;
  final bool isGettingRepliedTo;
  final int totalNumOfReplies;
  final int currentReplyNum;
  final int currentlyRetrievedReplies;
  final CommentSheetController commentSheetController;
  final int postCreatedAtTime;

  @override
  State<SimpleCommentTile> createState() => _SimpleCommentTileState();
}

class _SimpleCommentTileState extends State<SimpleCommentTile> {
  String get buildUserIdentifier =>
      widget.comment.comment.numericalUserIsOp ? "OP" : "#${widget.comment.comment.numericalUser.toString()}";

  List<TextSpan> _buildReplyHeaderSpans(BuildContext context) {
    List<TextSpan> spans = [];

    String replying = widget.comment.comment.numericalReplyingUserIsOp
        ? "OP"
        : "#${widget.comment.comment.numericalReplyingUser.toString()}";
    String user = buildUserIdentifier;

    if (widget.comment.comment.numericalReplyingUser != null || widget.comment.comment.numericalReplyingUserIsOp) {
      spans.add(TextSpan(
        text: replying,
        style: kDetail.copyWith(
            color: genColor(widget.postCreatedAtTime, getIdentifierFromReplyingUser())), // Set the color for "OP"
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
        style: kDetail.copyWith(color: genColor(widget.postCreatedAtTime, getIdentifierFromUser())),
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

  int getIdentifierFromReplyingUser() {
    if (widget.comment.comment.numericalReplyingUserIsOp) {
      return 0;
    } else {
      return widget.comment.comment.numericalReplyingUser ?? 9999;
    }
  }

  int getIdentifierFromUser() {
    if (widget.comment.comment.numericalUserIsOp) {
      return 0;
    } else {
      return widget.comment.comment.numericalUser ?? 9999;
    }
  }

  Future<void> loadMore() async {
    setState(() => isLoading = true);
    await context
        .read<CommentSectionCubit>()
        .loadReplies(widget.comment.comment.parentRoot ?? widget.comment.comment.id, widget.comment.comment.createdAt)
        .then(
          (possibleSuccess) =>
              possibleSuccess ? null : context.read<NotificationsCubit>().showErr("Error loading more"),
        );
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateCommentCubit>().state;
    return Padding(
      padding: EdgeInsets.only(left: !widget.isRootComment ? 15 : 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: genColor(widget.postCreatedAtTime, getIdentifierFromUser()),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: state is CreateCommentEnteringData &&
                          state.possibleReply is ReplyingToUser &&
                          (state.possibleReply as ReplyingToUser).replyingToCommentId == widget.comment.comment.id
                      ? Theme.of(context).colorScheme.surface // surface for highlight
                      : Theme.of(context).colorScheme.shadow,
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
                            // Text(context
                            //     .watch<CommentSectionCubit>()
                            //     .indexFromCommentId(widget.comment.comment.id)
                            //     .toString()),
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
                                TouchableOpacity(
                                  onTap: () => showButtonOptionsSheet(context, [
                                    OptionButton(
                                      text: "Save",
                                      icon: CupertinoIcons.bookmark,
                                      onTap: () => print("tap"),
                                    ),
                                    OptionButton(
                                      text: "Share",
                                      icon: CupertinoIcons.share,
                                      onTap: () => print("tap"),
                                    ),
                                    OptionButton(
                                      text: "Report",
                                      icon: CupertinoIcons.flag,
                                      onTap: () => print("tap"),
                                    ),
                                    // if is not root
                                    if (widget.currentReplyNum == widget.currentlyRetrievedReplies &&
                                        (!widget.isRootComment || widget.totalNumOfReplies == 0))
                                      OptionButton(
                                        text: "Try loading more replies",
                                        icon: CupertinoIcons.chat_bubble,
                                        onTap: () async => await loadMore(),
                                      )
                                  ]),
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                                    color: Colors.transparent, // transparent hitbox trick
                                    child: Icon(
                                      CupertinoIcons.ellipsis_circle,
                                      size: 18,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 5),
                                TouchableScale(
                                  onTap: () async {
                                    verifiedUserOnly(context, () {
                                      if (!widget.commentSheetController.isFocused()) {
                                        widget.commentSheetController.focus();
                                      }
                                      context.read<CreateCommentCubit>().updateReplyingTo(
                                            ReplyingToUser(
                                              replyingToCommentId: widget.comment.comment.id,
                                              identifier: buildUserIdentifier,
                                              rootCommentIdReplyingUnder:
                                                  widget.comment.comment.parentRoot ?? widget.comment.comment.id,
                                            ),
                                          );
                                      context.read<CreateCommentCubit>().state is CreateCommentEnteringData &&
                                              (context.read<CreateCommentCubit>().state as CreateCommentEnteringData)
                                                  .possibleReply is ReplyingToUser
                                          ? context
                                              .read<CommentSectionCubit>()
                                              .indexFromCommentId(((context.read<CreateCommentCubit>().state
                                                          as CreateCommentEnteringData)
                                                      .possibleReply as ReplyingToUser)
                                                  .replyingToCommentId)
                                              .fold(
                                                  (idx) => widget.feedController
                                                      .scrollToIndex(idx + 1, hapticFeedback: false),
                                                  (r) => context
                                                      .read<NotificationsCubit>()
                                                      .showErr("Error jumping to comment"))
                                          : null;
                                    });
                                  },
                                  child: Container(
                                    // Transparent container hitbox trick.
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.reply,
                                          size: 18,
                                          color: state is CreateCommentEnteringData &&
                                                  state.possibleReply is ReplyingToUser &&
                                                  (state.possibleReply as ReplyingToUser).replyingToCommentId ==
                                                      widget.comment.comment.id
                                              ? Theme.of(context).colorScheme.secondary
                                              : Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Reply",
                                          style: kDetail.copyWith(
                                              color: state is CreateCommentEnteringData &&
                                                      state.possibleReply is ReplyingToUser &&
                                                      (state.possibleReply as ReplyingToUser).replyingToCommentId ==
                                                          widget.comment.comment.id
                                                  ? Theme.of(context).colorScheme.secondary
                                                  : Theme.of(context).colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ReactionTile(
                                  simpleView: true,
                                  onTap: () async {
                                    verifiedUserOnly(
                                      context,
                                      () async => await Provider.of<GlobalContentService>(context, listen: false)
                                          .voteOnComment(widget.comment, widget.comment.userVote != 1 ? 1 : 0)
                                          .then(
                                            (value) => value.fold(
                                                (err) => context.read<NotificationsCubit>().showErr(err), (_) => null),
                                          ),
                                    );
                                  },
                                  extraLeftPadding: true,
                                  amount: widget.comment.comment.upvote,
                                  isSelected: widget.comment.userVote == 1,
                                  icon: CupertinoIcons.up_arrow,
                                  iconColor: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                ReactionTile(
                                  simpleView: true,
                                  onTap: () async {
                                    verifiedUserOnly(context, () async {
                                      await Provider.of<GlobalContentService>(context, listen: false)
                                          .voteOnComment(widget.comment, widget.comment.userVote != -1 ? -1 : 0)
                                          .then((value) => value.fold(
                                              (err) => context.read<NotificationsCubit>().showErr(err), (_) => null));
                                    });
                                  },
                                  extraLeftPadding: true,
                                  amount: widget.comment.comment.downvote,
                                  isSelected: widget.comment.userVote == -1,
                                  icon: CupertinoIcons.down_arrow,
                                  iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                              ],
                            ),
                            // Text(
                            //     "(ID: ${widget.comment.comment.id}) ${!widget.isRootComment} && (${widget.currentReplyNum} == ${widget.currentlyRetrievedReplies}) && (${widget.currentReplyNum} < ${widget.totalNumOfReplies})"),
                            WidgetOrNothing(
                              showWidget: (!widget.isRootComment &&
                                      widget.currentReplyNum == widget.currentlyRetrievedReplies &&
                                      widget.currentReplyNum < widget.totalNumOfReplies) ||
                                  isLoading,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SimpleTextButton(
                                    infiniteWidth: true,
                                    onTap: () async => await loadMore(),
                                    text: isLoading
                                        ? "Loading..."
                                        : "Load more (${widget.totalNumOfReplies - widget.currentReplyNum} left)",
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
