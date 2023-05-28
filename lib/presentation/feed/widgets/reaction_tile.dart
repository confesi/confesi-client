import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/utils/numbers/large_number_formatter.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class ReactionTile extends StatelessWidget {
  const ReactionTile({
    super.key,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final int amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("tap"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
          color: Theme.of(context).colorScheme.surface,
          borderRadius:
              BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 10),
            Text(
              largeNumberFormatter(amount),
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
