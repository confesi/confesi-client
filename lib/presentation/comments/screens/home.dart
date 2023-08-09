import 'dart:collection';

import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/numbers/large_number_formatter.dart';
import 'package:confesi/presentation/comments/widgets/sheet.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:confesi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:confesi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:scrollable/exports.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../application/user/cubit/quick_actions_cubit.dart';
import '../../../application/user/cubit/saved_posts_cubit.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../../init.dart';
import '../../../models/comment.dart';
import '../../create_post/overlays/confetti_blaster.dart';
import '../../feed/methods/show_post_options.dart';
import '../../feed/utils/post_metadata_formatters.dart';
import '../widgets/simple_comment_root_group.dart';
import '../widgets/simple_comment_tile.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';

class CommentsHome extends StatefulWidget {
  const CommentsHome({super.key, required this.props});

  final HomePostsCommentsProps props;

  @override
  State<CommentsHome> createState() => _CommentsHomeState();
}

class _CommentsHomeState extends State<CommentsHome> {
  FeedListController feedController = FeedListController(preloadBy: 1);
  late CommentSheetController commentSheetController;
  late ScreenshotCallback screenshotCallback;

  @override
  void initState() {
    commentSheetController = CommentSheetController();
    screenshotCallback = ScreenshotCallback();
    screenshotCallback.addListener(
      () {
        showNotificationChip(
          context,
          "Tap here to share this instead",
          notificationType: NotificationType.success,
          onTap: () => context.read<QuickActionsCubit>().sharePost(context, widget.props.post),
        );
      },
    );
    // post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.props.openKeyboard) commentSheetController.focus();
      Provider.of<GlobalContentService>(context, listen: false).clearComments();
      context.read<CreateCommentCubit>().clear();
      context.read<CommentSectionCubit>().clear();
    });
    super.initState();
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    commentSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: NavBlocker(
        blocking: Provider.of<CreateCommentService>(context).isLoading,
        child: KeyboardDismiss(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.shadow,
            body: Stack(
              children: [
                BlocBuilder<CommentSectionCubit, CommentSectionState>(
                  builder: (context, state) {
                    return FooterLayout(
                        footer: context.watch<CommentSectionCubit>().state is CommentSectionData
                            ? SafeArea(
                                top: false,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).colorScheme.onBackground,
                                        width: 0.8,
                                      ),
                                    ),
                                  ),
                                  child: CommentSheet(
                                    postCreatedAtTime: widget.props.post.createdAt,
                                    feedController: feedController,
                                    onSubmit: (value) async {
                                      commentSheetController.unfocus();
                                      Provider.of<CreateCommentService>(context, listen: false).setLoading(true);
                                      final replyingTo = context.read<CreateCommentCubit>().replyingToComment();
                                      int? replyingToIdx;
                                      if (replyingTo != null) {
                                        context
                                            .read<CommentSectionCubit>()
                                            .indexFromCommentId(replyingTo.rootCommentIdReplyingUnder)
                                            .fold(
                                              (idx) => replyingToIdx = idx,
                                              (_) => null, // do nothing
                                            );
                                      }
                                      print("GOT INDEX OF $replyingToIdx");
                                      await context
                                          .read<CommentSectionCubit>()
                                          .uploadComment(
                                            widget.props.post.id,
                                            value,
                                            replyingTo,
                                          )
                                          .then((eitherResponse) {
                                        eitherResponse.fold(
                                          (error) {
                                            context.read<NotificationsCubit>().showErr(error);
                                          },
                                          (commentWithMetadata) async {
                                            commentSheetController.delete();
                                            sl.get<ConfettiBlaster>().show(context);
                                            context.read<CreateCommentCubit>().clear();
                                            context.read<CreateCommentCubit>().updateReplyingTo(ReplyingToNothing());
                                            Provider.of<GlobalContentService>(context, listen: false)
                                                .updatePostCommentCount(widget.props.post.id, 1);
                                            if (replyingToIdx == null) {
                                              feedController.scrollToIndex(1);
                                            } else {
                                              feedController.scrollToIndex(replyingToIdx! + 2);
                                            }
                                          },
                                        );
                                      }).then(
                                        (_) =>
                                            Provider.of<CreateCommentService>(context, listen: false).setLoading(false),
                                      );
                                    },
                                    maxCharacters: maxCommentLength,
                                    controller: commentSheetController,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StatTileGroup(
                              icon1Text: "Back",
                              icon2Text: addCommasToNumber(widget.props.post.commentCount),
                              icon3Text: "More",
                              icon4Text: largeNumberFormatter(widget.props.post.upvote),
                              icon5Text: largeNumberFormatter(widget.props.post.downvote),
                              icon1OnPress: () => router.pop(context),
                              icon2OnPress: () => commentSheetController.isFocused()
                                  ? verifiedUserOnly(context, () => commentSheetController.unfocus())
                                  : verifiedUserOnly(context, () => commentSheetController.focus()),
                              icon3OnPress: () => buildOptionsSheet(context, widget.props.post),
                              icon4OnPress: () async => verifiedUserOnly(
                                context,
                                () async => await Provider.of<GlobalContentService>(context, listen: false)
                                    .voteOnPost(widget.props.post, widget.props.post.userVote != 1 ? 1 : 0)
                                    .then((value) => value.fold(
                                        (err) => context.read<NotificationsCubit>().showErr(err), (_) => null)),
                              ),
                              icon5OnPress: () async => verifiedUserOnly(
                                  context,
                                  () async => await Provider.of<GlobalContentService>(context, listen: false)
                                      .voteOnPost(widget.props.post, widget.props.post.userVote != -1 ? -1 : 0)
                                      .then((value) => value.fold(
                                          (err) => context.read<NotificationsCubit>().showErr(err), (_) => null))),
                              icon4Selected: widget.props.post.userVote == 1,
                              icon5Selected: widget.props.post.userVote == -1,
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: buildBody(context, state),
                              ),
                            ),
                          ],
                        ));
                  },
                ),
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: buildLoadingOverlay(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoadingOverlay(BuildContext context) {
    return Provider.of<CreateCommentService>(context).isLoading
        ? Container(
            color: Theme.of(context).colorScheme.background.withOpacity(0.5),
            child: LoadingOrAlert(message: StateMessage("Error", () {}), isLoading: true),
          )
        : const SizedBox();
  }

  Widget buildBody(BuildContext context, CommentSectionState state) {
    if (state is CommentSectionData) {
      final List<InfiniteScrollIndexable> commentWidgets = [];
      int commentIndex = 0; // Counter variable to keep track of the index

      for (final commentIds in state.commentIds) {
        final rootCommentId = commentIds.keys.first;
        final rootCommentIdsList = commentIds[rootCommentId]!;
        LinkedHashMap<int, CommentWithMetadata> commentSet = Provider.of<GlobalContentService>(context).comments;
        final comment = commentSet[rootCommentId];

        if (comment != null) {
          context.read<CommentSectionCubit>().updateCommentIdToIndex(comment.comment.id, commentIndex);
          // context.read<CommentSectionCubit>().updateRootCommentIndex(commentIndex + 1);
          commentWidgets.add(
            InfiniteScrollIndexable(
              rootCommentId,
              SimpleCommentRootGroup(
                root: SimpleCommentTile(
                  postCreatedAtTime: widget.props.post.createdAt,
                  commentSheetController: commentSheetController,
                  feedController: feedController,
                  currentReplyNum: 0, // doesn't matter for root
                  currentlyRetrievedReplies: 0, // doesn't matter for root
                  totalNumOfReplies: comment.comment.childrenCount,
                  isRootComment: true,
                  comment: comment,
                ),
                subTree: const [], // No sub-replies since they are one level deep
              ),
            ),
          );
          commentIndex++; // Increment the counter for the next comment
          int totalReplies = comment.comment.childrenCount;
          int iter = 1;
          for (final replyId in rootCommentIdsList) {
            final replyComment = commentSet[replyId];
            if (replyComment != null) {
              totalReplies += replyComment.comment.childrenCount;
              context.read<CommentSectionCubit>().updateCommentIdToIndex(replyComment.comment.id, commentIndex);
              commentWidgets.add(
                InfiniteScrollIndexable(
                  replyId,
                  SimpleCommentRootGroup(
                    root: SimpleCommentTile(
                      postCreatedAtTime: widget.props.post.createdAt,
                      commentSheetController: commentSheetController,
                      feedController: feedController,
                      currentlyRetrievedReplies: rootCommentIdsList.length,
                      currentReplyNum: iter,
                      totalNumOfReplies: totalReplies,
                      isRootComment: false,
                      comment: replyComment,
                    ),
                    subTree: const [], // No sub-replies since they are one level deep
                  ),
                ),
              );
            }
            iter++;
            commentIndex++; // Increment the counter for the next comment
          }
        }
      }

      return Align(
        alignment: Alignment.topCenter,
        child: FeedList(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetOrNothing(
                      showWidget: widget.props.post.title.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            widget.props.post.title,
                            style: kDisplay1.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.props.post.school.name}${buildFaculty(widget.props.post)}${buildYear(widget.props.post)} • ${widget.props.post.category.category.capitalize()}",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${timeAgoFromMicroSecondUnixTime(widget.props.post.createdAt)}${widget.props.post.emojis.isNotEmpty ? " • ${widget.props.post.emojis.map((e) => e).join("")}" : ""}",
                          style: kDetail.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    WidgetOrNothing(
                      showWidget: widget.props.post.content.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            widget.props.post.content,
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              SimpleCommentSort(onSwitch: (newSort) => print(newSort)),
            ],
          ),
          isScrollable: true,
          shrinkWrap: true,
          controller: feedController..items = commentWidgets,
          loadMore: (_) async => await context.read<CommentSectionCubit>().loadInitial(
              widget.props.post.id, CommentSortType.recent,
              refresh: Provider.of<GlobalContentService>(context, listen: false).comments.isEmpty),
          onPullToRefresh: () async {
            Provider.of<GlobalContentService>(context, listen: false).clearComments();
            context.read<CreateCommentCubit>().clear();
            context.read<CommentSectionCubit>().clear();
            await Future.wait([
              context
                  .read<CommentSectionCubit>()
                  .loadInitial(widget.props.post.id, CommentSortType.recent, refresh: true),
            ]);
          },
          hasError: state.paginationState == CommentFeedState.error,
          wontLoadMore: state.paginationState == CommentFeedState.end,
          onWontLoadMoreButtonPressed: () =>
              context.read<CommentSectionCubit>().loadInitial(widget.props.post.id, CommentSortType.recent),
          onErrorButtonPressed: () =>
              context.read<CommentSectionCubit>().loadInitial(widget.props.post.id, CommentSortType.recent),
          wontLoadMoreMessage:
              state.paginationState == CommentFeedState.end ? "You've reached the end" : "Error loading",
        ),
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(
          state is CommentSectionError ? state.message : null,
          () => context.read<CommentSectionCubit>().loadInitial(widget.props.post.id, CommentSortType.recent),
        ),
        isLoading: state is CommentSectionData && state.paginationState == CommentFeedState.loading,
      );
    }
  }
}
