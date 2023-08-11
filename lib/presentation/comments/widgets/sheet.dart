import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/colors/deterministic_random_color.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../shared/other/feed_list.dart';
import '../../shared/other/text_limit_tracker.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/textfields/expandable_textfield.dart';

class CommentSheetController extends ChangeNotifier {
  bool _blockingInteraction = false;
  late TextEditingController commentController;
  late FocusNode textFocusNode;

  void _init(TextEditingController commentController, FocusNode textFocusNode) {
    this.commentController = commentController;
    this.textFocusNode = textFocusNode;
  }

  bool get isBlocking => _blockingInteraction;

  void setBlocking(bool isBlocking) {
    textFocusNode.unfocus();
    _blockingInteraction = isBlocking;
    notifyListeners();
  }

  void focus() {
    textFocusNode.requestFocus();
    notifyListeners();
  }

  void unfocus() {
    textFocusNode.unfocus();
    notifyListeners();
  }

  bool isFocused() => textFocusNode.hasFocus;

  void delete() {
    textFocusNode.unfocus();
    commentController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    commentController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }
}

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    required this.onSubmit,
    required this.maxCharacters,
    required this.controller,
    required this.feedController,
    required this.postCreatedAtTime,
    Key? key,
  }) : super(key: key);

  final CommentSheetController controller;
  final int maxCharacters;
  final FeedListController feedController;
  final Function(String) onSubmit;
  final int postCreatedAtTime;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  bool isDisposed = false;

  @override
  void initState() {
    widget.controller.addListener(() => isDisposed ? null : setState(() => {}));
    super.initState();
  }

  int getNumericalUser(CreateCommentEnteringData state) {
    final possibleComment = Provider.of<GlobalContentService>(context)
        .comments[(state.possibleReply as ReplyingToUser).replyingToCommentId];
    if (possibleComment == null) {
      return 9999;
    } else if (possibleComment.comment.numericalUserIsOp) {
      return 0;
    } else {
      return possibleComment.comment.numericalUser ?? 9999;
    }
  }

  Widget buildBody(BuildContext context, CreateCommentState state) {
    if (state is CreateCommentEnteringData && state.possibleReply is ReplyingToUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TouchableScale(
              onTap: () => context
                  .read<CommentSectionCubit>()
                  .indexFromCommentId((state.possibleReply as ReplyingToUser).replyingToCommentId)
                  .fold((idx) => widget.feedController.scrollToIndex(idx + 1),
                      (_) => context.read<NotificationsCubit>().showErr("Error jumping to comment")),
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.transparent, // transparent for hitbox
                child: Text(
                  "Replying to ${(state.possibleReply as ReplyingToUser).identifier}",
                  style: kDetail.copyWith(color: genColor(widget.postCreatedAtTime, getNumericalUser(state))),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(width: 5),
            TouchableScale(
              onTap: () => context.read<CreateCommentCubit>().updateReplyingTo(ReplyingToNothing()),
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.transparent, // transparent for hitbox
                child: Icon(
                  CupertinoIcons.xmark,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateCommentCubit>().state;
    return IgnorePointer(
      ignoring: widget.controller.isBlocking,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<CreateCommentCubit, CreateCommentState>(
            builder: (context, state) => buildBody(context, state),
          ),
          ExpandableTextfield(
            verifiedUsersOnly: true,
            onChange: (_) {
              state is CreateCommentEnteringData && state.possibleReply is ReplyingToUser
                  ? context
                      .read<CommentSectionCubit>()
                      .indexFromCommentId((state.possibleReply as ReplyingToUser).replyingToCommentId)
                      .fold((idx) => widget.feedController.scrollToIndex(idx + 1, hapticFeedback: false),
                          (_) => context.read<NotificationsCubit>().showErr("Error jumping to comment"))
                  : null;
              setState(() => {});
            },
            color: Theme.of(context).colorScheme.background,
            focusNode: textFocusNode,
            hintText: "Add a comment...",
            maxLines: 4,
            minLines: 1,
            maxCharacters: widget.maxCharacters,
            controller: commentController,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: commentController.text.isEmpty
                ? Container()
                : AnimatedScale(
                    scale: commentController.text.isEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          SimpleTextButton(
                            text: "Delete",
                            isErrorText: true,
                            onTap: () => widget.controller.delete(),
                          ),
                          Expanded(
                            child: TextLimitTracker(
                              noText: false,
                              value: commentController.text.runes.length / widget.maxCharacters,
                            ),
                          ),
                          SimpleTextButton(
                            tapType: TapType.strongImpact,
                            text: "Submit",
                            onTap: () {
                              verifiedUserOnly(context, () {
                                widget.onSubmit(commentController.text);
                                setState(() => {});
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
