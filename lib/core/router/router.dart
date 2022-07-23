import 'package:Confessi/features/authentication/presentation/screens/TEMP_HOME.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/screens/login.dart';
import '../../features/authentication/presentation/screens/open.dart';
import '../../features/authentication/presentation/screens/register.dart';
import '../../features/authentication/presentation/screens/splash.dart';

/// The application's routes (screens) manager.
class AppRouter {
  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/splash":
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case "/open":
        return MaterialPageRoute(builder: (_) => const OpenScreen());
      case "/login":
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case "/register":
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case "/home": // Most of the screens are tabs under the /home named route.
        return MaterialPageRoute(builder: (_) => const TempHome());
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
