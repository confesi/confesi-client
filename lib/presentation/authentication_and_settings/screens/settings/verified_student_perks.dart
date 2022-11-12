import 'package:Confessi/application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'package:Confessi/presentation/authentication_and_settings/widgets/settings/perk_slideshow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/buttons/pop.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/selection_groups/text_stat_tile.dart';
import '../../../shared/selection_groups/text_stat_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class VerifiedStudentPerksScreen extends StatefulWidget {
  const VerifiedStudentPerksScreen({super.key});

  @override
  State<VerifiedStudentPerksScreen> createState() => _VerifiedStudentPerksScreenState();
}

class _VerifiedStudentPerksScreenState extends State<VerifiedStudentPerksScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "Verified Student Perks",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ScrollableView(
                      distancebetweenHapticEffectsDuringScroll: 50,
                      hapticEffectAtEdge: HapticType.medium,
                      controller: ScrollController(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 15),
                          PerkSlideshow(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PopButton(
                    horizontalPadding: 10,
                    justText: true,
                    onPress: () => print("tap"),
                    icon: CupertinoIcons.chevron_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: "Verify Email Now",
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: bottomSafeArea(context)),
                    child: Text(
                      "Verification is done by confirming you have access to a university email address. The email itself is not linked to your account. It is only verified, and then marked as taken.",
                      textScaleFactor: 1,
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
