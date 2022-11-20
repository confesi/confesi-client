import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile_group.dart';
import 'package:scrollable/exports.dart';

import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/layout/scrollable_area.dart';
import '../../shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/shared/enums.dart';
import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../../../constants/feed/general.dart';
import '../../shared/overlays/info_sheet.dart';

class PostAdvancedDetailsScreen extends StatelessWidget {
  const PostAdvancedDetailsScreen({
    Key? key,
    required this.comments,
    required this.faculty,
    required this.genre,
    required this.hates,
    required this.likes,
    required this.moderationStatus,
    required this.saves,
    required this.university,
    required this.year,
    required this.universityFullName,
  }) : super(key: key);

  final String universityFullName;
  final int likes;
  final int hates;
  final int comments;
  final int saves;
  final String university;
  final String faculty;
  final String genre;
  final int year;
  final String moderationStatus;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppbarLayout(
                  bottomBorder: false,
                  leftIcon: CupertinoIcons.xmark,
                  centerWidget: Text(
                    "Advanced Details",
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ScrollableView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        TextStatTileGroup(
                          text: "Quick stats",
                          tiles: [
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Likes",
                              rightText: addCommasToNumber(likes),
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Hates",
                              rightText: addCommasToNumber(hates),
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Comments",
                              rightText: addCommasToNumber(comments),
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Saves",
                              rightText: addCommasToNumber(saves),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextStatTileGroup(
                          text: "About the confessor",
                          tiles: [
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "University (abbr.)",
                              rightText: university,
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "University (full)",
                              rightText: universityFullName,
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Faculty",
                              rightText: faculty,
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Genre",
                              rightText: genre,
                            ),
                            TextStatTile(
                              noHorizontalPadding: true,
                              leftText: "Year of study",
                              rightText: year.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
