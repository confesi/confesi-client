import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';

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

  Future<void> updateWatched(SchoolWithMetadata schoolWithMetadata, bool watch) async {
    sl.get<GlobalContentService>().setSchool(schoolWithMetadata);

    if (state is SearchSchoolsData) {
      final currentState = state as SearchSchoolsData;

      final updatedSchools = currentState.schools.map((e) {
        if (e.id == schoolWithMetadata.id) {
          return e.copyWith(watched: watch);
        } else {
          return e;
        }
      }).toList();
      sl.get<GlobalContentService>().setSchools(updatedSchools); // Update global content service

      emit(SearchSchoolsData(
        updatedSchools,
        SearchSchoolsNoErr(),
      ));

      // Send the request to watch the school
      final response = await _watchSchoolApi.req(
        watch ? Verb.post : Verb.delete,
        true,
        "/api/v1/schools/${watch ? "watch" : "unwatch"}",
        {"school_id": schoolWithMetadata.id},
      );

      response.fold(
        (failureWithMsg) {
          // Revert to the old watched status on error
          final newSchools = currentState.schools.map((e) {
            if (e.id == schoolWithMetadata.id) {
              return e.copyWith(watched: !watch);
            } else {
              return e;
            }
          }).toList();
          sl.get<GlobalContentService>().setSchools(newSchools); // Update global content service

          emit(SearchSchoolsData(
            newSchools,
            SearchSchoolsErr(failureWithMsg.message(), schoolWithMetadata.id, !watch,
                currentState.schools.firstWhere((element) => element.id == schoolWithMetadata.id).home),
          ));
        },
        (response) {
          if (response.statusCode.toString()[0] != "2") {
            final newSchools = currentState.schools.map((e) {
              if (e.id == schoolWithMetadata.id) {
                return e.copyWith(watched: !watch);
              } else {
                return e;
              }
            }).toList();
            sl.get<GlobalContentService>().setSchools(newSchools); // Update global content service

            emit(SearchSchoolsData(
              newSchools,
              SearchSchoolsErr("Error updating school", schoolWithMetadata.id, !watch,
                  currentState.schools.firstWhere((element) => element.id == schoolWithMetadata.id).home),
            ));
          }
        },
      );
    } else {
      emit(const SearchSchoolsError("Unknown error"));
    }
  }

  Future<void> setHome(SchoolWithMetadata schoolWithMetadata) async {
    sl.get<GlobalContentService>().setSchool(schoolWithMetadata);

    if (state is SearchSchoolsData) {
      final currentState = state as SearchSchoolsData;

      // Cancel the ongoing request before starting a new one
      _setSchoolAsHomeApi.cancelCurrentReq();

      // Return the first id of the school where home is true
      final SchoolWithMetadata oldHome = currentState.schools.firstWhere((element) => element.home);
      print("first find of hold home school: ${oldHome.id}");

      // Store the old home school's data
      SchoolWithMetadata? oldHomeData;

      // Update the state with the updated schools list
      final updatedSchools = currentState.schools.map((e) {
        if (e.id == schoolWithMetadata.id) {
          return e.copyWith(home: true);
        } else {
          // Unset any other school that might also be considered home
          if (e.id == oldHome.id) {
            // Store the old home school's data
            oldHomeData = e;
            return e.copyWith(home: false);
          }
          return e;
        }
      }).toList();

      // Emit the updated state with the new schools list
      emit(SearchSchoolsData(
        updatedSchools,
        SearchSchoolsNoErr(),
      ));
      sl.get<GlobalContentService>().setSchools(updatedSchools);

      // Send the request to update the home school
      final response = await _setSchoolAsHomeApi.req(
        Verb.patch,
        true,
        "/api/v1/user/school",
        {"school_id": schoolWithMetadata.id},
      );

      response.fold(
        (failureWithMsg) {
          // Revert to the old home school's data on error
          if (oldHomeData != null) {
            final newSchools = currentState.schools.map((e) {
              if (e.id == schoolWithMetadata.id) {
                return e.copyWith(home: false); // Reset the selected school back to not being home
              } else {
                // Reset any other school that might also be considered home to true
                if (e.id == oldHome.id) {
                  return oldHomeData!.copyWith(home: true);
                }
                return e;
              }
            }).toList();
            sl.get<GlobalContentService>().setSchools(updatedSchools);

            emit(SearchSchoolsData(
                newSchools, SearchSchoolsErr(failureWithMsg.message(), oldHome.id, oldHome.watched, true)));
          } else {
            final newSchools = currentState.schools.map((e) {
              if (e.id == schoolWithMetadata.id) {
                return e.copyWith(home: false); // Reset the selected school back to not being home
              } else {
                // Reset any other school that might also be considered home to true
                if (e.id == oldHome.id) {
                  return e.copyWith(home: true);
                }
                return e;
              }
            }).toList();
            sl.get<GlobalContentService>().setSchools(updatedSchools);

            emit(SearchSchoolsData(
              newSchools,
              SearchSchoolsErr(failureWithMsg.message(), oldHome.id, oldHome.watched, true),
            ));
          }
        },
        (response) {
          if (response.statusCode.toString()[0] != "2") {
            final newSchools = currentState.schools.map((e) {
              if (e.id == schoolWithMetadata.id) {
                return e.copyWith(home: false); // Reset the selected school back to not being home
              } else {
                // Reset any other school that might also be considered home to true
                if (e.id == oldHome.id) {
                  return e.copyWith(home: true);
                }
                return e;
              }
            }).toList();
            sl.get<GlobalContentService>().setSchools(updatedSchools);
            emit(SearchSchoolsData(
              newSchools,
              SearchSchoolsErr("Error updating home school", oldHome.id, oldHome.watched, true),
            ));
          }
        },
      );
    } else {
      emit(const SearchSchoolsError("Unknown error"));
    }
  }
}
