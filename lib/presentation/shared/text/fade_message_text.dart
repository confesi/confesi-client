// import 'package:Confessi/core/styles/typography.dart';
// import 'package:Confessi/presentation/shared/behaviours/animated_cliprrect.dart';
// import 'package:flutter/material.dart';

// class FadeMessageTextController extends ChangeNotifier {
//   final TickerProvider tickerProvider;
//   late AnimationController animController;
//   String message = "";

//   FadeMessageTextController({required this.tickerProvider}) {
//     animController = AnimationController(
//       vsync: tickerProvider,
//       duration: const Duration(milliseconds: 350),
//     );
//   }

//   void hide() {
//     message = "";
//     notifyListeners();
//     animController.reverse();
//     animController.addListener(() {
//       notifyListeners();
//     });
//   }

//   void show(String text) {
//     message = text;
//     notifyListeners();
//     animController.reverse().then((_) {
//       animController.forward();
//       animController.addListener(() {
//         notifyListeners();
//       });
//     });
//   }
// }

// class FadeMessageText extends StatefulWidget {
//   const FadeMessageText({
//     super.key,
//     required this.controller,
//   });

//   final FadeMessageTextController controller;

//   @override
//   State<FadeMessageText> createState() => _FadeMessageTextState();
// }

// class _FadeMessageTextState extends State<FadeMessageText> {
//   @override
//   void initState() {
//     widget.controller.addListener(() => setState(() {}));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSize(
//       clipBehavior: Clip.antiAlias,
//       duration: const Duration(milliseconds: 350),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               widget.controller.message,
//               style: kBody.copyWith(
//                 color: Theme.of(context).colorScheme.error.withOpacity(widget.controller.animController.value),
//               ),
//               textAlign: TextAlign.left,
//             ),
//           ),
//           Positioned.fill(
//             child: Container(
//               color: Colors.blue.withOpacity(1 - widget.controller.animController.value),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
