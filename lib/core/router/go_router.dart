import 'package:confesi/models/post.dart';
import 'package:confesi/models/room.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/acknowledgements.dart';
import 'package:confesi/presentation/authentication_and_settings/screens/settings/filters.dart';
import 'package:confesi/presentation/dms/screens/chat.dart';
import 'package:confesi/presentation/dms/screens/home.dart';
import 'package:confesi/presentation/comments/screens/home.dart';
import 'package:confesi/presentation/feed/widgets/img_viewer.dart';
import 'package:confesi/presentation/notifications/screens/home.dart';

import 'package:confesi/presentation/authentication_and_settings/screens/authentication/open.dart';
import 'package:confesi/presentation/user/screens/saved_comments.dart';
import 'package:confesi/presentation/user/screens/your_comments.dart';
import '../../models/encrypted_id.dart';
import '../../presentation/authentication_and_settings/screens/authentication/reset_password.dart';
import '../../presentation/authentication_and_settings/screens/settings/contact.dart';
import '../../presentation/authentication_and_settings/screens/settings/faq.dart';
import '../../presentation/authentication_and_settings/screens/settings/feedback.dart';
import '../../presentation/authentication_and_settings/screens/settings/feeds_and_sorts.dart';
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
import '../../presentation/user/screens/emojis.dart';
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
import '../../presentation/profile/screens/account_stats.dart';

final GoRouter router = GoRouter(
  onException: (context, state, router) => router.go("/error"),
  routes: <GoRoute>[
    GoRoute(path: '/error', builder: (BuildContext context, GoRouterState state) => const CriticalErrorScreen()),
    GoRoute(path: '/login', builder: (BuildContext context, GoRouterState state) => const LoginScreen()),
    GoRoute(path: '/verify-email', builder: (BuildContext context, GoRouterState state) => const VerifyEmailScreen()),

    GoRoute(path: '/open', builder: (BuildContext context, GoRouterState state) => const OpenScreen()),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        HomeProps? props = state.extra == null ? null : state.extra as HomeProps;
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(props: props),
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
      path: '/img',
      pageBuilder: (context, state) {
        ImgProps props = state.extra as ImgProps;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ImgView(props: props),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the animation's value
            var tween = CurveTween(curve: Curves.easeInOut);
            var curvedAnimation = tween.animate(animation);
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/create',
      pageBuilder: (context, state) {
        GenericPost props = state.extra as GenericPost;
        return CustomTransitionPage(
          key: state.pageKey,
          child: CreatePostHome(props: props),
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
    GoRoute(
      path: '/create/details',
      builder: (BuildContext context, GoRouterState state) => const CreatePostDetails(),
    ),

    GoRoute(path: '/onboarding', builder: (BuildContext context, GoRouterState state) => const ShowcaseScreen()),
    GoRoute(
        path: '/home/posts/comments',
        builder: (BuildContext context, GoRouterState state) {
          HomePostsCommentsProps props = state.extra as HomePostsCommentsProps;
          return CommentsHome(props: props);
        }),

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

    GoRoute(path: "/home/emojis", builder: (BuildContext context, GoRouterState state) => const EmojisScreen()),
    GoRoute(path: "/home/rooms", builder: (BuildContext context, GoRouterState state) => const RoomsScreen()),
    GoRoute(
        path: "/home/rooms/chat",
        builder: (BuildContext context, GoRouterState state) {
          ChatProps props = state.extra as ChatProps;
          return ChatScreen(props: props);
        }),

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
    GoRoute(path: '/settings/filters', builder: (BuildContext context, GoRouterState state) => const FiltersScreen()),

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
    GoRoute(
        path: '/settings/feeds-and-sorts',
        builder: (BuildContext context, GoRouterState state) => const FeedsAndSortsScreen()),
  ],
);

class ImgProps {
  final String url;
  final bool isBlurred;
  final String heroTag;
  const ImgProps(this.url, this.isBlurred, this.heroTag);
}

class HomePostsSentimentProps {
  final EncryptedId postId;
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

class HomePostsCommentsProps {
  final PostLoadType postLoadType;
  const HomePostsCommentsProps(this.postLoadType);

  // toString
  @override
  String toString() {
    return 'HomePostsCommentsProps{postLoadType: $postLoadType}';
  }
}

class HomeProps {
  final VoidCallback? executeAfterHomeLoad;

  const HomeProps(this.executeAfterHomeLoad);

  // toString
  @override
  String toString() {
    return 'HomeProps{executeAfterHomeLoad: $executeAfterHomeLoad}';
  }
}

class CreatePostDetailsProps {
  final GenericPost post;

  const CreatePostDetailsProps(this.post);
}

class CreateProps {
  final GenericPost post;

  const CreateProps(this.post);
}

class ChatProps {
  final String roomId;

  const ChatProps(this.roomId);
}

//! Editing post props

class GenericPost {}

class EditedPost extends GenericPost {
  final String title;
  final String body;
  final EncryptedId id;

  EditedPost(this.title, this.body, this.id);
}

class CreatingNewPost extends GenericPost {
  final String title;
  final String body;

  CreatingNewPost({this.title = "", this.body = ""});
}

//! Home posts comment props with abstract classes

abstract class PostLoadType {}

class PreloadedPost extends PostLoadType {
  final PostWithMetadata post;
  final bool openKeyboard;

  PreloadedPost(this.post, this.openKeyboard);

  // toString
  @override
  String toString() {
    return 'PreloadedPost{post: $post, openKeyboard: $openKeyboard}';
  }
}

class NeedToLoadPost extends PostLoadType {
  final String maskedPostId;
  NeedToLoadPost(this.maskedPostId);

  // toString
  @override
  String toString() {
    return 'NeedToLoadPost{maskedPostId: $maskedPostId}';
  }
}
