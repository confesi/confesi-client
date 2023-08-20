import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';
import '../../../models/stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._api) : super(StatsLoading());

  final Api _api;

  void clear() {
    _api.cancelCurrReq();
    emit(StatsLoading());
  }

  Future<void> loadStats() async {
    _api.cancelCurrReq();
    emit(StatsLoading());
    (await _api.req(Verb.get, true, "/api/v1/user/user-stats", {})).fold(
      (failureWithMessage) => emit(StatsError(failureWithMessage.msg())),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            if (response.statusCode == 401) {
              emit(StatsGuest());
            } else {
              emit(const StatsError("TODO: 4XX"));
            }
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
