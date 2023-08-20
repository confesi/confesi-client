import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/services/api_client/api.dart';
import '../../../init.dart';
import '../../../models/post.dart';

part 'hottest_state.dart';

class HottestCubit extends Cubit<HottestState> {
  HottestCubit(this._api) : super(DailyHottestLoading());

  final Api _api;

  Future<void> loadMostRecent() async => await _loadFromDate(null);

  void clear() {
    _api.cancelCurrReq();
    sl.get<GlobalContentService>().setPosts([]);
    emit(DailyHottestLoading());
  }

  Future<void> loadPastDate(DateTime date) async => await _loadFromDate(date);

  Future<void> _loadFromDate(DateTime? date) async {
    _api.cancelCurrReq();
    emit(DailyHottestLoading());
    String queryParam = date == null ? "" : "?day=${date.yearMonthDay()}";
    (await _api.req(Verb.get, true, "/api/v1/posts/hottest$queryParam", {})).fold(
      (failure) => emit(DailyHottestError(message: failure.msg())),
      (response) {
        try {
          if (response.statusCode.toString()[0] == "2") {
            final body = json.decode(response.body)["value"];
            final posts = (body["posts"] as List).map((e) => PostWithMetadata.fromJson(e)).toList();
            final resDate = DateTime.parse(body["date"]);
            sl.get<GlobalContentService>().setPosts(posts);
            emit(DailyHottestData(posts: posts, date: resDate));
          } else {
            emit(DailyHottestError(message: "Unknown error"));
          }
        } catch (_) {
          emit(DailyHottestError(message: "Unknown error"));
        }
      },
    );
  }
}
