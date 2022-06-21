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
  error,
  loading,
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
    required this.refAccessToken,
  });

  final FeedStatus feedStatus;
  final String refAccessToken;
  final List<Widget> feedPosts;
  final bool postsCurrentlyLoading;
  final bool hasMorePosts;

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
    );
  }
}

class ExploreFeedNotifier extends StateNotifier<ExploreFeedState> {
  ExploreFeedNotifier({
    required this.accessToken,
  }) : super(ExploreFeedState(refAccessToken: accessToken));

  final String accessToken;

  void getPostsError(ErrorType errorType) {
    state = state.copyWith(newFeedStatus: FeedStatus.error);
    if (errorType == ErrorType.connectionError) {
      state = state.copyWith(newConnectionErrorFLAG: !state.connectionErrorFLAG);
    } else {
      state = state.copyWith(newServerErrorFLAG: !state.serverErrorFLAG);
    }
  }

  Future<void> getPosts(String accessToken) async {
    print("<===== GET GET GET =====>");
    state = state.copyWith(
        newFeedStatus: state.feedPosts.isNotEmpty ? FeedStatus.data : FeedStatus.loading);
    await Future.delayed(const Duration(milliseconds: 400));
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
        print([
          const SizedBox(height: 15),
          ...state.feedPosts.skip(1),
          ...postsToAdd,
        ]);
        state = state.copyWith(newFeedStatus: FeedStatus.data, newFeedPosts: [
          const SizedBox(height: 15),
          ...state.feedPosts.skip(1),
          ...postsToAdd,
        ]);
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
  final accessToken = ref.watch(tokenProvider).accessToken;
  return ExploreFeedNotifier(accessToken: accessToken);
});
