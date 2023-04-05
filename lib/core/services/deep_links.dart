import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../results/failures.dart';

// todo: finish iOS deep link implementation using: https://firebase.google.com/docs/dynamic-links/flutter/receive

//! route interface

abstract class DeepLinkRoute {
  String routeName();
}

//! routes

class PostRoute extends DeepLinkRoute {
  late String postId;

  static const String externalRouteName = "/post";

  PostRoute({required Uri uri}) {
    final Map<String, String> params = uri.queryParameters;
    params['id'] == null ? throw const FormatException() : postId = params['id']!;
  }

  @override
  String routeName() => externalRouteName;
}

//! logic

class DeepLinkService {
  static const fallbackWebsite =
      "https://confesi.com"; // todo: make the fallback link an "oops, we couldn't load this post" kind of thing
  static const uriPrefix = "https://confesi.page.link";
  static const imageUri =
      "https://matthewtrent.me/assets/biz-low-res.png"; // todo: replace with real image (perhaps a post preview?)
  static const linkDescription = "Check it out on the Confesi app";
  static const androidPackageName = "com.example.flutter_mobile_client";
  static const iOSBundleId = "com.example.flutterMobileClient";
  static const iOSAppStoreId = "123456789"; // TODO: change with real app store id

  Future<Either<String, DeepLinkFailure>> buildLink(String linkData, String mediaPreviewTitle) async {
    try {
      ShortDynamicLink link = await FirebaseDynamicLinks.instance.buildShortLink(
        DynamicLinkParameters(
          uriPrefix: uriPrefix,
          link: Uri.parse('$uriPrefix$linkData'),
          socialMetaTagParameters: SocialMetaTagParameters(
            title: mediaPreviewTitle,
            imageUrl: Uri.parse(imageUri),
            description: linkDescription,
          ),
          androidParameters: AndroidParameters(
            fallbackUrl: Uri.parse(fallbackWebsite),
            packageName: androidPackageName,
          ),
          iosParameters: IOSParameters(
            fallbackUrl: Uri.parse(fallbackWebsite),
            bundleId: iOSBundleId,
            appStoreId: iOSAppStoreId,
          ),
        ),
      );
      print("LINK:  $link");
      return Left(link.shortUrl.toString());
    } catch (e) {
      print("FAIL 1 $e");
      return Right(DeepLinkFailure());
    }
  }
}

class DeepLinkStream {
  final StreamController<Either<Failure, DeepLinkRoute>> _controller =
      StreamController<Either<Failure, DeepLinkRoute>>();
  late StreamSubscription<Either<Failure, DeepLinkRoute>> _subscription;

  DeepLinkStream() {
    _initDeepLink();
  }

  StreamSubscription<Either<Failure, DeepLinkRoute>> listen(void Function(Either<Failure, DeepLinkRoute> link)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    _subscription = _controller.stream.listen(onData);
    return _subscription;
  }

  Either<Failure, DeepLinkRoute> _parseRoute(Uri link) {
    final String path = link.path;
    try {
      if (path == PostRoute.externalRouteName) {
        return Right(PostRoute(uri: link));
      } else {
        return Left(DeepLinkFailure());
      }
    } catch (_) {
      print("FAIL 2");
      return Left(DeepLinkFailure());
    }
  }

  void _f(Uri link) {
    try {
      _controller.add(_parseRoute(link));
    } catch (_) {
      _controller.add(Left(DeepLinkFailure()));
    }
  }

  void _initDeepLink() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) _f(initialLink.link);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      _f(dynamicLink.link);
    }, onError: (error) {
      _controller.add(Left(DeepLinkFailure()));
    });
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
