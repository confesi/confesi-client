import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../../features/authentication/presentation/screens/home.dart';
import '../../features/authentication/presentation/screens/login.dart';
import '../../features/authentication/presentation/screens/onboarding.dart';
import '../../features/authentication/presentation/screens/open.dart';
import '../../features/authentication/presentation/screens/register.dart';
import '../../features/authentication/presentation/screens/splash.dart';
import '../../features/feed/presentation/cubit/recents_cubit.dart';
import '../../features/feed/presentation/cubit/trending_cubit.dart';

/// The application's routes (screens) manager.
class AppRouter {
  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/splash":
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case "/open":
        return MaterialPageRoute(builder: (_) => const OpenScreen());
      case "/onboarding":
        return MaterialPageRoute(builder: (_) => const ShowcaseScreen());
      case "/login":
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case "/register":
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case "/home": // Most of the screens are tabs under the /home named route.
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  lazy: false,
                  create: (context) => sl<TrendingCubit>(),
                  child: BlocProvider(
                    lazy: false,
                    create: (context) => sl<RecentsCubit>()..startLoading(),
                    child: const HomeScreen(),
                  ),
                ));
      case "/feed/details":
        return MaterialPageRoute(builder: (_) => const Text("Feed details"));
      case "/settings":
        return MaterialPageRoute(builder: (_) => const Text("Settings"));
      case "/settings/watchedUniversities":
        return MaterialPageRoute(builder: (_) => const Text("Watched universities"));
      default:
        throw Exception("Named route not defined");
    }
  }
}
