import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/extensions/strings/new_lines.dart';
import 'package:confesi/core/utils/strings/truncate_text.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/presentation/comments/widgets/comment_sheet.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/text.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/colors/deterministic_random_color.dart';
import '../../../models/comment.dart';
import '../../shared/buttons/option.dart';
import '../../feed/utils/post_metadata_formatters.dart';

//! Data classes

abstract class CommentType {
  CommentWithMetadata get comment;
  int get totalRetrievedReplies;
}

class RootComment extends CommentType {
  final CommentWithMetadata commentWithMetaData;
  final int _totalRetrievedReplies;

  RootComment(this.commentWithMetaData, this._totalRetrievedReplies);

  @override
  CommentWithMetadata get comment => commentWithMetaData;

  @override
  int get totalRetrievedReplies => _totalRetrievedReplies;

  // tostring with all field listed simply
  @override
  String toString() {
    return "totalRetrievedReplies: $_totalRetrievedReplies";
  }
}

class ReplyComment extends CommentType {
  final CommentWithMetadata commentWithMetaData;
  final int currentReplyNum;
  final int _totalRetrievedReplies;

  ReplyComment(
    this.commentWithMetaData,
    this.currentReplyNum,
    this._totalRetrievedReplies,
  );

  @override
  int get totalRetrievedReplies => _totalRetrievedReplies;

  @override
  CommentWithMetadata get comment => commentWithMetaData;

  @override
  String toString() {
    return "currentReplyNum: $currentReplyNum";
  }
}

//! Widget

class CommentTile extends StatefulWidget {
  const CommentTile({
    Key? key,
    required this.commentType,
    this.isGettingRepliedTo = false,
    required this.feedController,
    required this.commentSheetController,
    required this.postCreatedAtTime,
  }) : super(key: key);

  final CommentType commentType;
  final FeedListController feedController;
  final bool isGettingRepliedTo;
  final CommentSheetController commentSheetController;
  final int postCreatedAtTime;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  void showOptions(BuildContext context, int totalReplies) {
    showButtonOptionsSheet(context, [
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
      if ((totalReplies > widget.commentType.totalRetrievedReplies ||
              ((widget.commentType is RootComment && widget.commentType.totalRetrievedReplies == 0))) ||
          isLoading ||
          (widget.commentType is ReplyComment &&
              (widget.commentType as ReplyComment)._totalRetrievedReplies ==
                  (widget.commentType as ReplyComment).currentReplyNum))
        OptionButton(
          text: "Try loading more replies",
          icon: CupertinoIcons.chat_bubble,
          onTap: () async => await loadMore(),
        )
    ]);
  }

  String get buildUserIdentifier => widget.commentType.comment.comment.numericalUserIsOp
      ? "OP"
      : "#${widget.commentType.comment.comment.numericalUser.toString()}";

  bool truncating = true;

  List<TextSpan> _buildReplyHeaderSpans(BuildContext context) {
    List<TextSpan> spans = [];

    String replying = widget.commentType.comment.comment.numericalReplyingUserIsOp
        ? "OP"
        : "#${widget.commentType.comment.comment.numericalReplyingUser.toString()}";
    String user = buildUserIdentifier;

    if (widget.commentType.comment.comment.numericalReplyingUser != null ||
        widget.commentType.comment.comment.numericalReplyingUserIsOp) {
      spans.add(TextSpan(
        text: replying,
        style: kDetail.copyWith(
            color: genColor(widget.postCreatedAtTime, getIdentifierFromReplyingUser())), // Set the color for "OP"
      ));
    }

    if (widget.commentType.comment.comment.numericalReplyingUser != null ||
        widget.commentType.comment.comment.numericalReplyingUserIsOp) {
      spans.add(
        TextSpan(
          text: " <- ",
          style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary), // Set the color for "OP"
        ),
      );
    }

    if (widget.commentType.comment.comment.numericalUser != null ||
        widget.commentType.comment.comment.numericalUserIsOp) {
      spans.add(TextSpan(
        text: user,
        style: kDetail.copyWith(color: genColor(widget.postCreatedAtTime, getIdentifierFromUser())),
      ));
    }

    spans.add(TextSpan(
      text:
          " • ${timeAgoFromMicroSecondUnixTime(widget.commentType.comment.comment.createdAt)}${widget.commentType.comment.comment.edited ? " (edited)" : ""}",
      style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
    ));

