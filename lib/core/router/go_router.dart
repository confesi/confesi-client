import 'package:confesi/data/create_post/datasources/create_post_datasource.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/authentication/login.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/authentication/open.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/authentication/verify_email.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/appearance.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/contact.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/curvy.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/faq.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/feedback.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/home.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/text_size.dart';
import 'package:confesi/presentation/create_post/screens/details.dart';
import 'package:confesi/presentation/create_post/screens/home.dart';
import 'package:confesi/presentation/feed/screens/post_advanced_details.dart';
import 'package:confesi/presentation/feed/screens/post_detail_view.dart';
import 'package:confesi/presentation/primary/screens/critical_error.dart';
import 'package:confesi/presentation/primary/screens/home.dart';
import 'package:confesi/presentation/primary/screens/showcase.dart';
import 'package:confesi/presentation/primary/screens/splash.dart';
import 'package:confesi/presentation/profile/screens/account_details.dart';
import 'package:confesi/presentation/user_posts_and_comments/screens/posts.dart';
import 'package:confesi/presentation/user_posts_and_comments/screens/saved.dart';
import 'package:confesi/presentation/watched_universities/screens/search_universities.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../presentation/authentication_and_settings/screens/authentication/registration.dart';
import '../../presentation/profile/screens/account_stats.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: <GoRoute>[
    GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
    GoRoute(path: '/error', builder: (BuildContext context, GoRouterState state) => const CriticalErrorScreen()),
    GoRoute(path: '/open', builder: (BuildContext context, GoRouterState state) => const OpenScreen()),
    GoRoute(path: '/login', builder: (BuildContext context, GoRouterState state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (BuildContext context, GoRouterState state) => const RegistrationScreen()),
    GoRoute(path: '/verify-email', builder: (BuildContext context, GoRouterState state) => const VerifyEmailScreen()),
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
    GoRoute(path: '/home', builder: (BuildContext context, GoRouterState state) => const HomeScreen()),
    GoRoute(
        path: '/home/posts/detail',
        builder: (BuildContext context, GoRouterState state) => const SimpleDetailViewScreen()),
    GoRoute(
        path: '/home/posts/sentiment',
        builder: (BuildContext context, GoRouterState state) => const SentimentAnalysisScreen()),
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
        builder: (BuildContext context, GoRouterState state) => const YourPostsScreen()), // todo: your comments screen
    GoRoute(
        path: '/home/profile/saved/comments',
        builder: (BuildContext context, GoRouterState state) => const YourSavedPosts()), // todo: saved comments
    GoRoute(
        path: '/home/profile/saved/posts',
        builder: (BuildContext context, GoRouterState state) => const YourSavedPosts()),
    GoRoute(path: '/feedback', builder: (BuildContext context, GoRouterState state) => const FeedbackSettingScreen()),
    GoRoute(path: '/settings', builder: (BuildContext context, GoRouterState state) => const SettingsHome()),

    GoRoute(path: '/settings/faq', builder: (BuildContext context, GoRouterState state) => const FAQScreen()),
    GoRoute(
        path: '/settings/appearance', builder: (BuildContext context, GoRouterState state) => const AppearanceScreen()),
    GoRoute(
        path: '/settings/feedback',
        builder: (BuildContext context, GoRouterState state) => const FeedbackSettingScreen()),
    GoRoute(path: '/settings/contact', builder: (BuildContext context, GoRouterState state) => const ContactScreen()),
    GoRoute(
        path: '/settings/text-size', builder: (BuildContext context, GoRouterState state) => const TextSizeScreen()),
    GoRoute(path: '/settings/curvy', builder: (BuildContext context, GoRouterState state) => const CurvyScreen()),
    GoRoute(
        path: '/schools/search', builder: (BuildContext context, GoRouterState state) => const SearchSchoolsScreen()),
  ],
);
