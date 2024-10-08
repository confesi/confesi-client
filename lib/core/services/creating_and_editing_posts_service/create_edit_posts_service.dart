import 'dart:convert';
import 'dart:io';

import 'package:confesi/core/results/successes.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/post.dart';
import 'package:dartz/dartz.dart' as d;
import 'package:flutter/cupertino.dart';

import '../../utils/validators/either_not_empty_validator.dart';
import '../api_client/api.dart';

//! Editor state

class EditorState implements Comparable<EditorState> {
  final File editingFile;

  @override
  int compareTo(EditorState other) {
    return editingFile.path.compareTo(other.editingFile.path);
  }

  EditorState({
    required this.editingFile,
  });

  EditorState.empty(File file) : editingFile = file;
}

//! Meta state

abstract class CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateEnteringData extends CreatingEditingPostMetaState {}

class CreatingEditingPostMetaStateLoading extends CreatingEditingPostMetaState {}

//! Actual service

class CreatingEditingPostsService extends ChangeNotifier {
  CreatingEditingPostMetaState metaState = CreatingEditingPostMetaStateEnteringData();
  String title = "";
  String body = "";
  bool isChatPost = true;
  final List<EditorState> _images = [];

  void setIsChatPost(bool isChatPost) {
    this.isChatPost = isChatPost;
    notifyListeners();
  }

  // getter for image
  List<EditorState> get images => _images;

  // add an image to the list if it does not exist already in it, however, if it does exist, update the image with the new data
  void addImage(EditorState image) {
    final index = _images.indexWhere((element) => element.editingFile == image.editingFile);
    if (index == -1) {
      _images.add(image);
    } else {
      _images[index] = image;
    }
    notifyListeners();
  }

  void updateImages(List<EditorState> images) {
    _images.clear();
    _images.addAll(images);
    notifyListeners();
  }

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
    images.clear();
    notifyListeners();
  }

  Future<d.Either<ApiSuccess, String>> editPost(String title, String body, String id) async {
    _api.cancelCurrReq();
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    _api.setMultipart(false);
    final response = await _api.req(Verb.patch, true, "/api/v1/posts/edit", {
      "post_id": id,
      "title": title,
      "body": body,
    });

    return response.fold(
      (failureWithMsg) => d.Right(failureWithMsg.msg()),
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
            sl.get<GlobalContentService>().setPost(post);
            return d.Left(ApiSuccess());
          } catch (_) {
            return const d.Right("Confession created, but unable to load locally");
          }
        } else {
          // todo: fill in the appropriate error message
          return d.Right(response.body);
        }
      },
    );
  }

  Future<d.Either<ApiSuccess, String>> createNewPost(
    String title,
    String body,
    String category,
    List<File> files,
    bool isChatPost,
  ) async {
    _api.cancelCurrReq();
    _api.setTimeout(const Duration(seconds: 45));
    metaState = CreatingEditingPostMetaStateLoading();
    notifyListeners();
    _api.setMultipart(true);
    final validation = eitherNotEmptyValidator(title, body);
    if (validation.isLeft()) {
      return const d.Right("Can't submit empty confession");
    }

    final response = await _api.req(
      Verb.post,
      true,
      "/api/v1/posts/create",
      {
        "title": title,
        "body": body,
        "category": category,
        "is_chat_post": isChatPost,
      },
      files: Map.fromEntries(files.map((e) => MapEntry(e.path, e))),
    );

    return response.fold(
      (failureWithMsg) => d.Right(failureWithMsg.msg()),
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          try {
            final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
            sl.get<GlobalContentService>().setPost(post);
            return d.Left(ApiSuccess());
          } catch (_) {
            return const d.Right("Confession edited, but unable to update locally");
          }
        } else {
          // todo: fill in the appropriate error message
          return d.Right(response.body);
        }
      },
    );
  }
}
