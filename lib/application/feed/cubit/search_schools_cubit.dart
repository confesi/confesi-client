import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';

part 'search_schools_state.dart';

class SearchSchoolsCubit extends Cubit<SearchSchoolsState> {
  SearchSchoolsCubit() : super(SearchSchoolsLoading());

  Future<void> loadNearby() async {
    emit(SearchSchoolsLoading());
    (await Api().req(
      Verb.get,
      true,
      "/api/v1/schools?offset=1&limit=10",
      {},
      needsLatLong: true,
    ))
        .fold(
      (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.message())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(const SearchSchoolsError("TODO: 4XX"));
        } else {
          try {
            emit(SearchSchoolsData(
              (json.decode(response.body)["value"]["schools"] as List)
                  .map((e) => SchoolWithMetadata.fromJson(e))
                  .toList(),
            ));
          } catch (_) {
            emit(const SearchSchoolsError("Unknown error"));
          }
        }
      },
    );
  }

  Future<void> search(String query) async {
    emit(SearchSchoolsLoading());
    (await Api().req(
      Verb.get,
      true,
      "/api/v1/schools/search?query=$query",
      {},
      needsLatLong: true,
    ))
        .fold(
      (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.message())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(const SearchSchoolsError("TODO: 4XX"));
        } else {
          try {
            emit(SearchSchoolsData(
              (json.decode(response.body)["value"] as List).map((e) => SchoolWithMetadata.fromJson(e)).toList(),
            ));
          } catch (_) {
            emit(const SearchSchoolsError("Unknown error"));
          }
        }
      },
    );
  }

  Future<void> watchSchool(int id) async {}

  Future<void> stopWatchingSchool(int id) async {}

  Future<void> setSchoolAsHome(int id) async {}
}
