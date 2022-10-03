import 'package:Confessi/presentation/create_post/screens/details.dart';
import 'package:Confessi/presentation/create_post/screens/home.dart';
import 'package:Confessi/presentation/daily_hottest/screens/leaderboard.dart';
import 'package:Confessi/presentation/easter_eggs/screens/overscroll.dart';
import 'package:Confessi/presentation/feed/screens/detail_view.dart';
import 'package:Confessi/presentation/feed/screens/post_advanced_details.dart';
import 'package:Confessi/presentation/feedback/screens/home.dart';
import 'package:Confessi/presentation/initialization/screens/critical_error.dart';
import 'package:Confessi/presentation/settings/screens/appearance.dart';
import 'package:Confessi/presentation/settings/screens/faq.dart';
import 'package:Confessi/presentation/settings/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../dependency_injection.dart';
import '../../presentation/authentication/screens/home.dart';
import '../../presentation/authentication/screens/login.dart';
import '../../presentation/initialization/screens/onboarding.dart';
import '../../presentation/authentication/screens/open.dart';
import '../../presentation/authentication/screens/register.dart';
import '../../application/daily_hottest/hottest_cubit.dart';
import '../../application/daily_hottest/leaderboard_cubit.dart';
import '../../application/feed/recents_cubit.dart';
import '../../application/feed/trending_cubit.dart';
import '../../application/shared/biometrics_cubit.dart';

/// The application's routes (screens) manager.
class AppRouter {
  // Checks which routes show as a full screen animation.
  bool isFullScreen(RouteSettings routeSettings) {
    List<String> fullScreenDialogRoutes = [
      "/home/post/stats",
      "/home/create_replied_post",
      "/feedback",
      "/prefsError",
    ];
    return fullScreenDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  // Checks which routes show as a fade animation.
  bool isSizeAnim(RouteSettings routeSettings) {
    List<String> sizeAnimDialogRoutes = [
      "/home",
    ];
    return sizeAnimDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  // Checks which routes show as a fade animation.
  bool isFadeAnim(RouteSettings routeSettings) {
    List<String> fadeAnimDialogRoutes = [
      "/onboarding",
    ];
    return fadeAnimDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    /// Arguments passed to a named route.
    Widget page;
    final args = routeSettings.arguments as Map<String, dynamic>?;
    switch (routeSettings.name) {
      case "/open":
        page = const OpenScreen();
        break;
      case "/onboarding":
        page = const ShowcaseScreen();
        break;
      case "/login":
        page = const LoginScreen();
        break;
      case "/register":
        page = const RegisterScreen();
        break;
      case "/home": //! Most of the (main) screens are tabs under the /home named route. Thus, should have their BLoC/Cubit providers here.
        page = MultiBlocProvider(
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
            BlocProvider(
              lazy: false,
              create: (context) => sl<BiometricsCubit>(),
            ),
          ],
          child: const HomeScreen(),
        );
        break;
      // The direct route to creating a post (specifically, when you're replying to somebody else's post; separate from the tab that's a "create post" screen under /home, but uses the same screen).
      case "/home/create_replied_post":
        page = CreatePostHome(
          viewMethod: ViewMethod.separateScreen,
          title: args!['title'],
          body: args['body'],
          id: args['id'],
        );
        break;
      // Detailed view for each post (thread view, has comments, fully expanded text, etc.).
      case '/home/detail':
        page = DetailViewScreen(
          genre: args!['genre'],
          id: args['id'],
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
        );
        break;
      case '/home/create_post/details':
        page = DetailsScreen(
          title: args!['title'],
          body: args['body'],
          id: args['id'],
        );
        break;
      // An individual post's advanced stats.
      case "/home/post/stats":
        page = PostAdvancedDetailsScreen(
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
        );
        break;
      case "/hottest/leaderboard":
        page = BlocProvider(
          lazy: false,
          create: (context) => sl<LeaderboardCubit>()..loadRankings(),
          child: const LeaderboardScreen(),
        );
        break;
      case "/feedback":
        page = const FeedbackHome();
        break;
      case "/easterEggs/overscroll":
        page = const OverscrollEasterEgg();
        break;
      case "/settings":
        page = const SettingsHome();
        break;
      case "/settings/appearance":
        page = const AppearanceScreen();
        break;
      case "/settings/faq":
        page = const FAQScreen();
        break;
      case "/settings/watchedUniversities":
        page = const Text("Watched universities");
        break;
      case "/prefsError":
        page = const CriticalErrorScreen();
        break;
      default:
        throw Exception("Named route ${routeSettings.name} not defined");
    }
    if (isSizeAnim(routeSettings)) {
      return PageTransition(
        child: page,
        alignment: Alignment.center,
        type: PageTransitionType.scale,
        curve: Curves.decelerate,
        duration: const Duration(
          milliseconds: 750,
        ),
      );
    } else if (isFadeAnim(routeSettings)) {
      return PageTransition(
        child: page,
        alignment: Alignment.center,
        type: PageTransitionType.fade,
        curve: Curves.decelerate,
        duration: const Duration(
          milliseconds: 250,
        ),
      );
    } else {
      return MaterialPageRoute(
        fullscreenDialog: isFullScreen(routeSettings),
        settings: routeSettings,
        builder: (_) => page,
      );
    }
  }
}
