import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/general.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'features/authentication/presentation/cubit/authentication_cubit.dart';
import 'features/authentication/presentation/screens/splash.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: kPreviewMode,
      builder: (context) => MyApp(appRouter: sl()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) =>
          sl<AuthenticationCubit>()..silentlyAuthenticateUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: kPreviewMode,
        title: "Confesi",
        onGenerateRoute: appRouter.onGenerateRoute,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        builder: DevicePreview.appBuilder,

        /// Manages navigating to new screens if the authentication state switches to certain values.
        home: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) {
            return (previous.runtimeType != current.runtimeType) &&
                previous is! UserError;
          },
          listener: (context, state) {
            if (state is NoUser) {
              Navigator.of(context).pushNamed("/open");
            } else if (state is User) {
              if (state.justRegistered) {
                Navigator.of(context).pushNamed("/onboarding");
              } else {
                Navigator.of(context).pushNamed("/home");
              }
            }
          },
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
