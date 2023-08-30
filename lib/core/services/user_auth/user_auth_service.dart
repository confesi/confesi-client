import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
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

  final HiveService hive;
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
    Provider.of<GlobalContentService>(context, listen: false).clear();
    Provider.of<CreateCommentService>(context, listen: false).clear();
    Provider.of<PostsService>(context, listen: false).clearRecentsPosts();
    Provider.of<PostsService>(context, listen: false).clearSentimentPosts();
    Provider.of<PostsService>(context, listen: false).clearTrendingPosts();
    Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(0);
    Provider.of<CreatingEditingPostsService>(context, listen: false).clear();
    context.read<HottestCubit>().clear();
    context.read<LeaderboardCubit>().clear();
    context.read<AuthFlowCubit>().clear();
    context.read<AccountDetailsCubit>().clear();
    context.read<FeedbackCubit>().clear();
    context.read<FeedbackCategoriesCubit>().clear();
    context.read<StatsCubit>().clear();
    context.read<SearchSchoolsCubit>().clear();
    context.read<SavedPostsCubit>().clear();
    context.read<SchoolsDrawerCubit>().clear();
    context.read<QuickActionsCubit>().clear();
    context.read<NotificationsCubit>().clear();
    context.read<CommentSectionCubit>().clear();
    context.read<CreateCommentCubit>().clear();
    context.read<IndividualPostCubit>().clear();
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
