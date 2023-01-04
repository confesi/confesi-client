import 'dart:convert';

import '../../../core/clients/api_client.dart';

import '../../../core/alt_unused/http_client.dart';
import '../../../core/results/exceptions.dart';
import '../../../core/results/successes.dart';
import '../utils/error_message_to_exception.dart';

abstract class ICreatePostDatasource {
  Future<Success> uploadPost(String title, String body, String id);
}

class CreatePostDatasource implements ICreatePostDatasource {
  final ApiClient api;

  CreatePostDatasource({required this.api});

  @override
  Future<Success> uploadPost(String title, String body, String? id) async {
    return (await api.req(
      Method.post,
      "/api/create/post",
      {
        'title': title,
        'body': body,
        '_id': id,
      },
      dummyErrorChance: 0.1,
      dummyPath: "api.create.post.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return ApiSuccess();
        } else {
          throw errorMessageToException(jsonDecode(response.body));
        }
      },
    );
  }
}
