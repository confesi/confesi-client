import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/application/user/cubit/stats_cubit.dart';
import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/user.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';

part 'account_details_state.dart';

class AccountDetailsCubit extends Cubit<AccountDetailsState> {
  AccountDetailsCubit(this._api) : super(AccountDetailsLoading());

  final Api _api;

  void clear() {
    _api.cancelCurrReq();
    emit(AccountDetailsLoading());
  }

  Future<void> loadUserData() async {
    _api.cancelCurrReq();

    emit(AccountDetailsLoading());
    (await _api.req(Verb.get, true, "/api/v1/user/user", {})).fold(
      (failureWithMsg) => emit(AccountDetailsError(failureWithMsg.msg())),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(AccountDetailsError(ApiErrors.err(response)));
          } else if (response.statusCode.toString()[0] == "2") {
            final posts = User.fromJson((json.decode(response.body)["value"]));
            emit(
              AccountDetailsTrueData(
                err: NoErr(),
                data: AccData(
                  school: posts.school.name,
                  yearOfStudy: posts.yearOfStudy.type,
                  faculty: posts.faculty.faculty,
                ),
              ),
            );
          } else {
            emit(AccountDetailsError(ApiErrors.err(response)));
          }
        } catch (_) {
          emit(AccountDetailsError(ApiErrors.err(response)));
        }
      },
    );
  }

  Future<void> hideFaculty() async {
    try {
      final AccData originalState = _getCurrAccData();
      final ephemeralState = AccountDetailsEphemeral(
        data: AccData(school: originalState.school, yearOfStudy: originalState.yearOfStudy, faculty: null),
      );
      final oldData = AccData(
        school: ephemeralState.data.school,
        yearOfStudy: ephemeralState.data.yearOfStudy,
        faculty: originalState.faculty,
      );
      emit(ephemeralState);
      await _deleteValueInternal("/api/v1/user/faculty", oldData, (_) {
        emit(AccountDetailsTrueData(
          err: NoErr(),
          data: AccData(school: originalState.school, yearOfStudy: originalState.yearOfStudy, faculty: null),
        ));
      });
    } catch (_) {
      emit(const AccountDetailsError("Unknown error"));
    }
  }

  Future<void> hideYearOfStudy() async {
    try {
      final AccData originalState = _getCurrAccData();
      final ephemeralState = AccountDetailsEphemeral(
        data: AccData(school: originalState.school, yearOfStudy: null, faculty: originalState.faculty),
      );
      final oldData = AccData(
        school: ephemeralState.data.school,
        yearOfStudy: originalState.yearOfStudy,
        faculty: ephemeralState.data.faculty,
      );
      emit(ephemeralState);
      await _deleteValueInternal("/api/v1/user/year-of-study", oldData, (_) {
        emit(AccountDetailsTrueData(
          err: NoErr(),
          data: AccData(school: originalState.school, yearOfStudy: null, faculty: originalState.faculty),
        ));
      });
    } catch (_) {
      emit(const AccountDetailsError("Unknown error"));
    }
  }

  Future<void> _deleteValueInternal(
    String endpoint,
    AccData oldData,
    Function(AccData oldData) onSuccess,
  ) async {
    _api.cancelCurrReq();

    (await _api.req(Verb.delete, true, endpoint, {})).fold(
      (failureWithMsg) => emit(AccountDetailsTrueData(err: Err(failureWithMsg.msg()), data: oldData)),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
          } else if (response.statusCode.toString()[0] == "2") {
            onSuccess(oldData);
          } else {
            emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
          }
        } catch (_) {
          emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
        }
      },
    );
  }

  Future<void> updateFaculty(String newFaculty) async {
    try {
      final AccData originalState = _getCurrAccData();
      final ephemeralState = AccountDetailsEphemeral(
        data: AccData(
          school: originalState.school,
          yearOfStudy: originalState.yearOfStudy,
          faculty: newFaculty,
        ),
      );
      final oldData = AccData(
        school: ephemeralState.data.school,
        yearOfStudy: ephemeralState.data.yearOfStudy,
        faculty: originalState.faculty,
      );
      emit(ephemeralState);
      await _updateValueInternal("faculty", newFaculty, "/api/v1/user/faculty", oldData, (_) {
        try {
          final AccData currState = _getCurrAccData();
          emit(
            AccountDetailsTrueData(
              err: NoErr(),
              data: AccData(
                school: currState.school,
                yearOfStudy: currState.yearOfStudy,
                faculty: newFaculty,
              ),
            ),
          );
        } catch (_) {
          emit(const AccountDetailsError("Unknown error"));
        }
      });
    } catch (_) {
      emit(const AccountDetailsError("Unknown error"));
    }
  }

  AccData _getCurrAccData() {
    if (state is AccountDetailsTrueData) {
      return (state as AccountDetailsTrueData).data;
    } else if (state is AccountDetailsEphemeral) {
      return (state as AccountDetailsEphemeral).data;
    } else {
      throw Exception("Unknown state");
    }
  }

  Future<void> updateYearOfStudy(String newYearOfStudy) async {
    try {
      final AccData originalState = _getCurrAccData();
      final ephemeralState = AccountDetailsEphemeral(
        data: AccData(
          school: originalState.school,
          yearOfStudy: newYearOfStudy,
          faculty: originalState.faculty,
        ),
      );
      final oldData = AccData(
        school: ephemeralState.data.school,
        yearOfStudy: originalState.yearOfStudy,
        faculty: ephemeralState.data.faculty,
      );
      emit(ephemeralState);
      await _updateValueInternal("year_of_study", newYearOfStudy, "/api/v1/user/year-of-study", oldData, (_) {
        try {
          final AccData currState = _getCurrAccData();
          emit(
            AccountDetailsTrueData(
              err: NoErr(),
              data: AccData(
                school: currState.school,
                yearOfStudy: newYearOfStudy,
                faculty: currState.faculty,
              ),
            ),
          );
        } catch (_) {
          emit(const AccountDetailsError("Unknown error"));
        }
      });
    } catch (_) {
      emit(const AccountDetailsError("Unknown error"));
    }
  }

  Future<void> _updateValueInternal(
    String jsonBodyKey,
    String jsonBodyValue,
    String endpoint,
    AccData oldData,
    Function(AccData oldData) onSuccess,
  ) async {
    _api.cancelCurrReq();

    (await _api.req(Verb.patch, true, endpoint, {
      jsonBodyKey: jsonBodyValue,
    }))
        .fold(
      (failureWithMsg) => emit(AccountDetailsTrueData(err: Err(failureWithMsg.msg()), data: oldData)),
      (response) async {
        try {
          if (response.statusCode.toString()[0] == "4") {
            emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
          } else if (response.statusCode.toString()[0] == "2") {
            onSuccess(oldData);
          } else {
            emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
          }
        } catch (_) {
          emit(AccountDetailsTrueData(err: Err(ApiErrors.err(response)), data: oldData));
        }
      },
    );
  }
}
