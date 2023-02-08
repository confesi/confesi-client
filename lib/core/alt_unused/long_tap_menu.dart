// import 'package:Confessi/core/utils/sizing/height_fraction.dart';
// import 'package:Confessi/core/utils/sizing/width_fraction.dart';
// import 'package:Confessi/presentation/shared/button_touch_effects/touchable_shrink.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class LongPressMenu extends StatefulWidget {
//   const LongPressMenu({super.key, required this.child});

//   final Widget child;

//   @override
//   State<LongPressMenu> createState() => _LongPressMenuState();
// }

// class _LongPressMenuState extends State<LongPressMenu> with TickerProviderStateMixin {
//   Offset? _touchPoint;
//   // Fade animations
//   AnimationController? _fadeAnimationController;
//   Animation<double>? _fadeAnimation;
//   // Position transforming animations
//   late AnimationController _positionAnimationController;
//   late Animation<double> _positionAnimation;
//   OverlayEntry? _overlayEntry;
//   final double _buttonDiameter = 60;

//   @override
//   void initState() {
//     super.initState();
//     // Position animation
//     _positionAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 125),
//     );
//     _positionAnimation = CurvedAnimation(
//       parent: _positionAnimationController,
//       curve: Curves.linear,
//     );
//     // Fade animation
//     _fadeAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//       reverseDuration: const Duration(milliseconds: 100),
//     );
//     _fadeAnimation = CurveTween(curve: Curves.linear).animate(_fadeAnimationController!);
//     _fadeAnimation!.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _fadeAnimationController!.dispose();
//     super.dispose();
//   }

//   void _showOverlay(BuildContext context, {required String text}) async {
//     OverlayState? overlayState = Overlay.of(context);
//     _overlayEntry = OverlayEntry(builder: (context) {
//       return Positioned.fill(
//         child: FadeTransition(
//           opacity: _fadeAnimation!,
//           child: Container(
//             color: Colors.black.withOpacity(0.7),
//             child: Material(
//               color: Colors.transparent,
//               child: Stack(
//                 children: [
//                   Stack(
//                     children: [
//                       Positioned(
//                         left: _touchPoint!.dx - _buttonDiameter / 2,
//                         top: _touchPoint!.dy - _buttonDiameter / 2,
//                         child: Stack(
//                           children: [
//                             Transform.translate(
//                               offset: Offset(
//                                 _positionAnimation.value * _buttonDiameter * 3 / 2,
//                                 -_positionAnimation.value * _buttonDiameter,
//                               ),
//                               child: Container(
//                                 width: _buttonDiameter,
//                                 height: _buttonDiameter,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             Transform.translate(
//                               offset: Offset(0, -_positionAnimation.value * _buttonDiameter * 3 / 2),
//                               child: Container(
//                                 width: _buttonDiameter,
//                                 height: _buttonDiameter,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             Transform.translate(
//                               offset: Offset(
//                                 -_positionAnimation.value * _buttonDiameter * 3 / 2,
//                                 -_positionAnimation.value * _buttonDiameter,
//                               ),
//                               child: Container(
//                                 width: _buttonDiameter,
//                                 height: _buttonDiameter,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: _buttonDiameter,
//                               height: _buttonDiameter,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.transparent,
//                                 border: Border.all(
//                                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                                   width: 6,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//     _fadeAnimationController!.addListener(() {
//       overlayState!.setState(() {});
//     });
//     // inserting overlay entry
//     overlayState!.insert(_overlayEntry!);
//     _fadeAnimationController!.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TouchableShrink(
//       onLongPress: () {}, // Do nothing, just have this animation
//       child: GestureDetector(
//         onLongPress: () {
//           // Called on long press
//           HapticFeedback.lightImpact();
//           _showOverlay(context, text: "HEY!");
//           _positionAnimationController.forward();
//           _positionAnimation.addListener(() {
//             setState(() {});
//           });
//         },
//         onLongPressMoveUpdate: (details) {
//           // Called on update finger position
//           print(details.globalPosition);
//         },
//         onLongPressEnd: (details) {
//           // Called on release
//           _positionAnimationController.reverse();
//           _fadeAnimationController!.reverse().whenComplete(() => _overlayEntry!.remove());
//         },
//         onLongPressDown: (details) {
//           // Called instantly on touching the screen
//           _touchPoint = details.globalPosition;
//         },
//         child: widget.child,
//       ),
//     );
//   }
// }
