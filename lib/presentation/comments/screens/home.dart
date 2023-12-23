import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/application/posts/cubit/individual_post_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/presentation/comments/widgets/comment_tile.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/feed/widgets/post_tile.dart';
import 'package:confesi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
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
import '../widgets/sheet.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.props});

  final HomePostsCommentsProps props;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Future<void> delegateInitialLoad(BuildContext context, {bool refresh = false}) async {
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
          padding: const EdgeInsets.symmetric(vertical: 15),
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

  @override
  Widget build(BuildContext context) {
    PostWithMetadata? post = context.watch<IndividualPostCubit>().state is IndividualPostData
        ? (context.watch<IndividualPostCubit>().state as IndividualPostData).post
        : null;
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
            padding: EdgeInsets.all(post != null ? 10 : 0),
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
                      postCreatedAtTime: 123, // todo: postState.post.post.createdAt,
                    )
                  : const SizedBox(),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: BlocConsumer<IndividualPostCubit, IndividualPostState>(
                  listener: (context, state) {
                    if (state is IndividualPostData) {
                      context.read<CommentSectionCubit>().loadComments(state.post.post.id.mid, currentSortType);
                    }
                  },
                  builder: (context, state) {
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
                              // topPushdownOffset: MediaQuery.of(context2).padding.top + 67.5 + 15,
                              topPushdownOffsetAboveHeader: MediaQuery.of(context2).padding.top + 67.5,
                              header: buildPost(context2),
                              controller: feedController
                                ..items = genComments(context, state2, feedController, state.post),
                              loadMore: (_) async => await context2.read<CommentSectionCubit>().loadComments(
                                  state.post.post.id.mid, currentSortType,
                                  refresh: feedController.items.isEmpty),
                              onPullToRefresh: () async {
                                Provider.of<GlobalContentService>(context2, listen: false).clearComments();
                                context2.read<CreateCommentCubit>().clear();
                                context2.read<CommentSectionCubit>().clear();
                                context2.read<IndividualPostCubit>().setLoading();
                                await delegateInitialLoad(context, refresh: true);
                              },
                              hasError: state2.paginationState == CommentFeedState.error,
                              wontLoadMore: state2.paginationState == CommentFeedState.end,
                              onWontLoadMoreButtonPressed: () async => await context2
                                  .read<CommentSectionCubit>()
                                  .loadComments(state.post.post.id.mid, currentSortType,
                                      refresh: feedController.items.isEmpty),
                              onErrorButtonPressed: () async => await context2
                                  .read<CommentSectionCubit>()
                                  .loadComments(state.post.post.id.mid, currentSortType),
                              wontLoadMoreMessage: "You've reached the end",
                            );
                          } else {
                            return LoadingOrAlert(
                              message: StateMessage(
                                state2 is CommentSectionError ? state2.message : "Unknown error",
                                () => delegateInitialLoad(context, refresh: false),
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
                          () => delegateInitialLoad(context, refresh: false),
                        ),
                        isLoading: state is IndividualPostLoading,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 15,
                left: 15,
                child: CircleIconBtn(
                    icon: CupertinoIcons.arrow_left,
                    onTap: () {
                      router.pop(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
