// import 'package:Confessi/core/utils/numbers/is_plural.dart';
// import 'package:Confessi/core/utils/numbers/number_postfix.dart';
// import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
// import 'package:flutter/material.dart';

// import '../../../core/styles/typography.dart';
// import '../../../core/utils/sizing/height_fraction.dart';

// class LeaderboardHeaderTile extends StatelessWidget {
//   const LeaderboardHeaderTile({
//     super.key,
//     required this.hottests,
//     required this.placing,
//     required this.universityAbbr,
//     required this.universityFullName,
//     required this.url,
//   });

//   final String url;
//   final String universityAbbr;
//   final String universityFullName;
//   final int placing;
//   final int hottests;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
//       decoration: BoxDecoration(
//         border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             color: Theme.of(context).colorScheme.background,
//             width: double.infinity,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                     // shape: BoxShape.circle,
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: Text(
//                     "$placing${numberPostfix(placing)}",
//                     style: kTitle.copyWith(
//                       color: Theme.of(context).colorScheme.onSecondary,
//                     ),
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "$universityFullName / $universityAbbr",
//                         style: kDetail.copyWith(
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         isPlural(hottests) ? "$hottests hottests" : "$hottests hottest",
//                         style: kDetail.copyWith(
//                           color: Theme.of(context).colorScheme.onSurface,
//                         ),
//                         textAlign: TextAlign.left,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }