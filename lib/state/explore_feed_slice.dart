import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum FeedStatus {
  loading,
  error,
  data,
}

enum ErrorType {
  serverError,
  connectionError,
}

@immutable
class ExploreFeedState {
  const ExploreFeedState({
    this.connectionErrorFLAG = false,
    this.serverErrorFLAG = false,
    this.feedStatus = FeedStatus.loading,
    this.feedPosts = const [],
  });

  final FeedStatus feedStatus;
  final List<Widget> feedPosts;

  // flags that I can toggle (value doesn't matter) to get snackbar error message to show up
  final bool connectionErrorFLAG;
  final bool serverErrorFLAG;

  ExploreFeedState copyWith({
    FeedStatus? newFeedStatus,
    List<Widget>? newFeedPosts,
    bool? newServerErrorFLAG,
    bool? newConnectionErrorFLAG,
  }) {
    return ExploreFeedState(
      feedStatus: newFeedStatus ?? feedStatus,
      feedPosts: newFeedPosts ?? feedPosts,
      connectionErrorFLAG: newConnectionErrorFLAG ?? connectionErrorFLAG,
      serverErrorFLAG: newServerErrorFLAG ?? serverErrorFLAG,
    );
  }
}

class ExploreFeedNotifier extends StateNotifier<ExploreFeedState> {
  ExploreFeedNotifier() : super(const ExploreFeedState());

  void getPostsError(ErrorType errorType) {
    if (state.feedPosts.isEmpty) {
      // If the feed is empty (first load) then just show an error message + refresh button
      state = state.copyWith(newFeedStatus: FeedStatus.error);
    } else {
      // If the feed already has some posts, then show a snackbar error (shown via listener that picks up on toggle change)
      if (errorType == ErrorType.connectionError) {
        state = state.copyWith(newConnectionErrorFLAG: !state.connectionErrorFLAG);
      } else {
        state = state.copyWith(newServerErrorFLAG: !state.serverErrorFLAG);
      }
    }
  }

  Future<void> getPosts(String accessToken) async {
    // If we are calling this from an error state (meaning we clicked "reload again" or something) then
    // we want to show a spinner (results from setting to loading state).
    if (state.feedStatus == FeedStatus.error) {
      // Make it appear it's loading
      state = state.copyWith(newFeedStatus: FeedStatus.loading);
      await Future.delayed(const Duration(milliseconds: 400));
    }
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/posts/retrieve'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(<String, dynamic>{
              "number_of_posts": 20,
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        print("200");
        final posts = json.decode(response.body)["posts"];
        List<dynamic> postsToAdd = [];
        for (var post in posts) {
          postsToAdd.add(
            PostTile(
              icon: CupertinoIcons.flame,
              date: "Dec 14, 9:04am",
              faculty: "engineering",
              genre: "Relationships",
              body: post["text"],
              likes: 31,
              dislikes: 1,
              comments: 999,
            ),
          );
        }
        state = state.copyWith(
            newFeedStatus: FeedStatus.data,
            newFeedPosts: [const SizedBox(height: 15), ...postsToAdd, ...state.feedPosts]);
      } else {
        getPostsError(ErrorType.serverError);
      }
    } on TimeoutException {
      getPostsError(ErrorType.connectionError);
    } on SocketException {
      getPostsError(ErrorType.connectionError);
    } catch (error) {
      getPostsError(ErrorType.serverError);
    }
  }
}

final exploreFeedProvider = StateNotifierProvider<ExploreFeedNotifier, ExploreFeedState>((ref) {
  return ExploreFeedNotifier();
});
