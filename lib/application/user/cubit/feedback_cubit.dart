import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/clients/api.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  Future<void> sendFeedback(String feedback, String feedbackType) async {
    emit(FeedbackLoading());
    (await Api().req(Verb.post, true, "/api/v1/feedback/create", {
      "message": feedback,
      "type": feedbackType,
    }))
        .fold(
      (failureWithMsg) => emit(FeedbackError(failureWithMsg.msg())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(FeedbackError("TODO: 4XX"));
        } else if (response.statusCode.toString()[0] == "2") {
          emit(FeedbackSuccess("Feedback sent successfully"));
        } else {
          emit(FeedbackError("Unknown error"));
        }
      },
    );
  }
}
