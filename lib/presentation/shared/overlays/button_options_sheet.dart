import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubit/scaffold_shrinker_cubit.dart';
import '../../../core/styles/typography.dart';
import '../buttons/option.dart';

Future<dynamic> showButtonOptionsSheet(
    BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
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
        padding: const EdgeInsets.only(bottom: 15),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SwipebarLayout(),
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 15),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      text != null
                          ? SizedBox(
                              // This infinite width ensure it is presented on its own row inside the Wrap widget.
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                child: Text(
                                  text,
                                  style: kBody.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(),
                      ...buttons,
                      OptionButton(
                        onTap: () => {},
                        isRed: true,
                        text: "Cancel",
                        icon: CupertinoIcons.xmark,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 7.5),
            ],
          ),
        ),
      ),
    ),
  ).whenComplete(() {
    onComplete != null ? onComplete() : null;
    context.read<ScaffoldShrinkerCubit>().setExpanded();
  });
}
