import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/buttons/option.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../behaviours/init_opacity.dart';
import '../buttons/simple_text.dart';

Future<dynamic> showButtonOptionsSheet(BuildContext context, List<OptionButton> buttons,
    {String? text, VoidCallback? onComplete}) {
  HapticFeedback.lightImpact();
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    // Optionally, you can change this BorderRadius... it's kinda preference.
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSafeArea(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 200),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SwipebarLayout(),
                  ScrollableView(
                    thumbVisible: false,
                    child: Column(
                      children: buttons,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
