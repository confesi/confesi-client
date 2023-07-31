import 'package:confesi/application/shared/cubit/account_details_cubit.dart';
import 'package:confesi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/text/disclaimer_text.dart';
import 'package:scrollable/exports.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../create_post/widgets/faculty_picker_sheet.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/selection_groups/setting_tile.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  @override
  void initState() {
    context.read<AccountDetailsCubit>().loadUserData();
    super.initState();
  }

  Widget buildChild(BuildContext context, AccountDetailsState state) {
    if (state is AccountDetailsLoading) {
      return const Center(
        key: ValueKey("loading"),
        child: LoadingCupertinoIndicator(),
      );
    } else if (state is AccountDetailsData) {
      return Align(
        key: const ValueKey("data"),
        alignment: Alignment.topCenter,
        child: ScrollableView(
          physics: const BouncingScrollPhysics(),
          inlineBottomOrRightPadding: bottomSafeArea(context),
          controller: ScrollController(),
          scrollBarVisible: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TileGroup(
                  text: "Your home university",
                  tiles: [
                    SettingTile(
                      secondaryText: "Required",
                      leftIcon: CupertinoIcons.sparkles,
                      rightIcon: CupertinoIcons.pen,
                      text: state.school,
                      onTap: () => print("tap"),
                    ),
                  ],
                ),
                TileGroup(
                  text: "Your year of study",
                  tiles: [
                    SettingTile(
                      secondaryText: "Optional",
                      leftIcon: CupertinoIcons.sparkles,
                      rightIcon: CupertinoIcons.pen,
                      text: state.yearOfStudy ?? "Hidden",
                      onTap: () => print("tap"),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.read<AccountDetailsCubit>().updateSchool("University of British Columbia"),
                  child: const Text(
                    "temp update",
                  ),
                ),
                TileGroup(
                  text: "Your faculty",
                  tiles: [
                    SettingTile(
                      secondaryText: "Optional",
                      leftIcon: CupertinoIcons.sparkles,
                      rightIcon: CupertinoIcons.pen,
                      text: state.faculty ?? "Hidden",
                      onTap: () => showFacultyPickerSheet(context),
                    ),
                  ],
                ),
                const DisclaimerText(
                  text: "These details are shared alongside your confessions.",
                ),
              ],
            ),
          ),
        ),
      );
    } else if (state is AccountDetailsError) {
      return AlertIndicator(
        key: const ValueKey("error"),
        message: state.message,
        onPress: () => context.read<AccountDetailsCubit>().loadUserData(),
      );
    } else {
      throw Exception("Unhandled state");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "In-App Details",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIcon: CupertinoIcons.refresh,
                rightIconOnPress: () => context.read<AccountDetailsCubit>().loadUserData(),
                rightIconVisible: true,
              ),
              Expanded(
                child: BlocBuilder<AccountDetailsCubit, AccountDetailsState>(
                  builder: (context, state) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: buildChild(context, state),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
