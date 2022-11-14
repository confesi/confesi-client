import 'package:Confessi/presentation/authentication_and_settings/tabs/verified_student_email.dart';

import '../../tabs/register.dart';
import '../../../shared/behaviours/nav_blocker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_settings/cubit/register_cubit.dart';
import '../../tabs/account_details.dart';
import '../../tabs/verified_student_perks.dart';

class VerifiedStudentManager extends StatefulWidget {
  const VerifiedStudentManager({super.key});

  @override
  State<VerifiedStudentManager> createState() => _VerifiedStudentManagerState();
}

class _VerifiedStudentManagerState extends State<VerifiedStudentManager> {
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
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        VerifiedStudentPerksTab(nextScreen: () {
          FocusScope.of(context).unfocus();
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 850),
            curve: Curves.linearToEaseOut,
          );
        }),
        VerifiedStudentEmailTab(
          previousScreen: () {
            FocusScope.of(context).unfocus();
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 850),
              curve: Curves.linearToEaseOut,
            );
          },
        ),
      ],
    );
  }
}
