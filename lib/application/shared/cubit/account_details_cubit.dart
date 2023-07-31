import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/models/user.dart';
import 'package:equatable/equatable.dart';

import '../../../core/clients/api.dart';
import '../../../models/faculty.dart';
import '../../../models/school.dart';
import '../../../models/year_of_study.dart';

part 'account_details_state.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit() : super(AccountDetailsLoading());

  Future<void> loadUserData() async {
    emit(AccountDetailsLoading());
    (await Api().req(Method.get, true, "/api/v1/user/user", {})).fold(
      (failureWithMsg) => emit(AccountDetailsError(failureWithMsg.message())),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(const AccountDetailsError("TODO: 4XX"));
          } else if (response.statusCode.toString()[0] == "2") {
            final posts = User.fromJson((json.decode(response.body)["value"]));
            emit(AccountDetailsData(
                school: posts.school.name, yearOfStudy: posts.yearOfStudy.type, faculty: posts.faculty.faculty));
          } else {
            emit(const AccountDetailsError("Unknown error"));
          }
        } catch (_) {
          emit(const AccountDetailsError("Unknown error"));
        }
      },
    );
  }

  Future<void> updateSchool(String newSchool) async {
    if (state is AccountDetailsData) {
      final currentState = state as AccountDetailsData;
      final noErrMsgState = currentState.copyWith(errorMsg: null, school: newSchool);
      emit(noErrMsgState);
      await _updateValueInternal("full_school_name", newSchool, "/api/v1/user/school", noErrMsgState);
    } else {
      emit(const AccountDetailsError("Unknown error"));
    }
  }

  Future<void> _updateValueInternal(
    String jsonBodyKey,
    String jsonBodyValue,
    String endpoint,
    AccountDetailsData oldState,
  ) async {
    (await Api().req(Method.patch, true, endpoint, {
      jsonBodyKey + "hey": jsonBodyValue,
    }))
        .fold(
      (failureWithMsg) {
        emit(oldState.copyWith(
          errorMsg: "Error updating value",
          school: oldState.school,
          yearOfStudy: oldState.yearOfStudy,
          faculty: oldState.faculty,
        ));
      },
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(oldState.copyWith(
              errorMsg: "Error updating value",
              school: oldState.school,
              yearOfStudy: oldState.yearOfStudy,
              faculty: oldState.faculty,
            ));
          } else if (response.statusCode.toString()[0] == "2") {
            emit(oldState.copyWith(errorMsg: null));
          } else {
            emit(oldState.copyWith(
              errorMsg: "Error updating value",
              school: oldState.school,
              yearOfStudy: oldState.yearOfStudy,
              faculty: oldState.faculty,
            ));
          }
        } catch (_) {
          emit(oldState.copyWith(
            errorMsg: "Error updating value",
            school: oldState.school,
            yearOfStudy: oldState.yearOfStudy,
            faculty: oldState.faculty,
          ));
        }
      },
    );
  }
}
