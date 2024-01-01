import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'room_requests_state.dart';

class RoomRequestsCubit extends Cubit<RoomRequestsState> {
  RoomRequestsCubit(this._api) : super(RoomRequestsLoading());

  final Api _api;

  Future<void> loadData() async {
    _api.cancelCurrReq();
    emit(RoomRequestsLoading());
    (await _api.req(Verb.get, true, "/api/v1/dms/room/requests", {})).fold(
      (failureWithMsg) => emit(RoomRequestsError(failureWithMsg.msg())),
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final allowsRequests = json.decode(response.body)["value"] as bool;
            emit(RoomRequestsData(allowsRequests));
          } catch (_) {
            emit(RoomRequestsError(ApiErrors.err(response)));
          }
        } else {
          emit(RoomRequestsError(ApiErrors.err(response)));
        }
      },
    );
  }

  Future<Either<ApiSuccess, String>> toggleRequests() async {
    if (state is RoomRequestsData) {
      _api.cancelCurrReq();
      // eagerly set the new value and save the old value to possibly restore later
      final oldAllowsRequests = (state as RoomRequestsData).allowsRequests;
      emit(RoomRequestsData(!oldAllowsRequests));
      return (await _api.req(Verb.put, true, "/api/v1/dms/room/requests", {
        "requestable": (state as RoomRequestsData).allowsRequests,
      }))
          .fold(
        (failureWithMsg) {
          // restore the old value
          emit(RoomRequestsData(oldAllowsRequests));
          return Right(failureWithMsg.msg());
        },
        (response) {
          if (response.statusCode.toString()[0] == "2") {
            try {
              emit(RoomRequestsData(!oldAllowsRequests));
              return Left(ApiSuccess());
            } catch (_) {
              // restore the old value
              emit(RoomRequestsData(oldAllowsRequests));
              return Right(ApiErrors.err(response));
            }
          } else {
            // restore the old value
            emit(RoomRequestsData(oldAllowsRequests));
            return Right(ApiErrors.err(response));
          }
        },
      );
    }
    return const Right("Unknown error");
  }
}
