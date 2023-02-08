// import '../../../core/styles/typography.dart';
// import '../../../core/utils/sizing/width_breakpoint_fraction.dart';
// import '../../shared/behaviours/init_scale.dart';
// import '../../shared/behaviours/init_transform.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../shared/buttons/animated_simple_text.dart';
// import '../../../application/profile/cubit/biometrics_cubit.dart';

// class BiometricOverlayMessage extends StatelessWidget {
//   const BiometricOverlayMessage({
//     super.key,
//     required this.message,
//   });

//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         InitScale(
//           delayDurationInMilliseconds: 450,
//           addedToScale: .3,
//           child: InitTransform(
//             magnitudeOfTransform: -200,
//             child: Icon(
//               CupertinoIcons.lock,
//               color: Theme.of(context).colorScheme.primary,
//               size: 30,
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         SizedBox(
//           width: widthBreakpointFraction(context, .3, 350),
//           child: Text(
//             "Authenticate with biometrics to access your private profile.", // Allow no password, auto-password, or default
//             style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 30),
//         AnimatedSimpleTextButton(
//           useSecondaryColors: true,
//           onTap: () => context.read<BiometricsCubit>().authenticateWithBiometrics(),
//           text: message,
//         ),
//       ],
//     );
//   }
// }
