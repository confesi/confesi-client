import 'dart:convert';

import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:flutter/material.dart';

import '../../../application/user/cubit/saved_posts_cubit.dart';
import '../../../init.dart';
import '../../../models/post.dart';
import '../../clients/api.dart';
import '../global_content/global_content.dart';

enum FeedType { trending, recents, sentiment }

class PostsService extends ChangeNotifier {
  final Api _trendingApi;
  final Api _recentsApi;
  final Api _sentimentApi;

  PostsService(this._trendingApi, this._recentsApi, this._sentimentApi);

  List<int> trendingPostIds = [];
  List<int> recentsPostIds = [];
  List<int> sentimentPostIds = [];
  PaginationState trendingPaginationState = PaginationState.loading;
  PaginationState recentsPaginationState = PaginationState.loading;
  PaginationState sentimentPaginationState = PaginationState.loading;

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

  void _addIdsToList(FeedType feedType, List<int> postIds) {
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

  Future<void> loadMore(FeedType feedType, int schoolId, {bool refresh = false, bool allSchools = false}) async {
    _cancelCurrentReq(feedType);
    _updateFeedState(feedType, PaginationState.loading);
    notifyListeners();
    (await _apiClient(feedType).req(
      Verb.get,
      true,
      "/api/v1/posts/posts",
      {
        "purge_cache": refresh,
        "sort": _sort(feedType),
        "school_id": schoolId,
        "session_key": _sessionKey(feedType),
        "all_schools": allSchools,
      },
    ))
        .fold(
      (failureWithMsg) {
        _updateFeedState(feedType, PaginationState.error);
        notifyListeners();
      },
      (response) {
        if (response.statusCode.toString()[0] == "2") {
          // success
          final posts = (json.decode(response.body)["value"] as List).map((i) => Post.fromJson(i)).toList();
          sl.get<GlobalContentService>().setPosts(posts);
          _addIdsToList(feedType, posts.map((e) => e.id).toList());
          if (posts.length < postsPageSize) {
            // end
            _updateFeedState(feedType, PaginationState.end);
          } else {
            // still get ready to load more
            _updateFeedState(feedType, PaginationState.loading);
          }
          notifyListeners();
        } else {
          // failure
          _updateFeedState(feedType, PaginationState.error);
          notifyListeners();
        }
      },
    );
  }
}
