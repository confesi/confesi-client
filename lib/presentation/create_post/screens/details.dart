import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/presentation/create_post/widgets/faculty_picker_sheet.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:scrollable/exports.dart';

import '../../../application/create_post/cubit/post_cubit.dart';
import '../../shared/behaviours/nav_blocker.dart';
import '../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../../core/alt_unused/notification_chip.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/layout/scrollable_area.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/selection_groups/bool_selection_group.dart';
import '../../shared/selection_groups/bool_selection_tile.dart';
import '../../shared/selection_groups/text_stat_tile.dart';
import '../../shared/selection_groups/text_stat_tile_group.dart';
import '../../shared/text/link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
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
        if (state is Error) {
          showNotificationChip(context, state.message, notificationDuration: NotificationDuration.regular);
        }
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
                  Expanded(
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
                            leftIconIgnored: context.watch<CreatePostCubit>().state is Loading,
                            rightIcon: CupertinoIcons.info,
                            rightIconVisible: true,
                            rightIconOnPress: () => showInfoSheet(context, "Confessing",
                                "Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided here."),
                          ),
                        ),
                        Expanded(
                          child: ScrollableView(
                            physics: const BouncingScrollPhysics(),
                            scrollBarVisible: false,
                            hapticsEnabled: false,
                            inlineBottomOrRightPadding: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            controller: ScrollController(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15),
                                BoolSelectionGroup(
                                  text: "Select genre",
                                  selectionTiles: [
                                    BoolSelectionTile(
                                      topRounded: true,
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.cube_box,
                                      text: "General",
                                      isActive: true,
                                      onTap: () => print("tap"),
                                    ),
                                    BoolSelectionTile(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.heart,
                                      text: "Relationships",
                                      onTap: () => print("tap"),
                                    ),
                                    BoolSelectionTile(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.hammer_fill,
                                      text: "Classess",
                                      onTap: () => print("tap"),
                                    ),
                                    BoolSelectionTile(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.chat_bubble_2,
                                      text: "Politics",
                                      onTap: () => print("tap"),
                                    ),
                                    BoolSelectionTile(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.bandage,
                                      text: "Wholesome",
                                      onTap: () => print("tap"),
                                    ),
                                    BoolSelectionTile(
                                      bottomRounded: true,
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      icon: CupertinoIcons.flame,
                                      text: "Hot Takes",
                                      onTap: () => print("tap"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SettingTileGroup(
                                  text: "Audience (your home university)",
                                  settingTiles: [
                                    SettingTile(
                                      noRightIcon: true,
                                      secondaryText: "edit",
                                      leftIcon: CupertinoIcons.sparkles,
                                      text: "University of Victoria",
                                      onTap: () => print("tap"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SettingTileGroup(
                                  text: "Your year of study (optional)",
                                  settingTiles: [
                                    SettingTile(
                                      secondaryText: "edit",
                                      noRightIcon: true,
                                      leftIcon: CupertinoIcons.sparkles,
                                      text: "Hidden",
                                      onTap: () => print("tap"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SettingTileGroup(
                                  text: "Your faculty (optional)",
                                  settingTiles: [
                                    SettingTile(
                                      secondaryText: "edit",
                                      noRightIcon: true,
                                      leftIcon: CupertinoIcons.sparkles,
                                      text: "Hidden",
                                      onTap: () => showFacultyPickerSheet(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 0.8))),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: BlocBuilder<CreatePostCubit, CreatePostState>(
                          // buildWhen: (previous, current) => true,
                          builder: (context, state) {
                            return PopButton(
                              topPadding: 15,
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
