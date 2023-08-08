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
  final List<int> schoolIds; // List of school IDs
  final int selectedId;
  final int homeId;
  final SchoolsDrawerPossibleError possibleErr;

  const SchoolsDrawerData(this.schoolIds, this.selectedId, this.possibleErr, this.homeId);

  // copyWith method
  SchoolsDrawerData copyWith(
      {List<int>? schoolIds, int? selectedId, SchoolsDrawerPossibleError? possibleErr, int? homeId}) {
    return SchoolsDrawerData(
      schoolIds ?? this.schoolIds,
      selectedId ?? this.selectedId,
      possibleErr ?? this.possibleErr,
      homeId ?? this.homeId,
    );
  }

  @override
  List<Object> get props => [schoolIds, selectedId, possibleErr, homeId];
}
