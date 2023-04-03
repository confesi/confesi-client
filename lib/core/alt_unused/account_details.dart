// import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
// import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
// import 'package:scrollable/exports.dart';

// import '../../../../constants/enums_that_are_local_keys.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../application/authentication_and_settings/cubit/user_cubit.dart';
// import '../../../../constants/authentication_and_settings/text.dart';
// import '../../../../core/styles/typography.dart';
// import '../../create_post/widgets/faculty_picker_sheet.dart';
// import '../../shared/behaviours/simulated_bottom_safe_area.dart';
// import '../../shared/behaviours/themed_status_bar.dart';
// import '../../shared/layout/appbar.dart';
// import '../../shared/selection_groups/setting_tile.dart';
// import '../../shared/selection_groups/setting_tile_group.dart';

// class AccountDetailsScreen extends StatelessWidget {
//   const AccountDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ThemedStatusBar(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.shadow,
//         body: SafeArea(
//           bottom: false,
//           child: Column(
//             children: [
//               AppbarLayout(
//                 backgroundColor: Theme.of(context).colorScheme.shadow,
//                 centerWidget: Text(
//                   "Account details",
//                   style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Expanded(
//                 child: ScrollableView(
//                   inlineBottomOrRightPadding: bottomSafeArea(context),
//                   controller: ScrollController(),
//                   scrollBarVisible: false,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         SettingTileGroup(
//                           text: "Audience (your home university)",
//                           settingTiles: [
//                             SettingTile(
//                               noRightIcon: true,
//                               secondaryText: "edit",
//                               leftIcon: CupertinoIcons.sparkles,
//                               text: "University of Victoria",
//                               onTap: () => print("tap"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         SettingTileGroup(
//                           text: "Your year of study (optional)",
//                           settingTiles: [
//                             SettingTile(
//                               secondaryText: "edit",
//                               noRightIcon: true,
//                               leftIcon: CupertinoIcons.sparkles,
//                               text: "Hidden",
//                               onTap: () => print("tap"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         SettingTileGroup(
//                           text: "Your faculty (optional)",
//                           settingTiles: [
//                             SettingTile(
//                               secondaryText: "edit",
//                               noRightIcon: true,
//                               leftIcon: CupertinoIcons.sparkles,
//                               text: "Hidden",
//                               onTap: () => showFacultyPickerSheet(context),
//                             ),
//                           ],
//                         ),
//                         const DisclaimerText(
//                           topPadding: 15,
//                           text:
//                               "These details are shared alongside a confession. You can choose to keep your year and faculty hidden, but you must share your university.",
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
