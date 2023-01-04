import '../../../../application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import '../../../../core/alt_unused/notification_chip.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/text/disclaimer_text.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactSettingCubit, ContactSettingState>(
      listener: (context, state) {
        if (state is ContactSuccess) {
          showNotificationChip(context, "Email copied to clipboard.", notificationType: NotificationType.success);
        } else if (state is ContactError) {
          showNotificationChip(context, state.message);
        }
        context.read<ContactSettingCubit>().setContactStateToBase();
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
                  "Support",
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
                        // const HeaderText(text: "Contact us for support"),
                        const SizedBox(height: 10),
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
                        const DisclaimerText(
                          verticalPadding: 10,
                          text: "To permanently delete your account, send us an email.",
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
