import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/feed/widgets/reaction_tile.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';

import '../../shared/other/blue_tick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../methods/show_post_options.dart';
import 'child_post.dart';

class SimplePostTile extends StatefulWidget {
  const SimplePostTile({super.key});

  @override
  State<SimplePostTile> createState() => _SimplePostTileState();
}

class _SimplePostTileState extends State<SimplePostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => router.push("/home/posts/detail"),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            // only horizontal borders
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
                width: 0.8,
                style: BorderStyle.solid,
              ),
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onBackground,
                width: 0.8,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // bottom border
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 0.8,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "University of Victoria • CSC • 1st year",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "1 hour • 🔥 🚀",
                                  style: kDetail.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          TouchableOpacity(
                            onTap: () => buildOptionsSheet(context),
                            child: Container(
                              // transparent hitbox trick
                              color: Colors.transparent,
                              child: Icon(
                                CupertinoIcons.ellipsis_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "I found out all the stats profs are in a conspiracy ring together!",
                              style: kDisplay1.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: BlueTick(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sapien lacus, lacinia in posuere eget, bibendum quis lectus. Pellentesque eu nulla ullamcorper dui blandit porta vel id urna...",
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          ReactionTile(
                            amount: 1831231,
                            icon: CupertinoIcons.up_arrow,
                            iconColor: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          ReactionTile(
                            amount: 12341,
                            icon: CupertinoIcons.down_arrow,
                            iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                          ReactionTile(
                            amount: 123,
                            icon: CupertinoIcons.chat_bubble,
                            iconColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 15),
                    // const UrlPreviewTile(url: "https://uvic.ca"),
                    // const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
