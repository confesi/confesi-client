import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/text/link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButtonSheet extends StatelessWidget {
  const BottomButtonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        // border: Border(
        //   top: BorderSide(
        //     color: Theme.of(context).colorScheme.onBackground,
        //   ),
        // ),
      ),
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
          LinkText(
            onPress: () => print("tap"),
            linkText: "Skip for now",
            text: "",
          ),
        ],
      ),
    );
  }
}
