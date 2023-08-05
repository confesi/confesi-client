// comment_sheet_view.dart

import 'package:confesi/application/comments/cubit/comment_section_cubit.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/screens/post_detail_view.dart';
import 'package:confesi/presentation/comments/widgets/simple_comment_sort.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/feed/enums.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../models/comment.dart';
import '../../feed/widgets/simple_comment_root_group.dart';
import '../../feed/widgets/simple_comment_tile.dart';
import '../../shared/other/feed_list.dart';
import 'comment_tile.dart';

class CommentSheetView extends StatefulWidget {
  const CommentSheetView({super.key, required this.post});

  final Post post;

  @override
  State<CommentSheetView> createState() => _CommentSheetViewState();
}

class _CommentSheetViewState extends State<CommentSheetView> {
  FeedListController feedController = FeedListController();

  @override
  void initState() {
    context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentSectionCubit, CommentSectionState>(
      builder: (context, state) {
        return Column(
          children: [
            SimpleCommentSort(onSwitch: (newSort) => print(newSort)),
            buildBody(context, state),
          ],
        );
      },
    );
  }

  Widget buildBody(BuildContext context, CommentSectionState state) {
    if (state is CommentSectionData) {
      return FeedList(
        isScrollable: false,
        shrinkWrap: true,
        controller: feedController
          ..items = state.commentIds.entries
              .map((entry) {
                final commentId = entry.key;
                final commentIds = entry.value;
                final comment = context.watch<GlobalContentService>().comments[commentId];
                return comment != null
                    ? InfiniteScrollIndexable(
                        commentId,
                        SimpleCommentRootGroup(
                          root: SimpleCommentTile(
                            isRootComment: true,
                            content: comment.comment.content, // Check for null before accessing content
                          ),
                          subTree: buildReplies(commentIds),
                        ),
                      )
                    : null;
              })
              .whereType<InfiniteScrollIndexable>()
              .toList(),
        loadMore: (_) => context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent),
        onPullToRefresh: () => context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent),
        hasError: state.paginationState == PaginationState.error,
        wontLoadMore: state.paginationState == PaginationState.end,
        onWontLoadMoreButtonPressed: () =>
            context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent),
        onErrorButtonPressed: () =>
            context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent),
        wontLoadMoreMessage:
            state.paginationState == PaginationState.end ? "You've reached the end of the list" : "Error loading",
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(
          state is CommentSectionError ? state.message : null,
          () => context.read<CommentSectionCubit>().loadInitial(widget.post.id, CommentSortType.recent),
        ),
        isLoading: state is CommentSectionLoading,
      );
    }
  }

  List<SimpleCommentRootGroup> buildReplies(Set<int>? commentReplies) {
    if (commentReplies == null) {
      return [];
    }

    final commentWidgets = <SimpleCommentRootGroup>[];

    for (int commentId in commentReplies) {
      final comment = context.watch<GlobalContentService>().comments[commentId];
      if (comment != null) {
        commentWidgets.add(
          SimpleCommentRootGroup(
            root: SimpleCommentTile(
              isRootComment: false,
              // isGettingRepliedTo: true,
              content: comment.comment.content,
            ),
            subTree: const [],
          ),
        );
      }
    }

    return commentWidgets;
  }
}
