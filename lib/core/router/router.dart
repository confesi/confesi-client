import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/presentation/authentication_and_settings/screens/settings/feedback.dart';
import 'package:Confessi/presentation/authentication_and_settings/screens/settings/text_size.dart';

import '../../presentation/authentication_and_settings/screens/authentication/registration.dart';
import '../../presentation/authentication_and_settings/screens/settings/curvy.dart';
import '../../presentation/feed/screens/simple_detail_view.dart';

import '../../application/create_post/cubit/post_cubit.dart';
import '../../application/daily_hottest/cubit/hottest_cubit.dart';
import '../../application/profile/cubit/profile_cubit.dart';

import '../../application/authentication_and_settings/cubit/language_setting_cubit.dart';
import '../../presentation/authentication_and_settings/screens/settings/contact.dart';
import '../../presentation/authentication_and_settings/screens/settings/language.dart';
import '../../presentation/authentication_and_settings/screens/settings/verified_student_manager.dart';
import '../../presentation/create_post/screens/details.dart';
import '../../presentation/create_post/screens/home.dart';
import '../../presentation/leaderboard/screens/home.dart';
import '../../presentation/feed/screens/detail_view.dart';
import '../../presentation/feed/screens/post_advanced_details.dart';
import '../../presentation/profile/screens/account_details.dart';
import '../../presentation/profile/screens/achievement_tab_manager.dart';
import '../../presentation/profile/tabs/achievement_tab.dart';
import '../../presentation/watched_universities/screens/search_universities.dart';
import '../alt_unused/watched_universities.dart';
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
import '../../dependency_injection.dart';
import '../alt_unused/register_tab_manager.dart';
import '../../presentation/authentication_and_settings/screens/settings/biometric_lock.dart';
import '../../presentation/primary/screens/home.dart';
import '../../presentation/authentication_and_settings/screens/authentication/login.dart';
import '../../presentation/primary/screens/showcase.dart';
import '../../presentation/authentication_and_settings/screens/authentication/open.dart';
import '../../application/leaderboard/cubit/leaderboard_cubit.dart';
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
      "/create_post",
      "/settings",
      "/profile/achievements"
    ];
    return fullScreenDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  // Checks which routes show as a scale animation.
  bool isFadeAnim(RouteSettings routeSettings) {
    List<String> sizeAnimDialogRoutes = ["/home"];
    return sizeAnimDialogRoutes.contains(routeSettings.name) ? true : false;
  }

  // Checks which routes show as a size animation.
  bool isSizeAnim(RouteSettings routeSettings) {
    List<String> fadeAnimDialogRoutes = ["/onboarding", "/open", "/prefsError"];
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
        case "/register":
          page = const RegistrationScreen();
          break;
        case "/home": //! Most of the (main) screens are tabs under the /home named route. Thus, should have their BLoC/Cubit providers here.
          page = MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => sl<LeaderboardCubit>()..loadRankings(),
              ),
              BlocProvider(
                lazy: false,
                create: (context) => sl<ProfileCubit>()..loadProfile(),
              ),
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
            title: args!['title'],
            body: args['body'],
            id: args['id'],
          );
          break;
        case "/create_post":
          page = const CreatePostHome();
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
        // Simplified view for post details
        case "/home/simplified_detail":
          page = const SimpleDetailViewScreen();
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
            saves: args['saves'],
            university: args['university'],
            year: args['year'],
          );
          break;
        case "/profile/account_details":
          page = const AccountDetailsScreen();
          break;
        case "/profile/achievements":
          page = AchievementTabManager(
            rarity: args!['rarity'],
            achievements: args['achievements'],
          );
          break;
        case "/feedback":
          page = const FeedbackHome();
          break;
        case "/search_universities":
          page = const SearchUniversitiesScreen();
          break;
        case "/settings/appearance":
          page = const AppearanceScreen();
          break;
        case "/settings/text_size":
          page = const TextSizeScreen();
          break;
        case "/settings/curvy":
          page = const CurvyScreen();
          break;
        case "/settings/feedback":
          page = const FeedbackSettingScreen();
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

        case "/settings/biometric_lock":
          page = const BiometricLockScreen();
          break;
        case "/settings/verified_student_perks":
          page = const VerifiedStudentManager();
          break;
        case "/prefsError":
          page = const CriticalErrorScreen();
          break;
        default:
          throw Exception("Named route ${routeSettings.name} not defined");
      }
    } catch (e) {
      print(e);
      page = const CriticalErrorScreen();
    }
    if (isFadeAnim(routeSettings) || page is CriticalErrorScreen) {
      return PageTransition(
        child: page,
        settings: routeSettings,
        alignment: Alignment.center,
        type: PageTransitionType.fade,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 350),
      );
    } else if (isSizeAnim(routeSettings)) {
      return PageTransition(
        settings: routeSettings,
        child: page,
        alignment: Alignment.center,
        type: PageTransitionType.size,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 350),
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
