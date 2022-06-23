// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobile_client/constants/typography.dart';
// import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
// import 'package:flutter_mobile_client/state/token_slice.dart';
// import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// enum DisplayState { loading, error, endOfFeed }

// class SpinnerOrTextConnection extends ConsumerWidget {
//   const SpinnerOrTextConnection({this.onVisible, required this.displayState, Key? key})
//       : super(key: key);

//   final VoidCallback? onVisible;
//   final DisplayState displayState;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 200),
//         transitionBuilder: (Widget child, Animation<double> animation) =>
//             FadeTransition(opacity: animation, child: child),
//         child: AnimatedSize(
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           duration: const Duration(milliseconds: 400),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Center(
//               child: displayState == DisplayState.loading
//                   ? VisibilityDetector(
//                       key: const Key("loading-indicator"),
//                       onVisibilityChanged: (details) {
//                         if (details.visibleFraction > 0) {
//                           if (onVisible != null) {
//                             onVisible!();
//                           }
//                         }
//                       },
//                       child: const CupertinoActivityIndicator(),
//                     )
//                   : displayState == DisplayState.error
//                       ? Text(
//                           "Error. Try again. Really long text that should be a big problem unless it is fixed. Error. Try again. Really long text that should be a big problem unless it is fixed.",
//                           style: kDetail.copyWith(color: Theme.of(context).colorScheme.primary),
//                           textAlign: TextAlign.center,
//                           // overflow: TextOverflow.ellipsis,
//                         )
//                       : ErrorWithButtonText(
//                           headerText: "You've reached the bottom",
//                           buttonText: "load mores",
//                           onPress: () => ref.read(exploreFeedProvider.notifier)
//                           // .getPosts(ref.read(tokenProvider).accessToken, LoadingType.morePosts),
//                           ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
