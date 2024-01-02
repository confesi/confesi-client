
import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../constants/shared/constants.dart';
import '../../../../core/router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/sizing/height_fraction.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/buttons/pop.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // disables back button
      child: ThemeStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: heightFraction(context, 1 / 10)),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Expanded(
                    child: Image.asset(walrusFullBodyImgPath),
                  ),
                  const Spacer(),
                  PopButton(
                    onPress: () async => context.read<AuthFlowCubit>().registerAnon(),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Try as guest",
                    bottomPadding: 5,
                    loading: context.watch<AuthFlowCubit>().isLoading,
                  ),
                  AbsorbPointer(
                    absorbing: context.watch<AuthFlowCubit>().isLoading,
                    child: PopButton(
                      onPress: () => router.push("/login"),
                      icon: CupertinoIcons.arrow_right,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      text: "Login",
                      bottomPadding: 30,
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: context.watch<AuthFlowCubit>().isLoading,
                    child: PopButton(
                      onPress: () => router.push("/register", extra: const RegistrationPops(false)),
                      icon: CupertinoIcons.arrow_right,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Theme.of(context).colorScheme.onSecondary,
                      text: "Create account",
                    ),
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
