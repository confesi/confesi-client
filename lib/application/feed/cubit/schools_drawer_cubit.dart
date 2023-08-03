import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';

import '../../../models/school_with_metadata.dart';

part 'schools_drawer_state.dart';

class SchoolsDrawerCubit extends Cubit<SchoolsDrawerState> {
  SchoolsDrawerCubit() : super(SchoolsDrawerLoading());

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
          emit(SchoolsDrawerData(schools, homeUniversity.id, homeUniversity));
        } else {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
    );
    // emit(const SchoolsDrawerData([]));
  }
}
