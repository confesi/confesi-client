import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/shared/entities/post.dart';
import '../../../domain/feed/usecases/recents.dart';

part 'recents_state.dart';

// enum LoadMoreType {
//   pullToRefresh,
//   scrollAtBottom,
// }

class RecentsCubit extends Cubit<RecentsState> {
  final Recents recents;

  RecentsCubit({
    required this.recents,
  }) : super(InitialState());

  void startLoading() {
    emit(LoadingAll());
  }

  Future<void> fetchPosts(String lastSeenPostId, String token) async {
    if (state is ErrorLoadingAny) {
      emit(InitialState());
    } else if (state is HasPosts) {
      final hasPosts = state as HasPosts;
      emit(HasPosts(
          posts: hasPosts.posts, feedState: FeedDisplayState.loadingMore));
    }
    final failureOrPosts = await recents(
        RecentsParams(lastSeenPostId: lastSeenPostId, token: token));
    failureOrPosts.fold(
      (failure) => print("Failure... $failure"),
      (posts) {
        print("HEREEEE");
        if (state is HasPosts) {
          print("Success!");
          final hasPosts = state as HasPosts;
          emit(
            HasPosts(posts: [
              ...posts,
              ...hasPosts.posts,
            ], feedState: FeedDisplayState.stagnant),
          );
        } else {
          emit(
            HasPosts(posts: posts, feedState: FeedDisplayState.stagnant),
          );
        }
      },
    );
  }

  // TODO: How to make this work with pull-to-refresh?
  Future<void> refreshPosts(String token) async {}
}
