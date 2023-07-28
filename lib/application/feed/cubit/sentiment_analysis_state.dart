part of 'sentiment_analysis_cubit.dart';

abstract class SentimentAnalysisState extends Equatable {
  const SentimentAnalysisState();

  @override
  List<Object> get props => [];
}

class SentimentAnalysisLoading extends SentimentAnalysisState {}

class SentimentAnalysisData extends SentimentAnalysisState {
  final SentimentAnalysis sentimentAnalysis;

  const SentimentAnalysisData(this.sentimentAnalysis);

  @override
  List<Object> get props => [sentimentAnalysis];
}

class SentimentAnalysisError extends SentimentAnalysisState {
  final String message;

  const SentimentAnalysisError(this.message);

  @override
  List<Object> get props => [message];
}
