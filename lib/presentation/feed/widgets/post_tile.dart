import 'package:confesi/core/router/go_router.dart';

import '../../shared/other/blue_tick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/styles/typography.dart';
import 'child_post.dart';
import 'reaction_tile.dart';

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
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                  strokeAlign: BorderSide.strokeAlignCenter),
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "I found out all the stats profs are in a conspiracy ring together!",
                                style: kDisplay1.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 26 * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
                                ),
                              ),
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: BlueTick(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sapien lacus, lacinia in posuere eget, bibendum quis lectus. Pellentesque eu nulla ullamcorper dui blandit porta vel id urna...",
                          style: kBody.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: kBody.fontSize! * context.watch<UserCubit>().stateAsUser.textSizeEnum.multiplier,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // const SizedBox(height: 15),
                        // const UrlPreviewTile(url: "https://uvic.ca"),
                        // const SizedBox(height: 15),
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
