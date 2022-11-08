import 'package:Confessi/application/create_post/cubit/post_cubit.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/nav_blocker.dart';
import 'package:Confessi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:Confessi/presentation/shared/buttons/long.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_area.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile_group.dart';
import 'package:Confessi/presentation/shared/text/link.dart';
import 'package:Confessi/presentation/shared/text/spread_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/appbar.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.id,
  }) : super(key: key);

  final String title;
  final String body;
  final String? id;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is Error) showNotificationChip(context, state.message);
      },
      child: NavBlocker(
        blocking: context.watch<CreatePostCubit>().state is Loading,
        child: ThemedStatusBar(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  NavBlocker(
                    blocking: context.watch<CreatePostCubit>().state is Loading,
                    child: AppbarLayout(
                      bottomBorder: false,
                      centerWidget: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          'Add Details',
                          style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      leftIcon: CupertinoIcons.back,
                      leftIconIgnored: context.watch<CreatePostCubit>().state is Loading,
                      rightIcon: CupertinoIcons.info,
                      rightIconVisible: true,
                      rightIconOnPress: () => showInfoSheet(context, "Confessing",
                          "Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided here."),
                    ),
                  ),
                  Expanded(
                    child: ScrollableArea(
                      horizontalPadding: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          BoolSelectionGroup(
                            text: "Select genre",
                            selectionTiles: [
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.cube_box,
                                text: "General",
                                isActive: true,
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.heart,
                                text: "Relationships",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.hammer_fill,
                                text: "Classess",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.chat_bubble_2,
                                text: "Politics",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.bandage,
                                text: "Wholesome",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                noHorizontalPadding: true,
                                icon: CupertinoIcons.flame,
                                text: "Hot Takes",
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          // const TextStatTileGroup(
                          //   text: "Auto-populated details",
                          //   tiles: [
                          //     TextStatTile(noHorizontalPadding: true, leftText: "Year of study", rightText: "1"),
                          //     TextStatTile(noHorizontalPadding: true, leftText: "Faculty", rightText: "Kept private"),
                          //     TextStatTile(noHorizontalPadding: true, leftText: "University", rightText: "UVic"),
                          //   ],
                          // ),
                          BlocBuilder<CreatePostCubit, CreatePostState>(
                            // buildWhen: (previous, current) => true,
                            builder: (context, state) {
                              return PopButton(
                                topPadding: 20,
                                bottomPadding: 5,
                                loading: state is Loading ? true : false,
                                justText: true,
                                onPress: () async => await context
                                    .read<CreatePostCubit>()
                                    .uploadUserPost(widget.title, widget.body, widget.id),
                                icon: CupertinoIcons.chevron_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                text: 'Submit Confession',
                              );
                            },
                          ),
                          LinkText(
                            onPress: () => print("tap"),
                            text: "Posting as University of Victoria, year 2, computer science. ",
                            linkText: "Tap here to edit.",
                          ),
                          const SimulatedBottomSafeArea(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Text(
//                                       "Posting as University of Victoria, year 1, computer science. Edit these details here.",
//                                       style: kTitle.copyWith(
//                                         color: Theme.of(context).colorScheme.onSurface,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
