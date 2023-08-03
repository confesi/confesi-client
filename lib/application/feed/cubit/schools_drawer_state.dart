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

class SchoolsDrawerData extends SchoolsDrawerState {
  final List<SchoolWithMetadata> schools;
  final SchoolWithMetadata homeUniversity;
  final SelectedSchool selected;

  const SchoolsDrawerData(this.schools, this.selected, this.homeUniversity);

  // copyWith method
  SchoolsDrawerData copyWith({
    List<SchoolWithMetadata>? schools,
    SelectedSchool? selected,
    SchoolWithMetadata? homeUniversity,
  }) {
    return SchoolsDrawerData(
      schools ?? this.schools,
      selected ?? this.selected,
      homeUniversity ?? this.homeUniversity,
    );
  }

  @override
  List<Object> get props => [schools, selected, homeUniversity];
}
