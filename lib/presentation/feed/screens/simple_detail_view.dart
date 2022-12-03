import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/presentation/feed/widgets/post_stat_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key});

  @override
  State<SimpleDetailViewScreen> createState() => _SimpleDetailViewScreenState();
}

class _SimpleDetailViewScreenState extends State<SimpleDetailViewScreen> {
  bool bottomSheetIsShown = true;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: (details) {
          if (details is ScrollUpdateNotification) {
            if (details.scrollDelta! > 0) {
              setState(() {
                bottomSheetIsShown = false;
              });
            } else if (details.scrollDelta! < 0) {
              setState(() {
                bottomSheetIsShown = true;
              });
            }
          } else if (details is ScrollEndNotification && details.metrics.atEdge) {
            setState(() {
              bottomSheetIsShown = true;
            });
          }
          return false;
        },
        child: Column(
          children: [
            // AppbarLayout(
            //   backgroundColor: Color.fromARGB(255, 232, 138, 138),
            //   bottomBorder: false,
            //   centerWidget: Text(
            //     "Confession View",
            //     style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            //     overflow: TextOverflow.ellipsis,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            const PostStatTile(),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "I found out all the stats profs are in a conspiracy ring together!",
                                style: kTitle.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  SimpleTextButton(
                                    onTap: () => Navigator.pushNamed(context, '/home/profile/posts'),
                                    text: "Quote",
                                  ),
                                  SimpleTextButton(
                                    onTap: () => Navigator.pushNamed(context, '/home/profile/posts'),
                                    text: "Flag",
                                  ),
                                  SimpleTextButton(
                                    onTap: () => Navigator.pushNamed(context, '/home/profile/posts'),
                                    text: "Save",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Year 1 Computer Science / Politics / 22min ago / University of Victoria",
                                style: kDetail.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla.",
                                style: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: bottomSafeArea(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
