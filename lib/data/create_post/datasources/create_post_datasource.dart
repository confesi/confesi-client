import 'dart:convert';

import '../../../core/results/successes.dart';
import '../../../core/clients/http_client.dart';
import '../utils/error_message_to_exception.dart';

abstract class ICreatePostDatasource {
  Future<Success> uploadPost(String title, String body, String id);
}

class CreatePostDatasource implements ICreatePostDatasource {
  final HttpClient api;

  CreatePostDatasource({required this.api});

  @override
  Future<Success> uploadPost(String title, String body, String? id) async {
    final response = await api.req(
      true,
      Method.post,
      {
        'title': title,
        'body': body,
        '_id': id,
      },
      '/api/create/post',
      dummyData: true,
      dummyPath: 'api.create.post.json',
      // dummyDelay: const Duration(seconds: 1),
      // dummyErrorChance: 1,
      // dummyErrorMessage: 'fields blank',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiSuccess();
    } else {
      throw errorMessageToException(jsonDecode(response.body));
    }
  }
}
