part of 'post_cubit.dart';

@immutable
abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegularPost extends PostState {}

class ReplyPost extends PostState {}
