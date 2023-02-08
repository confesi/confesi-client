// import 'package:Confessi/core/styles/typography.dart';
// import 'package:Confessi/core/utils/sizing/width_fraction.dart';
// import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
// import 'package:Confessi/presentation/shared/other/cached_online_image.dart';

// import '../../../application/shared/cubit/share_cubit.dart';
// import '../../../constants/profile/enums.dart';
// import '../../../core/converters/achievement_rarity_to_color.dart';
// import '../../../core/converters/achievement_rarity_to_string.dart';
// import '../overlays/achievement_sheet.dart';
// import '../../shared/button_touch_effects/touchable_opacity.dart';
// import '../../shared/button_touch_effects/touchable_scale.dart';
// import '../../shared/overlays/info_sheet_with_action.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../shared/indicators/loading_cupertino.dart';
// import '../../shared/indicators/loading_material.dart';

// class AchievementTile extends StatelessWidget {
//   const AchievementTile({
//     super.key,
//     required this.title,
//     required this.aspectRatio,
//     required this.achievementImgUrl,
//     required this.description,
//     required this.quantity,
//     required this.rarity,
//   });

//   final AchievementRarity rarity;
//   final String achievementImgUrl;
//   final String title;
//   final String description;
//   final int quantity;
//   final double aspectRatio;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: InitScale(
//         child: TouchableScale(
//           onTap: () => showAchievementSheet(context, rarity, title, description, quantity),
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 child: AspectRatio(
//                   aspectRatio: aspectRatio,
//                   child: CachedOnlineImage(
//                     url: achievementImgUrl,
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: const EdgeInsets.all(5),
//                   padding: const EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                     color: Theme.of(context).colorScheme.background,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                           "x$quantity",
//                           style: kBody.copyWith(
//                             color: Theme.of(context).colorScheme.onError,
//                           ),
//                           textAlign: TextAlign.left,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(width: 10),
//                         Container(
//                           height: 8,
//                           width: 8,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: achievementRarityToColor(rarity),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
