import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_breakpoint_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubit/scaffold_shrinker_cubit.dart';
import '../layout/swipebar.dart';

// TODO: Make this sheet EASILY disable-able
Future<dynamic> showFeedbackSheet(BuildContext context) {
  bool anotherDialogIsUp =
      context.read<ScaffoldShrinkerCubit>().state is Shrunk;
  HapticFeedback.heavyImpact();
  context.read<ScaffoldShrinkerCubit>().setShrunk();
  return showModalBottomSheet(
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    context: context,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: heightFraction(context, .5)),
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            const SizedBox(height: 15),
            Text(
              "Let's improve Confesi, together.",
              style: kTitle.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              "All feedback (yes, all of it) will be read and considered by the lead developer.",
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            Flexible(
              child: InitScale(
                child: SizedBox(
                  width: widthBreakpointFraction(context, 2 / 3, 250),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleTextButton(
                        infiniteWidth: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/feedback");
                        },
                        text: "Give us feedback",
                      ),
                      const SizedBox(height: 15),
                      SimpleTextButton(
                        infiniteWidth: true,
                        isErrorText: true,
                        onTap: () =>
                            print("NOT YET IMPLEMENTED"), // TODO: implement
                        text: "Disable shake for feedback",
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
    // If another dialog is NOT up already, then you can set scaffold back to being expanded. Else, don't, and let the other sheet deal with it.
  ).whenComplete(() => !anotherDialogIsUp
      ? context.read<ScaffoldShrinkerCubit>().setExpanded()
      : null);
}
