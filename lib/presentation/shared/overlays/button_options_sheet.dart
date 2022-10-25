import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../buttons/option.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
  HapticFeedback.lightImpact();
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: bottomSafeArea(context)),
      child: InitScale(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SwipebarLayout(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  child: Text(
                                    text,
                                    style: kBody.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
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
    ),
  );
}
