import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/services/api_client/api.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../init.dart';
import '../../../models/encrypted_id.dart';
import '../../../presentation/leaderboard/widgets/leaderboard_item_tile.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._api) : super(LeaderboardLoading());

  final Api _api;

  Future<void> loadRankings({bool forceRefresh = false}) async {
    _api.cancelCurrReq();

    if (forceRefresh) {
      emit(LeaderboardLoading());
    }

    LeaderboardFeedState feedState = LeaderboardFeedState.feedLoading;
    DateTime oldStartViewDate;

    if (state is LeaderboardData) {
      oldStartViewDate = (state as LeaderboardData).startViewDate;
    } else {
      oldStartViewDate = DateTime.now().toUtc();
    }

    final response = await _api.req(
      Verb.get,
      true,
      "/api/v1/schools/rank",
      {
        "purge_cache": forceRefresh,
        "session_key": sl.get<UserAuthService>().baseSessionKey,
        "include_users_school": forceRefresh,
        "start_view_date": oldStartViewDate.yearMonthDay(),
      },
    );

    response.fold(
      (failureWithMsg) {
        if (failureWithMsg is ApiTooManyGlobalRequests) {
          emit(LeaderboardError(message: failureWithMsg.msg()));
        } else {
          emit(LeaderboardError(message: failureWithMsg.msg()));
        }
        return;
      },
      (response) async {
        try {
          if (response.statusCode == 410) {
            emit(LeaderboardError(message: "Leaderboard has new data, please refresh"));
            return;
          } else if (response.statusCode.toString()[0] == "2") {
            final body = json.decode(response.body)["value"];
            final newSchools = (body["schools"] as List).map((i) => SchoolWithMetadata.fromJson(i)).toList();
            sl.get<GlobalContentService>().setSchools(newSchools);
            if (newSchools.length < rankedSchoolsPageSize) {
              feedState = LeaderboardFeedState.noMore;
            }
            if (forceRefresh) {
              final userSchool = SchoolWithMetadata.fromJson(body["user_school"]);
              sl.get<GlobalContentService>().setSchool(userSchool);
              emit(LeaderboardData(
                newSchools.map((e) => e.school.id).toList(),
                feedState,
                oldStartViewDate,
                userSchoolId: userSchool.school.id,
              ));
              return;
            } else {
              if (state is LeaderboardData) {
                emit(LeaderboardData(
                  (state as LeaderboardData).schoolIds + newSchools.map((e) => e.school.id).toList(),
                  feedState,
                  oldStartViewDate,
                  userSchoolId: (state as LeaderboardData).userSchoolId,
                ));
                return;
              } else {
                emit(LeaderboardError(message: "Unknown error 1"));
                return;
              }
            }
          } else {
            emit(LeaderboardError(message: "Unknown error 2"));
          }
        } catch (_) {
          emit(LeaderboardError(message: "Unknown error 3"));
        }
      },
    );
  }
}
