import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppbarLayout(text: "Settings"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: const [
                  LongTextField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
