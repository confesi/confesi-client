import '../widgets/settings/perk_slideshow.dart';
import '../../shared/overlays/info_sheet.dart';

import '../../shared/buttons/pop.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';

class VerifiedStudentPerksTab extends StatefulWidget {
  const VerifiedStudentPerksTab({super.key, required this.nextScreen});

  final VoidCallback nextScreen;

  @override
  State<VerifiedStudentPerksTab> createState() => _VerifiedStudentPerksTabState();
}

class _VerifiedStudentPerksTabState extends State<VerifiedStudentPerksTab> {
  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
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
              rightIcon: CupertinoIcons.info,
              rightIconVisible: true,
              rightIconOnPress: () => showInfoSheet(context, "Verification",
                  "The perks that come with verification can be turned on/off whenever you want. This ensures you're never stuck with undesired perks."),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ScrollableView(
                      physics: const BouncingScrollPhysics(),
                      distancebetweenHapticEffectsDuringScroll: 50,
                      hapticEffectAtEdge: HapticType.medium,
                      controller: ScrollController(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    onPress: () => widget.nextScreen(),
                    icon: CupertinoIcons.chevron_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: "Next",
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: bottomSafeArea(context)),
                    child: Text(
                      "Verifying your student email allows us to confirm you're a real student. Your email is always kept private.",
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
