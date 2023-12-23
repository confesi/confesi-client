import 'dart:collection';

import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/application/posts/cubit/individual_post_cubit.dart';
import 'package:confesi/constants/feed/general.dart';
import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/numbers/large_number_formatter.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/comments/widgets/sheet.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/feed/screens/feed_tab_manager.dart';
import 'package:confesi/presentation/feed/widgets/img_viewer.dart';
import 'package:confesi/presentation/feed/widgets/sticky_appbar.dart';
import 'package:confesi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:confesi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:confesi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/text.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:scrollable/exports.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../application/user/cubit/quick_actions_cubit.dart';
import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../core/utils/funcs/links_from_text.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/strings/truncate_text.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../../init.dart';
import '../../../models/comment.dart';
import '../../create_post/overlays/confetti_blaster.dart';
import '../../feed/methods/show_post_options.dart';
import '../../feed/utils/post_metadata_formatters.dart';
import '../../shared/indicators/alert.dart';
import '../widgets/comment_tile.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/overlays/screen_overlay.dart';
import '../../shared/stat_tiles/stat_tile_group.dart';

const double stickyAppbarHeight = 120;

class CommentsHome extends StatefulWidget {
  const CommentsHome({super.key, required this.props});

  final HomePostsCommentsProps props;

  @override
  State<CommentsHome> createState() => _CommentsHomeState();
}

class _CommentsHomeState extends State<CommentsHome> with TickerProviderStateMixin {
  final FeedListController feedListController = FeedListController();
  late CommentSheetController commentSheetController;
  final ScreenshotCallback screenshotCallback = ScreenshotCallback();
  late StickyAppbarController _stickyAppbarController;
  bool isScrolling = false;

  Future<void> delegateInitialLoad(BuildContext context, {bool refresh = false}) async {
    if (widget.props.postLoadType is PreloadedPost && !refresh) {
      // preloaded
      context.read<IndividualPostCubit>().setPost((widget.props.postLoadType as PreloadedPost).post);
    } else if (widget.props.postLoadType is NeedToLoadPost) {
      // not preloaded
      await context.read<IndividualPostCubit>().loadPost((widget.props.postLoadType as NeedToLoadPost).maskedPostId);
    } else if (widget.props.postLoadType is PreloadedPost && refresh) {
      await context.read<IndividualPostCubit>().loadPost((widget.props.postLoadType as PreloadedPost).post.post.id.mid);
    } else {
      context.read<NotificationsCubit>().showErr("Error loading content");
    }
  }

  List<InfiniteScrollIndexable> generateComments(
    BuildContext context,
    CommentSectionState state,
    FeedListController feedController,
    PostWithMetadata post,
  ) {
    if (state is CommentSectionData) {
      final List<InfiniteScrollIndexable> commentWidgets = [];
      LinkedHashMap<EncryptedId, CommentWithMetadata> commentSet =
          Provider.of<GlobalContentService>(context, listen: false).comments;

      for (LinkedHashMap<String, List<EncryptedId>> commentIds in state.commentIds) {
        final rootCommentId = commentIds.keys.first;
        final rootCommentIdsList = commentIds[rootCommentId]!;

        int totalChildren = 0;

        final rootCommentIdEncrypted = EncryptedId(uid: rootCommentId, mid: '');
        final rootComment = commentSet[rootCommentIdEncrypted];

        if (rootComment != null) {
          int commentIndex = commentWidgets.length;
          context.read<CommentSectionCubit>().updateCommentIdToIndex(rootComment.comment.id, commentIndex);
          totalChildren += rootComment.comment.childrenCount;
          commentWidgets.add(
            InfiniteScrollIndexable(
              rootCommentId,
              CommentTile(
                postCreatedAtTime: post.post.createdAt,
                commentSheetController: commentSheetController,
                feedController: feedController,
                commentType: RootComment(rootComment, rootCommentIdsList.length),
              ),
            ),
          );

          for (final commentId in rootCommentIdsList) {
            final replyComment = commentSet[commentId];

            if (replyComment != null) {
              totalChildren += replyComment.comment.childrenCount;
            }
          }

          int iter = 1;
          for (final commentId in rootCommentIdsList) {
            final replyComment = commentSet[commentId];

            if (replyComment != null) {
              context.read<CommentSectionCubit>().updateCommentIdToIndex(replyComment.comment.id, commentIndex);

              commentWidgets.add(
                InfiniteScrollIndexable(
                  commentId.uid,
                  CommentTile(
                    postCreatedAtTime: post.post.createdAt,
                    commentSheetController: commentSheetController,
                    feedController: feedController,
                    commentType: ReplyComment(replyComment, iter, rootCommentIdsList.length),
                  ),
                ),
              );
              commentIndex++;
            }
            iter++;
          }

          // Update the totalChildren for the root comment outside the loop
          sl.get<GlobalContentService>().setRepliesPerSchool(rootCommentIdEncrypted, totalChildren);
        }
      }

      return commentWidgets;
    } else {
      return [];
    }
  }

