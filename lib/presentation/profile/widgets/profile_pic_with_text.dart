import 'package:flutter/material.dart';

import '../../shared/text/group.dart';

class ProfilePicWithText extends StatelessWidget {
  const ProfilePicWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 4,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/universities/twu.jpeg"),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const GroupText(
          small: true,
          body: "@mattrlt",
          header: "Matthew Trent",
        ),
      ],
    );
  }
}
