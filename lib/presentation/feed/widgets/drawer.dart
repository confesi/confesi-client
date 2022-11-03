import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/icon_text.dart';

class ExploreDrawer extends StatelessWidget {
  const ExploreDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Default Feed",
                        style: kSansSerifDisplay.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "University of Victoria",
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.75),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: SimpleTextButton(
                      onTap: () => print("tap"),
                      text: "All",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SimpleTextButton(
                      onTap: () => print("tap"),
                      text: "Random",
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification && notification.metrics.atEdge) {
                        HapticFeedback.heavyImpact();
                        return true;
                      }
                      if (notification is! ScrollUpdateNotification) return true;
                      HapticFeedback.selectionClick();
                      return true;
                    },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                          IconTextButton(
                            onPress: () => Navigator.of(context).pop(),
                            bottomText: "University of Victoria",
                            topText: "UVic",
                            leftIcon: CupertinoIcons.house,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SimpleTextButton(
                infiniteWidth: true,
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Edit watched universities",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
