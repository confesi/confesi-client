import 'package:Confessi/features/daily_hottest/presentation/screens/leaderboard.dart';
import 'package:Confessi/features/feed/presentation/screens/detail_view.dart';
import 'package:Confessi/features/feed/presentation/screens/post_advanced_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../../features/authentication/presentation/screens/home.dart';
import '../../features/authentication/presentation/screens/login.dart';
import '../../features/authentication/presentation/screens/onboarding.dart';
import '../../features/authentication/presentation/screens/open.dart';
import '../../features/authentication/presentation/screens/register.dart';
import '../../features/authentication/presentation/screens/splash.dart';
import '../../features/daily_hottest/presentation/cubit/leaderboard_cubit.dart';
import '../../features/feed/presentation/cubit/recents_cubit.dart';
import '../../features/feed/presentation/cubit/trending_cubit.dart';

/// The application's routes (screens) manager.
class AppRouter {
  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    /// Arguments passed to a named route.
    final args = routeSettings.arguments as Map<String, dynamic>?;
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
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => sl<TrendingCubit>()..fetchPosts(),
              ),
              BlocProvider(
                lazy: false,
                create: (context) => sl<RecentsCubit>(),
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      // Detailed view for each post (thread view, has comments, fully expanded text, etc.).
      case '/home/detail':
        return MaterialPageRoute(
          builder: (_) => DetailViewScreen(
            genre: args!['genre'],
            badges: args['badges'],
            postChild: args['post_child'],
            icon: args['icon'],
            time: args['time'],
            faculty: args['faculty'],
            text: args['text'],
            title: args['title'],
            likes: args['likes'],
            hates: args['hates'],
            comments: args['comments'],
            year: args['year'],
            university: args['university'],
          ),
        );
      // An individual post's advanced stats.
      case "/home/post/stats":
        return MaterialPageRoute(
          builder: (_) => const PostAdvancedDetailsScreen(),
        );
      case "/hottest/leaderboard":
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            lazy: false,
            create: (context) => sl<LeaderboardCubit>()..loadRankings(),
            child: const LeaderboardScreen(),
          ),
        );
      case "/settings":
        return MaterialPageRoute(builder: (_) => const Text("Settings"));
      case "/settings/watchedUniversities":
        return MaterialPageRoute(
            builder: (_) => const Text("Watched universities"));
      default:
        throw Exception("Named route ${routeSettings.name} not defined");
    }
  }
}
