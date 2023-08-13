import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';
import '../../../models/stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit() : super(StatsLoading());

  Future<void> loadStats() async {
    emit(StatsLoading());
    (await Api().req(Verb.get, true, "/api/v1/user/user-stats", {})).fold(
      (failureWithMessage) => emit(StatsError(failureWithMessage.msg())),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(const StatsError("TODO: 4XX"));
          } else if (response.statusCode.toString()[0] == "2") {
            emit(StatsData(Stats.fromJson(json.decode(response.body)["value"])));
          } else {
            emit(const StatsError("Unknown error"));
          }
        } catch (_) {
          emit(const StatsError("Unknown error"));
        }
      },
    );
  }
}
