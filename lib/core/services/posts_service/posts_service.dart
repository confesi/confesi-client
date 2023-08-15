import 'dart:convert';

import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ordered_set/ordered_set.dart';

import '../../../application/feed/cubit/schools_drawer_cubit.dart';
import '../../../application/user/cubit/saved_posts_cubit.dart';
import '../../../init.dart';
import '../../../models/post.dart';
import '../../results/successes.dart';
import '../api_client/api.dart';
import '../global_content/global_content.dart';

enum FeedType { trending, recents, sentiment }

class PostsService extends ChangeNotifier {
  final Api _trendingApi;
  final Api _recentsApi;
  final Api _sentimentApi;

  PostsService(this._trendingApi, this._recentsApi, this._sentimentApi);

  List<EncryptedId> trendingPostIds = [];
  List<EncryptedId> recentsPostIds = [];
  List<EncryptedId> sentimentPostIds = [];
  PaginationState trendingPaginationState = PaginationState.loading;
  PaginationState recentsPaginationState = PaginationState.loading;
  PaginationState sentimentPaginationState = PaginationState.loading;

  Future<Either<ApiSuccess, String>> deletePost(PostWithMetadata post) async {
    final oldPost = post;
    sl.get<GlobalContentService>().removePost(oldPost.post.id);
    return (await Api().req(Verb.patch, true, "/api/v1/posts/hide", {"post_id": post.post.id.mid})).fold(
      (failureWithMsg) {
        sl.get<GlobalContentService>().setPost(oldPost);
        return Right(failureWithMsg.msg());
      },
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          return Left(ApiSuccess());
        } else {
          sl.get<GlobalContentService>().setPost(oldPost);
          return const Right("Something went wrong");
        }
      },
    );
  }

  void _cancelCurrentReq(FeedType feedType) {
    switch (feedType) {
      case FeedType.trending:
        _trendingApi.cancelCurrReq();
        break;
      case FeedType.recents:
        _recentsApi.cancelCurrReq();
        break;
      case FeedType.sentiment:
        _sentimentApi.cancelCurrReq();
        break;
    }
  }

  void _updateFeedState(FeedType feedType, PaginationState paginationState) {
    switch (feedType) {
      case FeedType.trending:
        trendingPaginationState = paginationState;
        break;
      case FeedType.recents:
        recentsPaginationState = paginationState;
        break;
      case FeedType.sentiment:
        sentimentPaginationState = paginationState;
        break;
    }
  }

  Api _apiClient(FeedType feedType) {
    switch (feedType) {
      case FeedType.trending:
        return _trendingApi;
      case FeedType.recents:
        return _recentsApi;
      case FeedType.sentiment:
        return _sentimentApi;
    }
  }

  void _addIdsToList(FeedType feedType, List<EncryptedId> postIds) {
    OrderedSet<EncryptedId> ids = OrderedSet<EncryptedId>(); // Convert List to OrderedSet
    ids.addAll(postIds.reversed);

    switch (feedType) {
      case FeedType.trending:
        trendingPostIds.addAll(postIds);
        break;
      case FeedType.recents:
        recentsPostIds.addAll(postIds);
        break;
      case FeedType.sentiment:
        sentimentPostIds.addAll(postIds);
        break;
    }
  }

  String _sort(FeedType feedType) {
    switch (feedType) {
      case FeedType.trending:
        return "trending";
      case FeedType.recents:
        return "new";
      case FeedType.sentiment:
        return "sentiment";
    }
  }

  String _sessionKey(FeedType feedType) {
    switch (feedType) {
      case FeedType.trending:
        return sl.get<UserAuthService>().sessionKeyTrending;
      case FeedType.recents:
        return sl.get<UserAuthService>().sessionKeyRecents;
      case FeedType.sentiment:
        return sl.get<UserAuthService>().sessionKeySentiment;
    }
  }

  void _clearPosts(FeedType feedType) {
    switch (feedType) {
      case FeedType.trending:
        trendingPostIds.clear();
        break;
      case FeedType.recents:
        recentsPostIds.clear();
        break;
      case FeedType.sentiment:
        sentimentPostIds.clear();
        break;
    }
  }

  void clearTrendingPosts() => trendingPostIds.clear();

  void clearRecentsPosts() => recentsPostIds.clear();

  void clearSentimentPosts() => sentimentPostIds.clear();

  void reloadAllFeeds() {
    // set pagination states to loading
    trendingPaginationState = PaginationState.loading;
    recentsPaginationState = PaginationState.loading;
    sentimentPaginationState = PaginationState.loading;
    clearTrendingPosts();
    clearRecentsPosts();
    clearSentimentPosts();
    notifyListeners();
  }

  void notify() => notifyListeners();

  Future<void> loadMore(FeedType feedType, SelectedSchoolFeed selectedType, {bool refresh = false}) async {
    _cancelCurrentReq(feedType);
    if (refresh) {
      _clearPosts(feedType);
    }
    (await _apiClient(feedType).req(
      Verb.get,
      true,
      "/api/v1/posts/posts",
      {
        "purge_cache": refresh,
        "sort": _sort(feedType),
        "school_id": selectedType is SelectedSchool ? selectedType.id.mid : null,
        "session_key": _sessionKey(feedType),
        "all_schools": selectedType is SelectedAll,
      },
    ))
        .fold(
      (failureWithMsg) {
        _updateFeedState(feedType, PaginationState.error);
        notifyListeners();
      },
      (response) {
        try {
          if (response.statusCode.toString()[0] == "2") {
            // success
            final posts =
                (json.decode(response.body)["value"] as List).map((i) => PostWithMetadata.fromJson(i)).toList();
            _addIdsToList(feedType, posts.map((e) => e.post.id).toList());

            sl.get<GlobalContentService>().setPosts(posts);

            if (posts.length < postsPageSize) {
              // end
              _updateFeedState(feedType, PaginationState.end);
            } else {
              // still get ready to load more
              _updateFeedState(feedType, PaginationState.loading);
            }
          } else {
            // failure
            _updateFeedState(feedType, PaginationState.error);
          }
        } catch (e) {
          _updateFeedState(feedType, PaginationState.error);
        }
        notifyListeners();
      },
    );
  }
}
