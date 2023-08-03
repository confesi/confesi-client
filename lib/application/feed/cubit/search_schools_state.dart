part of 'search_schools_cubit.dart';

abstract class SearchSchoolsState extends Equatable {
  const SearchSchoolsState();

  @override
  List<Object> get props => [];
}

class SearchSchoolsLoading extends SearchSchoolsState {}

class SearchSchoolsData extends SearchSchoolsState {
  final List<SchoolWithMetadata> schools;

  const SearchSchoolsData(this.schools);

  @override
  List<Object> get props => [schools];
}

class SearchSchoolsError extends SearchSchoolsState {
  final String message;

  const SearchSchoolsError(this.message);

  @override
  List<Object> get props => [message];
}
