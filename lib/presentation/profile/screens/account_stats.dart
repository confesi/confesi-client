import 'package:confesi/presentation/profile/widgets/stat_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/selection_groups/text_stat_tile.dart';
import '../../shared/selection_groups/text_stat_tile_group.dart';

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
                  "Account stats",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ScrollableView(
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  controller: ScrollController(),
                  scrollBarVisible: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const StatTile(
                          leftNumber: 21231,
                          leftDescription: "Likes",
                          centerNumber: 1312,
                          centerDescription: "Hottests",
                          rightNumber: 32,
                          rightDescription: "Dislikes",
                        ),
                        const SizedBox(height: 10),
                        const TextStatTileGroup(
                          text: "How you compare to others",
                          tiles: [
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
                          ],
                        ),
                        const SizedBox(height: 30),
                        PopButton(
                          justText: true,
                          onPress: () {
                            FocusScope.of(context).unfocus();
                          },
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          text: "Share your stats",
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
