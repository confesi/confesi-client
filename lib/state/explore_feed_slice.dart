import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/general.dart';
import '../models/feed/highlight.dart';
import '../models/feed/post.dart';
import '../widgets/tiles/highlight.dart';
import '../widgets/tiles/post.dart';

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
    this.lastSeenID = "",
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

  Future<void> fetchMorePosts(String accessToken) async {
    state = state.copyWith(newHasError: false, newNoMorePosts: false);
    await _getPosts(LoadPostsType.loadMore, accessToken);
  }

  Future<void> refreshPostsFullScreen(String accessToken) async {
    state =
        state.copyWith(newHasError: false, newNoMorePosts: false, newLastSeenID: "", newPosts: []);
    // as to not cause a janky screen
    await Future.delayed(const Duration(milliseconds: 400));
    await _getPosts(LoadPostsType.refresh, accessToken);
  }

  Future<void> refreshPosts(String accessToken) async {
    state = state.copyWith(newHasError: false, newNoMorePosts: false, newLastSeenID: "");
    await _getPosts(LoadPostsType.refresh, accessToken);
  }

  Future<void> _getPosts(LoadPostsType loadPostsType, String accessToken) async {
    if (state.currentlyFetching) return;
    state = state.copyWith(newCurrentlyFetching: true);
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/posts/recents'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(<String, dynamic>{
              "lastPostViewedID": state.lastSeenID,
              "last_post_viewed_ID": state.lastSeenID,
            }),
          )
          .timeout(const Duration(seconds: 2));
      state = state.copyWith(newCurrentlyFetching: false);
      if (response.statusCode == 200) {
        final posts = json.decode(response.body)["foundPosts"];
        if (posts.length < kNumberOfPostsToLoad) {
          state = state.copyWith(newNoMorePosts: true);
        } else {
          state = state.copyWith(newNoMorePosts: false);
        }
        dynamic decodedPosts = json.decode(response.body)["foundPosts"];
        List postsToAdd = decodedPosts
            .map(
              (post) => PostTile(
                replyingtoPost: Post.fromJson(post).year.toString(),
                date: Post.fromJson(post).date,
                icon: Post.fromJson(post).icon,
                faculty: Post.fromJson(post).faculty,
                genre: Post.fromJson(post).genre,
                text: Post.fromJson(post).text,
                comments: Post.fromJson(post).comments,
                votes: Post.fromJson(post).votes,
                year: Post.fromJson(post).year,
              ),
            )
            .toList();
        state = state.copyWith(
          newLastSeenID: decodedPosts.length >= 1 ? decodedPosts.last["_id"] : state.lastSeenID,
          newPosts: loadPostsType == LoadPostsType.loadMore
              ? [
                  ...state.posts,
                  ...postsToAdd,
                ]
              : [...postsToAdd],
        );
      } else {
        print("here1 + ${response.statusCode}");
        onRequestError(loadPostsType, RequestErrorType.serverError);
      }
    } on TimeoutException catch (e) {
      print("here2 $e");
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
