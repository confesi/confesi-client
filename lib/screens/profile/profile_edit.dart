import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: const [
            AppbarLayout(text: "Edit profile"),
          ],
        ),
      ),
    );
  }
}
