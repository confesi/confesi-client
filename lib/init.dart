import 'dart:async';
import 'dart:ui';
import 'package:confesi/core/services/fcm_notifications/token_data.dart';

import 'application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'application/feed/cubit/sentiment_analysis_cubit.dart';
import 'core/services/create_post_hint_text/create_post_hint_text.dart';
import 'core/services/remote_config/remote_config.dart';
import 'core/services/user_auth/user_auth_data.dart';
import 'core/services/user_auth/user_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'application/shared/cubit/maps_cubit.dart';
import 'core/services/hive/hive_client.dart';
import 'domain/feed/usecases/launch_maps.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/fcm_notifications/notification_service.dart';
import 'domain/shared/usecases/share_content.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'core/clients/api_client.dart';
import 'domain/authentication_and_settings/usecases/open_device_settings.dart';
import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'data/create_post/datasources/create_post_datasource.dart';
import 'data/create_post/repositories/create_post_repository_concrete.dart';
import 'data/daily_hottest/datasources/daily_hottest_datasource.dart';
import 'data/leaderboard/datasources/leaderboard_datasource.dart';
import 'data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import 'data/leaderboard/repositories/leaderboard_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/copy_email_text.dart';
import 'domain/authentication_and_settings/usecases/launch_website.dart';
import 'domain/authentication_and_settings/usecases/open_mail_client.dart';
import 'domain/create_post/usecases/upload_post.dart';
import 'domain/daily_hottest/usecases/posts.dart';
import 'domain/leaderboard/usecases/ranking.dart';
import 'domain/profile/usecases/biometric_authentication.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'core/network/connection_info.dart';
import 'data/authentication_and_settings/datasources/authentication_datasource.dart';
import 'data/authentication_and_settings/repositories/authentication_repository_concrete.dart';
import 'data/feed/datasources/feed_datasource.dart';
import 'data/feed/repositories/feed_repository_concrete.dart';
import 'domain/feed/usecases/recents.dart';
import 'domain/feed/usecases/trending.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';
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
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
  );
}

/// Injects the needed dependencies for the app to run.
Future<void> init() async {
  //! Required first inits
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => LocalAuthentication());

  //! Already-singletons
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => ApiClient());
  HiveService hiveService = HiveService(sl());
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);

  //! Services
  UserAuthService userAuthService = UserAuthService(sl());
  userAuthService.hive.registerAdapter<UserAuthData>(UserAuthDataAdapter());
  userAuthService.hive.registerAdapter(ThemePrefAdapter());
  userAuthService.hive.registerAdapter(FcmTokenAdapter());
  sl.registerLazySingleton(() => userAuthService);
  sl.registerLazySingleton(() => NotificationService()..init());
  sl.registerLazySingleton(() => CreatePostHintManager());

  //! State (BLoC or Cubit)  // // Registers the authentication cubit.
  sl.registerFactory(() => RecentsCubit(recents: sl()));
  sl.registerFactory(() => SentimentAnalysisCubit());
  sl.registerFactory(() => TrendingCubit(trending: sl()));
  sl.registerFactory(() => LeaderboardCubit(ranking: sl()));
  sl.registerFactory(() => AuthFlowCubit());
  sl.registerFactory(() => HottestCubit(posts: sl()));
  sl.registerFactory(() => CreatePostCubit(uploadPost: sl()));
  sl.registerFactory(() => ContactSettingCubit(copyEmailTextUsecase: sl(), openMailClientUsecase: sl()));
  sl.registerFactory(() => WebsiteLauncherCubit(launchWebsiteUsecase: sl()));
  sl.registerFactory(() => LanguageSettingCubit(openDeviceSettingsUsecase: sl()));
  sl.registerFactory(() => MapsCubit(launchMapUsecase: sl()));
  sl.registerFactory(() => ShareCubit(shareContentUsecase: sl()));

  //! Usecases
  sl.registerLazySingleton(() => Recents(repository: sl()));
  sl.registerLazySingleton(() => Trending(repository: sl()));
  sl.registerLazySingleton(() => Ranking(repository: sl()));
  sl.registerLazySingleton(() => Posts(repository: sl()));
  sl.registerLazySingleton(() => UploadPost(repository: sl()));
  sl.registerLazySingleton(() => BiometricAuthentication(localAuthentication: sl()));
  sl.registerLazySingleton(() => OpenMailClient());
  sl.registerLazySingleton(() => CopyEmailText());
  sl.registerLazySingleton(() => LaunchWebsite());
  sl.registerLazySingleton(() => OpenDeviceSettings());
  sl.registerLazySingleton(() => ShareContent());
  sl.registerLazySingleton(() => LaunchMap());

  //! Repositories
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl(), datasource: sl()));
  sl.registerLazySingleton(() => FeedRepository(networkInfo: sl(), datasource: sl()));
  sl.registerLazySingleton(() => LeaderboardRepository(networkInfo: sl(), datasource: sl()));
  sl.registerLazySingleton(() => DailyHottestRepository(networkInfo: sl(), datasource: sl()));
  sl.registerLazySingleton(() => CreatePostRepository(networkInfo: sl(), datasource: sl()));

  //! Data sources
  sl.registerLazySingleton(() => AuthenticationDatasource(secureStorage: sl(), api: sl()));
  sl.registerLazySingleton(() => FeedDatasource(api: sl()));
  sl.registerLazySingleton(() => LeaderboardDatasource(api: sl()));
  sl.registerLazySingleton(() => DailyHottestDatasource(api: sl()));
  sl.registerLazySingleton(() => CreatePostDatasource(api: sl()));

  //! Firebase
  await initFirebase();
}
