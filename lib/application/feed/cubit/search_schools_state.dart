part of 'search_schools_cubit.dart';

abstract class SearchSchoolsState extends Equatable {
  const SearchSchoolsState();

  @override
  List<Object> get props => [];
}

class SearchSchoolsLoading extends SearchSchoolsState {}

class SearchSchoolsData extends SearchSchoolsState {}

class SearchSchoolsError extends SearchSchoolsState {}
