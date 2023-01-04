// import 'package:flutter/material.dart';

// class KeyboardDismissLayout extends StatefulWidget {
//   const KeyboardDismissLayout({
//     required this.child,
//     this.popView = false,
//     Key? key,
//   }) : super(key: key);

//   final Widget child;
//   final bool popView;

//   @override
//   State<KeyboardDismissLayout> createState() => _KeyboardDismissLayoutState();
// }

// class _KeyboardDismissLayoutState extends State<KeyboardDismissLayout> {
//   ScrollNotification? lastScrollNotification;
//   bool alreadyDismissedThisDrag = false;

//   void executeAction() => widget.popView ? Navigator.pop(context) : FocusScope.of(context).unfocus();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragStart: (_) {
//         if (!alreadyDismissedThisDrag) executeAction();
//       },
//       onVerticalDragUpdate: (_) => alreadyDismissedThisDrag = true,
//       onVerticalDragEnd: (_) => alreadyDismissedThisDrag = false,
//       behavior: HitTestBehavior.translucent,
//       onTap: () => executeAction(),
//       child: NotificationListener<ScrollNotification>(
//         onNotification: (notification) {
//           if (notification is UserScrollNotification &&
//               (lastScrollNotification == null || lastScrollNotification is ScrollStartNotification)) {
//             executeAction();
//           }
//           lastScrollNotification = notification;
//           return false;
//         },
//         child: widget.child,
//       ),
//     );
//   }
// }
