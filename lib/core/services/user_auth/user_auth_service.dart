import 'package:confesi/application/user/cubit/awards_cubit.dart';
import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/services/rooms/rooms_service.dart';
import 'package:confesi/presentation/dms/screens/home.dart';
import 'package:provider/provider.dart';

import '../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../application/comments/cubit/comment_section_cubit.dart';
import '../../../application/comments/cubit/create_comment_cubit.dart';
import '../../../application/create_post/cubit/post_categories_cubit.dart';
import '../../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../../application/feed/cubit/schools_drawer_cubit.dart';
import '../../../application/feed/cubit/search_schools_cubit.dart';
import '../../../application/feed/cubit/sentiment_analysis_cubit.dart';
import '../../../application/leaderboard/cubit/leaderboard_cubit.dart';
import '../../../application/posts/cubit/individual_post_cubit.dart';
import '../../../application/user/cubit/account_details_cubit.dart';
import '../../../application/user/cubit/feedback_categories_cubit.dart';
import '../../../application/user/cubit/feedback_cubit.dart';
import '../../../application/user/cubit/notifications_cubit.dart';
import '../../../application/user/cubit/quick_actions_cubit.dart';
import '../../../application/user/cubit/saved_posts_cubit.dart';
import '../../../application/user/cubit/stats_cubit.dart';
import '../creating_and_editing_posts_service/create_edit_posts_service.dart';
import '../hive_client/hive_client.dart';
import 'package:uuid/uuid.dart';

import '../posts_service/posts_service.dart';
import '../primary_tab_service/primary_tab_service.dart';
import 'user_auth_data.dart';
import 'package:flutter/cupertino.dart';

import '../../../init.dart';

class UserAuthService extends ChangeNotifier {
  UserAuthState state = UserAuthLoading();
  bool isAnon = true;
  String email = "";
  String uid = "";
  String baseSessionKey = "";
  String sessionKeyTrending = "";
  String sessionKeyRecents = "";
  String sessionKeySentiment = "";

  void setSessionKeys() {
    _setBaseSessionKey();
    _setSessionKeyTrending();
    _setSessionKeyRecents();
    _setSessionKeySentiment();
  }

  void _setBaseSessionKey() => baseSessionKey = sl.get<Uuid>().v4();
  void _setSessionKeyTrending() => sessionKeyTrending = sl.get<Uuid>().v4();
  void _setSessionKeyRecents() => sessionKeyRecents = sl.get<Uuid>().v4();
  void _setSessionKeySentiment() => sessionKeySentiment = sl.get<Uuid>().v4();

  // default data
  UserAuthData get def => UserAuthData();

  UserAuthData data() {
    if (state is UserAuthData) return state as UserAuthData;
    return def;
  }

  HiveService hive;
  UserAuthService(this.hive);

  void setNoDataState() {
    state = UserAuthNoData();
    notifyListeners();
  }

  Future<void> saveData(UserAuthData user) async {
    try {
      hive.openBoxByClass<UserAuthData>().then((box) async => await box.put(uid, user));
      state = user;
    } catch (_) {
      state = UserAuthError();
    }
    notifyListeners();
  }

  void clearCurrentExtraData() {
    isAnon = true;
    email = "";
    uid = "";
    baseSessionKey = "";
    sessionKeyTrending = "";
    sessionKeyRecents = "";
    sessionKeySentiment = "";
    notifyListeners();
  }

  void reloadAppStateThatNeedsAuth(BuildContext context) {
    context.read<SchoolsDrawerCubit>().loadSchools();
    context.read<StatsCubit>().loadStats();
  }

  /// Clears every state in the app so that the user can start fresh.
  void clearAllAppState(BuildContext context) {
    clearCurrentExtraData();
    sl.get<GlobalContentService>().clear();
    sl.get<CreateCommentService>().clear();
    sl.get<PostsService>().clearRecentsPosts();
    sl.get<PostsService>().clearSentimentPosts();
    sl.get<PostsService>().clearTrendingPosts();
    sl.get<PrimaryTabControllerService>().setTabIdx(0);
    sl.get<CreatingEditingPostsService>().clear();
    // Assuming sl is your service locator and all these Cubits are registered within it
    sl.get<RoomsService>().clear();
    sl.get<HottestCubit>().clear();
    sl.get<LeaderboardCubit>().clear();
    sl.get<AuthFlowCubit>().clear();
    sl.get<AccountDetailsCubit>().clear();
    sl.get<FeedbackCubit>().clear();
    sl.get<FeedbackCategoriesCubit>().clear();
    sl.get<StatsCubit>().clear();
    sl.get<SearchSchoolsCubit>().clear();
    sl.get<SavedPostsCubit>().clear();
    sl.get<SchoolsDrawerCubit>().clear();
    sl.get<QuickActionsCubit>().clear();
    sl.get<NotificationsCubit>().clear();
    sl.get<CommentSectionCubit>().clear();
    sl.get<CreateCommentCubit>().clear();
    sl.get<IndividualPostCubit>().clear();
    sl.get<AwardsCubit>().clear();
  }

  void loadAllAppState(BuildContext context) {
    print("LOADING ALL");
  }

  Future<void> getData(String uid) async {
    try {
      final box = await hive.openBoxByClass<UserAuthData>(); // Use await here
      final user = box.get(uid);
      if (user == null) {
        // default
        state = def;
      } else {
        // return the user
        state = user;
      }
    } catch (_) {
      state = UserAuthError();
    }
    notifyListeners();
  }
}

mixin class UserAuthState {}

class UserAuthError extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}
