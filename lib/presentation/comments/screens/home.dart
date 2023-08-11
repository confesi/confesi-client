import 'dart:collection';

import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/posts/cubit/individual_post_cubit.dart';
import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/numbers/large_number_formatter.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/comments/widgets/sheet.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:confesi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:http/http.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:scrollable/exports.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../application/user/cubit/quick_actions_cubit.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../core/utils/funcs/links_from_text.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../../init.dart';
import '../../../models/comment.dart';
import '../../create_post/overlays/confetti_blaster.dart';
import '../../feed/methods/show_post_options.dart';
import '../../feed/utils/post_metadata_formatters.dart';
import '../../shared/behaviours/url_preview.dart';
import '../widgets/simple_comment_root_group.dart';
import '../widgets/simple_comment_tile.dart';
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
  final FeedListController feedListController = FeedListController();
  final CommentSheetController commentSheetController = CommentSheetController();
  final ScreenshotCallback screenshotCallback = ScreenshotCallback();

  Future<void> delegateInitialLoad() async {
    // await Future.delayed(const Duration(milliseconds: 500));
    if (widget.props.postLoadType is PreloadedPost) {
      // preloaded
      context.read<IndividualPostCubit>().setPost((widget.props.postLoadType as PreloadedPost).post);
    } else if (widget.props.postLoadType is NeedToLoadPost) {
      // not preloaded
      await context.read<IndividualPostCubit>().loadPost((widget.props.postLoadType as NeedToLoadPost).maskedPostId);
    } else {
      context.read<NotificationsCubit>().showErr("Error loading content");
    }
  }

  List<InfiniteScrollIndexable> generateComments(
      BuildContext context, CommentSectionState state, FeedListController feedController, PostWithMetadata post) {
    if (state is CommentSectionData) {
      final List<InfiniteScrollIndexable> commentWidgets = [];
      int commentIndex = 0; // Counter variable to keep track of the index
      LinkedHashMap<EncryptedId, CommentWithMetadata> commentSet = Provider.of<GlobalContentService>(context).comments;

      // Set to keep track of comments that have already been added
      Set<EncryptedId> addedComments = <EncryptedId>{};

      for (LinkedHashMap<String, List<EncryptedId>> commentIds in state.commentIds) {
        final rootCommentId = commentIds.keys.first;
        final rootCommentIdsList = commentIds[rootCommentId]!;

        final commentId = EncryptedId(uid: rootCommentId, mid: ''); // mid doesn't matter
        final comment = commentSet[commentId];

        if (comment != null && !addedComments.contains(commentId)) {
          context.read<CommentSectionCubit>().updateCommentIdToIndex(comment.comment.id, commentIndex);
          commentWidgets.add(
            InfiniteScrollIndexable(
              rootCommentId,
              SimpleCommentRootGroup(
                root: SimpleCommentTile(
                  postCreatedAtTime: post.post.createdAt,
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
          addedComments.add(commentId); // Mark the comment as added

          commentIndex++; // Increment the counter for the next comment
          int totalReplies = comment.comment.childrenCount;
          int iter = 1;
          for (final replyId in rootCommentIdsList) {
            final replyComment = commentSet[replyId];

            if (replyComment != null) {
              // Check if the reply comment has already been added
              final replyCommentId = EncryptedId(uid: replyId.uid, mid: ''); // mid doesn't matter
              if (!addedComments.contains(replyCommentId)) {
                totalReplies += replyComment.comment.childrenCount;
                context.read<CommentSectionCubit>().updateCommentIdToIndex(replyComment.comment.id, commentIndex);
                commentWidgets.add(
                  InfiniteScrollIndexable(
                    replyId.uid,
                    SimpleCommentRootGroup(
                      root: SimpleCommentTile(
                        postCreatedAtTime: post.post.createdAt,
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
                addedComments.add(replyCommentId); // Mark the reply comment as added
                commentIndex++; // Increment the counter for the next comment
              }
            }
            iter++;
          }
        }
      }
      return commentWidgets;
    } else {
      return [];
    }
  }

  Widget buildHeader(BuildContext context, CommentSectionData commentData, IndividualPostData postState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () {
            HapticFeedback.lightImpact();
            upvote(postState.post);
          },
          child: Container(
            width: double.infinity,
            // transparent container to make the whole header clickable
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetOrNothing(
                    showWidget: postState.post.post.title.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          postState.post.post.title,
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
                        "${postState.post.post.school.name}${buildFaculty(postState.post)}${buildYear(postState.post)} • ${postState.post.post.category.category.capitalize()}",
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${timeAgoFromMicroSecondUnixTime(postState.post.post.createdAt)}${postState.post.emojis.isNotEmpty ? " • ${postState.post.emojis.map((e) => e).join("")}" : ""}",
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  WidgetOrNothing(
                    showWidget: postState.post.post.content.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          postState.post.post.content,
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  ...linksFromText(postState.post.post.content)
                      .take(maxNumberOfLinkPreviewsPerDetailCommentView) // Limit to a maximum of 3 links
                      .map((link) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: UrlPreviewTile(url: link),
                    );
                  }).toList(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
        SimpleCommentSort(onSwitch: (newSort) => print(newSort)),
      ],
    );
  }

  void upvote(PostWithMetadata post) {
    verifiedUserOnly(
      context,
      () async => await Provider.of<GlobalContentService>(context, listen: false)
          .voteOnPost(post, post.userVote != 1 ? 1 : 0)
          .then((value) => value.fold((err) => context.read<NotificationsCubit>().showErr(err), (_) => null)),
    );
  }

  void clearOldState() {
    context.read<CreateCommentCubit>().clear();
    context.read<CommentSectionCubit>().clear();
    context.read<IndividualPostCubit>().setLoading();
  }

  void startScreenshotListener() {
    screenshotCallback.addListener(
      () {
        context.read<IndividualPostCubit>().state is IndividualPostData
            ? showNotificationChip(
                context,
                "Tap here to share this instead",
                notificationType: NotificationType.success,
                onTap: () => context
                    .read<QuickActionsCubit>()
                    .sharePost(context, (context.read<IndividualPostCubit>().state as IndividualPostData).post),
              )
            : null;
      },
    );
  }

  @override
  void initState() {
    startScreenshotListener();
    clearOldState();
    delegateInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    feedListController.dispose();
    commentSheetController.dispose();
    screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OneThemeStatusBar(
      brightness:
          context.watch<IndividualPostCubit>().state is IndividualPostLoading ? Brightness.dark : Brightness.light,
      child: KeyboardDismiss(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: BlocConsumer<IndividualPostCubit, IndividualPostState>(
            listenWhen: (previous, current) => previous is IndividualPostLoading && current is IndividualPostData,
            listener: (context, state) {
              if (state is IndividualPostData) {
                context
                    .read<CommentSectionCubit>()
                    .loadInitial(state.post.post.id.mid, CommentSortType.recent, refresh: true);
              }
            },
            builder: (context, postState) {
              if (postState is IndividualPostData) {
                return BlocBuilder<CommentSectionCubit, CommentSectionState>(
                  builder: (context, commentState) {
                    if (commentState is CommentSectionData) {
                      return FooterLayout(
                        footer: SafeArea(
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
                              controller: commentSheetController,
                              onSubmit: (value) => print(value),
                              maxCharacters: maxCommentLength,
                              feedController: feedListController,
                              postCreatedAtTime: postState.post.post.createdAt,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              StatTileGroup(
                                icon1Text: "Back",
                                icon2Text: addCommasToNumber(postState.post.post.commentCount),
                                icon3Text: "More",
                                icon4Text: largeNumberFormatter(postState.post.post.upvote),
                                icon5Text: largeNumberFormatter(postState.post.post.downvote),
                                icon1OnPress: () => router.pop(context),
                                icon2OnPress: () => commentSheetController.isFocused()
                                    ? verifiedUserOnly(context, () => commentSheetController.unfocus())
                                    : verifiedUserOnly(context, () => commentSheetController.focus()),
                                icon3OnPress: () => buildOptionsSheet(context, postState.post),
                                icon4OnPress: () async => upvote(postState.post),
                                icon5OnPress: () async => verifiedUserOnly(
                                    context,
                                    () async => await Provider.of<GlobalContentService>(context, listen: false)
                                        .voteOnPost(postState.post, postState.post.userVote != -1 ? -1 : 0)
                                        .then((value) => value.fold(
                                            (err) => context.read<NotificationsCubit>().showErr(err), (_) => null))),
                                icon4Selected: Provider.of<GlobalContentService>(context)
                                        .posts[postState.post.post.id]!
                                        .userVote ==
                                    1,
                                icon5Selected: Provider.of<GlobalContentService>(context)
                                        .posts[postState.post.post.id]!
                                        .userVote ==
                                    -1,
                              ),
                              Expanded(
                                child: FeedList(
                                  header: buildHeader(context, commentState, postState),
                                  isScrollable: true,
                                  shrinkWrap: true,
                                  controller: feedListController
                                    ..items =
                                        generateComments(context, commentState, feedListController, postState.post),
                                  loadMore: (_) async => await context.read<CommentSectionCubit>().loadInitial(
                                      postState.post.post.id.mid, CommentSortType.recent,
                                      refresh: commentState.commentIds.isEmpty),
                                  hasError: commentState.paginationState == CommentFeedState.error,
                                  onErrorButtonPressed: () async => await context
                                      .read<CommentSectionCubit>()
                                      .loadInitial(postState.post.post.id.mid, CommentSortType.recent),
                                  onPullToRefresh: () async {
                                    Provider.of<GlobalContentService>(context, listen: false).clearComments();
                                    context.read<CreateCommentCubit>().clear();
                                    context.read<CommentSectionCubit>().clear();
                                    context.read<IndividualPostCubit>().setLoading();
                                    await delegateInitialLoad();
                                  },
                                  onWontLoadMoreButtonPressed: () async => await context
                                      .read<CommentSectionCubit>()
                                      .loadInitial(postState.post.post.id.mid, CommentSortType.recent,
                                          refresh: commentState.commentIds.isEmpty),
                                  wontLoadMore: commentState.paginationState == CommentFeedState.end,
                                  wontLoadMoreMessage: "You've reached the end",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return LoadingOrAlert(
                          message: StateMessage(
                              commentState is CommentSectionError ? commentState.message : "Unknown error",
                              () => context
                                  .read<CommentSectionCubit>()
                                  .loadInitial(postState.post.post.id.mid, CommentSortType.recent)),
                          isLoading: false);
                    }
                  },
                );
              } else {
                return LoadingOrAlert(
                    message: StateMessage(postState is IndividualPostError ? postState.message : "Unknown error",
                        () => delegateInitialLoad()),
                    isLoading: postState is IndividualPostLoading);
              }
            },
          ),
        ),
      ),
    );
  }
}
