import 'dart:async';
import 'dart:ui';
import 'package:confesi/core/services/fcm_notifications/token_data.dart';

import 'application/authentication_and_settings/cubit/auth_flow_cubit.dart';
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
import 'application/profile/cubit/biometrics_cubit.dart';
import 'domain/authentication_and_settings/usecases/load_refresh_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'core/network/connection_info.dart';
import 'data/authentication_and_settings/datasources/authentication_datasource.dart';
import 'data/authentication_and_settings/repositories/authentication_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/register.dart';
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
  // Registering Hive.

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  // Registers the package that allows us to use biometric authentication.
  sl.registerLazySingleton(() => LocalAuthentication());

  //! Already-singletons
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the custom api client class.
  sl.registerLazySingleton(() => ApiClient());
  // Registers the custom hive client class.
  HiveService hiveService = HiveService(sl());
  await hiveService.init();
  sl.registerLazySingleton(() => hiveService);

  //! Services
  UserAuthService userAuthService = UserAuthService(sl());
  userAuthService.hive.registerAdapter<UserAuthData>(UserAuthDataAdapter());
  userAuthService.hive.registerAdapter(ThemePrefAdapter());
  userAuthService.hive.registerAdapter(FcmTokenAdapter());
  sl.registerLazySingleton(() => userAuthService);
  // Registers notifications service.
  sl.registerLazySingleton(() => NotificationService()..init());

  //! State (BLoC or Cubit)  // // Registers the authentication cubit.
  // sl.registerFactory(() => AuthenticationCubit(register: sl(), login: sl(), logout: sl(), silentAuthentication: sl()));
  // Registers the recents cubit.
  sl.registerFactory(() => RecentsCubit(recents: sl()));
  // Registers the trending cubit.
  sl.registerFactory(() => TrendingCubit(trending: sl()));
  // Registers the leaderboard cubit.
  sl.registerFactory(() => LeaderboardCubit(ranking: sl()));
  // Registers the auth flow cubit.
  sl.registerFactory(() => AuthFlowCubit());
  // Registers the daily hottest cubit.
  sl.registerFactory(() => HottestCubit(posts: sl()));
  // Registers the create post cubit.
  sl.registerFactory(() => CreatePostCubit(uploadPost: sl()));
  // Registers the biometrics cubit.
  sl.registerFactory(() => BiometricsCubit(biometricAuthentication: sl()));
  // Registers the prefs cubit.
  // sl.registerFactory(() => PrefsCubit(appearance: sl(), loadRefreshToken: sl(), firstTime: sl()));
  // Registers the contact setting cubit.
  sl.registerFactory(() => ContactSettingCubit(copyEmailTextUsecase: sl(), openMailClientUsecase: sl()));
  // Registers the cubit that launches the website viewer.
  sl.registerFactory(() => WebsiteLauncherCubit(launchWebsiteUsecase: sl()));
  // Registers the cubit that opens the device's system settings.
  sl.registerFactory(() => LanguageSettingCubit(openDeviceSettingsUsecase: sl()));
  // Registers the cubit that opens the device's native maps app.
  sl.registerFactory(() => MapsCubit(launchMapUsecase: sl()));
  // Registers the share cubit.
  sl.registerFactory(() => ShareCubit(shareContentUsecase: sl()));

  //! Usecases
  // Registers the register usecase.
  sl.registerLazySingleton(() => Register(repository: sl(), api: sl()));
  // Registers the recents feed usecase.
  sl.registerLazySingleton(() => Recents(repository: sl()));
  // Registers the trending feed usecase.
  sl.registerLazySingleton(() => Trending(repository: sl()));
  // Registers the leaderboard usecase.
  sl.registerLazySingleton(() => Ranking(repository: sl()));
  // Registers the daily hottest usecase.
  sl.registerLazySingleton(() => Posts(repository: sl()));
  // Registers the upload post usecase.
  sl.registerLazySingleton(() => UploadPost(repository: sl()));
  // Registers the biometric authentication usecase.
  sl.registerLazySingleton(() => BiometricAuthentication(localAuthentication: sl()));

  // Registers the usecase that opens the mail client.
  sl.registerLazySingleton(() => OpenMailClient());
  // Registers the usecase that copies the email text for support.
  sl.registerLazySingleton(() => CopyEmailText());
  // Registers the launching a website usecase.
  sl.registerLazySingleton(() => LaunchWebsite());
  // Registers the usecase that opens a device's system settings.
  sl.registerLazySingleton(() => OpenDeviceSettings());
  // Registers the share usecase.
  sl.registerLazySingleton(() => ShareContent());

  // Registers the usecase to open the device's native maps app.
  sl.registerLazySingleton(() => LaunchMap());

  //! Repositories
  // Registers the authentication repository.
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl(), datasource: sl()));
  // Registers the feed repository.
  sl.registerLazySingleton(() => FeedRepository(networkInfo: sl(), datasource: sl()));
  // Registers the leaderboard repository.
  sl.registerLazySingleton(() => LeaderboardRepository(networkInfo: sl(), datasource: sl()));
  // Registers the daily hottest repository.
  sl.registerLazySingleton(() => DailyHottestRepository(networkInfo: sl(), datasource: sl()));
  // Registers the create post repository.
  sl.registerLazySingleton(() => CreatePostRepository(networkInfo: sl(), datasource: sl()));

  //! Data sources
  // Registers the authentication datasource.
  sl.registerLazySingleton(() => AuthenticationDatasource(secureStorage: sl(), api: sl()));
  // Registers the feed datasource.
  sl.registerLazySingleton(() => FeedDatasource(api: sl()));
  // Registers the leaderboard datasource.
  sl.registerLazySingleton(() => LeaderboardDatasource(api: sl()));
  // Registers the daily hottest datasource.
  sl.registerLazySingleton(() => DailyHottestDatasource(api: sl()));
  // Registers the create post datasource.
  sl.registerLazySingleton(() => CreatePostDatasource(api: sl()));

  //! Firebase
  // Registering Firebase.
  await initFirebase();
}
