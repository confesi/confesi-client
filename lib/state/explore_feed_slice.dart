import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

const kNumberOfPostsToLoad = 1;

@immutable
class ExploreFeedState {
  const ExploreFeedState({
    this.connectionErrorFLAG = false,
    this.serverErrorFLAG = false,
    this.feedPosts = const [],
    this.postsCurrentlyLoading = false,
    this.hasMorePosts = true,
    required this.refAccessToken,
  });

  final String refAccessToken;
  final List<Widget> feedPosts;
  final bool postsCurrentlyLoading;
  final bool hasMorePosts;

  // flags that I can toggle (value doesn't matter) to get snackbar error message to show up
  final bool connectionErrorFLAG;
  final bool serverErrorFLAG;

  ExploreFeedState copyWith({
    List<Widget>? newFeedPosts,
    bool? newServerErrorFLAG,
    bool? newConnectionErrorFLAG,
    String? newRefAccessToken,
  }) {
    return ExploreFeedState(
      refAccessToken: newRefAccessToken ?? refAccessToken,
      feedPosts: newFeedPosts ?? feedPosts,
      connectionErrorFLAG: newConnectionErrorFLAG ?? connectionErrorFLAG,
      serverErrorFLAG: newServerErrorFLAG ?? serverErrorFLAG,
    );
  }
}

class ExploreFeedNotifier extends StateNotifier<ExploreFeedState> {
  ExploreFeedNotifier({
    required this.accessToken,
  }) : super(ExploreFeedState(refAccessToken: accessToken));

  final String accessToken;

  void getPostsError() {
    state = state.copyWith();
  }

  Future<void> getPosts(String accessToken) async {
    if (state.postsCurrentlyLoading) return;
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
          state = state.copyWith();
        } else {
          state = state.copyWith();
        }
        List<Widget> postsToAdd = [];
        for (var post in posts) {
          postsToAdd.add(
            PostTile(
              icon: CupertinoIcons.flame,
              date: "Dec 14, 9:04am",
              faculty: "engineering",
              genre: "Relationships",
              body: post == posts.last ? "LAST LAST LAST LAST LAST LAST" : post["text"],
              likes: 31,
              dislikes: 1,
              comments: 999,
            ),
          );
        }
        // state = state.copyWith(
        //     newFeedPosts: loadingType == LoadingType.morePosts
        //         ? [
        //             const SizedBox(height: 15),
        //             ...state.feedPosts.skip(1),
        //             ...postsToAdd,
        //           ]
        //         : [
        //             const SizedBox(height: 15),
        //             ...postsToAdd,
        //           ]);
      } else {
        state = state.copyWith();
        getPostsError();
      }
    } on TimeoutException {
      state = state.copyWith();
      getPostsError();
    } on SocketException {
      state = state.copyWith();
      getPostsError();
    } catch (error) {
      state = state.copyWith();
      getPostsError();
    }
  }
}

final exploreFeedProvider = StateNotifierProvider<ExploreFeedNotifier, ExploreFeedState>((ref) {
  final accessToken = ref.watch(tokenProvider).accessToken;
  return ExploreFeedNotifier(accessToken: accessToken);
});
