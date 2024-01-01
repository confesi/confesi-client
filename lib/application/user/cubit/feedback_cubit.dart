import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit(this._api) : super(FeedbackInitial());

  final Api _api;

  void clear() {
    _api.cancelCurrReq();
    emit(FeedbackInitial());
  }

  Future<void> sendFeedback(String feedback, String feedbackType) async {
    _api.cancelCurrReq();
    emit(FeedbackLoading());
    (await _api.req(Verb.post, true, "/api/v1/feedback/create", {
      "message": feedback,
      "type": feedbackType,
    }))
        .fold(
      (failureWithMsg) => emit(FeedbackError(failureWithMsg.msg())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(FeedbackError(ApiErrors.err(response)));
        } else if (response.statusCode.toString()[0] == "2") {
          emit(FeedbackSuccess("Feedback sent successfully"));
        } else {
          emit(FeedbackError("Unknown error"));
        }
      },
    );
  }
}
