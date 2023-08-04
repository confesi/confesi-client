import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/go_router.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../shared/buttons/circle_icon_btn.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/other/cached_online_image.dart';

class SchoolDetail extends StatelessWidget {
  const SchoolDetail({super.key, required this.props});

  final HomeLeaderboardSchoolProps props;

  Widget buildBottomBtn(BuildContext context, bool shown) => AbsorbPointer(
        absorbing: !shown,
        child: Opacity(
          opacity: shown ? 1 : 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: PopButton(
                    topPadding: 15,
                    bottomPadding: 15,
                    loading: false,
                    justText: true,
                    onPress: () {
                      print("tap");
                    },
                    icon: CupertinoIcons.chevron_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: 'Add school to watched',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: heightFraction(context, .4),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Theme.of(context).colorScheme.shadow,
                          child: Zoomable(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              child: CachedOnlineImage(
                                url: props.school.imgUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 10,
                        child: SafeArea(
                          child: CircleIconBtn(
                            onTap: () => router.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        props.school.name,
                        style: kDisplay2.copyWith(color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isPlural(props.school.dailyHottests)
                            ? "${addCommasToNumber(props.school.dailyHottests)} hottests 🔥"
                            : "${addCommasToNumber(props.school.dailyHottests)} hottest 🔥",
                        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        props.school.abbr,
                        style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: [
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.primary,
                            onTap: () => print("tap"),
                            text: "Jump to this school's feed",
                          ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.primary,
                            onTap: () => print("todo: locate on map"),
                            text: "Locate on map",
                          ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.primary,
                            onTap: () => print("tap"),
                            text: "Set as home",
                          ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.primary,
                            onTap: () => print("tap"),
                            text: "Website",
                          ),
                        ],
                      ),
                      buildBottomBtn(context, false), // for sizing reasons
                      const SimulatedBottomSafeArea(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildBottomBtn(context, true)
        ],
      ),
    );
  }
}
