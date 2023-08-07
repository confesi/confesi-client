import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Key? key,
  }) : super(key: key);

  final CommentSheetController controller;
  final int maxCharacters;
  final FeedListController feedController;
  final Function(String) onSubmit;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  bool isDisposed = false;

  @override
  void initState() {
    widget.controller._init(commentController, textFocusNode);
    widget.controller.addListener(() => isDisposed ? null : setState(() => {}));
    super.initState();
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
                  .indexFromCommentId((state.possibleReply as ReplyingToUser).commentId)
                  .fold((idx) => widget.feedController.scrollToIndex(idx + 1),
                      (_) => context.read<NotificationsCubit>().show("Error jumping to comment")),
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.transparent, // transparent for hitbox
                child: Text(
                  "Replying to ${(state.possibleReply as ReplyingToUser).identifier}",
                  style: kDetail.copyWith(color: Theme.of(context).colorScheme.secondary),
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
            onChange: (_) {
              setState(() => {});
              context.read<CreateCommentCubit>().state is CreateCommentEnteringData &&
                      (context.read<CreateCommentCubit>().state as CreateCommentEnteringData).possibleReply
                          is ReplyingToUser
                  ? context
                      .read<CommentSectionCubit>()
                      .indexFromCommentId(((context.read<CreateCommentCubit>().state as CreateCommentEnteringData)
                              .possibleReply as ReplyingToUser)
                          .commentId)
                      .fold(
                          (idx) => widget.feedController.currentIndex() != idx + 1
                              ? widget.feedController.scrollToIndex(idx + 1, hapticFeedback: false)
                              : null,
                          (r) => context.read<NotificationsCubit>().show("Error jumpingt to comment"))
                  : null;
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
                            text: 'Cancel',
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
                            text: 'Post',
                            onTap: () {
                              widget.onSubmit(commentController.text);
                              setState(() => {});
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
