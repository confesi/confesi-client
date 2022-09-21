import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_burst.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/presentation/shared/text/group.dart';
import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('tap'),
      child: Container(
        margin: EdgeInsets.all(widthFraction(context, .01)),
        width: widthFraction(context, .49),
        height: widthFraction(context, .67),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.shadow,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/images/achievements/pigeon.png",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          "The Chatterbox",
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Rare",
                              textAlign: TextAlign.left,
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            LineLayout(color: Theme.of(context).colorScheme.onBackground),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                "16x",
                textAlign: TextAlign.left,
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
