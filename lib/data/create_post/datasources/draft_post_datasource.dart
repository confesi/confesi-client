import 'package:Confessi/core/clients/hive_client.dart';
import 'package:Confessi/data/create_post/models/draft_post_model.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:Confessi/domain/create_post/usecases/save_draft.dart';

import '../../../constants/local_storage_keys.dart';
import '../../../core/clients/api_client.dart';

import '../../../core/results/successes.dart';

abstract class IDraftPostDatasource {
  Future<Success> saveDraftPost(SaveDraftPostParams saveDraftPostParams);
  Future<List<DraftPostEntity>> getDraftPosts(String userId);
  Future<Success> deleteDraftPost(String userId, int index);
}

class DraftPostDatasource implements IDraftPostDatasource {
  final ApiClient api;
  final HiveClient hiveClient;

  DraftPostDatasource({required this.api, required this.hiveClient});

  @override
  Future<List<DraftPostEntity>> getDraftPosts(String userId) async {
    final listOfValues = await hiveClient.getAllValues(userId + hiveDraftPartition);
    return listOfValues.map((i) => DraftPostModel.fromJson(i)).toList();
  }

  @override
  Future<Success> saveDraftPost(SaveDraftPostParams saveDraftPostParams) async {
    await hiveClient.addValue(
      saveDraftPostParams.userId + hiveDraftPartition,
      DraftPostModel(
        title: saveDraftPostParams.draftPostEntity.title,
        body: saveDraftPostParams.draftPostEntity.body,
        repliedPostId: saveDraftPostParams.draftPostEntity.repliedPostId,
        repliedPostBody: saveDraftPostParams.draftPostEntity.repliedPostBody,
        repliedPostTitle: saveDraftPostParams.draftPostEntity.repliedPostTitle,
      ).toJson(),
    );
    return ApiSuccess();
  }

  @override
  Future<Success> deleteDraftPost(String userId, int index) async {
    await hiveClient.deleteAt(userId + hiveDraftPartition, index);
    return ApiSuccess();
  }
}
