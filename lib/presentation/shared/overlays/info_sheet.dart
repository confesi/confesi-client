import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shared/cubit/scaffold_shrinker_cubit.dart';
import '../layout/swipebar.dart';

Future<dynamic> showInfoSheet(BuildContext context, String header, String body) {
  context.read<ScaffoldShrinkerCubit>().setShrunk();
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height / 3),
        padding: const EdgeInsets.only(bottom: 15),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            const SizedBox(height: 15),
            Text(
              header,
              style: kTitle.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Flexible(
              child: ScrollableView(
                horizontalPadding: numberUntilLimit(widthFraction(context, .1), 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InitOpacity(
                      defaultOpacity: 0.2,
                      durationInMilliseconds: 2500,
                      child: Text(
                        body,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(() => context.read<ScaffoldShrinkerCubit>().setExpanded());
}
