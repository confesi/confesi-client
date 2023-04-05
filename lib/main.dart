import 'package:Confessi/core/services/notifications.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application/authentication_and_settings/cubit/login_cubit.dart';
import 'application/authentication_and_settings/cubit/register_cubit.dart';
import 'application/authentication_and_settings/cubit/user_cubit.dart';
import 'application/create_post/cubit/drafts_cubit.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'constants/enums_that_are_local_keys.dart';
import 'core/router/router.dart';
import 'core/services/in_app_notifications/in_app_notifications.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'generated/l10n.dart';
import 'presentation/primary/screens/splash.dart';

// FCM background messager handler. Required to be top-level.
@pragma('vm:entry-point') // Needed so this function isn't moved during release compilation.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("======================> BG handler called");
  await Firebase.initializeApp();
  // InAppMessageService inAppMessageService = InAppMessageService();
  // inAppMessageService.addMessage(message);
  NotificationService().fcmDeletagor(
    message: message,
    onNotification: (title, body) => null, // do nothing since this will be handled natively
    onUpdateMessage: (title, body) => InAppMessageService().addMessage(title, body),
  );
}

void main() async {
  // Initializes everything that is needed for the app to run.
  await init();
  // Initializes the background handler for messages. Required to be top-level.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Locks the application to portait mode (facing up).
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //! Streams for notifications
  sl.get<NotificationService>().token.then((token) {
    token.fold((l) => print(l), (r) => print(r));
  }); // todo: save this to device storage or on new token save it (initialize with context then so I can use the usecases to set prefs? Or STORE SEPERATELY?)

  sl.get<NotificationService>().onTokenRefresh((token) {
    print("======================> Token refreshed: $token");
  });
  runApp(MyApp(appRouter: sl()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  ThemeMode getAppearance(AppearanceEnum state) {
    if (state == AppearanceEnum.dark) {
      return ThemeMode.dark;
    } else if (state == AppearanceEnum.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Create post provider here because context of drafts needs to be accessed from functions.
        BlocProvider(
          lazy: false,
          create: (context) => sl<DraftsCubit>(),
        ),
        // Create post provider here because context needs to be accessed from functions.
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        // Hottest provider here so context can be accessed inside the bottom sheet.
        BlocProvider(
          lazy: false,
          create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<WebsiteLauncherCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ShareCubit>(),
        ),
        BlocProvider(
          lazy: false,
          // create: (context) => sl<UserCubit>()..authenticateUser(AuthenticationType.silent), // TODO: add silent auth
          // create: (context) => sl<UserCubit>(),
          create: (context) => sl<UserCubit>()..loadUser(true),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<RegisterCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code; English first, so it's default/fallback
              Locale('fr', ''), // French, no country code
              Locale('es', ''), // Spanish, no country code
            ],
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: context.watch<UserCubit>().stateIsUser
                // If state is user, then use their preferences
                ? getAppearance(
                    context.watch<UserCubit>().stateAsUser.appearanceEnum,
                  )
                // Otherwise, just go dark
                : ThemeMode.dark,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                // Force the textScaleFactor that's loaded from the device
                // to lock to 1 (you can change it in-app independent of the inherited scale).
                data: data.copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
