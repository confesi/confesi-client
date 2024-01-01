import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/posts/cubit/individual_post_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/core/utils/verified_students/verified_user_only.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/presentation/comments/widgets/comment_tile.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/feed/widgets/post_tile.dart';
import 'package:confesi/presentation/feed/widgets/sticky_appbar.dart';
import 'package:confesi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';

import '../../../application/comments/cubit/create_comment_cubit.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../models/post.dart';
import '../../shared/buttons/circle_icon_btn.dart';
import '../widgets/comment_sheet.dart';

const double stickyHeaderHeight = 146;

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.props});

  final HomePostsCommentsProps props;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Future<void> delegateInitialLoad(BuildContext context, {bool refresh = false}) async {
    if (!mounted) return;
    if (widget.props.postLoadType is PreloadedPost && !refresh) {
      // preloaded
      context.read<IndividualPostCubit>().setPost((widget.props.postLoadType as PreloadedPost).post);
    } else if (widget.props.postLoadType is NeedToLoadPost) {
      // not preloaded
      await context.read<IndividualPostCubit>().loadPost((widget.props.postLoadType as NeedToLoadPost).maskedPostId);
    } else if (widget.props.postLoadType is PreloadedPost && refresh) {
      await context
          .read<IndividualPostCubit>()
          .loadPost((widget.props.postLoadType as PreloadedPost).post.post.id.mid)
          .then((value) {
        // load comments
        context.read<CommentSectionCubit>().loadComments(
            (widget.props.postLoadType as PreloadedPost).post.post.id.mid, currentSortType,
            refresh: true);
      });
    } else {
      context.read<NotificationsCubit>().showErr("Error loading content");
    }
  }

  Widget buildPost(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<IndividualPostCubit, IndividualPostState>(
          builder: (context, state) {
            if (state is IndividualPostData) {
              return PostTile(post: state.post, detailView: true);
            } else {
              return LoadingOrAlert(
                  message: StateMessage(
                    state is IndividualPostError ? state.message : "Unknown error",
                    () => delegateInitialLoad(context, refresh: false),
                  ),
                  isLoading: state is IndividualPostLoading);
            }
          },
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
                width: borderSize,
              ),
            ),
          ),
          child: SimpleCommentSort(
            commentSortType: currentSortType,
            onSwitch: (newSort) {
              Haptics.f(H.regular);
              context.read<CommentSectionCubit>().clear();
              setState(() => currentSortType = newSort);
              context.read<CommentSectionCubit>().loadComments(
                  (context.read<IndividualPostCubit>().state as IndividualPostData).post.post.id.mid, newSort,
                  refresh: true);
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CreateCommentCubit>().clear();
    context.read<CommentSectionCubit>().clear();
    currentSortType =
        Provider.of<UserAuthService>(context, listen: false).data().defaultCommentSort.convertToCommentSortType;
    delegateInitialLoad(context);
  }

  @override
  void dispose() {
    super.dispose();
    feedController.dispose();
    commentSheetController.dispose();
  }

  FeedListController feedController = FeedListController();
  CommentSheetController commentSheetController = CommentSheetController();

  late CommentSortType currentSortType;

  List<InfiniteScrollIndexable> genComments(
      BuildContext context, CommentSectionState state, FeedListController controller, PostWithMetadata post) {
    // return [];
    if (state is! CommentSectionData) return [];

    final List<InfiniteScrollIndexable> commentWidgets = [];
    final commentSet = Provider.of<GlobalContentService>(context, listen: false).comments;

    for (var commentIds in state.commentIds) {
      final rootCommentId = commentIds.keys.first;
      final rootCommentIdsList = commentIds[rootCommentId]!;

      final rootCommentIdEncrypted = EncryptedId(uid: rootCommentId, mid: '');
      final rootComment = commentSet[rootCommentIdEncrypted];

      if (rootComment == null) continue;

      int totalChildren = rootComment.comment.childrenCount;
      int commentIndex = commentWidgets.length;
      context.read<CommentSectionCubit>().updateCommentIdToIndex(rootComment.comment.id, commentIndex);

      commentWidgets.add(
        InfiniteScrollIndexable(
          rootCommentId,
          CommentTile(
            postCreatedAtTime: post.post.createdAt,
            commentSheetController: commentSheetController,
            feedController: controller,
            commentType: RootComment(rootComment, rootCommentIdsList.length),
          ),
        ),
      );

      int iter = 1;
      for (final commentId in rootCommentIdsList) {
        final replyComment = commentSet[commentId];
        if (replyComment != null) {
          totalChildren += replyComment.comment.childrenCount;
          context.read<CommentSectionCubit>().updateCommentIdToIndex(replyComment.comment.id, commentIndex);

          commentWidgets.add(
            InfiniteScrollIndexable(
              commentId.uid,
              CommentTile(
                postCreatedAtTime: post.post.createdAt,
                commentSheetController: commentSheetController,
                feedController: controller,
                commentType: ReplyComment(replyComment, iter, rootCommentIdsList.length),
              ),
            ),
          );
          commentIndex++;
          iter++;
        }
      }

      sl.get<GlobalContentService>().setRepliesPerSchool(rootCommentIdEncrypted, totalChildren);
    }

    return commentWidgets;
  }

  PostWithMetadata? post;

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      post = context.watch<IndividualPostCubit>().state is IndividualPostData
          ? (context.watch<IndividualPostCubit>().state as IndividualPostData).post
          : null;
    }
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: FooterLayout(
          footer: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
              ),
            ),
            padding: post != null ? const EdgeInsets.all(10) : null,
            child: SafeArea(
              top: false,
              child: post != null
                  ? CommentSheet(
                      controller: commentSheetController,
                      onSubmit: (value) async {
                        print(value);
                      },
                      maxCharacters: maxCommentLength,
                      feedController: feedController,
                      postCreatedAtTime: post!.post.createdAt,
                    )
                  : const SizedBox(),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: BlocConsumer<IndividualPostCubit, IndividualPostState>(
                  listener: (contextL, state) {
                    if (state is IndividualPostData) {
                      contextL.read<CommentSectionCubit>().loadComments(state.post.post.id.mid, currentSortType);
                    }
                  },
                  builder: (context1, state) {
                    if (state is IndividualPostData) {
                      return BlocConsumer<CommentSectionCubit, CommentSectionState>(
                        listener: (context2, state2) {
                          if (state2 is CommentSectionError) {
                            context2.read<CommentSectionCubit>().clear();
                          }
                        },
                        builder: (context2, state2) {
                          if (state2 is CommentSectionData) {
                            return FeedList(
                              swipeRefreshLockedToEnable: true,
                              // topPushdownOffset: MediaQuery.of(context2).padding.top + 67.5 + 15,
                              topPushdownOffsetAboveHeader: stickyHeaderHeight,
                              nothingFoundMessage: "No comments found",
                              header: buildPost(context2),
                              controller: feedController
                                ..items = genComments(context1, state2, feedController, state.post),
                              loadMore: (_) async {
                                // ensure I won't need to look up deactivated widget's ancestor
                                if (mounted) {
                                  await context.read<CommentSectionCubit>().loadComments(
                                      state.post.post.id.mid, currentSortType,
                                      refresh: feedController.items.isEmpty);
                                }
                              },
                              onPullToRefresh: () async {
                                Provider.of<GlobalContentService>(context2, listen: false).clearComments();
                                context2.read<CreateCommentCubit>().clear();
                                context2.read<CommentSectionCubit>().clear();
                                context2.read<IndividualPostCubit>().setLoading();
                                await delegateInitialLoad(context1, refresh: true);
                              },
                              hasError: state2.paginationState == CommentFeedState.error,
                              wontLoadMore: state2.paginationState == CommentFeedState.end,
                              onWontLoadMoreButtonPressed: () async => await context1
                                  .read<CommentSectionCubit>()
                                  .loadComments(state.post.post.id.mid, currentSortType, refresh: false),
                              onErrorButtonPressed: () async => await context1
                                  .read<CommentSectionCubit>()
                                  .loadComments(state.post.post.id.mid, currentSortType),
                              wontLoadMoreMessage: "You've reached the end",

                              stickyHeader: StickyAppbarProps(
                                height: stickyHeaderHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context).colorScheme.onBackground,
                                        width: borderSize,
                                      ),
                                    ),
                                  ),
                                  width: widthFraction(context, 1),
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleIconBtn(
                                            color: Theme.of(context).colorScheme.primary,
                                            bgColor: Theme.of(context).colorScheme.surface,
                                            icon: CupertinoIcons.arrow_left,
                                            onTap: () {
                                              Haptics.f(H.regular);
                                              router.pop(context);
                                            }),
                                        const Spacer(),
                                        WidgetOrNothing(
                                          showWidget: state.post.post.chatPost && !state.post.owner,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 15),
                                              CircleIconBtn(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                bgColor: Theme.of(context).colorScheme.surface,
                                                icon: CupertinoIcons.chat_bubble_2,
                                                onTap: () {
                                                  Haptics.f(H.regular);
                                                  verifiedUserOnly(
                                                    context,
                                                    () async => (await Provider.of<RoomsService>(context, listen: false)
                                                            .createNewRoom(state.post.post.id.mid))
                                                        .fold(
                                                      (_) => router.push("/home/rooms"),
                                                      (errMsg) => context.read<NotificationsCubit>().showErr(errMsg),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        CircleIconBtn(
                                          color: Theme.of(context).colorScheme.primary,
                                          bgColor: Theme.of(context).colorScheme.surface,
                                          icon: CupertinoIcons.arrow_up_to_line_alt,
                                          onTap: () {
                                            feedController.scrollToTop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return LoadingOrAlert(
                              message: StateMessage(
                                state2 is CommentSectionError ? state2.message : "Unknown error",
                                () => delegateInitialLoad(context1, refresh: false),
                              ),
                              isLoading: false, // never loading, always either "data" or "error"
                            );
                          }
                        },
                      );
                    }
                    {
                      return LoadingOrAlert(
                        message: StateMessage(
                          state is IndividualPostError ? state.message : "Unknown error",
                          () => delegateInitialLoad(context1, refresh: false),
                        ),
                        isLoading: state is IndividualPostLoading,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
