import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/creating_and_editing_posts_service/create_edit_posts_service.dart';
import 'package:confesi/presentation/create_post/overlays/confetti_blaster.dart';
import 'package:confesi/presentation/shared/selection_groups/switch_selection_tile.dart';
import 'package:provider/provider.dart';

import 'package:scrollable/exports.dart';
import '../../../core/router/go_router.dart';
import '../../../init.dart';
import '../../shared/behaviours/nav_blocker.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/selection_groups/tile_group.dart';
import '../../shared/selection_groups/bool_selection_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/appbar.dart';

class CreatePostDetails extends StatefulWidget {
  const CreatePostDetails({Key? key}) : super(key: key);

  @override
  State<CreatePostDetails> createState() => _CreatePostDetailsState();
}

class _CreatePostDetailsState extends State<CreatePostDetails> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavBlocker(
      blocking: Provider.of<CreatingEditingPostsService>(context).metaState is CreatingEditingPostMetaStateLoading,
      child: ThemeStatusBar(
        child: KeyboardDismiss(
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
                              blocking: Provider.of<CreatingEditingPostsService>(context).metaState
                                  is CreatingEditingPostMetaStateLoading,
                              child: AppbarLayout(
                                backgroundColor: Theme.of(context).colorScheme.background,
                                bottomBorder: true,
                                centerWidget: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    "Add Details",
                                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                leftIconIgnored: Provider.of<CreatingEditingPostsService>(context).metaState
                                    is CreatingEditingPostMetaStateLoading,
                                rightIcon: CupertinoIcons.info,
                                rightIconVisible: true,
                                leftIconDisabled: Provider.of<CreatingEditingPostsService>(context).metaState
                                    is CreatingEditingPostMetaStateLoading,
                                rightIconOnPress: () => showInfoSheet(context, "Confessing",
                                    "Please be civil when posting, but have fun! All confessions are anonymous, excluding the details provided here plus your school, and your faculty and year of study if you provided them."),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Theme.of(context).colorScheme.shadow,
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
                                      BlocBuilder<PostCategoriesCubit, PostCategoriesState>(
                                        builder: (context, state) {
                                          if (state is PostCategoriesData) {
                                            return Column(
                                              children: [
                                                TileGroup(
                                                  text: "Allow users to message you anonymously off this post",
                                                  tiles: [
                                                    SwitchSelectionTile(
                                                      isActive:
                                                          Provider.of<CreatingEditingPostsService>(context).isChatPost,
                                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                                      icon: CupertinoIcons.chat_bubble_2,
                                                      text: "Chat post",
                                                      onTap: () => Provider.of<CreatingEditingPostsService>(context,
                                                              listen: false)
                                                          .setIsChatPost(!Provider.of<CreatingEditingPostsService>(
                                                                  context,
                                                                  listen: false)
                                                              .isChatPost),
                                                    ),
                                                  ],
                                                ),
                                                TileGroup(
                                                  text: "Select genre",
                                                  tiles: state.categories.map((category) {
                                                    return BoolSelectionTile(
                                                      isActive:
                                                          state.selectedIndex == state.categories.indexOf(category),
                                                      icon: category.icon,
                                                      text: category.name,
                                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                                      onTap: () => context
                                                          .read<PostCategoriesCubit>()
                                                          .updateCategoryIdx(state.categories.indexOf(category)),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            );
                                          } else {
                                            throw Exception("bad state");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
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
                          child: Container(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  width: borderSize,
                                ),
                              ),
                            ),
                            child: PopButton(
                              topPadding: 15,
                              bottomPadding: 15,
                              loading: Provider.of<CreatingEditingPostsService>(context).metaState
                                  is CreatingEditingPostMetaStateLoading,
                              justText: true,
                              onPress: () async {
                                final provider = Provider.of<CreatingEditingPostsService>(context, listen: false);
                                final selectedCategory = context
                                    .read<PostCategoriesCubit>()
                                    .data
                                    .categories[context.read<PostCategoriesCubit>().data.selectedIndex]
                                    .name;
                                (await provider.createNewPost(
                                  provider.title,
                                  provider.body,
                                  selectedCategory,
                                  Provider.of<CreatingEditingPostsService>(context, listen: false)
                                      .images
                                      .map((e) => e.editingFile)
                                      .toList(),
                                  Provider.of<CreatingEditingPostsService>(context, listen: false).isChatPost,
                                )) // todo: files
                                    .fold(
                                  (_) {
                                    sl.get<ConfettiBlaster>().show(context);
                                    provider.clear();
                                    router.go("/home");
                                  },
                                  (failureMsg) {
                                    context.read<NotificationsCubit>().showErr(failureMsg);
                                    provider.setMetaState(CreatingEditingPostMetaStateEnteringData());
                                  },
                                );
                              },
                              icon: CupertinoIcons.chevron_right,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: "Submit confession",
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
