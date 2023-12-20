import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/models/award_total.dart';
import 'package:confesi/models/award_type.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/services/api_client/api.dart';

part 'awards_state.dart';

class AwardsCubit extends Cubit<AwardsState> {
  AwardsCubit(this._api) : super(AwardsLoading());

  final Api _api;

  void clear() => emit(AwardsLoading());

  Future<void> load() async {
    _api.cancelCurrReq();
    emit(AwardsLoading());
    (await _api.req(Verb.get, true, "/api/v1/user/awards", {})).fold(
      (failureWithMsg) => emit(AwardsError(message: failureWithMsg.msg())),
      (response) {
        if (response.statusCode.toString().startsWith('2')) {
          try {
            final data = json.decode(response.body) as Map<String, dynamic>;
            final hasList = data['value']['has'] as List? ?? [];
            final missingList = data['value']['missing'] as List? ?? [];

            final has = hasList.map((e) => AwardTotal.fromJson(e as Map<String, dynamic>)).toList();
            final missing = missingList.map((e) => AwardType.fromJson(e as Map<String, dynamic>)).toList();
            emit(AwardsData(has: has, missing: missing));
          } catch (_) {
            emit(AwardsError(message: "Server error"));
          }
        } else {
          emit(AwardsError(message: "Server error"));
        }
      },
    );
  }
}
