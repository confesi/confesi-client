import 'dart:async';

import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/application/feed/cubit/sentiment_analysis_cubit.dart';
import 'package:confesi/application/user/cubit/feedback_categories_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:confesi/models/school.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';

import 'package:confesi/presentation/create_post/overlays/confetti_blaster.dart';

import 'application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import 'application/create_post/cubit/post_categories_cubit.dart';
import 'application/feed/cubit/search_schools_cubit.dart';
import 'application/user/cubit/account_details_cubit.dart';
import 'application/user/cubit/feedback_cubit.dart';
import 'application/user/cubit/quick_actions_cubit.dart';
import 'application/user/cubit/saved_posts_cubit.dart';
import 'application/user/cubit/stats_cubit.dart';
import 'core/services/hive/hive_client.dart';
import 'core/services/user_auth/user_auth_service.dart';
import 'models/school_with_metadata.dart';
import 'presentation/shared/overlays/notification_chip.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'application/leaderboard/cubit/leaderboard_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'core/router/go_router.dart';
import 'core/services/fcm_notifications/notification_service.dart';
import 'core/services/user_auth/user_auth_data.dart';
import 'core/styles/themes.dart';
import 'firebase_options.dart';
import 'init.dart';

// FCM background messager handler. Required to be top-level. Needs `pragma` to prevent function being moved during release compilation.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sl.get<NotificationService>().onMessage((p0) {
    print("backgroundMessage: $p0");
  });
}

void main() async => await init().then(
      (_) => analytics.logAppOpen().then(
            (value) => runApp(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => sl<UserAuthService>(), lazy: true),
                  ChangeNotifierProvider(create: (context) => sl<GlobalContentService>(), lazy: true),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(lazy: false, create: (context) => sl<SentimentAnalysisCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<CreatePostCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<PostCategoriesCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<HottestCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<LeaderboardCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<AuthFlowCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<AccountDetailsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<FeedbackCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<FeedbackCategoriesCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<StatsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<SearchSchoolsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<SavedPostsCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<SchoolsDrawerCubit>()),
                    BlocProvider(lazy: false, create: (context) => sl<QuickActionsCubit>()),
                  ],
                  child: debugMode && devicePreview
                      ? DevicePreview(builder: (context) => const ShrinkView())
                      : const ShrinkView(),
                ),
              ),
            ),
          ),
    );

class ShrinkView extends StatelessWidget {
  const ShrinkView({super.key});

