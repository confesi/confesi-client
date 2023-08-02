import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/school.dart';
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
    (await Api().req(
      Verb.get,
      true,
      "/api/v1/schools/rank",
      {
        "purge_cache": refreshFeed,
        "session_key": sl.get<UserAuthService>().sessionKey,
        "include_users_school": refreshFeed,
        "start_view_date": oldStartViewDate.yearMonthDay(),
      },
      needsLatLong: true,
    ))
        .fold(
      (failureWithMsg) {
        print("GOT HEREEEEEEE + ${failureWithMsg.runtimeType}");
        if (failureWithMsg is ApiTooManyGlobalRequests) {
          print("GLOBAL IP ABUSE");

          if (state is LeaderboardData) {
            print("HEREEE");
            emit(LeaderboardData(
              (state as LeaderboardData).schools,
              userSchool: (state as LeaderboardData).userSchool,
              LeaderboardFeedState.errorLoadingMore,
              (state as LeaderboardData).startViewDate,
            ));
          } else {
            emit(LeaderboardError(message: failureWithMsg.message()));
          }
        } else {
          emit(LeaderboardError(message: failureWithMsg.message()));
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
            late DateTime newStartViewData;
            if (refreshFeed) {
              newStartViewData = DateTime.now().toUtc();
              allSchools = newSchoolsParsed;
              userSchool = School.fromJson(body["user_school"]);
            } else if (state is LeaderboardData) {
              newStartViewData = (state as LeaderboardData).startViewDate;
              // add new schools to end, not start
              allSchools = (state as LeaderboardData).schools + newSchoolsParsed;
              userSchool = (state as LeaderboardData).userSchool;
            } else {
              newStartViewData = DateTime.now().toUtc();
              allSchools = newSchoolsParsed;
              userSchool = School.fromJson(body["user_school"]);
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
