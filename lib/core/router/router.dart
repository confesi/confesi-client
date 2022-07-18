import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/": // Splash screen route.
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/open":
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/login":
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/register":
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/home": // Most of the screens are tabs under /home.
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/feed/details":
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      case "/settings/watchedUniversities":
        return MaterialPageRoute(builder: (_) => const Text("Screen"));
      default:
        throw Exception("Named route not defined");
    }
  }
}
