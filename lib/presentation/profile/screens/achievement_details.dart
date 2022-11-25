import 'package:Confessi/application/shared/cubit/share_cubit.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/indicators/loading.dart';

class AchievementDetailsScreen extends StatefulWidget {
  const AchievementDetailsScreen({super.key});

  @override
  State<AchievementDetailsScreen> createState() => _AchievementDetailsScreenState();
}

class _AchievementDetailsScreenState extends State<AchievementDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ScrollableView(
        controller: ScrollController(),
        inlineBottomOrRightPadding: bottomSafeArea(context),
        scrollBarVisible: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widthFraction(context, 1),
              height: heightFraction(context, .4),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "https://matthewtrent.me/tests/ach.jpg",
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: LoadingIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Icon(Icons.error, color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Super Duper Hot",
                              style: kSansSerifDisplay.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rare / 3x",
                              style: kDetail.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      EmblemButton(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        icon: CupertinoIcons.share,
                        onPress: () => context
                            .read<ShareCubit>()
                            .shareContent(context, "hey", "Check out my achievement!"), // TODO: fill out here
                        iconColor: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 10),
                      EmblemButton(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        icon: CupertinoIcons.xmark,
                        onPress: () => Navigator.pop(context),
                        iconColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec blandit ex eu nunc mattis auctor. Nam accumsan malesuada quam in egestas. Ut interdum efficitur purus, quis facilisis massa lobortis a. Nullam pharetra vel lacus faucibus accumsan. Quisque suscipit euismod tellus, vitae luctus turpis sodales sit amet. Vivamus feugiat nibh sit amet enim feugiat, ac gravida sem auctor. Mauris eu augue at arcu sodales semper a sit amet nulla.",
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
