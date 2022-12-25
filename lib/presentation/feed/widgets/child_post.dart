import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/material.dart';

class ChildPost extends StatefulWidget {
  const ChildPost({super.key});

  @override
  State<ChildPost> createState() => _ChildPostState();
}

class _ChildPostState extends State<ChildPost> {
  @override
  Widget build(BuildContext context) {
    return TouchableScale(
      onTap: () => print("tap"),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Replying to post:",
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              "I wonder if any profs are in the mafia, this is serious",
              style: kDisplay1.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17,
              ),
              textAlign: TextAlign.left,
            ),
            // const SizedBox(height: 5),
            // Text(
            //   "I wonder if any profs are in the mafia, this is serious",
            //   style: kBody.copyWith(
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            //   textAlign: TextAlign.left,
            // ),
          ],
        ),
      ),
    );
  }
}
