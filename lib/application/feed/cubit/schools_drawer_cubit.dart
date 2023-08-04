import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';

import '../../../models/school_with_metadata.dart';

part 'schools_drawer_state.dart';

class SchoolsDrawerCubit extends Cubit<SchoolsDrawerState> {
  SchoolsDrawerCubit(this._api) : super(SchoolsDrawerLoading());

  final Api _api;

  void setSelectedFeedInUI(SelectedSchool selectedSchool) {
    if (state is SchoolsDrawerData) {
      if ((selectedSchool is SelectedId &&
              (state as SchoolsDrawerData).schools.any((school) => school.id == selectedSchool.id)) ||
          selectedSchool is SelectedRandom ||
          selectedSchool is SelectedAll) {
        emit(SchoolsDrawerData(
          (state as SchoolsDrawerData).schools,
          selectedSchool,
          (state as SchoolsDrawerData).homeUniversity,
          SchoolsDrawerNoErr(),
        ));
      } else {
        emit(const SchoolDrawerError("Unknown error"));
      }
    }
  }

  void setHomeSchoolInUI(SchoolWithMetadata school) {
    if (state is SchoolsDrawerData) {
      // for every school
      final currentState = state as SchoolsDrawerData;
      currentState.schools.map((school) {
        // if the school is the one we want to update
        if (school.id == school.id) {
          // update the school with the new home value
          return school.copyWith(home: true);
        } else {
          // otherwise, just return the school
          return school;
        }
      }).toList();
      // emit
      emit(currentState.copyWith(homeUniversity: school));
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }

  void resetSchoolInUI(int id, bool watched, bool home) {
    print("setSchool($id, $watched, $home)");
    if (state is SchoolsDrawerData) {
      final currentState = state as SchoolsDrawerData;

      // Find the school with the given id
      final updatedSchool = currentState.schools.firstWhere((school) => school.id == id);

      // Update the 'watched' and 'home' fields of the school based on the arguments
      final updatedSchoolWithWatchedAndHome = updatedSchool.copyWith(watched: watched, home: home);

      // Remove 'home' from all other schools and add the updated school to the list
      final updatedSchools = currentState.schools.map((school) {
        return school.id == id ? updatedSchoolWithWatchedAndHome : school.copyWith(home: false);
      }).toList();

      // Emit the updated state with the new schools list and the selected home university
      emit(
        currentState.copyWith(
          schools: updatedSchools,
          homeUniversity: home ? updatedSchoolWithWatchedAndHome : currentState.homeUniversity,
        ),
      );
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }

  Future<void> removeWatchedSchool(int id) async {
    _api.cancelCurrentReq();
    (await _api.req(Verb.delete, true, "/api/v1/schools/unwatch", {"school_id": id})).fold(
      (failureWithMsg) {
        if (state is SchoolsDrawerData) {
          emit((state as SchoolsDrawerData).copyWith(possibleErr: SchoolsDrawerErr(failureWithMsg.message())));
        } else {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
      (response) async {
        if (response.statusCode.toString()[0] != "2") {
          if (state is SchoolsDrawerData) {
            emit((state as SchoolsDrawerData).copyWith(possibleErr: SchoolsDrawerErr("TODO: Error")));
          } else {
            emit(const SchoolDrawerError("Unknown error"));
          }
        }
      },
    );
  }

  void removeWatchedSchoolInUI(int id) {
    print("removing..... $id");
    if (state is SchoolsDrawerData) {
      final currentState = state as SchoolsDrawerData;

      // for every school in schools
      for (var school in currentState.schools) {
        // if the school id matches the id passed in
        if (school.id == id) {
          // update the school to be unwatched
          final updatedSchool = school.copyWith(watched: false);

          // update the school in the list of schools
          final updatedSchools = currentState.schools.map((s) {
            return s.id == id ? updatedSchool : s;
          }).toList();

          // emit the updated state with the new schools list
          emit(currentState.copyWith(schools: updatedSchools));
          return;
        }
      }
    }
  }

  void addWatchedSchool(SchoolWithMetadata school) {
    if (state is SchoolsDrawerData) {
      final currentState = state as SchoolsDrawerData;

      // Check if the new school already exists in the list based on id, watched
      final existingSchoolIndex = currentState.schools.indexWhere(
        (s) => s.id == school.id && s.watched == school.watched,
      );
      late List<SchoolWithMetadata> updatedSchools;
      if (existingSchoolIndex == -1) {
        // add
        updatedSchools = currentState.schools.toList()..add(school);
      } else {
        // update
        updatedSchools = currentState.schools.map((s) {
          if (s.id == school.id && s.home == school.home) {
            return school.copyWith(watched: true);
          } else {
            return s;
          }
        }).toList();
      }

      // Emit the updated state with the new schools list
      emit(currentState.copyWith(schools: updatedSchools));
    }
  }

  Future<void> loadWatchedSchools() async {
    emit(SchoolsDrawerLoading());
    (await Api().req(Verb.get, true, "/api/v1/schools/watched", {"include_home_school": true})).fold(
      (failureWithMsg) => emit(SchoolDrawerError(failureWithMsg.message())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(SchoolDrawerError(response.body));
        } else if (response.statusCode.toString()[0] == "2") {
          final body = json.decode(response.body);
          final schools =
              (body["value"]["schools"] as List<dynamic>).map((e) => SchoolWithMetadata.fromJson(e)).toList();
          final homeUniversity = SchoolWithMetadata.fromJson(body["value"]["user_school"]);
          emit(SchoolsDrawerData(
            schools,
            SelectedId(homeUniversity.id),
            homeUniversity,
            SchoolsDrawerNoErr(),
          ));
        } else {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
    );
  }
}
