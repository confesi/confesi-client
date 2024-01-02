import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';
import '../../../models/encrypted_id.dart';
import '../../../models/school_with_metadata.dart';

part 'schools_drawer_state.dart';

class SchoolsDrawerCubit extends Cubit<SchoolsDrawerState> {
  SchoolsDrawerCubit(this._api) : super(SchoolsDrawerLoading());

  final Api _api;

  void clear() {
    _api.cancelCurrReq();
    emit(SchoolsDrawerLoading());
  }

  String selectedStr(BuildContext context) {
    if (state is SchoolsDrawerData && (state as SchoolsDrawerData).selected is SelectedSchool) {
      return Provider.of<GlobalContentService>(context)
          .schools[((state as SchoolsDrawerData).selected as SelectedSchool).id]!
          .school
          .name;
    } else {
      // everyone defaults to everything
      return "All";
    }
  }

  SelectedSchoolFeed get selectedSchoolFeed {
    if (state is SchoolsDrawerData && (state as SchoolsDrawerData).selected is SelectedSchool) {
      return SelectedSchool(((state as SchoolsDrawerData).selected as SelectedSchool).id);
    } else {
      return SelectedAll();
    }
  }

  Future<void> getAndSetRandomSchool(EncryptedId? withoutSchoolId) async {
    if (state is SchoolsDrawerData) {
      final s = state as SchoolsDrawerData;
      final newState = s.copyWith(isLoadingRandomSchool: true);
      emit(newState);
      _api.cancelCurrReq();
      print("HERE!!");
      (await _api.req(Verb.get, true,
              "/api/v1/schools/random${withoutSchoolId != null ? "?without-school=${withoutSchoolId.mid}" : ''}", {}))
          .fold(
        (failureWithMsg) =>
            emit(s.copyWith(possibleErr: SchoolsDrawerErr(failureWithMsg.msg()), isLoadingRandomSchool: false)),
        (response) {
          try {
            if (response.statusCode.toString()[0] == "2") {
              final body = json.decode(response.body);
              final school = SchoolWithMetadata.fromJson(body["value"]);
              sl.get<GlobalContentService>().setSchool(school);
              setSelectedSchoolInUI(SelectedSchool(school.school.id));
              if (response.statusCode == 401) {
                emit(SchoolsDrawerData(SelectedSchool(school.school.id), SchoolsDrawerNoErr(),
                    isLoadingRandomSchool: false, isGuest: true));
              } else {
                emit(SchoolsDrawerData(SelectedSchool(school.school.id), SchoolsDrawerNoErr(),
                    isLoadingRandomSchool: false, isGuest: false));
              }
            } else {
              emit(s.copyWith(possibleErr: SchoolsDrawerErr(ApiErrors.err(response)), isLoadingRandomSchool: false));
            }
          } catch (_) {
            emit(s.copyWith(possibleErr: SchoolsDrawerErr("Unknown error"), isLoadingRandomSchool: false));
          }
        },
      );
    }
  }

  void setSchoolsGuest() async {
    emit(SchoolsDrawerData(
      SelectedAll(),
      SchoolsDrawerNoErr(),
      isGuest: true,
    ));
  }

  Future<void> loadSchools() async {
    _api.cancelCurrReq();
    emit(SchoolsDrawerLoading());
    (await _api.req(Verb.get, true, "/api/v1/schools/watched", {"include_home_school": true})).fold(
      (failureWithMsg) => emit(SchoolDrawerError(failureWithMsg.msg())),
      (response) {
        try {
          if (response.statusCode == 200) {
            final body = json.decode(response.body);
            final schools =
                (body["value"]["schools"] as List<dynamic>).map((e) => SchoolWithMetadata.fromJson(e)).toList();
            final homeUniversity = SchoolWithMetadata.fromJson(body["value"]["user_school"]);

            // clear any previous schools
            sl.get<GlobalContentService>().clearSchools();
            // add all to global content service
            sl.get<GlobalContentService>().setSchools(schools);
            sl.get<GlobalContentService>().setSchool(homeUniversity);

            emit(SchoolsDrawerData(
              SelectedAll(),
              SchoolsDrawerNoErr(),
              isGuest: false,
            ));
          } else if (response.statusCode == 401) {
            if (state is SchoolsDrawerData) {
              emit((state as SchoolsDrawerData).copyWith(isGuest: true));
            } else {
              emit(SchoolsDrawerData(
                SelectedAll(),
                SchoolsDrawerNoErr(),
                isGuest: true,
              ));
            }
          } else {
            emit(const SchoolDrawerError("Unknown error"));
          }
        } catch (_) {
          emit(const SchoolDrawerError("Unknown error"));
        }
      },
    );
  }

  void setSelectedSchoolInUI(SelectedSchoolFeed selectedType) {
    if (state is SchoolsDrawerData) {
      final currentState = state as SchoolsDrawerData;
      emit(currentState.copyWith(selected: selectedType));
    } else {
      emit(const SchoolDrawerError("Unknown error"));
    }
  }
}
