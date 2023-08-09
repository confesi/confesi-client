import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';
import '../../../models/school_with_metadata.dart';

part 'schools_drawer_state.dart';

class SchoolsDrawerCubit extends Cubit<SchoolsDrawerState> {
  SchoolsDrawerCubit(this._api) : super(SchoolsDrawerLoading());

  final Api _api;

  String selected(BuildContext context, SchoolsDrawerData data) {
    if (data.selected is SelectedSchool) {
      return Provider.of<GlobalContentService>(context).schools[(data.selected as SelectedSchool).id]!.name;
    } else {
      return "All";
    }
  }

  Future<void> loadSchools() async {
    _api.cancelCurrReq();
    emit(SchoolsDrawerLoading());
    (await _api.req(Verb.get, true, "/api/v1/schools/watched", {"include_home_school": true})).fold(
      (failureWithMsg) => null,
      (response) {
        try {
          if (response.statusCode == 200) {
            final body = json.decode(response.body);
            final schools =
                (body["value"]["schools"] as List<dynamic>).map((e) => SchoolWithMetadata.fromJson(e)).toList();
            final homeUniversity = SchoolWithMetadata.fromJson(body["value"]["user_school"]);

            // add all to global content service
            sl.get<GlobalContentService>().setSchools(schools);
            sl.get<GlobalContentService>().addSchool(homeUniversity);

            emit(SchoolsDrawerData(
              SelectedSchool(homeUniversity.id),
              SchoolsDrawerNoErr(),
            ));
          } else {
            emit(const SchoolDrawerError("Unknown error"));
          }
        } catch (_) {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
    );
  }

  void setSelectedSchoolInUI(SelectedType selectedType) {
    if (state is SchoolsDrawerData) {
      final currentState = state as SchoolsDrawerData;
      emit(currentState.copyWith(selected: selectedType));
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }
}
