import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/splash":
        return MaterialPageRoute(builder: (_) => const Text("Splash"));
      case "/open":
        return MaterialPageRoute(builder: (_) => const Text("Open"));
      case "/login":
        return MaterialPageRoute(builder: (_) => const Text("Login"));
      case "/register":
        return MaterialPageRoute(builder: (_) => const Text("Register"));
      case "/home": // Most of the screens are tabs under /home.
        return MaterialPageRoute(builder: (_) => const Text("Home"));
      case "/feed/details":
        return MaterialPageRoute(builder: (_) => const Text("Feed details"));
      case "/settings/watchedUniversities":
        return MaterialPageRoute(builder: (_) => const Text("Watched universities"));
      default:
        throw Exception("Named route not defined");
    }
  }
}
