import '../../../core/utils/sizing/height_fraction.dart';
import '../widgets/settings/perk_slideshow.dart';
import '../../shared/behaviours/keyboard_dismiss.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/overlays/info_sheet_with_action.dart';
import '../../shared/text/link.dart';
import '../../shared/textfields/bulge_textfield.dart';

import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';

class VerifiedStudentEmailTab extends StatefulWidget {
  const VerifiedStudentEmailTab({super.key, required this.previousScreen});

  final VoidCallback previousScreen;

  @override
  State<VerifiedStudentEmailTab> createState() => _VerifiedStudentEmailTabState();
}

class _VerifiedStudentEmailTabState extends State<VerifiedStudentEmailTab> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
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
                  "Email Verification",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIcon: CupertinoIcons.arrow_up,
                rightIconVisible: true,
                rightIconOnPress: () => widget.previousScreen(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: bottomSafeArea(context)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BulgeTextField(
                          bottomPadding: 10,
                          topPadding: 15,
                          topText: "Enter your UVic student email",
                          hintText: "___@uvic.ca",
                          controller: textEditingController,
                        ),
                        const SizedBox(height: 45),
                        PopButton(
                          bottomPadding: 15,
                          topPadding: 10,
                          justText: true,
                          onPress: () => print("tap"),
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          text: "Send Verification Email",
                        ),
                        TouchableOpacity(
                          onTap: () => showInfoSheetWithAction(
                              context,
                              "Home University's Email",
                              "The email we attempt to verify is the primary student address associated with your home university, in this case, the University of Victoria. To verify under a different address, change your home university.",
                              () => print("change home university"),
                              "Update Home University"),
                          child: Container(
                            // Transparent hitbox trick.
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Why must I verify this type of email?",
                                  style: kTitle.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
