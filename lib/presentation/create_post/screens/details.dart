import '../overlays/confetti_blaster.dart';
import 'package:scrollable/exports.dart';
import '../../../application/create_post/cubit/post_cubit.dart';
import '../../shared/behaviours/nav_blocker.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/overlays/notification_chip.dart';
import '../../shared/selection_groups/tile_group.dart';
import '../../shared/selection_groups/bool_selection_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/appbar.dart';

class CreatePostDetails extends StatefulWidget {
  const CreatePostDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePostDetails> createState() => _CreatePostDetailsState();
}

class _CreatePostDetailsState extends State<CreatePostDetails> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is Error) {
          showNotificationChip(context, state.message, notificationDuration: NotificationDuration.regular);
        } else if (state is SuccessfullySubmitted) {
          ConfettiBlaster().show(context);
        }
      },
      child: NavBlocker(
        blocking: context.watch<CreatePostCubit>().state is Loading,
        child: ThemedStatusBar(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
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
                                    "Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided here plus your school, and your faculty and year of study if you provided them."),
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
                                    TileGroup(
                                      text: "Select genre",
                                      tiles: [
                                        BoolSelectionTile(
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
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     print(await sl.get<LocalDataService>().initDb());
                                    //   },
                                    //   child: Text("init"),
                                    // ),
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     (await sl.get<LocalDataService>().getUserType())
                                    //         .fold((failure) => print(failure), (user) => print(user));
                                    //   },
                                    //   child: Text("userType"),
                                    // ),
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     (await sl
                                    //             .get<LocalDataService>()
                                    //             .createUserPrefs(GuestUser(sl.get<LocalDataService>().defaultPrefs())))
                                    //         .fold((failure) => print(failure), (success) => print(success));
                                    //   },
                                    //   child: Text("set user (GUEST or account)"),
                                    // ),
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     (await sl.get<LocalDataService>().fetchUser())
                                    //         .fold((failure) => print(failure), (user) => print(user.prefs.textScale));
                                    //   },
                                    //   child: Text("fetch user"),
                                    // ),
                                    // TextButton(
                                    //   onPressed: () async {
                                    //     (await sl.get<LocalDataService>().updateUser(textScale: 3))
                                    //         .fold((failure) => print(failure), (success) => print(success));
                                    //   },
                                    //   child: Text("update user to XX"),
                                    // ),
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
                        ),
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
                                      .uploadUserPost("widget.title", "widget.body", "widget.id"),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
