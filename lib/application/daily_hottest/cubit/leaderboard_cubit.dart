import '../../../presentation/daily_hottest/utils/failure_to_message.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/usecases/no_params.dart';
import '../../../domain/daily_hottest/entities/leaderboard_item.dart';
import '../../../domain/daily_hottest/usecases/ranking.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final Ranking ranking;

  LeaderboardCubit({required this.ranking}) : super(Loading());

  Future<void> loadRankings() async {
    if (state is Error) {
      final error = state as Error;
      emit(Error(message: error.message, retryingAfterError: true));
    } else {
      emit(Loading());
    }
    final failureOrRankings = await ranking(NoParams());
    failureOrRankings.fold(
      (failure) {
        if (isClosed) return;
        emit(Error(message: failureToMessage(failure)));
      },
      (rankings) {
        if (isClosed) return;
        emit(Data(rankings: rankings));
      },
    );
  }
}
