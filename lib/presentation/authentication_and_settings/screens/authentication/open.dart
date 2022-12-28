import 'package:Confessi/application/authentication_and_settings/cubit/user_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/presentation/shared/text_animations/typewriter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/sizing/height_fraction.dart';
import '../../../../core/utils/sizing/width_breakpoint_fraction.dart';
import '../../../shared/behaviours/init_scale.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/buttons/pop.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: ThemedStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: heightFraction(context, 1 / 10)),
              child: Column(
                children: [
                  const Text("TODO: add graphic here"), // TODO Add a graphic here
                  const Spacer(),
                  PopButton(
                    onPress: () => context.read<UserCubit>().setHomeViewedThenReloadUser(context),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Try as guest",
                    bottomPadding: 5,
                  ),
                  PopButton(
                    onPress: () => Navigator.of(context).pushNamed("/login"),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Login",
                    bottomPadding: 30,
                  ),
                  PopButton(
                    onPress: () => Navigator.of(context).pushNamed("/register"),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: "Create account",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
