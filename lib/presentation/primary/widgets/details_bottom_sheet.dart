import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/text/link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingDetailsBottomSheet extends StatelessWidget {
  const OnboardingDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopButton(
            justText: true,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onSecondary,
            text: "Continue",
            onPress: () => print("tap"),
            icon: CupertinoIcons.chevron_forward,
          ),
          const SizedBox(height: 15),
          Text(
            "Tap the blanks to edit them",
            textAlign: TextAlign.center,
            style: kTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          )
        ],
      ),
    );
  }
}
