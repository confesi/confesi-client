import 'dart:math';

import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/shared/behaviours/animated_bobbing.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:confesi/presentation/shared/buttons/pop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/router/go_router.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../layout/swipebar.dart';

// static function to return a random ShakeConstant from a list of classes that extend from it
ShakeConstant _randomShakeConstant() {
  List<ShakeConstant> shakes = [
    ShakeCrazyConstant1(),
    ShakeCrazyConstant2(),
    ShakeDefaultConstant1(),
    ShakeDefaultConstant2(),
    ShakeHardConstant1(),
    ShakeHardConstant2(),
    ShakeHorizontalConstant1(),
    ShakeHorizontalConstant2(),
    ShakeOpacityConstant(),
    ShakeSlowConstant1(),
    ShakeCrazyConstant2(),
    ShakeVerticalConstant1(),
    ShakeVerticalConstant2(),
  ];
  return shakes[Random().nextInt(shakes.length)];
}

Future<dynamic> showRegisteredUserOnlySheet(BuildContext context, {VoidCallback? onComplete}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) => ClipRRect(
      // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SwipebarLayout(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: bottomSafeArea(context), top: 15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              walrusFullBodyImgPath,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "The walrus is not impressed",
                        style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Guests have read-only access. Registered users can do everything.",
                        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      PopButton(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        textColor: Theme.of(context).colorScheme.onSecondary,
                        text: "Create account",
                        onPress: () {
                          router.pop();
                          router.push("/register", extra: const RegistrationPops(true));
                        },
                        icon: CupertinoIcons.add,
                        justText: true,
                      ),
                      const SimulatedBottomSafeArea()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
