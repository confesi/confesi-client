import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/indicators/loading_cupertino.dart';

import 'package:scrollable/exports.dart';
import '../../../application/create_post/cubit/post_cubit.dart';
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
    return NavBlocker(
      blocking: context.watch<CreatePostCubit>().state is PostLoading,
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
                              blocking: context.watch<CreatePostCubit>().state is PostLoading,
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
                                leftIconIgnored: context.watch<CreatePostCubit>().state is PostLoading,
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
                                    BlocBuilder<PostCategoriesCubit, PostCategoriesState>(
                                      builder: (context, state) {
                                        if (state is PostCategoriesData) {
                                          return TileGroup(
                                            text: "Select genre",
                                            tiles: state.categories.map((category) {
                                              return BoolSelectionTile(
                                                isActive: state.selectedIndex == state.categories.indexOf(category),
                                                icon: category.icon,
                                                text: category.name,
                                                backgroundColor: Theme.of(context).colorScheme.surface,
                                                onTap: () => context
                                                    .read<PostCategoriesCubit>()
                                                    .updateCategoryIdx(state.categories.indexOf(category)),
                                              );
                                            }).toList(),
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
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: SafeArea(
                          top: false,
                          child: BlocBuilder<CreatePostCubit, CreatePostState>(
                            builder: (context, state) {
                              return Container(
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
                                  loading: state is PostLoading,
                                  justText: true,
                                  onPress: () async {
                                    await context.read<CreatePostCubit>().uploadUserPost(
                                          context.read<PostCategoriesCubit>().data.title,
                                          context.read<PostCategoriesCubit>().data.body,
                                          context
                                              .read<PostCategoriesCubit>()
                                              .data
                                              .categories[context.read<PostCategoriesCubit>().data.selectedIndex]
                                              .name,
                                        );
                                  },
                                  icon: CupertinoIcons.chevron_right,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Theme.of(context).colorScheme.onSecondary,
                                  text: 'Submit confession',
                                ),
                              );
                            },
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
