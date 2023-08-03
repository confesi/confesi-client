import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';

part 'search_schools_state.dart';

class SearchSchoolsCubit extends Cubit<SearchSchoolsState> {
  SearchSchoolsCubit(this._searchSchoolsApi, this._setSchoolAsHomeApi, this._watchSchoolApi)
      : super(SearchSchoolsLoading());

  final Api _searchSchoolsApi;
  final Api _watchSchoolApi;
  final Api _setSchoolAsHomeApi;

  Future<void> loadNearby() async {
    _searchSchoolsApi.cancelCurrentReq();
    emit(SearchSchoolsLoading());
    (await _searchSchoolsApi.req(
      Verb.get,
      true,
      "/api/v1/schools?offset=1&limit=10",
      {},
    ))
        .fold(
      (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.message())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(const SearchSchoolsError("TODO: 4XX"));
        } else {
          try {
            emit(
              SearchSchoolsData(
                (json.decode(response.body)["value"]["schools"] as List)
                    .map((e) => SchoolWithMetadata.fromJson(e))
                    .toList(),
                SearchSchoolsNoErr(),
              ),
            );
          } catch (_) {
            emit(const SearchSchoolsError("Unknown error"));
          }
        }
      },
    );
  }

  Future<void> search(String query) async {
    _searchSchoolsApi.cancelCurrentReq();
    emit(SearchSchoolsLoading());
    (await _searchSchoolsApi.req(
      Verb.get,
      true,
      "/api/v1/schools/search?query=$query",
      {},
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
              SearchSchoolsNoErr(),
            ));
          } catch (_) {
            emit(const SearchSchoolsError("Unknown error"));
          }
        }
      },
    );
  }

  Future<void> updateWatched(int id, bool watch) async {
    if (state is SearchSchoolsData) {
      final currentState = state as SearchSchoolsData;
      final oldState = currentState.schools.firstWhere((element) => element.id == id);

      // Cancel the ongoing request before starting a new one
      _watchSchoolApi.cancelCurrentReq();

      // Update the state with the updated schools list
      final updatedSchools = currentState.schools.map((e) {
        if (e.id == id) {
          return e.copyWith(watched: watch);
        } else {
          return e;
        }
      }).toList();

      // Emit the updated state with the new schools list
      emit(SearchSchoolsData(
        updatedSchools,
        SearchSchoolsNoErr(),
      ));

      // Send the request to watch the school
      final response = await _watchSchoolApi.req(
        watch ? Verb.post : Verb.delete,
        true,
        "/api/v1/schools/${watch ? "watch" : "unwatch"}",
        {"school_id": id},
      );

      response.fold(
        (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.message())),
        (response) async {
          if (response.statusCode.toString()[0] == "4") {
            if (state is SearchSchoolsData) {
              final currentState = state as SearchSchoolsData;
              final updatedSchools = currentState.schools.map((e) {
                if (e.id == id) {
                  return e.copyWith(watched: oldState.watched);
                } else {
                  return e;
                }
              }).toList();
              emit(SearchSchoolsData(
                updatedSchools,
                SearchSchoolsErr("Error updating school"),
              ));
            } else {
              emit(const SearchSchoolsError("Unknown error"));
            }
          } else {
            try {
              if (response.statusCode.toString()[0] != "2") {
                if (state is SearchSchoolsData) {
                  final currentState = state as SearchSchoolsData;
                  final updatedSchools = currentState.schools.map((e) {
                    if (e.id == id) {
                      return e.copyWith(watched: oldState.watched);
                    } else {
                      return e;
                    }
                  }).toList();
                  emit(SearchSchoolsData(
                    updatedSchools,
                    SearchSchoolsNoErr(),
                  ));
                } else {
                  emit(const SearchSchoolsError("Unknown error"));
                }
                // else, do nothing
              }
            } catch (_) {
              if (state is SearchSchoolsData) {
                final currentState = state as SearchSchoolsData;
                final updatedSchools = currentState.schools.map((e) {
                  if (e.id == id) {
                    return e.copyWith(watched: oldState.watched);
                  } else {
                    return e;
                  }
                }).toList();
                emit(SearchSchoolsData(
                  updatedSchools,
                  SearchSchoolsErr("Error updating school"),
                ));
              } else {
                emit(const SearchSchoolsError("Unknown error"));
              }
            }
          }
        },
      );
    } else {
      emit(const SearchSchoolsError("Unknown error"));
    }
  }

  Future<void> stopWatchingSchool(int id) async {}

  Future<void> setSchoolAsHome(int id) async {}
}