  @override
  Widget build(BuildContext context) {
    // final data = Provider.of<UserAuthService>(context, listen: true).data();
    return Center(
      // Use a SizedBox to limit the width of the entire app
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        constraints: BoxConstraints(
            maxWidth: Provider.of<UserAuthService>(context).data().isShrunkView
                ? shrunkViewWidth
                : MediaQuery.of(context).size.width),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const MyApp(),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<User?>? _userChangeStream;
  bool firstOpen = true;

  @override
  void initState() {
    startFcmListener();
    startShakeForFeedbackListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAuthListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    sl.get<StreamController<User?>>().close();
    _userChangeStream?.cancel();
    sl.get<HiveService>().dispose();
    sl.get<NotificationService>().dispose();
    super.dispose();
  }

  bool shakeViewOpen = false;

  void startShakeForFeedbackListener() {
    ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!shakeViewOpen &&
            Provider.of<UserAuthService>(context, listen: false).data().shakeToGiveFeedback &&
            ModalRoute.of(context)?.settings.name != "/feedback") {
          shakeViewOpen = true;
          router.push("/settings/feedback").then((value) => shakeViewOpen = false);
        }
      },
      shakeThresholdGravity: 3,
      shakeCountResetTime: 1500,
      minimumShakeCount: 2,
    );
  }

  Future<void> startAuthListener() async {
    // clear user data
    sl.get<UserAuthService>().clearCurrentExtraData();
    sl.get<FirebaseAuth>().authStateChanges().listen((User? user) => sl.get<StreamController<User?>>().add(user));
    _userChangeStream = sl.get<StreamController<User?>>().stream.listen((User? user) async {
      sl.get<NotificationService>().updateToken(user?.uid);
      if (user == null) {
        firstOpen = true;
        await Future.delayed(const Duration(milliseconds: 500)).then((_) {
          sl.get<UserAuthService>().setNoDataState();
          HapticFeedback.lightImpact();
          router.go("/open");
          context.read<AuthFlowCubit>().emitDefault();
        });
      } else {
        await Future.delayed(const Duration(milliseconds: 500)).then(
          (_) async {
            sl.get<UserAuthService>().setNoDataState();
            await sl.get<UserAuthService>().getData(sl.get<FirebaseAuth>().currentUser!.uid).then((_) {
              if (sl.get<UserAuthService>().state is! UserAuthData) {
                router.go("/error");
                context.read<AuthFlowCubit>().emitDefault();
                return;
              }
              if (user.isAnonymous) {
                sl.get<UserAuthService>().isAnon = true;
                sl.get<UserAuthService>().uid = user.uid;
                sl.get<UserAuthService>().setNewSessionKey();
                router.go("/home");
              } else {
                sl.get<UserAuthService>().isAnon = false;
                sl.get<UserAuthService>().email = user.email!;
                sl.get<UserAuthService>().uid = user.uid;
                sl.get<UserAuthService>().setNewSessionKey();
                if (user.emailVerified) {
                  router.go("/home");
                } else {
                  router.go("/verify-email");
                }
              }
              context.read<AuthFlowCubit>().emitDefault();
              if (firstOpen) {
                context.read<SchoolsDrawerCubit>().loadWatchedSchools();
                firstOpen = false;
              }
            });
          },
        );
      }
    });
  }

  Future<void> startFcmListener() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    sl.get<NotificationService>().token.then((token) {
      token.fold((l) => print(l), (r) => print(r));
    });
    sl.get<NotificationService>().requestPermissions();
    await sl.get<NotificationService>().init();
    sl.get<NotificationService>().onMessage((msg) {
      print("onMessage: $msg");
    });
    sl.get<NotificationService>().onMessageOpenedInApp((msg) {
      print("onMessageOpenedApp: $msg");
    });
    sl
        .get<NotificationService>()
        .onTokenRefresh((token) => {}); // we don't care about this, since we have our own mechanism
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final data = Provider.of<UserAuthService>(context, listen: true).data();
        return BlocListener<AuthFlowCubit, AuthFlowState>(
          listenWhen: (previous, current) => true, // listen for every change
          listener: (context, state) {
            if (state is AuthFlowNotification) {
              showNotificationChip(context, state.message, notificationType: state.type);
            }
          },
          child: BlocListener<QuickActionsCubit, QuickActionsState>(
            listener: (context, state) {
              if (state is QuickActionsDefault && state.possibleErr is QuickActionsErr) {
                showNotificationChip(context, (state.possibleErr as QuickActionsErr).message);
              }
            },
            child: BlocListener<SearchSchoolsCubit, SearchSchoolsState>(
              listenWhen: (previous, current) => true,
              listener: (context, state) {
                if (state is SearchSchoolsData && state.possibleErr is SearchSchoolsErr) {
                  showNotificationChip(context, (state.possibleErr as SearchSchoolsErr).message);
                  final errState = (state.possibleErr as SearchSchoolsErr);
                  context
                      .read<SchoolsDrawerCubit>()
                      .resetSchoolInUI(errState.schoolId, errState.watched, errState.home);
                }
              },
              child: BlocListener<SchoolsDrawerCubit, SchoolsDrawerState>(
                listener: (context, state) {
                  if (state is SchoolsDrawerData && state.possibleErr is SchoolsDrawerErr) {
                    showNotificationChip(context, (state.possibleErr as SchoolsDrawerErr).message);
                  }
                },
                child: BlocListener<CreatePostCubit, CreatePostState>(
                  listener: (context, state) {
                    if (state is PostError) {
                      showNotificationChip(context, state.message);
                    } else if (state is PostSuccessfullySubmitted) {
                      sl.get<ConfettiBlaster>().show(context);
                      router.go("/home");
                      showNotificationChip(context, "Posted successfully", notificationType: NotificationType.success);
                    }
                  },
                  child: BlocListener<AccountDetailsCubit, AccountDetailsState>(
                    listener: (context, state) {
                      if (state is AccountDetailsTrueData && state.err is Err) {
                        showNotificationChip(context, (state.err as Err).message);
                      }
                    },
                    child: BlocListener<FeedbackCubit, FeedbackState>(
                      listener: (context, state) {
                        if (state is FeedbackError) {
                          showNotificationChip(context, state.msg());
                        } else if (state is FeedbackSuccess) {
                          sl.get<ConfettiBlaster>().show(context);
                          router.pop(context);
                          showNotificationChip(context, state.msg(), notificationType: NotificationType.success);
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: MaterialApp.router(
                          routeInformationProvider: router.routeInformationProvider,
                          routeInformationParser: router.routeInformationParser,
                          routerDelegate: router.routerDelegate,
                          debugShowCheckedModeBanner: false,
                          title: "Confesi",
                          theme: AppTheme.light,
                          darkTheme: AppTheme.dark,
                          themeMode: data.themePref == ThemePref.system
                              ? ThemeMode.system
                              : data.themePref == ThemePref.light
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                          builder: (BuildContext context, Widget? child) {
                            final MediaQueryData data = MediaQuery.of(context);
                            return MediaQuery(
                              // update max width
                              // Force the textScaleFactor that's loaded from the device
                              // to lock to 1 (you can change it in-app independent of the inherited scale).
                              data: data.copyWith(textScaleFactor: 1),
                              child: child!,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
