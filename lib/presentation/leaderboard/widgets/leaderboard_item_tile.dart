import '../../../core/utils/numbers/add_commas_to_number.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../../core/utils/numbers/number_postfix.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class LeaderboardItemTile extends StatelessWidget {
  const LeaderboardItemTile({
    super.key,
    required this.hottests,
    required this.placing,
    required this.universityAbbr,
    required this.universityFullName,
  });

  final String universityAbbr;
  final String universityFullName;
  final int placing;
  final int hottests;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.8, strokeAlign: BorderSide.strokeAlignCenter),
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "$placing${numberPostfix(placing)}",
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
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
    );
  }
}
