import 'package:Confessi/application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:Confessi/presentation/create_post/widgets/draft_tile.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:Confessi/presentation/shared/layout/line.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../application/create_post/cubit/post_cubit.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/buttons/pop.dart';
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
        children: [
          const SwipebarLayout(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            child: Text(
              "Your draft confessions",
              style: kDisplay1.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
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

      _animatedListKey.currentState?.removeItem(index, builder, duration: const Duration(milliseconds: 75));
      setState(() {});
    } else {
      showNotificationChip(context, "Error deleting draft");
    }
  }

  Widget buildBody(BuildContext context, DraftsState state) {
    if (state is DraftsLoading) {
      return const LoadingCupertinoIndicator();
    } else if (state is DraftsData) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<DraftsCubit, DraftsState>(
              builder: (context, state) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: buildBody(context, state),
              ),
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
                child: PopButton(
                  topPadding: 15,
                  justText: true,
                  onPress: () => Navigator.pop(context),
                  icon: CupertinoIcons.chevron_right,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  text: 'Back to writing',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
