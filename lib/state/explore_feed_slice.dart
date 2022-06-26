import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/models/feed/post.dart';
import 'package:flutter_mobile_client/state/post_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

// ~IMPORTANT~ this value should be the same as the number of posts the server sends back
const kNumberOfPostsToLoad = 5;

enum LoadPostsType {
  refresh,
  loadMore,
}

enum RequestErrorType {
  connectionError,
  serverError,
}

@immutable
class ExploreFeedState {
  const ExploreFeedState({
    this.hasError = false,
    this.currentlyFetching = false,
    this.noMorePosts = false,
    this.connectionErrorFLAG = false,
    this.serverErrorFLAG = false,
    this.posts = const [],
    this.lastSeenID = "000000000000000000000000",
  });

  final List<Widget> posts;
  final bool currentlyFetching;
  final bool hasError;
  final bool noMorePosts;
  final String lastSeenID;

  // flags that I can toggle (value doesn't matter) to get snackbar error message to show up
  final bool connectionErrorFLAG;
  final bool serverErrorFLAG;

  ExploreFeedState copyWith({
    List<Widget>? newPosts,
    bool? newServerErrorFLAG,
    bool? newConnectionErrorFLAG,
    bool? newHasError,
    bool? newCurrentlyFetching,
    bool? newNoMorePosts,
    String? newLastSeenID,
  }) {
    return ExploreFeedState(
      lastSeenID: newLastSeenID ?? lastSeenID,
      posts: newPosts ?? posts,
      connectionErrorFLAG: newConnectionErrorFLAG ?? connectionErrorFLAG,
      serverErrorFLAG: newServerErrorFLAG ?? serverErrorFLAG,
      hasError: newHasError ?? hasError,
      currentlyFetching: newCurrentlyFetching ?? currentlyFetching,
      noMorePosts: newNoMorePosts ?? noMorePosts,
    );
  }
}

class ExploreFeedNotifier extends StateNotifier<ExploreFeedState> {
  ExploreFeedNotifier() : super(const ExploreFeedState());

  // on error set posts array to zero?
  void onRequestError(LoadPostsType loadPostsType, RequestErrorType requestErrorType) {
    state = state.copyWith(newHasError: true, newCurrentlyFetching: false);
    if (loadPostsType == LoadPostsType.refresh) {
      if (requestErrorType == RequestErrorType.connectionError) {
        state = state.copyWith(newConnectionErrorFLAG: !state.connectionErrorFLAG);
      } else {
        state = state.copyWith(newServerErrorFLAG: !state.serverErrorFLAG);
      }
    }
  }

  void resetLastSeenPostID() => state = state.copyWith(newLastSeenID: "000000000000000000000000");

  Future<void> fetchMorePosts(String accessToken) async {
    state = state.copyWith(newHasError: false, newNoMorePosts: false);
    await _getPosts(LoadPostsType.loadMore, accessToken);
  }

  Future<void> refreshPosts(String accessToken) async {
    resetLastSeenPostID();
    state = state.copyWith(newHasError: false, newNoMorePosts: false);
    await _getPosts(LoadPostsType.refresh, accessToken);
  }

  Future<void> _getPosts(LoadPostsType loadPostsType, String accessToken) async {
    if (state.currentlyFetching) return;
    state = state.copyWith(newCurrentlyFetching: true);
    print("<=========>");
    // if (loadPostsType == LoadPostsType.refresh) state = state.copyWith(newPosts: []);
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/posts/retrieve'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(<String, dynamic>{
              "last_post_viewed_id": state.lastSeenID,
            }),
          )
          .timeout(const Duration(seconds: 2));
      state = state.copyWith(newCurrentlyFetching: false);
      if (response.statusCode == 200) {
        final posts = json.decode(response.body)["posts"];
        if (posts.length < kNumberOfPostsToLoad) {
          print("uh oh, less than");
          state = state.copyWith(newNoMorePosts: true);
        } else {
          state = state.copyWith(newNoMorePosts: false);
        }
        dynamic decodedPosts = json.decode(response.body)["posts"];
        List postsToAdd = decodedPosts
            .map(
              (post) => PostTile(
                date: Post.fromJson(post).date,
                icon: Post.fromJson(post).icon,
                faculty: Post.fromJson(post).faculty,
                genre: Post.fromJson(post).genre,
                body: Post.fromJson(post).body,
                likes: Post.fromJson(post).likes,
                dislikes: Post.fromJson(post).dislikes,
                comments: Post.fromJson(post).comments,
              ),
            )
            .toList();
        state = state.copyWith(
          newLastSeenID: decodedPosts.length >= 1 ? decodedPosts.last["_id"] : state.lastSeenID,
          // newLastSeenID: decodedPosts.last["_id"] ?? state.lastSeenID,
          newPosts: loadPostsType == LoadPostsType.loadMore
              ? [
                  ...state.posts,
                  ...postsToAdd,
                ]
              : [
                  ...postsToAdd,
                ],
        );
      } else {
        print("here1");
        onRequestError(loadPostsType, RequestErrorType.serverError);
      }
    } on TimeoutException {
      print("here2");

      onRequestError(loadPostsType, RequestErrorType.connectionError);
    } on SocketException {
      print("here3");

      onRequestError(loadPostsType, RequestErrorType.connectionError);
    } catch (error) {
      print("here4: $error");

      onRequestError(loadPostsType, RequestErrorType.serverError);
    }
  }
}

final exploreFeedProvider = StateNotifierProvider<ExploreFeedNotifier, ExploreFeedState>((ref) {
  return ExploreFeedNotifier();
});
