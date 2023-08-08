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

class SchoolsDrawerData extends SchoolsDrawerState {
  final SelectedType selected;
  final SchoolsDrawerPossibleError possibleErr;

  const SchoolsDrawerData(this.selected, this.possibleErr);

  // copyWith method
  SchoolsDrawerData copyWith({SelectedType? selected, SchoolsDrawerPossibleError? possibleErr}) {
    return SchoolsDrawerData(
      selected ?? this.selected,
      possibleErr ?? this.possibleErr,
    );
  }

  @override
  List<Object> get props => [selected, possibleErr];
}

//! Error type

abstract class SchoolsDrawerPossibleError {}

class SchoolsDrawerErr extends SchoolsDrawerPossibleError {
  final String message;

  SchoolsDrawerErr(this.message);
}

class SchoolsDrawerNoErr extends SchoolsDrawerPossibleError {}

//! Selected type

abstract class SelectedType {}

class SelectedSchool extends SelectedType {
  final int id;

  SelectedSchool(this.id);
}

class SelectedAll extends SelectedType {}

class SelectedRandom extends SelectedType {}
