import 'package:confesi/application/shared/cubit/maps_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/simple_text.dart';
import 'package:confesi/presentation/shared/other/zoomable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../core/router/go_router.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/other/cached_online_image.dart';

class SchoolDetail extends StatelessWidget {
  const SchoolDetail({super.key, required this.props});

  final HomeLeaderboardSchoolProps props;

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
                          child: TouchableScale(
                            onTap: () => router.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () => router.pop(),
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 30,
                                ),
                              ),
                            ),
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
                            text: "This school's feed",
                          ),
                          SimpleTextButton(
                            bgColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.primary,
                            onTap: () => context.read<MapsCubit>().launchMapAtLocation(
                                props.school.lat.toDouble(), props.school.lon.toDouble(), props.school.name),
                            text: "Locate on map",
                          ),
                        ],
                      ),
                      const SimulatedBottomSafeArea(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
              child: PopButton(
                icon: CupertinoIcons.add,
                textColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPress: () => print("tap"),
                text: "Add school to watched",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
