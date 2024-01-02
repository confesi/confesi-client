import 'package:confesi/application/user/cubit/account_details_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/text/disclaimer_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../user/widgets/picker_selector.dart';
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
    if (state is AccountDetailsTrueData || state is AccountDetailsEphemeral) {
      late final AccData data;
      if (state is AccountDetailsTrueData) {
        data = state.data;
      } else {
        data = (state as AccountDetailsEphemeral).data;
      }
      return Align(
        alignment: Alignment.topCenter,
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
                    text: data.school,
                    onTap: () => router.push('/schools/search'),
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
                    text: data.yearOfStudy ?? "Hidden",
                    onTap: () => showPickerSheet(
                      context,
                      yearsOfStudy,
                      (idx) => context.read<AccountDetailsCubit>().updateYearOfStudy(yearsOfStudy[idx]),
                      () => context.read<AccountDetailsCubit>().hideYearOfStudy(),
                      true,
                    ),
                  ),
                ],
              ),
              TileGroup(
                text: "Your faculty",
                tiles: [
                  SettingTile(
                    secondaryText: "Optional",
                    leftIcon: CupertinoIcons.sparkles,
                    rightIcon: CupertinoIcons.pen,
                    text: data.faculty ?? "Hidden",
                    onTap: () => showPickerSheet(
                      context,
                      faculties,
                      (idx) => context.read<AccountDetailsCubit>().updateFaculty(faculties[idx]),
                      () => context.read<AccountDetailsCubit>().hideFaculty(),
                      true,
                    ),
                  ),
                ],
              ),
              const DisclaimerText(
                text: "These details are shared alongside your confessions.",
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: bottomSafeArea(context)),
        child: LoadingOrAlert(
          message: StateMessage(state is AccountDetailsError ? state.message : null,
              () => context.read<AccountDetailsCubit>().loadUserData()),
          isLoading: state is AccountDetailsLoading,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                bottomBorder: true,
                backgroundColor: Theme.of(context).colorScheme.background,
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
                child: Container(
                  color: Theme.of(context).colorScheme.shadow,
                  child: BlocBuilder<AccountDetailsCubit, AccountDetailsState>(
                    builder: (context, state) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: buildChild(context, state),
                    ),
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
