// import 'package:Confessi/core/utils/sizing/width_fraction.dart';
// import 'package:Confessi/core/alt_unused/chat_feed/widgets/swipe_cards.dart';
// import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../../../styles/typography.dart';
// import '../../../../presentation/shared/layout/appbar.dart';

// class ChatFeedHome extends StatefulWidget {
//   const ChatFeedHome({super.key});

//   @override
//   State<ChatFeedHome> createState() => _ChatFeedHomeState();
// }

// class _ChatFeedHomeState extends State<ChatFeedHome> {
//   late SwipeCardsController controller;

//   @override
//   void initState() {
//     controller = SwipeCardsController([
//       CardData(Container(color: Colors.blue, height: 400, width: 300), "abc"),
//       CardData(Container(color: Colors.blue, height: 400, width: 300), "def"),
//     ]);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: ThemedStatusBar(
//         child: Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.background,
//           body: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 AppbarLayout(
//                   bottomBorder: true,
//                   leftIcon: CupertinoIcons.xmark,
//                   centerWidget: Text(
//                     "Chat Feed",
//                     style: kTitle.copyWith(
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: SwipeCards(
//                       leftSwipe: (id) => print(id),
//                       rightSwipe: (id) => print(id),
//                       controller: controller,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [TextButton(onPressed: () => print(controller.topCardId()), child: Text("click"))],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
