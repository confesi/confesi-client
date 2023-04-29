import '../../../../application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alt_unused/notification_chip.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/selection_groups/text_stat_tile.dart';
import '../../../shared/selection_groups/text_stat_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageSettingCubit, LanguageSettingState>(
      listener: (context, state) {
        if (state is LanguageSettingError) {
          showNotificationChip(context, state.message);
          // set to base
          context.read<LanguageSettingCubit>().setLanguageStateToBase();
        }
      },
      child: ThemedStatusBar(
          child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "Language",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ScrollableView(
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  distancebetweenHapticEffectsDuringScroll: 50,
                  hapticEffectAtEdge: HapticType.medium,
                  controller: ScrollController(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SettingTileGroup(
                          text: "Change language via system settings",
                          settingTiles: [
                            SettingTile(
                              rightIcon: CupertinoIcons.link,
                              leftIcon: CupertinoIcons.map,
                              text: "System settings",
                              onTap: () => context.read<LanguageSettingCubit>().openDeviceSettings(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const TextStatTileGroup(
                          text: "Supported languages",
                          tiles: [
                            TextStatTile(
                              topRounded: true,
                              leftText: "English",
                              rightText: "en",
                            ),
                            TextStatTile(
                              leftText: "French",
                              rightText: "fr",
                            ),
                            TextStatTile(
                              bottomRounded: true,
                              leftText: "Spanish",
                              rightText: "es",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
