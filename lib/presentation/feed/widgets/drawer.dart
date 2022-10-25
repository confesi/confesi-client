import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/icon_text.dart';
import '../../shared/buttons/touchable_text.dart';
import '../../shared/layout/line.dart';
import '../../shared/text/group.dart';

class ExploreDrawer extends StatelessWidget {
  const ExploreDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupText(header: "Current feed", body: "University of Victoria", leftAlign: true, small: true),
                  LineLayout(
                    color: Theme.of(context).colorScheme.onBackground,
                    topPadding: 15,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Default feed",
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "University of Victoria",
                          leftIcon: CupertinoIcons.house,
                        ),
                        LineLayout(
                          color: Theme.of(context).colorScheme.onBackground,
                          bottomPadding: 15,
                        ),
                        Text(
                          "Watched universities (3/5)",
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "University of Colorado",
                          leftIcon: CupertinoIcons.rocket,
                        ),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "Trinity Western University",
                          leftIcon: CupertinoIcons.rocket,
                        ),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "University of Michigan",
                          leftIcon: CupertinoIcons.rocket,
                        ),
                        LineLayout(
                          color: Theme.of(context).colorScheme.onBackground,
                          bottomPadding: 15,
                        ),
                        Text(
                          "More options",
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "Random university",
                          leftIcon: CupertinoIcons.tickets,
                        ),
                        IconTextButton(
                          onPress: () => Navigator.of(context).pop(),
                          text: "All campuses",
                          leftIcon: CupertinoIcons.square_stack_3d_down_right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    LineLayout(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    TouchableTextButton(
                      textColor: Theme.of(context).colorScheme.primary,
                      animatedClick: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const WatchedUniversitiesSettingsMenu(),
                        //   ),
                        // );
                      },
                      text: "Edit watched universities",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
