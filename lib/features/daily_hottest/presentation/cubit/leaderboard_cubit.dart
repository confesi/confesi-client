import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/features/daily_hottest/presentation/utils/failure_to_message.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/leaderboard_item.dart';
import '../../domain/usecases/ranking.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final Ranking ranking;

  LeaderboardCubit({required this.ranking}) : super(Loading());

  Future<void> loadRankings() async {
    if (state is Error) {
      // print('heree');
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
