// import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
// import 'package:Confessi/core/utils/sizing/height_fraction.dart';
// import 'package:Confessi/core/utils/sizing/width_fraction.dart';
// import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import "dart:math" as math;

// enum SwipeDirection {
//   left,
//   right,
// }

// class CardData {
//   CardData(this.child, this.id);

//   final Widget child;
//   final dynamic id;

//   final UniqueKey uniqueKey = UniqueKey();
// }

// class SwipeCardsController extends ChangeNotifier {
//   List<CardData> cards = [];
//   List<SwipeDirection> directions = [];

//   SwipeCardsController(List<CardData> seedCards) {
//     cards = seedCards;
//   }

//   // todo: return either?
//   dynamic topCardId() {
//     if (cards.isEmpty) return;
//     dynamic id = cards.removeAt(0).id;
//     notifyListeners();
//     return id;
//   }

//   // todo: return either?
//   void hideCard(SwipeDirection swipe) {
//     if (cards.isEmpty) return;
//     directions.insert(0, swipe);
//   }
// }

// // todo: if position is != top, shrink it a bit?
// // todo: only allow drag if top index (0) of stack

// class SwipeCards extends StatefulWidget {
//   const SwipeCards({
//     super.key,
//     required this.controller,
//     required this.leftSwipe,
//     required this.rightSwipe,
//   });

//   final SwipeCardsController controller;
//   final Function(dynamic) leftSwipe;
//   final Function(dynamic) rightSwipe;

//   @override
//   State<SwipeCards> createState() => _SwipeCardsState();
// }

// class _SwipeCardsState extends State<SwipeCards> {
//   late List<SwipeDirection> directions;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: widget.controller.cards.isEmpty
//             ? const LoadingCupertinoIndicator()
//             : Stack(
//                 children: widget.controller.cards.map((cardData) {
//                   return _DraggableWrapper(
//                     controller: widget.controller,
//                     leftSwipe: (id) => widget.leftSwipe(id),
//                     rightSwipe: (id) => widget.rightSwipe(id),
//                     child: cardData.child,
//                   );
//                 }).toList(),
//               ),
//       ),
//     );
//   }
// }

// class _DraggableWrapper extends StatefulWidget {
//   const _DraggableWrapper({
//     super.key,
//     required this.leftSwipe,
//     required this.rightSwipe,
//     required this.child,
//     required this.controller,
//   });

//   final Function(dynamic) leftSwipe;
//   final Function(dynamic) rightSwipe;
//   final Widget child;
//   final SwipeCardsController controller;

//   @override
//   State<_DraggableWrapper> createState() => _DraggableWrapperState();
// }

// class _DraggableWrapperState extends State<_DraggableWrapper> with SingleTickerProviderStateMixin {
//   late Offset offset = const Offset(0, 0);
//   bool animateBackToStart = false;
//   late AnimationController translateAnimController;
//   late Animation translateAnim;
//   bool negativeDir = false;

//   @override
//   void initState() {
//     translateAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
//     translateAnim = CurvedAnimation(parent: translateAnimController, curve: Curves.linear);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     translateAnimController.dispose();
//     super.dispose();
//   }

//   double getRotation(double dx) {
//     double rotOffset = dx / 100;
//     int multiplier = rotOffset.isNegative ? -1 : 1;
//     return multiplier *
//         numberUntilLimit(rotOffset.abs(), 2) *
//         math.pi /
//         16; // todo: make negative depending on where card swiped from (top or bottom)
//   }

//   void hideCard(SwipeDirection swipe) {
//     translateAnimController.forward().then((_) {
//       dynamic id = widget.controller.topCardId();
//       if (swipe == SwipeDirection.left) {
//         widget.leftSwipe(id);
//       } else {
//         widget.rightSwipe(id);
//       }
//     });
//     translateAnimController.addListener(() => setState(() => {}));
//   }

//   int getNegMultiplier() => negativeDir ? -1 : 1;

//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(
//       offset: Offset(getNegMultiplier() * translateAnim.value * widthFraction(context, 2), 0),
//       child: Transform.translate(
//         offset: const Offset(0, 0),
//         child: Transform.rotate(
//           angle: getNegMultiplier() * translateAnim.value * math.pi / 5,
//           child: GestureDetector(
//             onPanStart: (details) => setState(() => animateBackToStart = false),
//             onPanUpdate: (details) =>
//                 setState(() => offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy)),
//             onPanEnd: (details) {
//               if (offset.dx.abs() > widthFraction(context, .3) && offset.dy.abs() < heightFraction(context, .5)) {
//                 HapticFeedback.lightImpact();
//                 if (offset.dx.isNegative) {
//                   negativeDir = true;
//                   hideCard(SwipeDirection.left);
//                 }
//                 if (!offset.dx.isNegative) {
//                   negativeDir = false;
//                   hideCard(SwipeDirection.right);
//                 }
//               } else {
//                 setState(() {
//                   offset = const Offset(0, 0);
//                   animateBackToStart = true;
//                 });
//               }
//             },
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     alignment: Alignment.center,
//                     children: [
//                       AnimatedPositioned(
//                         duration: animateBackToStart ? const Duration(milliseconds: 800) : Duration.zero,
//                         curve: Curves.easeOutBack,
//                         left: offset.dx,
//                         top: offset.dy,
//                         child: AnimatedContainer(
//                           duration: animateBackToStart ? const Duration(milliseconds: 800) : Duration.zero,
//                           transform: Matrix4.rotationZ(getRotation(offset.dx)),
//                           curve: Curves.easeOutBack,
//                           child: AnimatedScale(
//                             duration: const Duration(milliseconds: 250),
//                             curve: Curves.easeIn,
//                             scale: 1,
//                             child: widget.child,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Opacity(
//                   opacity: 0,
//                   child: IgnorePointer(
//                     ignoring: true,
//                     child: widget.child,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
