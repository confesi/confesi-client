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
  final List<SchoolWithMetadata> schools;
  final SchoolWithMetadata homeUniversity;
  final int selectedSchoolId;

  const SchoolsDrawerData(this.schools, this.selectedSchoolId, this.homeUniversity);

  @override
  List<Object> get props => [schools, selectedSchoolId];
}
