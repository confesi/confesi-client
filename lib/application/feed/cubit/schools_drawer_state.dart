part of 'schools_drawer_cubit.dart';

abstract class SchoolsDrawerState extends Equatable {
  const SchoolsDrawerState();

  @override
  List<Object> get props => [];
}

class SchoolsDrawerLoading extends SchoolsDrawerState {}

class SchoolDrawerError extends SchoolsDrawerState {
  final String message;

  const SchoolDrawerError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class SchoolsDrawerPossibleError {}

class SchoolsDrawerErr extends SchoolsDrawerPossibleError {
  final String message;

  SchoolsDrawerErr(this.message);
}

class SchoolsDrawerNoErr extends SchoolsDrawerPossibleError {}

class SchoolsDrawerData extends SchoolsDrawerState {
  final int selectedId;
  final SchoolsDrawerPossibleError possibleErr;

  const SchoolsDrawerData(this.selectedId, this.possibleErr);

  // copyWith method
  SchoolsDrawerData copyWith(
      {List<int>? schoolIds, int? selectedId, SchoolsDrawerPossibleError? possibleErr, int? homeId}) {
    return SchoolsDrawerData(
      selectedId ?? this.selectedId,
      possibleErr ?? this.possibleErr,
    );
  }

  @override
  List<Object> get props => [selectedId, possibleErr];
}
