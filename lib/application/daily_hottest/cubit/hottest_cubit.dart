import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/extensions/dates/year_month_day.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/clients/api.dart';
import '../../../init.dart';
import '../../../models/post.dart';

part 'hottest_state.dart';

class HottestCubit extends Cubit<HottestState> {
  HottestCubit() : super(DailyHottestLoading());

  Future<void> loadYesterday() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    _loadFromDate(yesterday);
  }

  Future<void> loadPastDate(DateTime date) async {
    _loadFromDate(date);
  }

  Future<void> _loadFromDate(DateTime date) async {
    emit(DailyHottestLoading());
    (await Api().req(Verb.get, true, "/api/v1/posts/hottest?day=${date.yearMonthDay()}", {})).fold(
      (failure) => emit(DailyHottestError(message: failure.msg(), date: date)),
      (response) {
        try {
          if (response.statusCode.toString()[0] == "2") {
            final posts = (json.decode(response.body)["value"] as List).map((e) => Post.fromJson(e)).toList();
            sl.get<GlobalContentService>().setPosts(posts);
            emit(DailyHottestData(posts: posts, date: date));
          } else {
            print("UNKNOWN ERROR 1");
            emit(DailyHottestError(message: "Unknown error", date: date));
          }
        } catch (e) {
          print("UNKNOWN ERROR 2 $e");
          emit(DailyHottestError(message: "Unknown error", date: date));
        }
      },
    );
  }
}
