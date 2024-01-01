import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
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
              emit(StatsError(ApiErrors.err(response)));
            }
          } else if (response.statusCode.toString()[0] == "2") {
            emit(StatsData(Stats.fromJson(json.decode(response.body)["value"])));
          } else {
            emit(StatsError(ApiErrors.err(response)));
          }
        } catch (_) {
          emit(StatsError(ApiErrors.err(response)));
        }
      },
    );
  }
}
