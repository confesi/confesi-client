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

abstract class SelectedSchool {}

class SelectedId extends SelectedSchool {
  final int id;

  SelectedId(this.id);

  @override
  List<Object> get props => [id];
}

class SelectedAll extends SelectedSchool {}

class SelectedRandom extends SelectedSchool {}

abstract class SchoolsDrawerPossibleError {}

class SchoolsDrawerErr extends SchoolsDrawerPossibleError {
  final String message;

  SchoolsDrawerErr(this.message);
}

class SchoolsDrawerNoErr extends SchoolsDrawerPossibleError {}

class SchoolsDrawerData extends SchoolsDrawerState {
  final List<SchoolWithMetadata> schools;
  final SchoolWithMetadata homeUniversity;
  final SelectedSchool selected;
  final SchoolsDrawerPossibleError possibleErr;

  const SchoolsDrawerData(this.schools, this.selected, this.homeUniversity, this.possibleErr);

  // copyWith method
  SchoolsDrawerData copyWith({
    List<SchoolWithMetadata>? schools,
    SelectedSchool? selected,
    SchoolWithMetadata? homeUniversity,
    SchoolsDrawerPossibleError? possibleErr,
  }) {
    return SchoolsDrawerData(
      schools ?? this.schools,
      selected ?? this.selected,
      homeUniversity ?? this.homeUniversity,
      possibleErr ?? this.possibleErr,
    );
  }

  @override
  List<Object> get props => [schools, selected, homeUniversity, possibleErr];
}
