import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/acknowledgements.dart';
import 'package:confesi/presentation/notifications/screens/home.dart';

import 'package:confesi/presentation/authentication_and_settings/screens/authentication/open.dart';
import 'package:confesi/presentation/user/screens/saved_comments.dart';
import 'package:confesi/presentation/user/screens/your_comments.dart';
import '../../presentation/authentication_and_settings/screens/authentication/reset_password.dart';
import '../../presentation/authentication_and_settings/screens/settings/contact.dart';
import '../../presentation/authentication_and_settings/screens/settings/faq.dart';
import '../../presentation/authentication_and_settings/screens/settings/feedback.dart';
import '../../presentation/authentication_and_settings/screens/settings/home.dart';
import '../../presentation/create_post/screens/details.dart';
import '../../presentation/create_post/screens/home.dart';
import '../../presentation/feed/screens/post_sentiment_analysis.dart';
import '../../presentation/feedback/screens/home.dart';
import '../../presentation/leaderboard/screens/school_detail.dart';
import '../../presentation/primary/screens/critical_error.dart';
import '../../presentation/primary/screens/home.dart';
import '../../presentation/primary/screens/showcase.dart';
import '../../presentation/profile/screens/account_details.dart';
import '../../presentation/user/screens/your_posts.dart';
import '../../presentation/user/screens/saved_posts.dart';
import '../../presentation/watched_universities/screens/search_schools.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../presentation/authentication_and_settings/screens/authentication/login.dart';
import '../../presentation/authentication_and_settings/screens/authentication/registration.dart';
import '../../presentation/authentication_and_settings/screens/authentication/verify_email.dart';
import '../../presentation/authentication_and_settings/screens/settings/appearance.dart';
import '../../presentation/authentication_and_settings/screens/settings/curvy.dart';
import '../../presentation/authentication_and_settings/screens/settings/notifications.dart';
import '../../presentation/authentication_and_settings/screens/settings/text_size.dart';
import '../../presentation/feed/screens/post_detail_view.dart';
import '../../presentation/primary/screens/splash.dart';
import '../../presentation/profile/screens/account_stats.dart';

final GoRouter router = GoRouter(
  onException: (context, state, router) => router.go("/error"),
  initialLocation: "/",
  routes: <GoRoute>[
    GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
    GoRoute(path: '/error', builder: (BuildContext context, GoRouterState state) => const CriticalErrorScreen()),
    GoRoute(path: '/login', builder: (BuildContext context, GoRouterState state) => const LoginScreen()),
    GoRoute(path: '/verify-email', builder: (BuildContext context, GoRouterState state) => const VerifyEmailScreen()),

    GoRoute(path: '/open', builder: (BuildContext context, GoRouterState state) => const OpenScreen()),

    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return FadeTransition(
              opacity: curvedAnimation, // Use the curvedAnimation for opacity
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/create',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CreatePostHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return ScaleTransition(
              scale: curvedAnimation,
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/schools/search',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SearchSchoolsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curvedAnimation),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/feedback',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const FeedbackHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curvedAnimation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(path: '/create/details', builder: (BuildContext context, GoRouterState state) => const CreatePostDetails()),

    GoRoute(path: '/onboarding', builder: (BuildContext context, GoRouterState state) => const ShowcaseScreen()),
    GoRoute(
        path: '/home/posts/detail',
        builder: (BuildContext context, GoRouterState state) => const SimpleDetailViewScreen()),

    GoRoute(
      path: '/home/posts/sentiment',
      builder: (BuildContext context, GoRouterState state) {
        HomePostsSentimentProps props = state.extra as HomePostsSentimentProps;
        return SentimentAnalysisScreen(props: props);
      },
    ),
    GoRoute(
        path: '/home/profile/saved/posts',
        builder: (BuildContext context, GoRouterState state) => const YourSavedPostsScreen()),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        RegistrationPops props = state.extra as RegistrationPops;
        return RegistrationScreen(props: props);
      },
    ),

    GoRoute(
      path: '/reset-password',
      builder: (BuildContext context, GoRouterState state) => const ResetPasswordScreen(),
    ),

    GoRoute(
      path: '/home/leaderboard/school',
      pageBuilder: (context, state) {
        HomeLeaderboardSchoolProps props = state.extra as HomeLeaderboardSchoolProps;
        return CustomTransitionPage(
          key: state.pageKey,
          child: SchoolDetail(props: props),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return ScaleTransition(
              scale: curvedAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/home/leaderboard/school',
      builder: (BuildContext context, GoRouterState state) {
        HomeLeaderboardSchoolProps props = state.extra as HomeLeaderboardSchoolProps;
        return SchoolDetail(props: props);
      },
    ),

    GoRoute(
        path: '/home/profile/account',
        builder: (BuildContext context, GoRouterState state) => const AccountDetailsScreen()),
    GoRoute(
        path: '/home/profile/stats',
        builder: (BuildContext context, GoRouterState state) => const AccountProfileStats()),
    GoRoute(
        path: '/home/profile/posts', builder: (BuildContext context, GoRouterState state) => const YourPostsScreen()),
    GoRoute(
        path: '/home/profile/comments',
        builder: (BuildContext context, GoRouterState state) => const YourCommentsScreen()),
    GoRoute(
        path: '/home/profile/saved/comments',
        builder: (BuildContext context, GoRouterState state) =>
            const YourSavedCommentsScreen()), // todo: saved comments

    GoRoute(path: '/settings', builder: (BuildContext context, GoRouterState state) => const SettingsHome()),

    GoRoute(path: '/settings/faq', builder: (BuildContext context, GoRouterState state) => const FAQScreen()),

    GoRoute(
        path: '/home/notifications',
        builder: (BuildContext context, GoRouterState state) => const NotificationsScreen()),
    GoRoute(
        path: '/settings/notifications',
        builder: (BuildContext context, GoRouterState state) => const NotificationsSettingScreen()),
    GoRoute(
        path: '/settings/appearance', builder: (BuildContext context, GoRouterState state) => const AppearanceScreen()),
    GoRoute(
        path: '/settings/feedback',
        builder: (BuildContext context, GoRouterState state) => const FeedbackSettingScreen()),
    GoRoute(path: '/settings/contact', builder: (BuildContext context, GoRouterState state) => const ContactScreen()),
    GoRoute(
        path: "/settings/acknowledgements",
        builder: (BuildContext context, GoRouterState state) => const AcknowledgementsScreen()),
    GoRoute(
        path: '/settings/text-size', builder: (BuildContext context, GoRouterState state) => const TextSizeScreen()),
    GoRoute(path: '/settings/curvy', builder: (BuildContext context, GoRouterState state) => const CurvyScreen()),
  ],
);

class HomePostsSentimentProps {
  final int postId;
  const HomePostsSentimentProps(this.postId);
}

class RegistrationPops {
  final bool upgradingToFullAccount;
  const RegistrationPops(this.upgradingToFullAccount);
}

class HomeLeaderboardSchoolProps {
  final SchoolWithMetadata school;
  const HomeLeaderboardSchoolProps(this.school);
}
