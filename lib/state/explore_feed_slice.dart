import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const kNumberOfPostsToLoad = 2;

enum FeedStatus {
  loading,
  error,
  data,
}

enum ErrorType {
  serverError,
  connectionError,
}

enum LoadingType {
  refresh,
  morePosts,
}

@immutable
class ExploreFeedState {
  const ExploreFeedState({
    this.connectionErrorFLAG = false,
    this.serverErrorFLAG = false,
    this.feedStatus = FeedStatus.loading,
    this.feedPosts = const [],
    this.postsCurrentlyLoading = false,
    this.hasMorePosts = true,
    this.error = false,
    required this.refAccessToken,
  });

  final FeedStatus feedStatus;
  final String refAccessToken;
  final List<Widget> feedPosts;
  final bool postsCurrentlyLoading;
  final bool hasMorePosts;
  final bool error;

  // flags that I can toggle (value doesn't matter) to get snackbar error message to show up
  final bool connectionErrorFLAG;
  final bool serverErrorFLAG;

  ExploreFeedState copyWith({
    FeedStatus? newFeedStatus,
    List<Widget>? newFeedPosts,
    bool? newServerErrorFLAG,
    bool? newConnectionErrorFLAG,
    bool? newPostsCurrentlyLoading,
    bool? newHasMorePosts,
    bool? newError,
    String? newRefAccessToken,
  }) {
    return ExploreFeedState(
      refAccessToken: newRefAccessToken ?? refAccessToken,
      postsCurrentlyLoading: newPostsCurrentlyLoading ?? postsCurrentlyLoading,
      feedStatus: newFeedStatus ?? feedStatus,
      feedPosts: newFeedPosts ?? feedPosts,
      connectionErrorFLAG: newConnectionErrorFLAG ?? connectionErrorFLAG,
      serverErrorFLAG: newServerErrorFLAG ?? serverErrorFLAG,
      hasMorePosts: newHasMorePosts ?? hasMorePosts,
      error: newError ?? error,
    );
  }
}

class ExploreFeedNotifier extends StateNotifier<ExploreFeedState> {
  ExploreFeedNotifier({
    required this.accessToken,
  }) : super(ExploreFeedState(refAccessToken: accessToken));

  final String accessToken;

  void getPostsError(ErrorType errorType) {
    if (state.feedPosts.isEmpty) {
      // If the feed is empty (first load) then just show an error message + refresh button
      state = state.copyWith(newFeedStatus: FeedStatus.error);
    } else {
      // If the feed already has some posts, then show a snackbar error (shown via listener that picks up on toggle change)
      if (errorType == ErrorType.connectionError) {
        state = state.copyWith(newFeedPosts: [
          ...state.feedPosts,
          ErrorWithButtonText(
              headerText: "Connection error",
              buttonText: "try again",
              onPress: () {
                print(accessToken);
                getPosts(accessToken, LoadingType.morePosts);
              })
        ]);
      } else {
        state = state.copyWith(newError: true);
      }
    }
  }

  Future<void> getPosts(String accessToken, LoadingType loadingType) async {
    print("state method for more posts called");
    // This prevents spamming the API while it is already loading.
    // if (state.postsCurrentlyLoading) return;
    // If we are calling this from an error state (meaning we clicked "reload again" or something) then
    // we want to show a spinner (results from setting to loading state).
    if (state.feedStatus == FeedStatus.error) {
      // Make it appear it's loading
      state = state.copyWith(newFeedStatus: FeedStatus.loading);
      await Future.delayed(const Duration(milliseconds: 400));
    }
    state = state.copyWith(newError: false); // newPostsCurrentlyLoading: true,
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/posts/retrieve'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(<String, dynamic>{
              "number_of_posts": kNumberOfPostsToLoad,
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        print("200");
        final posts = json.decode(response.body)["posts"];
        if (posts.length < kNumberOfPostsToLoad) {
          state = state.copyWith(newHasMorePosts: false);
        } else {
          state = state.copyWith(newHasMorePosts: true);
        }
        List<Widget> postsToAdd = [];
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
            newFeedPosts: loadingType == LoadingType.morePosts
                ? [
                    const SizedBox(height: 15),
                    ...state.feedPosts.skip(1),
                    ...postsToAdd,
                  ]
                : [const SizedBox(height: 15), ...postsToAdd]);
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
    // state = state.copyWith(newPostsCurrentlyLoading: false);
  }
}

final exploreFeedProvider = StateNotifierProvider<ExploreFeedNotifier, ExploreFeedState>((ref) {
  final accessToken = ref.watch(tokenProvider).accessToken;
  return ExploreFeedNotifier(accessToken: accessToken);
});
