import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/other/link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/option.dart';
import '../../shared/overlays/button_options_sheet.dart';

class SimplePostTile extends StatefulWidget {
  const SimplePostTile({super.key});

  @override
  State<SimplePostTile> createState() => _SimplePostTileState();
}

class _SimplePostTileState extends State<SimplePostTile> {
  // Show the options for this post.
  void buildOptionsSheet(BuildContext context) => showButtonOptionsSheet(context, [
        OptionButton(
          text: "Save",
          icon: CupertinoIcons.bookmark,
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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/home/simplified_detail"),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    // borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "University of Victoria • Politics • 22m",
                            style: kDetail.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TouchableScale(
                        onTap: () => buildOptionsSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          color: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.ellipsis,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //!
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "I found out all the stats profs are in a conspiracy ring together!",
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sapien lacus, lacinia in posuere eget, bibendum quis lectus. Pellentesque eu nulla ullamcorper dui blandit porta vel id urna...",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        const UrlPreviewTile(url: "https://www.apple.com/ca/shop/buy-watch/apple-watch"),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                //!
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color: Theme.of(context).colorScheme.background, // background
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              CupertinoIcons.chat_bubble,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "42",
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.hand_thumbsdown,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "11.4k",
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              CupertinoIcons.hand_thumbsup,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CupertinoIcons.share,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
