import 'package:Confessi/application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile_group.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
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
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "Language",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                inlineBottomOrRightPadding: bottomSafeArea(context) * 2,
                distancebetweenHapticEffectsDuringScroll: 50,
                hapticEffectAtEdge: HapticType.medium,
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      SettingTileGroup(
                        text: "Change language via system settings",
                        settingTiles: [
                          SettingTile(
                            rightIcon: CupertinoIcons.link,
                            leftIcon: CupertinoIcons.map,
                            text: "System settings",
                            onTap: () async =>
                                await openAppSettings(), // TODO: make a usecase to handle error cases for this
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SettingTileGroup(
                        text: "Want another language added?",
                        settingTiles: [
                          SettingTile(
                            leftIcon: CupertinoIcons.chat_bubble,
                            text: "Give us feedback",
                            onTap: () => Navigator.of(context).pushNamed("/feedback"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextStatTileGroup(
                        text: "Supported languages",
                        tiles: [
                          TextStatTile(
                            topRounded: true,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            leftText: "English",
                            rightText: "en",
                          ),
                          TextStatTile(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            leftText: "Spanish",
                            rightText: "es",
                          ),
                          TextStatTile(
                            bottomRounded: true,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            leftText: "French",
                            rightText: "fr",
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
    ));
  }
}
