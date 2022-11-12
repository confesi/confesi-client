import '../../tabs/register.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../tabs/account_details.dart';

class RegisterTabManager extends StatefulWidget {
  const RegisterTabManager({super.key});

  @override
  State<RegisterTabManager> createState() => _RegisterTabManagerState();
}

class _RegisterTabManagerState extends State<RegisterTabManager> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return NavBlocker(
          blocking: state is RegisterLoading, // TODO: Change to bloc builder
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              AccountDetails(
                nextScreen: () => pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.linearToEaseOut,
                ),
              ),
              RegisterScreen(
                previousScreen: () => pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.linearToEaseOut,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
