import 'package:Confessi/presentation/shared/behaviours/pull_refresh.dart';
import 'package:Confessi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// TODO: make custom AMAZING loading indicator
import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/text/group.dart';
import '../widgets/stat_tile.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  double extraHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PullRefresh(
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
          print("REload..");
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (details) {
            if (details.metrics.pixels <= 0) {
              setState(() {
                extraHeight = -details.metrics.pixels;
              });
            }
            return false;
          },
          child: CupertinoScrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Transform.translate(
                offset: Offset(0, -extraHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: heightFraction(context, .4) + extraHeight,
                      child: Image.asset(
                        "assets/images/universities/ufv.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.background,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: GroupText(
                              small: true,
                              header: "mattrlt",
                              body: "University of Victoria (UVic)",
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, 60),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: widthFraction(context, 1),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SimpleTextButton(
                                            onTap: () => print('tap'),
                                            text: "Comments",
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SimpleTextButton(
                                            onTap: () => print('tap'),
                                            text: "Saved",
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SimpleTextButton(
                                            onTap: () => print('tap'),
                                            text: "Posts",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  StatTile(
                                    leftTap: () => showInfoSheet(
                                        context,
                                        "Total Likes",
                                        "The total amount of likes your posts have acquired: ${addCommasToNumber(17231223)}."),
                                    centerTap: () => showInfoSheet(
                                        context,
                                        "Daily Hottest",
                                        "The number of times one of your posts has reached the Daily Hottest page: ${addCommasToNumber(2)}. It's hard for this to happen even once!"),
                                    rightTap: () => showInfoSheet(
                                        context,
                                        "Total Hates",
                                        "The total amount of hates your posts have acquired: ${addCommasToNumber(3891)}."),
                                    leftNumber: 17231223,
                                    leftDescription: "Total Likes",
                                    centerNumber: 2,
                                    centerDescription: "Daily Hottest",
                                    rightNumber: 3891,
                                    rightDescription: "Total Hates",
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Your achievements (rarest first)",
                                          style: kTitle.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      EmblemButton(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        icon: CupertinoIcons.ellipsis,
                                        onPress: () => print("tap"),
                                        iconColor: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  StaggeredGrid.count(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    children: [
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.purple),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.pink),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.green),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.red),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 4,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Row(
//                           children: [
//                             const Expanded(
//                               child: GroupText(
//                                 leftAlign: true,
//                                 small: true,
//                                 header: "@mattrlt",
//                                 body: "University of Victoria (UVic)",
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             EmblemButton(
//                               backgroundColor: Colors.transparent,
//                               icon: CupertinoIcons.lock,
//                               onPress: () => showInfoSheet(
//                                   context,
//                                   "This Page is Private",
//                                   "Your profile is only ever visible to you. That's why we secure it with biometrics, as we wouldn't want any prying eyes seeing what you've done!"),
//                               iconColor:
//                                   Theme.of(context).colorScheme.onSurface,
//                             ),
//                             const SizedBox(width: 5),
//                             EmblemButton(
//                               backgroundColor: Colors.transparent,
//                               icon: CupertinoIcons.gear,
//                               onPress: () => print("tap"),
//                               iconColor:
//                                   Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ],
//                         ),

// Positioned.fill(
//   child: Padding(
//     padding: const EdgeInsets.all(10),
//     child: Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Spacer(),
        // Container(
        //   height: 120,
        //   width: 120,
        //   decoration: BoxDecoration(
        //     color: Theme.of(context)
        //         .colorScheme
        //         .onSurfaceVariant,
        //     shape: BoxShape.circle,
        //   ),
        // ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             const Expanded(
//               child: GroupText(
//                 leftAlign: true,
//                 small: true,
//                 header: "@mattrlt",
//                 body: "University of Victoria (UVic)",
//               ),
//             ),
//             const SizedBox(width: 10),
//             EmblemButton(
//               backgroundColor: Colors.transparent,
//               icon: CupertinoIcons.lock,
//               onPress: () => showInfoSheet(
//                   context,
//                   "This Page is Private",
//                   "Your profile is only ever visible to you. That's why we secure it with biometrics, as we wouldn't want any prying eyes seeing what you've done!"),
//               iconColor:
//                   Theme.of(context).colorScheme.onSurface,
//             ),
//             const SizedBox(width: 5),
//             EmblemButton(
//               backgroundColor: Colors.transparent,
//               icon: CupertinoIcons.gear,
//               onPress: () => print("tap"),
//               iconColor:
//                   Theme.of(context).colorScheme.onSurface,
//             ),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
