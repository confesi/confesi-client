import 'package:confesi/presentation/profile/widgets/stat_tile.dart';
import 'package:confesi/presentation/shared/selection_groups/rectangle_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/selection_groups/setting_tile.dart';
import '../../shared/selection_groups/setting_tile_group.dart';
import '../../shared/selection_groups/text_stat_tile.dart';

class AccountProfileStats extends StatefulWidget {
  const AccountProfileStats({super.key});

  @override
  State<AccountProfileStats> createState() => _AccountProfileStatsState();
}

class _AccountProfileStatsState extends State<AccountProfileStats> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "Your Account",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIconVisible: true,
                rightIcon: CupertinoIcons.gear,
                rightIconOnPress: () => router.push("/settings"),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ScrollableView(
                  physics: const BouncingScrollPhysics(),
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  controller: ScrollController(),
                  scrollBarVisible: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your stats",
                          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        const StatTile(
                          leftNumber: 21231,
                          leftDescription: "Likes",
                          centerNumber: 1312,
                          centerDescription: "Hottests",
                          rightNumber: 32,
                          rightDescription: "Dislikes",
                        ),
                        const SizedBox(height: 15),
                        TextStatTile(
                          topRounded: true,
                          leftText: "Likes",
                          rightText: "top 10%",
                        ),
                        TextStatTile(
                          leftText: "Hottests",
                          rightText: "top 10%",
                        ),
                        TextStatTile(
                          bottomRounded: true,
                          leftText: "Dislikes",
                          rightText: "top 3.5%",
                        ),
                        const SizedBox(height: 15),
                        RectangleTileGroup(
                          text: "Content",
                          tiles: [
                            RectangleTile(
                              onLeftTap: () => print("tap"),
                              onRightTap: () => print("tap"),
                              icon: CupertinoIcons.bookmark,
                              leftText: "Saved comments",
                              rightText: "Saved confessions",
                            ),
                            RectangleTile(
                              onLeftTap: () => print("tap"),
                              onRightTap: () => print("tap"),
                              icon: CupertinoIcons.cube_box,
                              leftText: "Your comments",
                              rightText: "Your confessions",
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Your details",
                          settingTiles: [
                            SettingTile(
                              leftIcon: CupertinoIcons.pencil,
                              text: "School, faculty, and year",
                              onTap: () => router.push("/home/profile/account"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
