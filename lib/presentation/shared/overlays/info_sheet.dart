import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubit/scaffold_shrinker_cubit.dart';
import '../layout/swipebar.dart';

Future<dynamic> showInfoSheet(
    BuildContext context, String header, String body) {
  context.read<ScaffoldShrinkerCubit>().setShrunk();
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height / 2),
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
                horizontalPadding: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InitScale(
                      child: Text(
                        body,
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
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