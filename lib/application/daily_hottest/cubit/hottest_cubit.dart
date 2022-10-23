import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/usecases/no_params.dart';
import '../../../domain/daily_hottest/usecases/posts.dart';
import '../../../presentation/daily_hottest/utils/failure_to_message.dart';

part 'hottest_state.dart';

class HottestCubit extends Cubit<HottestState> {
  final Posts posts;

  HottestCubit({required this.posts}) : super(Loading());

  Future<void> loadPosts() async {
    if (state is Error) {
      final error = state as Error;
      emit(Error(message: error.message, retryingAfterError: true));
    } else {
      emit(Loading());
    }
    final failureOrRankings = await posts(NoParams());
    if (isClosed) return;
    failureOrRankings.fold(
      (failure) {
        emit(Error(message: failureToMessage(failure)));
      },
      (posts) {
        emit(Data(posts: posts));
      },
    );
  }
}
