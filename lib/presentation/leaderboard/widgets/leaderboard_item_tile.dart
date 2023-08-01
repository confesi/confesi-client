import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';

import '../../../application/shared/cubit/maps_cubit.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/numbers/is_plural.dart';
import '../../../core/utils/numbers/number_postfix.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class LeaderboardItemTile extends StatelessWidget {
  const LeaderboardItemTile({
    super.key,
    required this.hottests,
    this.placing,
    required this.universityAbbr,
    required this.universityFullName,
  });

  final String universityAbbr;
  final String universityFullName;
  final int? placing;
  final int hottests;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => context
          .read<MapsCubit>()
          .launchMapAtLocation(48.4634, -123.3117, "University of Victoria"), // todo: remove hard coding

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
                      "$universityFullName • $universityAbbr",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isPlural(hottests)
                          ? "${addCommasToNumber(hottests)} hottests"
                          : "${addCommasToNumber(hottests)} hottest",
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
