import 'package:Confessi/core/results/successes.dart';
import '../../../core/authorization/http_client.dart';
import '../../../core/results/exceptions.dart';

abstract class ICreatePostDatasource {
  Future<Success> uploadPost(String title, String body, String id);
}

class CreatePostDatasource implements ICreatePostDatasource {
  final ApiClient api;

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
        dummyPath: 'api.create.post.json');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiSuccess();
    } else {
      throw ServerException();
    }
  }
}
