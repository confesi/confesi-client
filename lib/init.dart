import 'dart:async';
import 'dart:ui';
import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/application/user/cubit/account_details_cubit.dart';
import 'package:confesi/application/user/cubit/feedback_categories_cubit.dart';
import 'package:confesi/application/user/cubit/feedback_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/application/user/cubit/stats_cubit.dart';
import 'package:confesi/core/clients/api.dart';
import 'package:confesi/core/services/create_comment_service/create_comment_service.dart';
import 'package:confesi/core/services/fcm_notifications/token_data.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/core/utils/funcs/debouncer.dart';
import 'package:confesi/presentation/create_post/overlays/confetti_blaster.dart';
import 'package:uuid/uuid.dart';
import 'application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'application/comments/cubit/comment_section_cubit.dart';
import 'application/comments/cubit/create_comment_cubit.dart';
import 'application/feed/cubit/schools_drawer_cubit.dart';
import 'application/feed/cubit/search_schools_cubit.dart';
import 'application/feed/cubit/sentiment_analysis_cubit.dart';
import 'application/user/cubit/quick_actions_cubit.dart';
import 'application/user/cubit/saved_posts_cubit.dart';
import 'core/services/create_post_hint_text/create_post_hint_text.dart';
import 'core/services/posts_service/posts_service.dart';
import 'core/services/remote_config/remote_config.dart';
import 'core/services/sharing/sharing.dart';
import 'core/services/splash_screen_hint_text/splash_screen_hint_text.dart';
import 'core/services/user_auth/user_auth_data.dart';
import 'core/services/user_auth/user_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/services/hive/hive_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/fcm_notifications/notification_service.dart';

import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'core/network/connection_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

// Get the GetIt instance to use for injection
final GetIt sl = GetIt.instance;
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> initFirebase() async {
  // init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // remote config
  final remoteConfigService = RemoteConfigService(sl());
  await remoteConfigService.init();
  sl.registerLazySingleton(() => remoteConfigService);
  // appcheck
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.appAttest,
  // );
}

/// Injects the needed dependencies for the app to run.
Future<void> init() async {
  //! Required first inits
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //! Alt
  sl.registerLazySingleton(() => StreamController<User?>.broadcast());
  sl.registerLazySingleton(() => ConfettiBlaster());
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton(() => Debouncer());

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => LocalAuthentication());

  //! Already-singletons
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  HiveService hiveService = HiveService(sl());
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);

  //! Services
  UserAuthService userAuthService = UserAuthService(sl());
  GlobalContentService globalContentService = GlobalContentService(Api(), Api(), Api());
  PostsService postsService = PostsService(Api(), Api(), Api());
  CreateCommentService createCommentService = CreateCommentService();

  userAuthService.hive.registerAdapter<UserAuthData>(UserAuthDataAdapter());
  userAuthService.hive.registerAdapter(ThemePrefAdapter());
  userAuthService.hive.registerAdapter(UnitSystemAdapter());
  userAuthService.hive.registerAdapter(ProfanityFilterAdapter());
  userAuthService.hive.registerAdapter(FcmTokenAdapter());
  sl.registerLazySingleton(() => userAuthService);
  sl.registerLazySingleton(() => globalContentService);
  sl.registerLazySingleton(() => postsService);
  sl.registerLazySingleton(() => createCommentService);
  sl.registerLazySingleton(() => NotificationService()..init());
  sl.registerLazySingleton(() => CreatePostHintManager());
  sl.registerLazySingleton(() => SplashScreenHintManager());
  sl.registerLazySingleton(() => Sharing());

  //! State (BLoC or Cubit)
  sl.registerFactory(() => SentimentAnalysisCubit());
  sl.registerFactory(() => LeaderboardCubit(Api()));
  sl.registerFactory(() => AuthFlowCubit());
  sl.registerFactory(() => HottestCubit());
  sl.registerFactory(() => CreatePostCubit());
  sl.registerFactory(() => PostCategoriesCubit());
  sl.registerFactory(() => AccountDetailsCubit());
  sl.registerFactory(() => FeedbackCubit());
  sl.registerFactory(() => FeedbackCategoriesCubit());
  sl.registerFactory(() => StatsCubit());
  sl.registerFactory(() => SchoolsDrawerCubit(Api()));
  sl.registerFactory(() => SearchSchoolsCubit(Api()));
  sl.registerFactory(() => SavedPostsCubit(Api()));
  sl.registerFactory(() => QuickActionsCubit(sl()));
  sl.registerFactory(() => NotificationsCubit());
  sl.registerFactory(() => CommentSectionCubit(Api(), Api(), Api()));
  sl.registerFactory(() => CreateCommentCubit());

  //! Firebase
  await initFirebase();
}
