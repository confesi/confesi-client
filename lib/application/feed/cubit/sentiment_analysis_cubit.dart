import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/clients/api.dart';
import '../../../models/sentiment_analysis.dart';

part 'sentiment_analysis_state.dart';

class SentimentAnalysisCubit extends Cubit<SentimentAnalysisState> {
  SentimentAnalysisCubit() : super(SentimentAnalysisLoading());

  Future<void> loadSentimentAnalysis(int postId) async {
    emit(SentimentAnalysisLoading());
    (await Api().req(Verb.get, true, "/api/v1/posts/sentiment?id=$postId", {})).fold(
      (failure) => emit(SentimentAnalysisError(failure.message())),
      (response) {
        try {
          if (response.statusCode.toString()[0] == "2") {
            final sentiment = SentimentAnalysis.fromJson(jsonDecode(response.body)["value"]);
            emit(SentimentAnalysisData(sentiment));
          } else {
            emit(const SentimentAnalysisError("Unknown error"));
          }
        } catch (_) {
          emit(const SentimentAnalysisError("Unknown error"));
        }
      },
    );
  }
}
