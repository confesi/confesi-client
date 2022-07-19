import 'package:flutter/material.dart';

import '../../features/authentication/presentation/screens/login.dart';
import '../../features/authentication/presentation/screens/open.dart';
import '../../features/authentication/presentation/screens/register.dart';
import '../../features/authentication/presentation/screens/splash.dart';

class AppRouter {
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
        return MaterialPageRoute(builder: (_) => const Text("Home"));
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
