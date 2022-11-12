import '../../application/authentication_and_settings/cubit/language_setting_cubit.dart';
import '../../presentation/authentication_and_settings/screens/settings/contact.dart';
import '../../presentation/authentication_and_settings/screens/settings/haptics.dart';
import '../../presentation/authentication_and_settings/screens/settings/language.dart';
import '../../presentation/create_post/screens/details.dart';
import '../../presentation/create_post/screens/home.dart';
import '../../presentation/daily_hottest/screens/leaderboard.dart';
import '../../presentation/easter_eggs/screens/overscroll.dart';
import '../../presentation/feed/screens/detail_view.dart';
import '../../presentation/feed/screens/post_advanced_details.dart';
import '../../presentation/feed/screens/watched_universities.dart';
import '../../presentation/feedback/screens/home.dart';
import '../../presentation/primary/screens/critical_error.dart';
import '../../presentation/authentication_and_settings/screens/settings/appearance.dart';
import '../../presentation/authentication_and_settings/screens/settings/faq.dart';
import '../../presentation/authentication_and_settings/screens/settings/home.dart';
import '../../presentation/user_posts_and_comments/screens/comments.dart';
import '../../presentation/user_posts_and_comments/screens/posts.dart';
import '../../presentation/user_posts_and_comments/screens/saved.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import '../../application/authentication_and_settings/cubit/website_launcher_setting_cubit.dart';
import '../../dependency_injection.dart';
import '../../presentation/authentication_and_settings/screens/authentication/register_tab_manager.dart';
import '../../presentation/authentication_and_settings/screens/settings/biometric_lock.dart';
import '../../presentation/primary/screens/home.dart';
import '../../presentation/authentication_and_settings/screens/authentication/login.dart';
import '../../presentation/primary/screens/showcase.dart';
import '../../presentation/authentication_and_settings/screens/authentication/open.dart';
import '../../application/daily_hottest/cubit/leaderboard_cubit.dart';
import '../../application/feed/cubit/recents_cubit.dart';
import '../../application/feed/cubit/trending_cubit.dart';
import '../../application/profile/cubit/biometrics_cubit.dart';

/// The application's routes (screens) manager.
class AppRouter {
  // Checks which routes show as a full screen animation.
  bool isFullScreen(RouteSettings routeSettings) {
    List<String> fullScreenDialogRoutes = [
      "/home/post/stats",
      "/home/create_replied_post",
      "/feedback",
      "/prefsError",
      "/create_post",
      "/settings",
      "/watched_universities",
    ];
    return fullScreenDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  // Checks which routes show as a size animation.
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
      "/open",
    ];
    return fadeAnimDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  /// Converts: navigating to a named route -> that actual route.
  Route onGenerateRoute(RouteSettings routeSettings) {
    Widget page;
    // Arguments passed to a named route.
    final args = routeSettings.arguments as Map<String, dynamic>?;
    try {
      switch (routeSettings.name) {
        case "/open":
          page = const OpenScreen();
          break;
        case "/onboarding":
          page = ShowcaseScreen(
            isRewatching: args!["isRewatching"],
          );
          break;
        case "/login":
          page = const LoginScreen();
          break;
        case "/registerTabManager":
          page = const RegisterTabManager();
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
        // TODO: HERE
        case "/create_post":
          page = const CreatePostHome(viewMethod: ViewMethod.separateScreen);
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
        case '/home/profile/comments':
          page = const CommentsScreen();
          break;
        case '/home/profile/posts':
          page = const PostsScreen();
          break;
        case '/home/profile/saved':
          page = const SavedScreen();
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
          page = MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => sl<WebsiteLauncherSettingCubit>(),
              ),
            ],
            child: const SettingsHome(),
          );
          break;
        case "/watched_universities":
          page = const WatchedUniversitiesScreen();
          break;
        case "/settings/appearance":
          page = const AppearanceScreen();
          break;
        case "/settings/faq":
          page = const FAQScreen();
          break;
        case "/settings/contact":
          page = MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => sl<ContactSettingCubit>(),
              ),
            ],
            child: const ContactScreen(),
          );
          break;
        case "/settings/language":
          page = MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => sl<LanguageSettingCubit>(),
              ),
            ],
            child: const LanguageScreen(),
          );
          break;
        case "/settings/haptics":
          page = const HapticsScreen();
          break;
        case "/settings/biometric_lock":
          page = const BiometricLockScreen();
          break;
        case "/prefsError":
          page = const CriticalErrorScreen();
          break;
        default:
          throw Exception("Named route ${routeSettings.name} not defined");
      }
    } catch (e) {
      page = const CriticalErrorScreen();
    }
    if (isSizeAnim(routeSettings)) {
      return PageTransition(
        child: page,
        settings: routeSettings,
        alignment: Alignment.center,
        type: PageTransitionType.scale,
        curve: Curves.decelerate,
        duration: const Duration(
          milliseconds: 750,
        ),
      );
    } else if (isFadeAnim(routeSettings) || page is CriticalErrorScreen) {
      return PageTransition(
        settings: routeSettings,
        child: page,
        alignment: Alignment.center,
        type: PageTransitionType.fade,
        curve: Curves.decelerate,
        duration: const Duration(
          milliseconds: 150,
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
