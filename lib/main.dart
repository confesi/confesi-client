import 'package:Confessi/application/create_post/post_cubit.dart';
import 'package:Confessi/application/shared/prefs_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/presentation/primary/widgets/onboarding_university_select.dart';
import 'package:Confessi/presentation/feedback/screens/home.dart';
import 'package:Confessi/presentation/primary/screens/splash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/shared/dev.dart';
import 'application/shared/scaffold_shrinker_cubit.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'application/authentication/authentication_cubit.dart';
import 'presentation/primary/screens/onboarding_details.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  // Locks the application to portait mode (facing up).
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(MyApp(appRouter: sl())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  // ThemeData getLightTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicLight;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantLight;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonLight;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiLight;
  //   } else {
  //     return AppTheme.classicLight;
  //   }
  // }

  // ThemeData getDarkTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicDark;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantDark;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonDark;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiDark;
  //   } else {
  //     return AppTheme.classicDark;
  //   }
  // }

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
        BlocProvider(
          lazy: false,
          create: (context) => sl<AuthenticationCubit>()..silentlyAuthenticateUser(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ScaffoldShrinkerCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<PrefsCubit>()..loadInitialPrefsAndTokens(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: AppTheme.classicLight,
            darkTheme: AppTheme.classicDark,
            themeMode: context.watch<PrefsCubit>().isLoaded
                ? getAppearance(
                    context.watch<PrefsCubit>().prefs.appearanceEnum,
                  )
                : ThemeMode.system,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            // home: Builder(
            //   builder: (context) {
            //     return const SplashScreen();
            //   },
            // ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
