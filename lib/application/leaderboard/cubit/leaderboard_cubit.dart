import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/school.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../constants/shared/dev.dart';
import '../../../core/clients/api.dart';
import '../../../domain/leaderboard/usecases/ranking.dart';
import '../../../domain/shared/entities/infinite_scroll_indexable.dart';
import '../../../init.dart';
import '../../../presentation/leaderboard/widgets/leaderboard_item_tile.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final Ranking ranking;

  LeaderboardCubit({required this.ranking}) : super(LeaderboardLoading());

  Future<void> loadRankings({bool forceRefresh = false}) async {
    late bool refreshFeed;
    LeaderboardFeedState feedState = LeaderboardFeedState.feedLoading;
    if (state is LeaderboardData) {
      refreshFeed = false;
      emit(LeaderboardData(
        (state as LeaderboardData).schools,
        userSchool: (state as LeaderboardData).userSchool,
        feedState,
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
    (await Api().req(
      Verb.get,
      true,
      "/api/v1/schools/rank",
      {
        "purge_cache": refreshFeed,
        "session_key": sl.get<UserAuthService>().sessionKey,
        "include_users_school": refreshFeed,
        "start_view_date": DateTime.now().toUtc().yearMonthDay()
      },
    ))
        .fold(
      (failureWithMsg) => emit(LeaderboardError(message: "Unknown error")),
      (response) async {
        try {
          if (response.statusCode == 410) {
            if (state is LeaderboardData) {
              emit(LeaderboardData(
                (state as LeaderboardData).schools,
                userSchool: (state as LeaderboardData).userSchool,
                LeaderboardFeedState.staleDate,
              ));
            } else {
              emit(LeaderboardError(message: "Stale date, please refresh"));
            }
          } else if (response.statusCode.toString()[0] == "2") {
            final body = json.decode(response.body)["value"];
            final newSchools = (body["schools"] as List).map((i) => School.fromJson(i)).toList();
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
                      index.toString(),
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

            late School userSchool;
            late List<InfiniteScrollIndexable> allSchools;
            if (refreshFeed) {
              allSchools = newSchoolsParsed;
              userSchool = School.fromJson(body["user_school"]);
            } else if (state is LeaderboardData) {
              // add new schools to end, not start
              allSchools = (state as LeaderboardData).schools + newSchoolsParsed;
              userSchool = (state as LeaderboardData).userSchool;
            } else {
              allSchools = newSchoolsParsed;
              userSchool = School.fromJson(body["user_school"]);
            }
            emit(LeaderboardData(allSchools, feedState, userSchool: userSchool));
          } else {
            if (state is LeaderboardData) {
              emit(LeaderboardData(
                (state as LeaderboardData).schools,
                LeaderboardFeedState.errorLoadingMore,
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
