// import '../../../core/styles/typography.dart';
// import '../../shared/layout/appbar.dart';
// import '../../../domain/feed/entities/post_child.dart';
// import '../widgets/circle_comment_switcher_button.dart';
// import '../widgets/comment_divider.dart';
// import '../widgets/comment_sheet.dart';
// import '../widgets/comment_tile.dart';
// import '../widgets/post_tile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:keyboard_attachable/keyboard_attachable.dart';

// import '../../../constants/feed/enums.dart';
// import '../../../constants/feed/general.dart';
// import '../../../constants/shared/enums.dart';
// import '../../../domain/shared/entities/badge.dart';
// import '../../shared/behaviours/themed_status_bar.dart';
// import '../widgets/infinite_list.dart';

// class DetailViewScreen extends StatefulWidget {
//   const DetailViewScreen({
//     Key? key,
//     required this.icon,
//     required this.genre,
//     required this.time,
//     required this.faculty,
//     required this.text,
//     required this.title,
//     required this.likes,
//     required this.hates,
//     required this.comments,
//     required this.year,
//     required this.university,
//     required this.postChild,
//     required this.badges,
//     required this.universityFullName,
//     required this.id,
//   }) : super(key: key);

//   final String? id;
//   final String universityFullName;
//   final IconData icon;
//   final String genre;
//   final String time;
//   final String faculty;
//   final String text;
//   final String title;
//   final int likes;
//   final int hates;
//   final int year;
//   final String university;
//   final int comments;
//   final PostChild postChild;
//   final List<BadgeEntity> badges;

//   @override
//   State<DetailViewScreen> createState() => _DetailViewScreenState();
// }

// class _DetailViewScreenState extends State<DetailViewScreen> with TickerProviderStateMixin {
//   // Is the scrollview at the very top?
//   bool atTop = true;

//   // Should the button to jump between root comments be visible?
//   bool visible = true;

//   late InfiniteController controller;

//   Future<void> onLoad() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (!mounted) return;
//     setState(() {
//       controller.addItems([1, 2, 3]);
//     });
//   }

//   Future<void> onRefresh() async {
//     HapticFeedback.lightImpact();
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (!mounted) return;
//     setState(() {
//       controller.setItems([1, 2, 3, 4]);
//     });
//   }

//   @override
//   void initState() {
//     controller = InfiniteController(
//       atTop: (isAtTop) {
//         if (!mounted) return;
//         setState(() {
//           atTop = isAtTop;
//         });
//       },
//       feedState: InfiniteListState.feedLoading,
//       preloadBy: 25,
//       items: [],
//       rootIndexes: [10, 20, 30, 40],
//       onLoad: () async => onLoad(),
//       onRefresh: () async => onRefresh(),
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ThemedStatusBar(
//       child: Scaffold(
//         // This bottom sheet is overlayed atop transformed widgets (covers scrollview)
//         // content during scrolling-to-fresh since that utilizes transforms.
//         bottomSheet: Container(
//           height: MediaQuery.of(context).padding.bottom,
//           color: Theme.of(context).colorScheme.background,
//         ),
//         backgroundColor: Theme.of(context).colorScheme.background,
//         resizeToAvoidBottomInset: true,
//         body: SafeArea(
//           child: FooterLayout(
//             footer: KeyboardAttachable(
//               child: CommentSheet(
//                 controller: CommentSheetController(),
//                 onSubmit: (comment) => print(comment),
//                 maxCharacters: kMaxCommentLength,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppbarLayout(
//                   bottomBorder: false,
//                   centerWidget: Text(
//                     'Thread View',
//                     style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                   ),
//                   leftIconVisible: true,
//                   rightIcon: atTop ? null : CupertinoIcons.arrow_up_to_line,
//                   rightIconVisible: atTop ? false : true,
//                   rightIconOnPress: () {
//                     atTop ? null : controller.scrollToTop();
//                   },
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       InfiniteList(
//                         controller: controller,
//                         refreshIndicatorBackgroundColor: Theme.of(context).colorScheme.background,
//                         refreshIndicatorColor: Theme.of(context).colorScheme.primary,
//                         // TODO: implement these widgets:
//                         fullPageLoading: const Text('full page loading'),
//                         fullPageError: const Text('full page error'),
//                         fullPageEmpty: const Text('full page empty'),
//                         feedLoading: const Text('feed loading'),
//                         feedError: const Text('feed error'),
//                         feedEmpty: const Text('feed empty'),
//                         itemBuilder: (context, index) {
//                           return CommentTile(
//                             likes: index,
//                             hates: index,
//                             text: 'dummy text here: $index',
//                             depth: CommentDepth.root,
//                           );
//                         },
//                         header: Column(
//                           children: [
//                             PostTile(
//                               id: widget.id,
//                               badges: widget.badges,
//                               postChild: widget.postChild,
//                               icon: widget.icon,
//                               postView: PostView.detailView,
//                               university: widget.university,
//                               genre: widget.genre,
//                               time: widget.time,
//                               faculty: widget.faculty,
//                               text: widget.text,
//                               title: widget.title,
//                               likes: widget.likes,
//                               hates: widget.hates,
//                               comments: widget.comments,
//                               year: widget.year,
//                               universityFullName: widget.universityFullName,
//                             ),
//                             CommentDivider(
//                               comments: widget.comments,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         right: 10,
//                         bottom: 10,
//                         child: KeyboardVisibilityBuilder(
//                           builder: (context, isKeyboardVisible) {
//                             return CircleCommentSwitcherButton(
//                               visible: !isKeyboardVisible,
//                               scrollToRootDirection: ScrollToRootDirection.down,
//                               controller: controller,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Expanded(
//                 //   child:
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }