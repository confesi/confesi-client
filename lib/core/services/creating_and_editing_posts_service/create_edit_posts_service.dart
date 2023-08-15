import 'package:confesi/models/encrypted_id.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/validators/either_not_empty_validator.dart';
import '../api_client/api.dart';

//! Meta state

abstract class CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateEnteringData extends CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateLoading extends CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateSuccess extends CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateErr extends CreatingEditingPostMetaState {
  final String message;

  CreatingEditingPostMetaStateErr(this.message);
}

//! Post type

abstract class CreatingEditingPostsType {}

class CreatingEditingPostsNewPost extends CreatingEditingPostsType {}

class CreatingEditingPostsEditPost extends CreatingEditingPostsType {
  final EncryptedId id;

  CreatingEditingPostsEditPost(this.id);
}

//! Actual service

class CreatingEditingPostsService extends ChangeNotifier {
  CreatingEditingPostMetaState metaState = CreatingEditingPostMetaStateEnteringData();
  CreatingEditingPostsType type = CreatingEditingPostsNewPost();

  final Api _api;

  CreatingEditingPostsService(this._api);

  void setMetaState(CreatingEditingPostMetaState metaState) {
    this.metaState = metaState;
    notifyListeners();
  }

  void clear() {
    metaState = CreatingEditingPostMetaStateEnteringData();
    type = CreatingEditingPostsNewPost();
    notifyListeners();
  }

  void setPostType(CreatingEditingPostsType type) {
    this.type = type;
    notifyListeners();
  }

  Future<void> editPost(String title, String body, EncryptedId id) async {
    type = CreatingEditingPostsEditPost(id);
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    _api.cancelCurrReq();
    return (await _api.req(Verb.patch, true, "/api/v1/posts/edit", {
      "post_id": id.mid,
      "title": title,
      "body": body,
    }))
        .fold(
      (failureWithMsg) {
        metaState = CreatingEditingPostMetaStateErr(failureWithMsg.msg());
        notifyListeners();
      },
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          metaState = CreatingEditingPostMetaStateSuccess();
          notifyListeners();
          clear();
        } else {
          // todo: fill in the appropriate error message
          metaState = CreatingEditingPostMetaStateErr(response.body);
          notifyListeners();
        }
      },
    );
  }

  Future<void> createNewPost(String title, String body, String category) async {
    type = CreatingEditingPostsNewPost();
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    _api.cancelCurrReq();

    return eitherNotEmptyValidator(title, body).fold(
      (failure) {
        metaState = CreatingEditingPostMetaStateErr("Can't submit empty confession");
        notifyListeners();
      },
      (_) async {
        (await _api.req(
          Verb.post,
          true,
          "/api/v1/posts/create",
          {
            "title": title,
            "body": body,
            "category": category,
          },
        ))
            .fold(
          (failure) {
            metaState = CreatingEditingPostMetaStateErr(failure.msg());
            notifyListeners();
            clear();
          },
          (response) {
            if (response.statusCode.toString()[0] == "2") {
              metaState = CreatingEditingPostMetaStateSuccess();
              notifyListeners();
            } else {
              // todo: fill in the appropriate error message
              metaState = CreatingEditingPostMetaStateErr(response.body);
              notifyListeners();
            }
          },
        );
      },
    );
  }
}
