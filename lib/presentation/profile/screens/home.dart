import 'dart:ui';

import 'package:Confessi/core/cubit/biometrics_cubit.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/presentation/profile/screens/biometric_overlay_message.dart';
import 'package:Confessi/presentation/profile/screens/profile.dart';
import 'package:Confessi/presentation/shared/overlays/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        context.read<BiometricsCubit>().setNotAuthenticated();
        startBlurTimer();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  Future<void> startBlurTimer() async {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        context.read<BiometricsCubit>().setNotAuthenticated();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<BiometricsCubit>().setNotAuthenticated();
    _animController = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    );
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    _animController.reverse();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animController.dispose();
    super.dispose();
  }

  Widget buildChild(BiometricsState state) {
    if (state is! Authenticated) {
      return BiometricOverlayMessage(
        message: state is AuthenticationError
            ? "Try again"
            : state is AuthenticationLoading
                ? "Loading..."
                : "Confirm ID",
      );
    } else {
      return Container();
    }
  }

  double getBlurValue() => _anim.value * 10;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<BiometricsCubit, BiometricsState>(
        listener: (context, state) {
          // Start/reverse the blur animation.
          if (state is Authenticated) {
            reverseAnim();
          } else {
            startAnim();
          }
          // Check when to show error snackbar.
          if (state is AuthenticationError &&
              state.biometricErrorType == BiometricErrorType.exausted) {
            showSnackbar(context,
                "Attempts exausted! Lock your entire device, login with the passcode, then open the app and try again.",
                stayLonger: true);
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IgnorePointer(
                ignoring: _anim.value == 0 ? false : true,
                child: const Profile(),
              ),
              IgnorePointer(
                ignoring: _anim.value != 1 ? true : false,
                child: Opacity(
                  opacity: _anim.value,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: getBlurValue(), sigmaY: getBlurValue()),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(_anim.value * .5),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          // transitionBuilder: (Widget child,
                          //         Animation<double> animation) =>
                          //     ScaleTransition(scale: animation, child: child),
                          child: buildChild(state),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
