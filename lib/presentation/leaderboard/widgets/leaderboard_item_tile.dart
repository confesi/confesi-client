import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/models/school.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/numbers/add_commas_to_number.dart';

import '../../../core/utils/numbers/is_plural.dart';
import '../../../core/utils/numbers/number_postfix.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class LeaderboardItemTile extends StatelessWidget {
  const LeaderboardItemTile({
    super.key,
    this.placing,
    required this.school,
  });

  final School school;
  final int? placing;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => router.push(
        "/home/leaderboard/school",
        extra: HomeLeaderboardSchoolProps(school),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignInside),
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: placing != null
                    ? Text(
                        "$placing${numberPostfix(placing!)}",
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Icon(
                        CupertinoIcons.building_2_fill,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${school.name} • ${school.abbr}",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isPlural(school.dailyHottests)
                          ? "${addCommasToNumber(school.dailyHottests)} hottests"
                          : "${addCommasToNumber(school.dailyHottests)} hottest",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
