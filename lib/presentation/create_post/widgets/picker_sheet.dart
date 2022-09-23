import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/buttons/long.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shared/scaffold_shrinker_cubit.dart';
import '../../../core/styles/typography.dart';

Future<dynamic> showPickerSheet(BuildContext context, List<String> items,
    int index, String header, Function(int) updateState) {
  context.read<ScaffoldShrinkerCubit>().setShrunk();
  return showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
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
            const SizedBox(height: 5),
            Text(
              "Selections save automatically",
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return InitOpacity(
                      child: ScrollableView(
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: CupertinoPicker(
                            scrollController:
                                FixedExtentScrollController(initialItem: index),
                            selectionOverlay: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.15),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            looping: false,
                            itemExtent: 40,
                            onSelectedItemChanged: (newIndex) {
                              HapticFeedback.selectionClick();
                              updateState(newIndex);
                            },
                            children: items
                                .map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Center(
                                        child: Text(
                                          item,
                                          style: kBody.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(() => context.read<ScaffoldShrinkerCubit>().setExpanded());
}
