import 'dart:convert';

import '../../../core/clients/api_client.dart';
import '../models/profile_model.dart';
import '../../../domain/profile/entities/profile_entity.dart';

import '../../../core/results/exceptions.dart';

abstract class IProfileDatasource {
  Future<ProfileEntity> fetchProfileData();
}

class ProfileDatasource implements IProfileDatasource {
  ApiClient api;

  ProfileDatasource({required this.api});

  @override
  Future<ProfileEntity> fetchProfileData() async {
    return (await api.req(
      Method.get,
      "/api/profile",
      null,
      dummyErrorChance: 0,
      dummyPath: "api.profile.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(jsonDecode(response.body));
          return ProfileModel.fromJson(jsonDecode(response.body));
        } else {
          throw ServerException();
        }
      },
    );
  }
}
