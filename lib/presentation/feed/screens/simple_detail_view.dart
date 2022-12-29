import 'package:Confessi/presentation/feed/widgets/post_stat_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/buttons/option.dart';
import 'package:Confessi/presentation/shared/overlays/button_options_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/notification_chip.dart';

class SimpleDetailViewScreen extends StatefulWidget {
  const SimpleDetailViewScreen({super.key});

  @override
  State<SimpleDetailViewScreen> createState() => _SimpleDetailViewScreenState();
}

class _SimpleDetailViewScreenState extends State<SimpleDetailViewScreen> {
  bool bottomSheetIsShown = true;

  // Show the options for this post.
  void buildOptionsSheet(BuildContext context) => showButtonOptionsSheet(context, [
        OptionButton(
          text: "Share",
          icon: CupertinoIcons.share,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Quote",
          icon: CupertinoIcons.paperplane,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Save",
          icon: CupertinoIcons.bookmark,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Details",
          icon: CupertinoIcons.info,
          onTap: () => print("tap"),
        ),
        OptionButton(
          text: "Report",
          icon: CupertinoIcons.flag,
          onTap: () => print("tap"),
        ),
      ]);

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
            Hero(
              tag: 'purple',
              child: PostStatTile(
                icon1OnPress: () => Navigator.pop(context),
                icon2OnPress: () => print("tap"),
                icon3OnPress: () => print("tap"),
                icon4OnPress: () => print("tap"),
                icon5OnPress: () => print("tap"),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                                    onTap: () => buildOptionsSheet(context),
                                    text: "Advanced options",
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
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan.",
                                style: kBody.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20),
                              // const CommentSortTile(),
                              SimpleTextButton(
                                infiniteWidth: true,
                                onTap: () => print("tap"),
                                text: "Sort by: most liked",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: bottomSafeArea(context)),
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
