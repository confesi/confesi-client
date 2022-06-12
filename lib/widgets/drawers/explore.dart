import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/icon_text.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_text.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/text/link.dart';
import 'package:flutter_mobile_client/widgets/text/row.dart';

class ExploreDrawer extends StatelessWidget {
  const ExploreDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  const GroupText(
                      header: "Current feed", body: "University of Victoria", leftAlign: true),
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
                          style: kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        const IconTextButton(
                          text: "University of Victoria",
                          icon: CupertinoIcons.house,
                        ),
                        LineLayout(
                          color: Theme.of(context).colorScheme.onBackground,
                          bottomPadding: 15,
                        ),
                        Text(
                          "Watched universities (3/5)",
                          style: kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        const IconTextButton(
                          text: "University of Colorado",
                          icon: CupertinoIcons.rocket,
                        ),
                        const IconTextButton(
                          text: "Trinity Western University",
                          icon: CupertinoIcons.rocket,
                        ),
                        const IconTextButton(
                          text: "University of Michigan",
                          icon: CupertinoIcons.rocket,
                        ),
                        LineLayout(
                          color: Theme.of(context).colorScheme.onBackground,
                          bottomPadding: 15,
                        ),
                        Text(
                          "More options",
                          style: kHeader.copyWith(color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        const IconTextButton(
                          text: "Random university",
                          icon: CupertinoIcons.tickets,
                        ),
                        const IconTextButton(
                          text: "All campuses",
                          icon: CupertinoIcons.square_stack_3d_down_right,
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
                      bottomPadding: 15,
                    ),
                    const IconTextButton(
                      text: "Edit watched universities",
                      icon: CupertinoIcons.pencil,
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
