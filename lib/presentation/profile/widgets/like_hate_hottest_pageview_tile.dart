import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../shared/other/widget_or_nothing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';

class LikeHateHottestPageviewTile extends StatelessWidget {
  const LikeHateHottestPageviewTile({
    super.key,
    required this.header,
    required this.percentile,
    required this.pluralHeader,
    required this.value,
    this.showSwipeSign = true,
  });

  final int value;
  final bool showSwipeSign;
  final String header;
  final String pluralHeader;
  final double percentile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignCenter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${addCommasToNumber(value)} ${isPlural(value) ? pluralHeader : header}",
            style: kDisplay1.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "You're in the top ${percentile.toString()}% of users.",
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: WidgetOrNothing(
              showWidget: showSwipeSign,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Swipe",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      CupertinoIcons.arrow_right,
                      size: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
