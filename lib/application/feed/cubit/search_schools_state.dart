part of 'search_schools_cubit.dart';

abstract class SearchSchoolsState extends Equatable {
  const SearchSchoolsState();

  @override
  List<Object> get props => [];
}

abstract class PossibleError {}

class SearchSchoolsErr extends PossibleError {
  final String message;

  SearchSchoolsErr(this.message);
}

class SearchSchoolsNoErr extends PossibleError {}

class SearchSchoolsLoading extends SearchSchoolsState {}

class SearchSchoolsData extends SearchSchoolsState {
  final List<SchoolWithMetadata> schools;
  final PossibleError possibleErr;

  const SearchSchoolsData(this.schools, this.possibleErr);

  SearchSchoolsData copyWith({
    List<SchoolWithMetadata>? schools,
    PossibleError? possibleErr,
  }) {
    return SearchSchoolsData(
      schools ?? this.schools,
      possibleErr ?? this.possibleErr,
    );
  }

  @override
  List<Object> get props => [schools, possibleErr];
}

class SearchSchoolsError extends SearchSchoolsState {
  final String message;

  const SearchSchoolsError(this.message);

  @override
  List<Object> get props => [message];
}
