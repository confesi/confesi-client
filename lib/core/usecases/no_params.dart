import 'package:equatable/equatable.dart';

/// The passable type for when a usecase doesn't require anything.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
