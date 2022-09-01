import 'package:Confessi/presentation/create_post/screens/details.dart';
import 'package:Confessi/presentation/create_post/screens/home.dart';
import 'package:Confessi/presentation/daily_hottest/screens/leaderboard.dart';
import 'package:Confessi/presentation/feed/screens/detail_view.dart';
import 'package:Confessi/presentation/feed/screens/post_advanced_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../../presentation/authentication/screens/home.dart';
import '../../presentation/authentication/screens/login.dart';
import '../../presentation/authentication/screens/onboarding.dart';
import '../../presentation/authentication/screens/open.dart';
import '../../presentation/authentication/screens/register.dart';
import '../../presentation/authentication/screens/splash.dart';
import '../../presentation/create_post/cubit/post_cubit.dart';
import '../../presentation/daily_hottest/cubit/hottest_cubit.dart';
import '../../presentation/daily_hottest/cubit/leaderboard_cubit.dart';
import '../../presentation/feed/cubit/recents_cubit.dart';
import '../../presentation/feed/cubit/trending_cubit.dart';

/// The application's routes (screens) manager.
class AppRouter {
  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    /// Arguments passed to a named route.
    final args = routeSettings.arguments as Map<String, dynamic>?;
    switch (routeSettings.name) {
      case "/splash":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SplashScreen(),
        );
      case "/open":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const OpenScreen(),
        );
      case "/onboarding":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ShowcaseScreen(),
        );
      case "/login":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const LoginScreen(),
        );
      case "/register":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const RegisterScreen(),
        );
      case "/home": //! Most of the (main) screens are tabs under the /home named route. Thus, should have their BLoC/Cubit providers here.
        return MaterialPageRoute(
          settings: routeSettings,
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
              BlocProvider(
                lazy: false,
                create: (context) => sl<HottestCubit>()..loadPosts(),
              ),
            ],
            child: const HomeScreen(),
          ),
        );
      // The direct route to creating a post (specifically, when you're replying to somebody else's post; separate from the tab that's a "create post" screen under /home, but uses the same screen).
      case "/home/create_replied_post":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => CreatePostHome(
            viewMethod: ViewMethod.separateScreen,
            title: args!['title'],
            body: args['body'],
          ),
        );
      // Detailed view for each post (thread view, has comments, fully expanded text, etc.).
      case '/home/detail':
        return MaterialPageRoute(
          settings: routeSettings,
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
            universityFullName: args['university_full_name'],
          ),
        );
      case '/home/create_post/details':
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => DetailsScreen(
                  title: args!['title'],
                  body: args['body'],
                  id: args['id'],
                ));
      // An individual post's advanced stats.
      case "/home/post/stats":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => PostAdvancedDetailsScreen(
            comments: args!['comments'],
            universityFullName: args['university_full_name'],
            faculty: args['faculty'],
            genre: args['genre'],
            hates: args['hates'],
            likes: args['likes'],
            moderationStatus: args['moderation_status'],
            saves: args['saves'],
            university: args['university'],
            year: args['year'],
          ),
        );
      case "/hottest/leaderboard":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => BlocProvider(
            lazy: false,
            create: (context) => sl<LeaderboardCubit>()..loadRankings(),
            child: const LeaderboardScreen(),
          ),
        );
      case "/settings":
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Text("Settings"),
        );
      case "/settings/watchedUniversities":
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => const Text("Watched universities"));
      default:
        throw Exception("Named route ${routeSettings.name} not defined");
    }
  }
}
