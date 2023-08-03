import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';

import '../../../models/school_with_metadata.dart';

part 'schools_drawer_state.dart';

class SchoolsDrawerCubit extends Cubit<SchoolsDrawerState> {
  SchoolsDrawerCubit() : super(SchoolsDrawerLoading());

  void setCurrentSchool(SelectedSchool selectedSchool) {
    if (state is SchoolsDrawerData) {
      if ((selectedSchool is SelectedId &&
              (state as SchoolsDrawerData).schools.any((school) => school.id == selectedSchool.id)) ||
          selectedSchool is SelectedRandom ||
          selectedSchool is SelectedAll) {
        emit(SchoolsDrawerData(
          (state as SchoolsDrawerData).schools,
          selectedSchool,
          (state as SchoolsDrawerData).homeUniversity,
        ));
      } else {
        emit(const SchoolDrawerError("Unknown error"));
      }
    }
  }

  void updateHomeSchool(int id) {
    print("UPDATING HOME TO $id");
    if (state is SchoolsDrawerData) {
      emit(
        (state as SchoolsDrawerData).copyWith(
          homeUniversity: (state as SchoolsDrawerData).schools.firstWhere((school) => school.id == id),
        ),
      );
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }

  void removeWatchedSchool(int id) {
    if (state is SchoolsDrawerData) {
      emit((state as SchoolsDrawerData).copyWith(
        schools: (state as SchoolsDrawerData).schools.where((school) => school.id != id).toList(),
      ));
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }

  void addWatchedSchool(SchoolWithMetadata school) {
    if (state is SchoolsDrawerData) {
      emit(
        (state as SchoolsDrawerData).copyWith(
            schools: (state as SchoolsDrawerData).schools
              ..add(school)
              ..sort((a, b) => a.name.compareTo(b.name))),
      );
    } else {
      emit(const SchoolDrawerError("Unknown error"));
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
          emit(SchoolsDrawerData(schools, SelectedId(homeUniversity.id), homeUniversity));
        } else {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
    );
  }
}
