import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/constants/feed/constants.dart';
import '../../../domain/shared/entities/post.dart';
import '../../../domain/feed/usecases/trending.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  final Trending trending;
  TrendingCubit({required this.trending}) : super(LoadingAll());

  Future<void> fetchPosts() async {
    if (state is HasPosts) {
      final hasPosts = state as HasPosts;
      emit(HasPosts(posts: hasPosts.posts, feedState: FeedState.loadingMore));
    }
    final failureOrPosts = await trending(NoParams());
    if (state is ErrorLoadingAny) {
      failureOrPosts.fold(
        (failure) {
          emit(ErrorLoadingAny());
        },
        (posts) {
          if (posts.length < kPostsReturnedPerLoad) {
            emit(HasPosts(posts: posts, feedState: FeedState.reachedEnd));
          } else {
            emit(HasPosts(posts: posts, feedState: FeedState.loadingMore));
          }
        },
      );
    } else if (state is LoadingAll) {
      failureOrPosts.fold(
        (failure) {
          emit(ErrorLoadingAny());
        },
        (posts) {
          if (posts.length < kPostsReturnedPerLoad) {
            emit(HasPosts(posts: posts, feedState: FeedState.reachedEnd));
          } else {
            emit(HasPosts(posts: posts, feedState: FeedState.loadingMore));
          }
        },
      );
    } else if (state is HasPosts) {
      final hasPosts = state as HasPosts;
      failureOrPosts.fold(
        (failure) {
          emit(HasPosts(
              posts: hasPosts.posts, feedState: FeedState.errorLoadingMore));
        },
        (posts) {
          if (posts.length < kPostsReturnedPerLoad) {
            emit(HasPosts(
                posts: [...hasPosts.posts, ...posts],
                feedState: FeedState.reachedEnd));
          } else {
            emit(HasPosts(
                posts: [...hasPosts.posts, ...posts],
                feedState: FeedState.loadingMore));
          }
        },
      );
    }
  }

  /// Getting a whole new batch of posts.
  Future<void> refreshPosts() async {
    final failureOrPosts = await trending(NoParams());
    final hasPosts = state as HasPosts;
    failureOrPosts.fold(
      (failure) {
        emit(HasPosts(
            posts: hasPosts.posts, feedState: FeedState.errorRefreshing));
      },
      (posts) {
        if (posts.length < kPostsReturnedPerLoad) {
          emit(HasPosts(posts: posts, feedState: FeedState.reachedEnd));
        } else {
          emit(HasPosts(posts: posts, feedState: FeedState.loadingMore));
        }
      },
    );
  }
}
