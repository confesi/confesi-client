import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/clients/api.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../init.dart';
import '../../../presentation/leaderboard/widgets/leaderboard_item_tile.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._api) : super(LeaderboardLoading());

  final Api _api;

  Future<void> loadRankings({bool forceRefresh = false}) async {
    late bool refreshFeed;
    _api.cancelCurrReq();
    LeaderboardFeedState feedState = LeaderboardFeedState.feedLoading;
    if (state is LeaderboardData) {
      refreshFeed = false;
      emit(LeaderboardData(
        (state as LeaderboardData).schools,
        userSchool: (state as LeaderboardData).userSchool,
        feedState,
        (state as LeaderboardData).startViewDate,
      ));
    } else if (state is LeaderboardError || state is LeaderboardLoading) {
      emit(LeaderboardLoading());
      refreshFeed = true;
    } else {
      emit(LeaderboardLoading());
      emit(LeaderboardError(message: "Unknown error"));
      return;
    }
    if (forceRefresh) refreshFeed = true;
    late DateTime oldStartViewDate;
    if (state is LeaderboardData) {
      oldStartViewDate = (state as LeaderboardData).startViewDate;
    } else {
      oldStartViewDate = DateTime.now().toUtc();
    }
    (await _api.req(
      Verb.get,
      true,
      "/api/v1/schools/rank",
      {
        "purge_cache": refreshFeed,
        "session_key": sl.get<UserAuthService>().baseSessionKey,
        "include_users_school": refreshFeed,
        "start_view_date": oldStartViewDate.yearMonthDay(),
      },
    ))
        .fold(
      (failureWithMsg) {
        if (failureWithMsg is ApiTooManyGlobalRequests) {
          if (state is LeaderboardData) {
            emit(LeaderboardData(
              (state as LeaderboardData).schools,
              userSchool: (state as LeaderboardData).userSchool,
              LeaderboardFeedState.errorLoadingMore,
              (state as LeaderboardData).startViewDate,
            ));
          } else {
            emit(LeaderboardError(message: failureWithMsg.msg()));
          }
        } else {
          emit(LeaderboardError(message: failureWithMsg.msg()));
        }
      },
      (response) async {
        try {
          if (response.statusCode == 410) {
            if (state is LeaderboardData) {
              emit(LeaderboardData(
                (state as LeaderboardData).schools,
                userSchool: (state as LeaderboardData).userSchool,
                LeaderboardFeedState.staleDate,
                (state as LeaderboardData).startViewDate,
              ));
            } else {
              emit(LeaderboardError(message: "New data has arrived, please refresh"));
            }
          } else if (response.statusCode.toString()[0] == "2") {
            final body = json.decode(response.body)["value"];
            final newSchools = (body["schools"] as List).map((i) => SchoolWithMetadata.fromJson(i)).toList();
            int placingOffset = 0;
            if (state is LeaderboardData && !refreshFeed) {
              placingOffset = (state as LeaderboardData).schools.length;
            }
            List<InfiniteScrollIndexable> newSchoolsParsed = newSchools
                .asMap()
                .map(
                  (index, e) => MapEntry(
                    index,
                    InfiniteScrollIndexable(
                      index,
                      LeaderboardItemTile(
                        school: e,
                        placing: index + placingOffset + 1,
                      ),
                    ),
                  ),
                )
                .values
                .toList();

            if (newSchoolsParsed.length < rankedSchoolsPageSize) {
              feedState = LeaderboardFeedState.noMore;
            }

            late SchoolWithMetadata userSchool;
            late List<InfiniteScrollIndexable> allSchools;
            late DateTime newStartViewData;
            if (refreshFeed) {
              newStartViewData = DateTime.now().toUtc();
              allSchools = newSchoolsParsed;
              userSchool = SchoolWithMetadata.fromJson(body["user_school"]);
            } else if (state is LeaderboardData) {
              newStartViewData = (state as LeaderboardData).startViewDate;
              // add new schools to end, not start
              allSchools = (state as LeaderboardData).schools + newSchoolsParsed;
              userSchool = (state as LeaderboardData).userSchool;
            } else {
              newStartViewData = DateTime.now().toUtc();
              allSchools = newSchoolsParsed;
              userSchool = SchoolWithMetadata.fromJson(body["user_school"]);
            }
            emit(LeaderboardData(allSchools, feedState, userSchool: userSchool, newStartViewData));
          } else {
            if (state is LeaderboardData) {
              emit(LeaderboardData(
                (state as LeaderboardData).schools,
                LeaderboardFeedState.errorLoadingMore,
                (state as LeaderboardData).startViewDate,
                userSchool: (state as LeaderboardData).userSchool,
              ));
            } else {
              emit(LeaderboardError(message: "Unknown error"));
            }
          }
        } catch (_) {
          if (state is LeaderboardData) {
            emit(LeaderboardData(
              (state as LeaderboardData).schools,
              LeaderboardFeedState.errorLoadingMore,
              (state as LeaderboardData).startViewDate,
              userSchool: (state as LeaderboardData).userSchool,
            ));
          } else {
            emit(LeaderboardError(message: "Unknown error"));
          }
        }
      },
    );
  }
}
