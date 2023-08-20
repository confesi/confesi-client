import 'dart:convert';

import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/post.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/validators/either_not_empty_validator.dart';
import '../api_client/api.dart';

//! Meta state

abstract class CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateEnteringData extends CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateLoading extends CreatingEditingPostMetaState {}

//! Actual service

class CreatingEditingPostsService extends ChangeNotifier {
  CreatingEditingPostMetaState metaState = CreatingEditingPostMetaStateEnteringData();
  String title = "";
  String body = "";

  final Api _api;

  CreatingEditingPostsService(this._api);

  void setMetaState(CreatingEditingPostMetaState metaState) {
    this.metaState = metaState;
    notifyListeners();
  }

  void clear() {
    _api.cancelCurrReq();
    metaState = CreatingEditingPostMetaStateEnteringData();
    title = "";
    body = "";
    notifyListeners();
  }

  Future<Either<ApiSuccess, String>> editPost(String title, String body, EncryptedId id) async {
    _api.cancelCurrReq();
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    final response = await _api.req(Verb.patch, true, "/api/v1/posts/edit", {
      "post_id": id.mid,
      "title": title,
      "body": body,
    });

    return response.fold(
      (failureWithMsg) => Right(failureWithMsg.msg()),
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
            sl.get<GlobalContentService>().setPost(post);
            return Left(ApiSuccess());
          } catch (_) {
            return const Right("Confession created, but unable to load locally");
          }
        } else {
          // todo: fill in the appropriate error message
          return Right(response.body);
        }
      },
    );
  }

  Future<Either<ApiSuccess, String>> createNewPost(String title, String body, String category) async {
    _api.cancelCurrReq();
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    final validation = eitherNotEmptyValidator(title, body);
    if (validation.isLeft()) {
      return const Right("Can't submit empty confession");
    }

    final response = await _api.req(
      Verb.post,
      true,
      "/api/v1/posts/create",
      {
        "title": title,
        "body": body,
        "category": category,
      },
    );

    return response.fold(
      (failureWithMsg) => Right(failureWithMsg.msg()),
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
            sl.get<GlobalContentService>().setPost(post);
            return Left(ApiSuccess());
          } catch (_) {
            return const Right("Confession edited, but unable to update locally");
          }
        } else {
          // todo: fill in the appropriate error message
          return Right(response.body);
        }
      },
    );
  }
}
