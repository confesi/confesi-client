import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/text/disclaimer_text.dart';
import 'package:scrollable/exports.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../create_post/widgets/faculty_picker_sheet.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/selection_groups/setting_tile.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

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
                  "Account details",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
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
                        TileGroup(
                          text: "Your home university",
                          tiles: [
                            SettingTile(
                              noRightIcon: true,
                              secondaryText: "edit",
                              leftIcon: CupertinoIcons.sparkles,
                              text: "University of Victoria",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        TileGroup(
                          text: "Your year of study (optional)",
                          tiles: [
                            SettingTile(
                              secondaryText: "edit",
                              noRightIcon: true,
                              leftIcon: CupertinoIcons.sparkles,
                              text: "Hidden",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        TileGroup(
                          text: "Your faculty (optional)",
                          tiles: [
                            SettingTile(
                              secondaryText: "edit",
                              noRightIcon: true,
                              leftIcon: CupertinoIcons.sparkles,
                              text: "Hidden",
                              onTap: () => showFacultyPickerSheet(context),
                            ),
                          ],
                        ),
                        const DisclaimerText(
                          text:
                              "These details are shared alongside a confession. You can choose to keep your year and faculty hidden, but you must share your university.",
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