  Widget buildHeader(BuildContext context, CommentSectionData commentData, IndividualPostData postState) {
    final post = Provider.of<GlobalContentService>(context).posts[postState.post.post.id]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      TextNoVertOverflow(
                        post.post.title.isEmpty ? "[no title]" : removeSubsequentNewLines(post.post.title),
                        style: kDisplay1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              kDisplay1.fontSize! * Provider.of<UserAuthService>(context).data().textSize.multiplier,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextNoVertOverflow(
                        "${post.post.school.name}${buildFaculty(post)}${buildYear(post)} • ${post.post.category.category}",
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // adjust this as per your alignment preference
                        crossAxisAlignment: CrossAxisAlignment.center, // adjust this too as per your needs
                        children: <Widget>[
                          TextNoVertOverflow(
                            timeAgoFromMicroSecondUnixTime(post.post.createdAt),
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          if (post.post.edited) ...[
                            // using spread operator to conditionally render widgets
                            const SizedBox(width: 5), // add some space between text widgets
                            TextNoVertOverflow(
                              "• Edited",
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                WidgetOrNothing(
                  showWidget: post.post.content.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextNoVertOverflow(
                          removeSubsequentNewLines(post.post.content),
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:
                                kBody.fontSize! * Provider.of<UserAuthService>(context).data().textSize.multiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ImgViewer(
                    imageSources: post.post.imgUrls.map((e) => MyImageSource(url: e)).toList(),
                    isBlurred: Provider.of<UserAuthService>(context, listen: true).data().blurImages,
                    heroAnimPrefix: "comments_view"),
              ],
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

  void tryOpenKeyboard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.props.postLoadType is PreloadedPost && (widget.props.postLoadType as PreloadedPost).openKeyboard) {
        commentSheetController.focus();
      }
    });
  }

  @override
  void initState() {
    _stickyAppbarController = StickyAppbarController(this);
    commentSheetController = CommentSheetController();
    tryOpenKeyboard();
    startScreenshotListener();
    clearOldState();
    delegateInitialLoad(context);
    super.initState();
  }

  @override
  void dispose() {
    _stickyAppbarController.dispose();
    feedListController.dispose();
    screenshotCallback.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext ogContext, BuildContext context, IndividualPostState postState) {
    if (postState is IndividualPostData) {
      if (Provider.of<GlobalContentService>(ogContext).posts[postState.post.post.id] == null) {
        return Center(
          key: const ValueKey("deleted_post"),
          child: AlertIndicator(
            message: "This confession has been deleted",
            onPress: () => router.pop(),
            btnMsg: "Go back",
          ),
        );
      }
      return Builder(
        builder: (context) {
          return BlocBuilder<CommentSectionCubit, CommentSectionState>(
            builder: (newContext, commentState) {
              if (commentState is CommentSectionData) {
                return FooterLayout(
                  footer: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border(
                        top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SafeArea(
                      top: false,
                      child: CommentSheet(
                        controller: commentSheetController,
                        onSubmit: (value) async {
                          Provider.of<CreateCommentService>(ogContext, listen: false).setLoading(true);
                          final possibleReplyingTo = ogContext.read<CreateCommentCubit>().replyingToComment();
                          int? replyingToIdx;

                          if (possibleReplyingTo != null) {
                            final rootCommentId = possibleReplyingTo.rootCommentIdReplyingUnder;

                            try {
                              final matchingRootComment = commentState.commentIds.firstWhere(
                                (element) => element.containsKey(rootCommentId.uid),
                                orElse: () => throw Exception(),
                              );

                              final lastReplyList = matchingRootComment[rootCommentId.uid];

                              if (lastReplyList != null && lastReplyList.isNotEmpty) {
                                final possibleLast = lastReplyList.last;
                                final indexResult =
                                    ogContext.read<CommentSectionCubit>().indexFromCommentId(possibleLast);
                                indexResult.fold(
                                  (idx) {
                                    replyingToIdx = idx + 1;
                                  },
                                  (_) {
                                    // Handle indexFromCommentId error for last reply
                                    replyingToIdx = null;
                                  },
                                );
                              } else {
                                final indexResult =
                                    ogContext.read<CommentSectionCubit>().indexFromCommentId(rootCommentId);
                                indexResult.fold(
                                  (idx) {
                                    replyingToIdx = idx + 1;
                                  },
                                  (_) {
                                    // Handle indexFromCommentId error for root comment
                                    replyingToIdx = null;
                                  },
                                );
                              }
                            } catch (e) {
                              ogContext.read<NotificationsCubit>().showErr("Error replying to comment");
                            }
                          }
                          await ogContext
                              .read<CommentSectionCubit>()
                              .uploadComment(
                                postState.post.post.id,
                                value,
                                possibleReplyingTo,
                              )
                              .then((errOrComment) {
                            errOrComment.fold(
                              (errMsg) => ogContext.read<NotificationsCubit>().showErr(errMsg),
                              (comment) {
                                commentSheetController.unfocus();
                                sl.get<ConfettiBlaster>().show(ogContext);
                                ogContext.read<CreateCommentCubit>().clear();
                                commentSheetController.delete();
                                ogContext.read<CreateCommentCubit>().updateReplyingTo(ReplyingToNothing());
                                Provider.of<GlobalContentService>(ogContext, listen: false).setComment(comment);
                                Provider.of<GlobalContentService>(ogContext, listen: false)
                                    .updatePostCommentCount(postState.post.post.id, 1);
                                // if (possibleReplyingTo != null) {
                                //   Provider.of<GlobalContentService>(ogContext, listen: false)
                                //       .addOneToRootCommentCount(possibleReplyingTo.replyingToCommentId);
                                // }
                                if (replyingToIdx != null) {
                                  feedListController.scrollToIndex(replyingToIdx! + 2);
                                } else {
                                  feedListController.scrollToIndex(1);
                                }
                              },
                            );
                          }).then(
                            (value) => Provider.of<CreateCommentService>(ogContext, listen: false).setLoading(false),
                          );
                        },
                        maxCharacters: maxCommentLength,
                        feedController: feedListController,
                        postCreatedAtTime: postState.post.post.createdAt,
                      ),
                    ),
                  ),
                  child: StickyAppbar(
                    controller: _stickyAppbarController,
                    stickyHeader: StickyAppbarProps(
                      height: stickyAppbarHeight,
                      child: StatTileGroup(
                        icon1Text: "Back",
                        icon2Text: addCommasToNumber(postState.post.post.commentCount),
                        icon3Text: "More",
                        icon4Text: largeNumberFormatter(postState.post.post.upvote),
                        icon5Text: largeNumberFormatter(postState.post.post.downvote),
                        icon1OnPress: () => router.pop(ogContext),
                        icon2OnPress: () => commentSheetController.isFocused()
                            ? verifiedUserOnly(ogContext, () => commentSheetController.unfocus())
                            : verifiedUserOnly(ogContext, () => commentSheetController.focus()),
                        icon3OnPress: () => buildOptionsSheet(ogContext, postState.post),
                        icon4OnPress: () async => upvote(postState.post),
                        icon5OnPress: () async => verifiedUserOnly(
                            ogContext,
                            () async => await Provider.of<GlobalContentService>(ogContext, listen: false)
                                .voteOnPost(postState.post, postState.post.userVote != -1 ? -1 : 0)
                                .then((value) => value.fold(
                                    (err) => ogContext.read<NotificationsCubit>().showErr(err), (_) => null))),
                        icon4Selected:
                            Provider.of<GlobalContentService>(ogContext).posts[postState.post.post.id]!.userVote == 1,
                        icon5Selected:
                            Provider.of<GlobalContentService>(ogContext).posts[postState.post.post.id]!.userVote == -1,
                      ),
                    ),
                    child: FeedList(
                      topPushdownOffsetAboveHeader: appbarHeight + MediaQuery.of(context).padding.top,
                      centeredEmptyIndicator: false,
                      onScrollChange: (start) => WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isScrolling = start;
                        });
                      }),
                      header: buildHeader(ogContext, commentState, postState),
                      shrinkWrap: true,
                      controller: feedListController
                        ..items = generateComments(ogContext, commentState, feedListController, postState.post),
                      loadMore: (_) async => await ogContext.read<CommentSectionCubit>().loadComments(
                          postState.post.post.id.mid, CommentSortType.recent,
                          refresh: feedListController.items.isEmpty),
                      hasError: commentState.paginationState == CommentFeedState.error,
                      onErrorButtonPressed: () async => await ogContext
                          .read<CommentSectionCubit>()
                          .loadComments(postState.post.post.id.mid, CommentSortType.recent),
                      onPullToRefresh: () async {
                        Provider.of<GlobalContentService>(ogContext, listen: false).clearComments();
                        ogContext.read<CreateCommentCubit>().clear();
                        ogContext.read<CommentSectionCubit>().clear();
                        ogContext.read<IndividualPostCubit>().setLoading();
                        await delegateInitialLoad(ogContext, refresh: true);
                      },
                      onWontLoadMoreButtonPressed: () async => await ogContext.read<CommentSectionCubit>().loadComments(
                          postState.post.post.id.mid, CommentSortType.recent,
                          refresh: commentState.commentIds.isEmpty),
                      wontLoadMore: commentState.paginationState == CommentFeedState.end,
                      wontLoadMoreMessage: "You've reached the end",
                    ),
                  ),
                );
              } else {
                return LoadingOrAlert(
                    message: StateMessage(
                        commentState is CommentSectionError ? commentState.message : "Unknown error",
                        () => ogContext
                            .read<CommentSectionCubit>()
                            .loadComments(postState.post.post.id.mid, CommentSortType.recent)),
                    isLoading: false);
              }
            },
          );
        },
        key: const ValueKey("comments_home"),
      );
    } else {
      return LoadingOrAlert(
        key: const ValueKey("comments_home_loading"),
        message: StateMessage(postState is IndividualPostError ? postState.message : "Unknown error",
            () => delegateInitialLoad(ogContext)),
        isLoading: postState is IndividualPostLoading,
      );
    }
  }

  @override
  Widget build(BuildContext ogContext) {
    return OneThemeStatusBar(
      brightness: Brightness.dark,
      child: KeyboardDismiss(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(ogContext).colorScheme.background,
          body: Builder(builder: (context) {
            return BlocConsumer<IndividualPostCubit, IndividualPostState>(
              listenWhen: (previous, current) => previous is IndividualPostLoading && current is IndividualPostData,
              listener: (context, state) {
                if (state is IndividualPostData) {
                  ogContext
                      .read<CommentSectionCubit>()
                      .loadComments(state.post.post.id.mid, CommentSortType.recent, refresh: true);
                }
              },
              builder: (context, postState) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: buildBody(ogContext, context, postState),
              ),
            );
          }),
        ),
      ),
    );
  }
}
