import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/styles/typography.dart';
import '../behaviours/animated_cliprrect.dart';

class StepperTile extends StatefulWidget {
  const StepperTile({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  State<StepperTile> createState() => _StepperTileState();
}

class _StepperTileState extends State<StepperTile> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => setState(() => isOpen = !isOpen),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onBackground, width:borderSize, strokeAlign: BorderSide.strokeAlignInside),
          color: Theme.of(context).colorScheme.background,
          borderRadius:  BorderRadius.all(
            Radius.circular(Provider.of<UserAuthService>(context).data().componentCurviness.borderRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      children: [
                        Icon(
                          isOpen ? CupertinoIcons.minus : CupertinoIcons.plus,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            widget.question,
                            maxLines: 5,
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedClipRect(
              duration: const Duration(milliseconds: 175),
              reverseDuration: const Duration(milliseconds: 175),
              alignment: Alignment.bottomCenter,
              horizontalAnimation: false,
              open: isOpen,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Text(
                  widget.answer,
                  style: kBody.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
