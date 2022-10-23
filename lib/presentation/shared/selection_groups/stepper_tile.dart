import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/animated_cliprrect.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return TouchableOpacity(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
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
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.bottomCenter,
              horizontalAnimation: false,
              open: isOpen,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.decelerate,
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
