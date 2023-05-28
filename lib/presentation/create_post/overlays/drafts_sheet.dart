import 'package:Confessi/application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:Confessi/presentation/create_post/widgets/draft_tile.dart';
import 'package:Confessi/presentation/shared/indicators/alert.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/layout/appbar.dart';

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
          AppbarLayout(
            bottomBorder: true,
            centerWidget: Text(
              "Your drafts",
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            rightIconVisible: true,
            rightIcon: CupertinoIcons.info,
            rightIconOnPress: () => showInfoSheet(
              context,
              "Drafts",
              "Draft confessions are deleted upon you logging out. This is for security.",
            ),
            leftIcon: CupertinoIcons.xmark,
          ),
          const Expanded(child: _DraftsSheet()),
        ],
      ),
    ),
  );
}

class _DraftsSheet extends StatefulWidget {
  const _DraftsSheet();

  @override
  State<_DraftsSheet> createState() => _DraftsSheetState();
}

class _DraftsSheetState extends State<_DraftsSheet> {
  List<DraftPostEntity> draftEntities = [];

  @override
  void initState() {
    loadDrafts();
    super.initState();
  }

  void loadDrafts() async {
    await context.read<DraftsCubit>().getDrafts(context.read<UserCubit>().userId()).then((drafts) async {
      if (mounted) {
        setState(() {
          draftEntities = drafts.reversed.toList();
        });
      }
    });
  }

  void openDraft(BuildContext context, int index) {
    context.read<DraftsCubit>().loadFromDraft(
          context.read<UserCubit>().userId(),
          index,
          draftEntities[index].title,
          draftEntities[index].body,
          draftEntities[index].repliedPostId,
          draftEntities[index].repliedPostTitle,
          draftEntities[index].repliedPostBody,
        );
  }

  Widget buildBody(BuildContext context, DraftsState state) {
    if (state is DraftsLoading) {
      return const LoadingCupertinoIndicator();
    } else if (state is DraftsData) {
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: draftEntities.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: bottomSafeArea(context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No drafts found",
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: draftEntities.length + 1,
                  itemBuilder: (context, i) {
                    // Returns a bottom buffer so that content doesn't extend over bottom un-safe area
                    if (i == draftEntities.length) return SizedBox(height: bottomSafeArea(context));
                    // Returns main list widgets
                    return Dismissible(
                      resizeDuration: const Duration(milliseconds: 100),
                      movementDuration: const Duration(milliseconds: 100),
                      background: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).colorScheme.surfaceTint,
                        child: Icon(
                          CupertinoIcons.arrow_up_left_arrow_down_right,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      secondaryBackground: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        color: Theme.of(context).colorScheme.error,
                        child: Icon(
                          CupertinoIcons.trash,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          openDraft(context, i);
                        } else {
                          if (await context.read<DraftsCubit>().deleteDraft(context.read<UserCubit>().userId(), i)) {
                            setState(() => draftEntities.removeAt(i));
                          } else {
                            showNotificationChip(context, "Error removing draft");
                          }
                        }
                      },
                      key: UniqueKey(),
                      child: DraftTile(
                        childBody: draftEntities[i].repliedPostBody,
                        childTitle: draftEntities[i].repliedPostTitle,
                        childId: draftEntities[i].repliedPostId,
                        title: draftEntities[i].title,
                        body: draftEntities[i].body,
                        onTap: () => openDraft(context, i),
                      ),
                    );
                  },
                ));
    } else if (state is DraftsError) {
      return AlertIndicator(message: state.message, onPress: () => loadDrafts());
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DraftsCubit, DraftsState>(
      builder: (context, state) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: buildBody(context, state),
      ),
    );
  }
}
