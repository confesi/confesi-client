import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../button_touch_effects/touchable_opacity.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    this.popContext = true,
    required this.onTap,
    required this.text,
    required this.icon,
    this.isRed = false,
    this.noBottomPadding = false,
    Key? key,
  }) : super(key: key);

  final bool popContext;
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRed;
  final bool noBottomPadding;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        popContext ? Navigator.pop(context) : null;
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: noBottomPadding ? 0 : 5),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
          borderRadius:
              BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Container(
          // Transparent hitbox trick.
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    style: kTitle.copyWith(
                      color: isRed ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
