import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/general.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';
import '../utils/error_message_to_exception.dart';

abstract class IFeedDatasource {
  Future<List<Post>> fetchRecents(String lastSeenPostId);
  Future<List<Post>> fetchTrending(String lastSeenPostId);
  Future<List<Post>> fetchDailyHottest();
}

class FeedDatasource implements IFeedDatasource {
  final http.Client client;

  FeedDatasource({required this.client});

  @override
  Future<List<PostModel>> fetchRecents(String lastSeenPostId) async {
    final response = await http
        .post(
          Uri.parse('$kDomain/api/posts/recents'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "last_post_viewed_ID": lastSeenPostId,
          }),
        )
        .timeout(const Duration(seconds: 2));
    final statusCode = response.statusCode;
    final decodedBody = json.decode(response.body);
    if (statusCode == 200) {
      return decodedBody.map((post) => PostModel.fromJson(post)).toList();
    } else {
      throw errorMessageToException(decodedBody);
    }
  }

  @override
  Future<List<Post>> fetchTrending(String lastSeenPostId) {
    // TODO: implement fetchTrending
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchDailyHottest() {
    // TODO: implement fetchDailyHottest
    throw UnimplementedError();
  }
}
