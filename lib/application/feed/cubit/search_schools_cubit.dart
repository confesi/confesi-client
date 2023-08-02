import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_schools_state.dart';

class SearchSchoolsCubit extends Cubit<SearchSchoolsState> {
  SearchSchoolsCubit() : super(SearchSchoolsLoading());
}
