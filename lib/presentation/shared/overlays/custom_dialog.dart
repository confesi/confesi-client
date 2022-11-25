// import 'package:Confessi/core/styles/typography.dart';
// import 'package:Confessi/core/utils/sizing/height_fraction.dart';
// import 'package:Confessi/core/utils/sizing/width_fraction.dart';
// import 'package:Confessi/presentation/shared/button_touch_effects/touchable_shrink.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../buttons/emblem.dart';

// class LongPressMenu extends StatefulWidget {
//   const LongPressMenu({super.key, required this.child});

//   final Widget child;

//   @override
//   State<LongPressMenu> createState() => _LongPressMenuState();
// }

// class _LongPressMenuState extends State<LongPressMenu> with TickerProviderStateMixin {
//   AnimationController? _fadeAnimationController;
//   Animation<double>? _fadeAnimation;

//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     // Fade animation
//     _fadeAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 175),
//       reverseDuration: const Duration(milliseconds: 175),
//     );
//     _fadeAnimation = CurveTween(curve: Curves.decelerate).animate(_fadeAnimationController!);
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
//             color: Colors.black.withOpacity(0.4),
//             child: Material(
//               color: Colors.transparent,
//               child: Center(
//                 child: Transform.scale(
//                   scale: _fadeAnimationController!.value,
//                   child: Container(
//                     margin: const EdgeInsets.all(15),
//                     constraints: BoxConstraints(minHeight: heightFraction(context, 1 / 3)),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.background.withOpacity(_fadeAnimationController!.value),
//                       borderRadius: const BorderRadius.all(Radius.circular(0)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Hottest of the day",
//                             style: kSansSerifDisplay.copyWith(
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                           Text(
//                             "Hottest of the day",
//                             style: kBody.copyWith(
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           EmblemButton(
//                             backgroundColor: Theme.of(context).colorScheme.surface,
//                             icon: CupertinoIcons.xmark,
//                             onPress: () => _fadeAnimationController!.reverse().then((value) => _overlayEntry!.remove()),
//                             iconColor: Theme.of(context).colorScheme.onSurface,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
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
//     return GestureDetector(
//       onTap: () => _showOverlay(context, text: "HEY!"),
//       child: widget.child,
//     );
//   }
// }