    return spans;
  }

  bool isLoading = false;

  int getIdentifierFromReplyingUser() {
    if (widget.commentType.comment.comment.numericalReplyingUserIsOp) {
      return 0;
    } else {
      return widget.commentType.comment.comment.numericalReplyingUser ?? 9999;
    }
  }

  int getIdentifierFromUser() {
    if (widget.commentType.comment.comment.numericalUserIsOp) {
      return 0;
    } else {
      return widget.commentType.comment.comment.numericalUser ?? 9999;
    }
  }

  Future<void> loadMore() async {
    setState(() => isLoading = true);
    await context
        .read<CommentSectionCubit>()
        .loadReplies(widget.commentType.comment.comment.parentRootId ?? widget.commentType.comment.comment.id,
            widget.commentType.comment.comment.createdAt)
        .then(
          (possibleSuccess) =>
              possibleSuccess ? null : context.read<NotificationsCubit>().showErr("Error loading more"),
        );
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final int totalReplies = widget.commentType.comment.comment.parentRootId == null
        ? 0
        : Provider.of<GlobalContentService>(context)
                    .repliesPerCommentThread[widget.commentType.comment.comment.parentRootId] ==
                null
            ? 0
            : Provider.of<GlobalContentService>(context)
                .repliesPerCommentThread[widget.commentType.comment.comment.parentRootId]!;
    final state = context.watch<CreateCommentCubit>().state;
    return GestureDetector(
      onTap: () => setState(() => truncating = !truncating),
      onLongPress: () => showOptions(context, totalReplies),
      child: Padding(
        padding: EdgeInsets.only(left: widget.commentType is! RootComment ? 15 : 0),
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
                            (state.possibleReply as ReplyingToUser).replyingToCommentId ==
                                widget.commentType.comment.comment.id
                        ? Theme.of(context).colorScheme.shadow // shadow for highlight
                        : Theme.of(context).colorScheme.background,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: borderSize,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                              TextNoVertOverflow(
                                truncating
                                    ? truncateText(widget.commentType.comment.comment.content.removeExtraNewLines,
                                        commentPreviewLength,
                                        ellipsis: "... (tap for more)")
                                    : widget.commentType.comment.comment.content.removeExtraNewLines,
                                style: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 1.2,
                                  fontSize: kBody.fontSize! *
                                      Provider.of<UserAuthService>(context).data().textSize.multiplier,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TouchableOpacity(
                                      onTap: () => showOptions(context, totalReplies),
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
                                                  replyingToCommentId: widget.commentType.comment.comment.id,
                                                  identifier: buildUserIdentifier,
                                                  rootCommentIdReplyingUnder:
                                                      widget.commentType.comment.comment.parentRootId ??
                                                          widget.commentType.comment.comment.id,
                                                  currentlyFocusingRoot:
                                                      widget.commentType.comment.comment.parentRootId == null,
                                                ),
                                              );
                                          context.read<CreateCommentCubit>().state is CreateCommentEnteringData &&
                                                  (context.read<CreateCommentCubit>().state
                                                          as CreateCommentEnteringData)
                                                      .possibleReply is ReplyingToUser
                                              ? context
                                                  .read<CommentSectionCubit>()
                                                  .indexFromCommentId(((context.read<CreateCommentCubit>().state
                                                              as CreateCommentEnteringData)
                                                          .possibleReply as ReplyingToUser)
                                                      .replyingToCommentId)
                                                  .fold(
                                                    (idx) => widget.feedController.scrollToIndex(
                                                        context,
                                                        idx +
                                                            (widget.commentType.comment.comment.parentRootId == null
                                                                ? 1
                                                                : 2),
                                                        hapticFeedback: false),
                                                    (r) => context
                                                        .read<NotificationsCubit>()
                                                        .showErr("Error jumping to comment"),
                                                  )
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
                                                          widget.commentType.comment.comment.id
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
                                                              widget.commentType.comment.comment.id
                                                      ? Theme.of(context).colorScheme.secondary
                                                      : Theme.of(context).colorScheme.primary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ReactionTile(
                                      simpleView: true,
                                      onTap: () async {
                                        verifiedUserOnly(
                                          context,
                                          () async => await Provider.of<GlobalContentService>(context, listen: false)
                                              .voteOnComment(widget.commentType.comment,
                                                  widget.commentType.comment.userVote != 1 ? 1 : 0)
                                              .then(
                                                (value) => value.fold(
                                                    (err) => context.read<NotificationsCubit>().showErr(err),
                                                    (_) => null),
                                              ),
                                        );
                                      },
                                      amount: widget.commentType.comment.comment.upvote,
                                      isSelected: widget.commentType.comment.userVote == 1,
                                      icon: CupertinoIcons.up_arrow,
                                      iconColor: Theme.of(context).colorScheme.onErrorContainer,
                                    ),
                                    const SizedBox(width: 10),
                                    ReactionTile(
                                      simpleView: true,
                                      onTap: () async {
                                        verifiedUserOnly(context, () async {
                                          await Provider.of<GlobalContentService>(context, listen: false)
                                              .voteOnComment(widget.commentType.comment,
                                                  widget.commentType.comment.userVote != -1 ? -1 : 0)
                                              .then((value) => value.fold(
                                                  (err) => context.read<NotificationsCubit>().showErr(err),
                                                  (_) => null));
                                        });
                                      },
                                      amount: widget.commentType.comment.comment.downvote,
                                      isSelected: widget.commentType.comment.userVote == -1,
                                      icon: CupertinoIcons.down_arrow,
                                      iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                              // Text(widget.commentType.toString()),
                              // Text("total replies: ${totalReplies.toString()}"),
                              // Text("CHILDREN COUNT: ${widget.commentType.comment.comment.childrenCount}"),
                              WidgetOrNothing(
                                showWidget: (totalReplies > widget.commentType.totalRetrievedReplies &&
                                        ((widget.commentType is RootComment &&
                                                widget.commentType.totalRetrievedReplies == 0) ||
                                            (widget.commentType is ReplyComment &&
                                                widget.commentType.totalRetrievedReplies ==
                                                    (widget.commentType as ReplyComment).currentReplyNum))) ||
                                    isLoading,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: SimpleTextButton(
                                      infiniteWidth: true,
                                      onTap: () async => await loadMore(),
                                      text: isLoading ? "Loading..." : "Load more",
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
      ),
    );
  }
}
