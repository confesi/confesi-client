part of 'feedback_cubit.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

abstract class FeedbackResult extends FeedbackState {
  String msg();
}

class FeedbackSuccess extends FeedbackResult {
  final String _message;
  FeedbackSuccess(this._message);
  @override
  String msg() => _message;
}

class FeedbackError extends FeedbackResult {
  final String _message;
  FeedbackError(this._message);
  @override
  String msg() => _message;
}

class FeedbackLoading extends FeedbackState {}

class FeedbackInitial extends FeedbackState {}
