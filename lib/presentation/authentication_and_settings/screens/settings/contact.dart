import 'package:Confessi/application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'package:Confessi/presentation/shared/overlays/center_overlay_message.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactSettingCubit, ContactSettingState>(
      // listenWhen: (previous, current) => false,
      listener: (context, state) {
        if (state is ContactSuccess) {
          CenterOverlay().show(context, "Copied Successfully");
        } else if (state is ContactError) {
          showNotificationChip(context, state.message);
        }
        context.read<ContactSettingCubit>().setContactStateToBase();
      },
      child: ThemedStatusBar(
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
                  "Support",
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
                        // const HeaderText(text: "Contact us for support"),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Send us one-time feedback",
                          settingTiles: [
                            SettingTile(
                              leftIcon: CupertinoIcons.chat_bubble,
                              text: kSettingsFeedbackLabel,
                              onTap: () => Navigator.of(context).pushNamed("/feedback"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Contact support agent",
                          settingTiles: [
                            SettingTile(
                              rightIcon: CupertinoIcons.square_on_square,
                              leftIcon: CupertinoIcons.mail,
                              text: "Copy email address",
                              onTap: () => context.read<ContactSettingCubit>().copyEmailText(),
                            ),
                            SettingTile(
                              rightIcon: CupertinoIcons.link,
                              leftIcon: CupertinoIcons.mail,
                              text: "Open email",
                              onTap: () => context.read<ContactSettingCubit>().openMailClient(),
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
