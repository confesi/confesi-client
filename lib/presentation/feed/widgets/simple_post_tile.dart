import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/feed/widgets/child_post.dart';
import 'package:Confessi/presentation/feed/widgets/reaction_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/option.dart';
import '../../shared/other/link_preview.dart';
import '../../shared/overlays/button_options_sheet.dart';

class SimplePostTile extends StatefulWidget {
  const SimplePostTile({super.key});

  @override
  State<SimplePostTile> createState() => _SimplePostTileState();
}

class _SimplePostTileState extends State<SimplePostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/home/simplified_detail"),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        // const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ReactionTile(
                                amount: 1831231,
                                icon: CupertinoIcons.up_arrow,
                                iconColor: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 15),
                              ReactionTile(
                                amount: 12341,
                                icon: CupertinoIcons.down_arrow,
                                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                              const SizedBox(width: 15),
                              ReactionTile(
                                amount: 123,
                                icon: CupertinoIcons.chat_bubble,
                                iconColor: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sapien lacus, lacinia in posuere eget, bibendum quis lectus. Pellentesque eu nulla ullamcorper dui blandit porta vel id urna...",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 15),
                        const UrlPreviewTile(url: "https://uvic.ca"),
                        const SizedBox(height: 15),
                        const ChildPost(),
                      ],
                    ),
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
