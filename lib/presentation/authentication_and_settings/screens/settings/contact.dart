import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/text/disclaimer_text.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              bottomBorder: true,
              backgroundColor: Theme.of(context).colorScheme.shadow,
              centerWidget: Text(
                "Support",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                physics: const BouncingScrollPhysics(),
                inlineBottomOrRightPadding: bottomSafeArea(context),
                distancebetweenHapticEffectsDuringScroll: 50,
                hapticEffectAtEdge: HapticType.medium,
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TileGroup(
                        text: "Contact support agent",
                        tiles: [
                          SettingTile(
                            rightIcon: CupertinoIcons.square_on_square,
                            leftIcon: CupertinoIcons.mail,
                            text: "Copy email address",
                            onTap: () => print("COPY"),
                          ),
                          SettingTile(
                            rightIcon: CupertinoIcons.link,
                            leftIcon: CupertinoIcons.mail,
                            text: "Open email",
                            onTap: () => context.read<QuickActionsCubit>().launchMailClientWithToConfesiPopulated(),
                          ),
                        ],
                      ),
                      const DisclaimerText(
                        text: "To permanently delete your account, send us an email.",
                      ),
                      const SimulatedBottomSafeArea(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
