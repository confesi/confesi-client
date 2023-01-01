import 'package:Confessi/application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:Confessi/presentation/create_post/widgets/draft_tile.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/layout/swipebar.dart';

Future<dynamic> showDraftsSheet(BuildContext context) {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: heightFraction(context, .9)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // EmblemButton(
          //   backgroundColor: Theme.of(context).colorScheme.surface,
          //   icon: CupertinoIcons.xmark,
          //   onPress: () => Navigator.pop(context),
          //   iconColor: Theme.of(context).colorScheme.onSurface,
          // ),
          const SwipebarLayout(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                Text(
                  "Load a draft confession",
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  "These are saved locally to your device, and lost upon sign out.",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                SimpleTextButton(
                  onTap: () => Navigator.pop(context),
                  text: "Go back to writing",
                  infiniteWidth: true,
                ),
                // const SizedBox(height: 15),
                // SimpleTextButton(
                //   onTap: () =>
                //       context.read<DraftsCubit>().saveDraft(context.read<UserCubit>().userId(), "tit", "bod", null),
                //   text: "Write",
                //   infiniteWidth: true,
                // ),
                // const SizedBox(height: 15),
                // SimpleTextButton(
                //   onTap: () => context.read<DraftsCubit>().getDrafts(context.read<UserCubit>().userId()),
                //   text: "Read",
                //   infiniteWidth: true,
                // ),
                // const SizedBox(height: 15),
                // SimpleTextButton(
                //   onTap: () => context.read<DraftsCubit>().deleteDraft(context.read<UserCubit>().userId(), 0),
                //   text: "Delete",
                //   infiniteWidth: true,
                // ),
              ],
            ),
          ),
          LineLayout(color: Theme.of(context).colorScheme.surface),
          const Expanded(child: _DraftsSheet()),
        ],
      ),
    ),
  );
}

class _DraftsSheet extends StatefulWidget {
  const _DraftsSheet({super.key});

  @override
  State<_DraftsSheet> createState() => _DraftsSheetState();
}

class _DraftsSheetState extends State<_DraftsSheet> {
  List<DraftPostEntity> draftEntities = [];
  GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

  @override
  void initState() {
    loadDrafts();
    super.initState();
  }

  void loadDrafts() async {
    await context.read<DraftsCubit>().getDrafts(context.read<UserCubit>().userId()).then((drafts) async {
      if (mounted) {
        setState(() {
          draftEntities = drafts;
        });
        _animatedListKey = GlobalKey(); // Resets the global key.
      }
    });
  }

  void removeAtIndex(int index) async {
    if (await context.read<DraftsCubit>().deleteDraft(context.read<UserCubit>().userId(), index)) {
      DraftPostEntity removedItem = draftEntities.removeAt(index);
      builder(context, animation) {
        // A method to build the Card widget.
        return SizeTransition(
          sizeFactor: animation,
          child: DraftTile(
            childTitle: removedItem.repliedPostTitle,
            childBody: removedItem.repliedPostBody,
            childId: removedItem.repliedPostId,
            title: removedItem.title,
            body: removedItem.body,
            onTap: () => {}, // Can't click an item currently being removed.
            onDelete: () => {}, // Can't click an item currently being removed.
          ),
        );
      }

      _animatedListKey.currentState?.removeItem(index, builder, duration: const Duration(milliseconds: 175));
      setState(() {});
    } else {
      showNotificationChip(context, "Error deleting draft");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DraftsCubit, DraftsState>(
      builder: (context, state) {
        if (state is DraftsLoading) {
          return const LoadingCupertinoIndicator();
        } else if (state is DraftsData) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: state.drafts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "No drafts here!",
                      style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                : SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    child: AnimatedList(
                      physics: const BouncingScrollPhysics(),
                      key: _animatedListKey,
                      initialItemCount: draftEntities.length,
                      itemBuilder: (context, i, animation) {
                        return Column(
                          children: [
                            DraftTile(
                              childBody: draftEntities[i].repliedPostBody,
                              childTitle: draftEntities[i].repliedPostTitle,
                              childId: draftEntities[i].repliedPostId,
                              title: draftEntities[i].title,
                              body: draftEntities[i].body,
                              onTap: () => context.read<DraftsCubit>().loadFromDraft(
                                  context.read<UserCubit>().userId(),
                                  i,
                                  draftEntities[i].title,
                                  draftEntities[i].body,
                                  draftEntities[i].repliedPostId,
                                  draftEntities[i].repliedPostTitle,
                                  draftEntities[i].repliedPostBody),
                              onDelete: () => removeAtIndex(i),
                            ),
                            if (i == draftEntities.length - 1) SizedBox(height: bottomSafeArea(context))
                          ],
                        );
                      },
                    ),
                  ),
          );
        } else if (state is DraftsError) {
          return AlertIndicator(message: state.message, onPress: () => loadDrafts());
        } else {
          return Container();
        }
      },
    );
  }
}
