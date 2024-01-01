import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/core/services/api_client/api.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';

part 'search_schools_state.dart';

class SearchSchoolsCubit extends Cubit<SearchSchoolsState> {
  SearchSchoolsCubit(this._searchSchoolsApi) : super(SearchSchoolsLoading());

  final Api _searchSchoolsApi;

  void clear() {
    _searchSchoolsApi.cancelCurrReq();
    emit(SearchSchoolsLoading());
  }

  Future<void> loadNearby() async {
    _searchSchoolsApi.cancelCurrReq();
    emit(SearchSchoolsLoading());
    (await _searchSchoolsApi.req(
      Verb.get,
      true,
      "/api/v1/schools?offset=1&limit=10",
      {},
    ))
        .fold(
      (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.msg())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(SearchSchoolsError(ApiErrors.err(response)));
        } else {
          try {
            final schools = (json.decode(response.body)["value"]["schools"] as List)
                .map((e) => SchoolWithMetadata.fromJson(e))
                .toList();
            sl.get<GlobalContentService>().setSchools(schools);
            emit(
              SearchSchoolsData(
                schools,
                SearchSchoolsNoErr(),
              ),
            );
          } catch (_) {
            emit(SearchSchoolsError(ApiErrors.err(response)));
          }
        }
      },
    );
  }

  Future<void> search(String query) async {
    _searchSchoolsApi.cancelCurrReq();
    emit(SearchSchoolsLoading());
    (await _searchSchoolsApi.req(
      Verb.get,
      true,
      "/api/v1/schools/search?query=$query",
      {},
    ))
        .fold(
      (failureWithMsg) => emit(SearchSchoolsError(failureWithMsg.msg())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          emit(SearchSchoolsError(ApiErrors.err(response)));
        } else {
          try {
            final schools =
                (json.decode(response.body)["value"] as List).map((e) => SchoolWithMetadata.fromJson(e)).toList();
            sl.get<GlobalContentService>().setSchools(schools);

            emit(SearchSchoolsData(
              schools,
              SearchSchoolsNoErr(),
            ));
          } catch (_) {
            emit(SearchSchoolsError(ApiErrors.err(response)));
          }
        }
      },
    );
  }
}
