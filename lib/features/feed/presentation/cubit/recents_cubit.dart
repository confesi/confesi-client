import 'package:Confessi/features/feed/domain/usecases/recents.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recents_state.dart';

class RecentsCubit extends Cubit<RecentsState> {
  final Recents recents;

  RecentsCubit({
    required this.recents,
  }) : super(RecentsLoading());

  Future<void> fetchPosts(String lastSeenPostId, String token) async {
    final failureOrPosts =
        await recents(RecentsParams(lastSeenPostId: lastSeenPostId, token: token));
    failureOrPosts.fold(
      (failure) => print("failure"),
      (posts) => print("posts!"),
    );
  }
}
