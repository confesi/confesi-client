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
  final SelectedSchoolFeed selected;
  final SchoolsDrawerPossibleError possibleErr;
  final bool isLoadingRandomSchool;

  const SchoolsDrawerData(this.selected, this.possibleErr, {this.isLoadingRandomSchool = false});

  // copyWith method
  SchoolsDrawerData copyWith(
      {SelectedSchoolFeed? selected, SchoolsDrawerPossibleError? possibleErr, bool? isLoadingRandomSchool}) {
    return SchoolsDrawerData(
      selected ?? this.selected,
      possibleErr ?? this.possibleErr,
      isLoadingRandomSchool: isLoadingRandomSchool ?? this.isLoadingRandomSchool,
    );
  }

  @override
  List<Object> get props => [selected, possibleErr, isLoadingRandomSchool, selected];
}

//! Error type

abstract class SchoolsDrawerPossibleError {}

class SchoolsDrawerErr extends SchoolsDrawerPossibleError {
  final String message;

  SchoolsDrawerErr(this.message);
}

class SchoolsDrawerNoErr extends SchoolsDrawerPossibleError {}

//! Selected type

abstract class SelectedSchoolFeed {}

class SelectedSchool extends SelectedSchoolFeed {
  final int id;

  SelectedSchool(this.id);
}

class SelectedAll extends SelectedSchoolFeed {}
