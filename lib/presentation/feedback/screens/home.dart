import 'package:confesi/application/user/cubit/feedback_categories_cubit.dart';
import 'package:confesi/application/user/cubit/feedback_cubit.dart';
import 'package:confesi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/create_post/cubit/post_categories_cubit.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import 'package:scrollable/exports.dart';

import '../../../constants/feedback/text.dart';
import '../../../init.dart';
import '../../shared/behaviours/init_scale.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/selection_groups/bool_selection_tile.dart';
import '../../shared/selection_groups/tile_group.dart';
import '../../shared/textfields/expandable_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/feedback/general.dart';
import '../../../core/styles/typography.dart';
import '../../shared/other/text_limit_tracker.dart';
import '../../shared/layout/appbar.dart';

class FeedbackHome extends StatefulWidget {
  const FeedbackHome({super.key});

  @override
  State<FeedbackHome> createState() => _FeedbackHomeState();
}

class _FeedbackHomeState extends State<FeedbackHome> {
  late TextEditingController textEditingController;
  final FocusNode textFocusNode = FocusNode();

  bool isTextFocused = false;

  @override
  void initState() {
    textEditingController = TextEditingController();
    textFocusNode.addListener(() {
      if (textFocusNode.hasFocus) {
        isTextFocused = true;
      } else {
        isTextFocused = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: ThemeStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppbarLayout(
                  bottomBorder: false,
                  centerWidget: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isTextFocused
                        ? TextLimitTracker(
                            value: textEditingController.text.runes.length / maxFeedbackTextCharacterLimit,
                          )
                        : Text(
                            pageTitle,
                            style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                  ),
                  leftIcon: CupertinoIcons.xmark,
                  leftIconDisabled: context.watch<FeedbackCubit>().state is FeedbackLoading,
                  leftIconIgnored: context.watch<FeedbackCubit>().state is FeedbackLoading,
                ),
                Expanded(
                  child: ScrollableView(
                    physics: const BouncingScrollPhysics(),
                    scrollBarVisible: false,
                    hapticsEnabled: false,
                    inlineBottomOrRightPadding: bottomSafeArea(context),
                    controller: ScrollController(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          InitScale(
                            child: ExpandableTextfield(
                              onChange: (newValue) => setState(() => {}),
                              color: Theme.of(context).colorScheme.surface,
                              focusNode: textFocusNode,
                              maxLines: 8,
                              maxCharacters: maxFeedbackTextCharacterLimit,
                              hintText: textFieldHint,
                              controller: textEditingController,
                            ),
                          ),
                          BlocBuilder<FeedbackCategoriesCubit, FeedbackCategoriesState>(
                            builder: (context, state) {
                              if (state is FeedbackCategoriesData) {
                                return TileGroup(
                                  text: "Select type",
                                  tiles: state.categories.map((category) {
                                    return BoolSelectionTile(
                                      isActive: state.selectedIndex == state.categories.indexOf(category),
                                      icon: category.icon,
                                      text: category.name,
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      onTap: () => context
                                          .read<FeedbackCategoriesCubit>()
                                          .updateCategoryIdx(state.categories.indexOf(category)),
                                    );
                                  }).toList(),
                                );
                              } else {
                                // Handle other states (e.g., loading, error) if necessary
                                return const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: LoadingCupertinoIndicator(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          InitScale(
                            child: PopButton(
                              loading: context.watch<FeedbackCubit>().state is FeedbackLoading,
                              topPadding: 5,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: "Submit",
                              onPress: () => context.read<FeedbackCubit>().sendFeedback(
                                  textEditingController.text, context.read<FeedbackCategoriesCubit>().category()),
                              icon: CupertinoIcons.up_arrow,
                            ),
                          ),
                          const SimulatedBottomSafeArea()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
